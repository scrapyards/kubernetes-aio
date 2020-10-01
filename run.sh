#!/bin/bash
set -e
ansible-playbook --ask-become-pass -i inventory.yaml deploy-k8s.yaml
