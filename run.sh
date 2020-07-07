#!/bin/bash
set -e
ansible-playbook -i inventory.yaml deploy-k8s.yaml
