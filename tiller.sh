#!/bin/bash

set -xe

# Deploy helm/tiller into the cluster
kubectl create -n kube-system serviceaccount helm-tiller
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: helm-tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: helm-tiller
    namespace: kube-system
EOF

helm init --service-account helm-tiller #--output yaml

# Patch tiller-deploy service to expose metrics port
tee /tmp/tiller-deploy.yaml << EOF
  metadata:
    annotations:
      prometheus.io/scrape: "true"
      prometheus.io/port: "44135"
  spec:
    ports:
    - name: http
      port: 44135
      targetPort: http
EOF

kubectl patch service tiller-deploy -n kube-system --patch "$(cat /tmp/tiller-deploy.yaml)"

