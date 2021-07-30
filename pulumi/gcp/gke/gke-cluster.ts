// Copyright 2016-2021, Pulumi Corporation.

import * as google from "@pulumi/google-native";
import * as Pulumi from '@pulumi/pulumi'

// TODO: Determine this dynamically once https://github.com/pulumi/pulumi-google-native/issues/166 is done.
const engineVersion = "1.19.9-gke.1900";

export function Cluster(name: string) {
    const nodeConfig: google.types.input.container.v1.NodeConfigArgs = {
        machineType: "n1-standard-1",
        oauthScopes: [
            "https://www.googleapis.com/auth/compute",
            "https://www.googleapis.com/auth/devstorage.read_only",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring"
        ],
        preemptible: true,
    };
    
    const cluster = new google.container.v1.Cluster(name, {
        initialClusterVersion: engineVersion,
        nodePools: [{
            config: nodeConfig,
            initialNodeCount: 1,
            management: {
                autoRepair: false,
            },
            name: name,
        }],
        clusterIpv4Cidr: "/19",
    });
    
     const kubeconfig = Pulumi.all([cluster.name, cluster.endpoint, cluster.masterAuth])
        .apply(([name, url, auth]) => { 
    return `
apiVersion: v1
clusters:
    - cluster:
        certificate-authority-data: '${auth.clusterCaCertificate}'
        server: 'https://${url}'
    name: '${name}'
contexts:
    - context:
        cluster: '${name}'
        user: '${name}'
    name: '${name}'
current-context: '${name}'
kind: Config
preferences: {}
users:
    - name: '${name}'
    user:
        auth-provider:
        config:
            cmd-args: config config-helper --format=json
            cmd-path: gcloud
            expiry-key: '{.credential.token_expiry}'
            token-key: '{.credential.access_token}'
        name: gcp`
    })

    return {
        ... cluster,
        kubeconfig: kubeconfig
    }
}

