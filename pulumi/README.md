Create GKE and EKS clusters: `pulumi up`

Get kubeconfig for the created clusters:
```
pulumi stack output gke_KUBECONFIG > GKE_KUBECONFIG
pulumi stack output EKS_KUBECONFIG > EKS_KUBECONFIG
```

Destroy created resources: `pulumi destroy`