import * as aws from "@pulumi/aws";
import * as awsx from "@pulumi/awsx";

const bucket = new aws.s3.Bucket("my-bucket");

export const bucketName = bucket.id;

const listener = new awsx.lb.NetworkListener("nginx", { port: 80 });
const service = new awsx.ecs.FargateService("my-service", {
    assignPublicIp: true,
    desiredCount: 2,
    taskDefinitionArgs: {
        container: {
            image: "nginx:latest",
            cpu: 512,
            memory: 128,
            essential: true,
            portMappings: [listener]
        },
    },
});

export const url = listener.endpoint.hostname;
