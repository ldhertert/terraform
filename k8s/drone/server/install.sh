kubectl create ns drone
helm install --namespace drone drone drone/drone -f values.yaml
