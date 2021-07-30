import * as GKE from './gcp/gke/gke-cluster'
import * as EKS from "@pulumi/eks";

const gke = GKE.Cluster("harness-gke")
export const GKE_KUBECONFIG = gke.kubeconfig;

const eks = new EKS.Cluster("harness-eks");
export const EKS_KUBECONFIG = eks.kubeconfig;