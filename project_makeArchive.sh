#!/bin/bash

PROJECT_DIR="sf-d0241-k8s-minikube"

cd ..

zip -r "$PROJECT_DIR"__v$(date +'%Y%m%d_%H%M%S').zip $PROJECT_DIR
