#!/bin/bash
set -xe

: ${CALICO_VERSION:="v3.14"}

rm -f /tmp/calico.yaml
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
# curl https://docs.projectcalico.org/"${CALICO_VERSION}"/manifests/calico.yaml -o /tmp/calico.yaml
# kubectl apply -f /tmp/calico.yaml

kubectl -n kube-system set env daemonset/calico-node FELIX_IGNORELOOSERPF=true
