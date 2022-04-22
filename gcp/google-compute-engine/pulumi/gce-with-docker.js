"use strict";
const pulumi = require("@pulumi/pulumi");
const gcp = require("@pulumi/gcp");

const startupScript = `#!/bin/bash
sudo apt-get update
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh`;


const defaultInstance = new gcp.compute.Instance("luke-gce", {
    machineType: "e2-standard-2",
    tags: [ "http-server","https-server" ],
    bootDisk: {
        initializeParams: {
            image: "debian-10",
            type: 'pd-balanced',
            size: 10
        },
    },
    networkInterfaces: [{
        network: "default",
        accessConfigs: [{}],
    }],
    metadataStartupScript: startupScript,
    serviceAccount: {
        scopes: ["https://www.googleapis.com/auth/cloud-platform"],
    },
});


exports.instanceName = defaultInstance.name;
exports.instanceIP = defaultInstance.networkInterfaces[0].accessConfigs[0].natIp;
