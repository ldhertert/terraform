kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.4/deploy/static/provider/cloud/deploy.yaml
#helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
#helm repo update
#helm install nginx-ingress ingress-nginx/ingress-nginx

kubectl create deployment hello-app --image=gcr.io/google-samples/hello-app:1.0
kubectl expose deployment hello-app --port=8080 --target-port=8080             

NGINX_INGRESS_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -ojson  | jq -r '.status.loadBalancer.ingress[].ip')

cat <<EOF > ingress-resource.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-resource
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - host: "34.150.223.29.nip.io"
    http:
      paths:
      - pathType: Prefix
        path: "/hello"
        backend:
          service:
            name: hello-app
            port:
              number: 8080
EOF
kubectl apply -f ingress-resource.yaml
curl http://34.150.223.29.nip.io/hello
