terraform init
terraform apply
terraform output -raw kubectl_config > ~/.kube/eks_kubeconfig

# requires aws-iam-authenticator to be installed
export KUBECONFIG=~/.kube/eks_kubeconfig    
kubectl cluster-info

# terraform destroy
