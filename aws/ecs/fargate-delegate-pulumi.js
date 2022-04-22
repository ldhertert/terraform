"use strict";
const pulumi = require("@pulumi/pulumi");
const awsx = require('@pulumi/awsx');
const aws = require('@pulumi/aws');

// NOTE: This will create a new cluster

const taskExecutionRole = new aws.iam.Role("taskExecutionRole", {
    assumeRolePolicy: {
        Version: "2012-10-17",
        Statement: [{
            Action: "sts:AssumeRole",
            Principal: {
                Service: "ec2.amazonaws.com"
            },
            Effect: "Allow",
            Sid: "",
        }]
    },
    managedPolicyArns: [
        aws.iam.ManagedPolicies.AmazonEC2ContainerServiceforEC2Role,
        aws.iam.ManagedPolicies.AmazonEC2ContainerServiceRole,
        aws.iam.ManagedPolicies.AmazonEC2ContainerRegistryReadOnly,
    ],
    inlinePolicies: [{
        name: 'harness-ecs-policy',
        policy: JSON.stringify({
            Version: "2012-10-17",
            Statement: [{
                Effect: "Allow",
                Action: [
                    "ec2:DescribeRegions",
                    "ecr:DescribeRepositories",
                    "ecs:ListClusters",
                    "ecs:ListServices",
                    "ecs:DescribeServices",
                    "ecr:ListImages",
                    "ecs:RegisterTaskDefinition",
                    "ecs:CreateService",
                    "ecs:ListTasks",
                    "ecs:DescribeTasks",
                    "ecs:DeleteService",
                    "ecs:UpdateService",
                    "ecs:DescribeContainerInstances",
                    "ecs:DescribeTaskDefinition",
                    "application-autoscaling:DescribeScalableTargets",
                    "iam:ListRoles",
                    "iam:PassRole",
                    "logs:CreateLogGroup"
                ],
                Resource: "*",
            }]
        }),
    }]
});

const defaultVpc = new aws.ec2.DefaultVpc("default", {
    tags: {
        Name: "Default VPC",
    },
});


const delegateTask = new awsx.ecs.FargateTaskDefinition("delegateTask", {
    containers: {
        delegate: {
            image: "harness/delegate:latest",
            cpu: 512,
            memory: 4096,
            essential: true,
            name: "ecs-delegate",
            environment: [{"name":"ACCOUNT_ID","value":"Sy3KVuK1SZy2Z7OLhbKlNg"},{"name":"ACCOUNT_SECRET","value":"aa272cd5acfecb4070d6a0aa6436708d"},{"name":"DELEGATE_CHECK_LOCATION","value":"delegatefree.txt"},{"name":"DELEGATE_STORAGE_URL","value":"https://app.harness.io"},{"name":"DELEGATE_TYPE","value":"ECS"},{"name":"DELEGATE_GROUP_NAME","value":"dfdfssdf"},{"name":"DELEGATE_GROUP_ID","value":"Kq49qwKuRSGb_veYlnAxJA"},{"name":"DELEGATE_PROFILE","value":"kCWAocbfSoCVvMsMUnnq6A"},{"name":"INIT_SCRIPT","value":""},{"name":"DEPLOY_MODE","value":"KUBERNETES"},{"name":"MANAGER_HOST_AND_PORT","value":"https://app.harness.io/gratis"},{"name":"POLL_FOR_TASKS","value":"false"},{"name":"WATCHER_CHECK_LOCATION","value":"current.version"},{"name":"WATCHER_STORAGE_URL","value":"https://app.harness.io/public/free/freemium/watchers"},{"name":"CF_PLUGIN_HOME","value":""},{"name":"CDN_URL","value":"https://app.harness.io"},{"name":"REMOTE_WATCHER_URL_CDN","value":"https://app.harness.io/public/shared/watchers/builds"},{"name":"JRE_VERSION","value":"1.8.0_242"},{"name":"HELM3_PATH","value":""},{"name":"HELM_PATH","value":""},{"name":"CF_CLI6_PATH","value":""},{"name":"CF_CLI7_PATH","value":""},{"name":"KUSTOMIZE_PATH","value":""},{"name":"OC_PATH","value":""},{"name":"KUBECTL_PATH","value":""},{"name":"INSTALL_CLIENT_TOOLS_IN_BACKGROUND","value":"true"}],
            portMappings: [{ hostPort: 8080, "protocol": "tcp", "containerPort": 8080 }],
        },
    },
    desiredCount: 1,
    cpu: 512,
    memory: 4096,
    name: "ecs-delegate",
    iamRole: taskExecutionRole,
});

new awsx.ecs.FargateService("delegateService", {
    name: "ecs-delegate",
    desiredCount: 1,
    taskDefinition: delegateTask,
    assignPublicIp: true,
    subnets: defaultVpc.subnets
});
