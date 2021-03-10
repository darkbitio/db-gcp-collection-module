#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

# Freely modified
EXPORTER_GCP_SA_EMAIL="darkbit-gke-exporter@my-project-id.iam.gserviceaccount.com"
GCS_BUCKET_NAME="provided-gcs-bucket-name"
EXPORTER_IMAGE="gcr.io/darkbit-io/gke-exporter:v0.1.9"

# Populate with base64 encoded key, if provided
# Leave blank otherwise
EXPORTER_GKE_SA_KEY=""

# Not to be user-modified
NAMESPACE_NAME="darkbit"
SA_NAME="darkbit"
CLUSTERROLE_NAME="darkbit"
CLUSTERROLEBINDING_NAME="darkbit"
CRONJOB_NAME="darkbit-exporter"
EXPORTER_CRON_SCHEDULE_STRING="5 * * * *"
GCS_BUCKET_FOLDER="k8s"
DEBUG_EXPORT_TIME=""

cat <<EOF
---
apiVersion: v1
kind: Namespace
metadata:
  name: "${NAMESPACE_NAME}"
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
  namespace: "${NAMESPACE_NAME}"
automountServiceAccountToken: false  
---
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    iam.gke.io/gcp-service-account: "${EXPORTER_GCP_SA_EMAIL}"
  name: "${SA_NAME}"
  namespace: "${NAMESPACE_NAME}"
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: "${CLUSTERROLE_NAME}"
rules:
- apiGroups:
  - "*"
  resources:
  - "*"
  verbs:
  - get
  - list
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: "${CLUSTERROLEBINDING_NAME}"
  namespace: "${NAMESPACE_NAME}"
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: "${CLUSTERROLE_NAME}"
subjects:
- kind: ServiceAccount
  name: "${SA_NAME}"
  namespace: "${NAMESPACE_NAME}"
---
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: "${CRONJOB_NAME}"
  namespace: "${NAMESPACE_NAME}"
spec:
  concurrencyPolicy: Forbid
  schedule: "${EXPORTER_CRON_SCHEDULE_STRING}"
  jobTemplate:
    spec:
      template:
        metadata:       
          annotations:
            container.seccomp.security.alpha.kubernetes.io/darkbit: "runtime/default"
            container.apparmor.security.beta.kubernetes.io/darkbit: "runtime/default"
          labels:         
            app: "${CRONJOB_NAME}"
        spec:
          serviceAccountName: "${SA_NAME}"
          restartPolicy: Never
          containers:
          - name: darkbit
            image: "${EXPORTER_IMAGE}"
            securityContext:
              runAsUser: 65534
              runAsGroup: 65534
              allowPrivilegeEscalation: false
              capabilities:
                drop: ["ALL"]
            env:
            - name: "GCS_BUCKET_NAME"
              value: "${GCS_BUCKET_NAME}"
            - name: "GCS_BUCKET_FOLDER"
              value: "${GCS_BUCKET_FOLDER}"
            - name: "DEBUG_EXPORT_TIME"
              value: "${DEBUG_EXPORT_TIME}"
EOF
if [ "${EXPORTER_GKE_SA_KEY}" != "" ]; then
cat <<EOF
            - name: "GOOGLE_APPLICATION_CREDENTIALS"
              value: "/gcp/sa.key"
            volumeMounts:
            - name: exporter-sa-key
              mountPath: "/gcp"
              readOnly: true
          volumes:
          - name: exporter-sa-key
            secret:
              secretName: darkbit-exporter
              items:
              - key: "sa.key"
                path: "sa.key"
---
apiVersion: v1
kind: Secret
metadata:
  name: "${CRONJOB_NAME}"
  namespace: "${NAMESPACE_NAME}"
type: Opaque
data:
  sa.key: ${EXPORTER_GKE_SA_KEY}
EOF
fi
