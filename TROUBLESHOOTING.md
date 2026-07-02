# TROUBLESHOOTING.md

# Capstone Project 2 - Troubleshooting and Lessons Learned

This document captures the major issues encountered during the
implementation of the project, their root causes, and the solutions
applied.

------------------------------------------------------------------------

## 1. Jenkins Service Failed to Start

### Issue

Jenkins service failed immediately after installation.

### Error

    Failed to start jenkins.service

### Root Cause

The latest Jenkins release requires Java 21 while Java 17 was installed
on the server.

### Resolution

-   Installed OpenJDK 21.
-   Restarted the Jenkins service.

### Verification

``` bash
sudo systemctl status jenkins
```

------------------------------------------------------------------------

## 2. GitHub Push Failed Due to Large Files

### Issue

GitHub rejected repository push operations.

### Error

    File terraform-provider-aws is 760 MB and exceeds GitHub limit.

### Root Cause

Terraform provider binaries and state files were accidentally committed.

### Resolution

Added:

``` text
.terraform/
*.tfstate
*.tfstate.backup
```

to `.gitignore` and removed the files from Git history.

------------------------------------------------------------------------

## 3. Docker Push Failed from Jenkins

### Issue

Docker image push failed during Jenkins pipeline execution.

### Error

    insufficient_scope: authorization failed

### Root Cause

The Jenkins user was not authenticated with Docker Hub.

### Resolution

Logged into Docker Hub using:

``` bash
docker login
```

under the Jenkins user account.

------------------------------------------------------------------------

## 4. Kubernetes ImagePullBackOff

### Issue

Pods failed to start because container images could not be pulled.

### Error

    ImagePullBackOff

### Root Cause

Images were initially built on Apple Silicon architecture and were
incompatible with Kubernetes worker nodes.

### Resolution

Rebuilt and pushed Linux compatible images and implemented Jenkins build
number tagging.

------------------------------------------------------------------------

## 5. Kubernetes API Server Connection Refused

### Issue

kubectl commands failed after cluster initialization.

### Error

    The connection to the server 172.x.x.x:6443 was refused

### Root Cause

Control plane services were still initializing.

### Resolution

Verified: - kube-apiserver - etcd - kube-controller-manager -
kube-scheduler

until all components became healthy.

------------------------------------------------------------------------

## 6. Calico CrashLoopBackOff

### Issue

Calico networking pods repeatedly crashed.

### Root Cause

containerd cgroup driver mismatch.

### Resolution

Enabled:

``` text
SystemdCgroup=true
```

inside `/etc/containerd/config.toml`.

Restarted:

``` bash
sudo systemctl restart containerd
sudo systemctl restart kubelet
```

------------------------------------------------------------------------

## 7. Worker Node Pod CrashLoopBackOff

### Issue

Application pods continuously restarted on worker nodes.

### Root Cause

Worker nodes required the same containerd cgroup configuration as the
control plane.

### Resolution

Applied the same containerd configuration to all worker nodes and
restarted services.

------------------------------------------------------------------------

## 8. Jenkinsfile Groovy Syntax Errors

### Issue

Pipeline execution failed during parsing.

### Error

    MultipleCompilationErrorsException

### Root Cause

Invalid stage and brace structure inside Jenkinsfile.

### Resolution

Rebuilt the pipeline using valid Declarative Pipeline syntax.

------------------------------------------------------------------------

## 9. Static Image Tag Deployment Issue

### Issue

Website changes were not visible after deployment.

### Root Cause

Kubernetes reused cached Docker images because a static image tag (`v1`)
was used.

### Resolution

Implemented dynamic image tagging using Jenkins build numbers:

``` text
anshu9103/capstone-website:${BUILD_NUMBER}
```

------------------------------------------------------------------------

## 10. GitHub Webhook Not Triggering Jenkins Builds

### Issue

Jenkins pipelines only worked when triggered manually.

### Root Cause

GitHub webhook integration was not configured.

### Resolution

Configured GitHub Webhooks and enabled:

``` text
GitHub hook trigger for GITScm polling
```

------------------------------------------------------------------------

## Lessons Learned

-   Infrastructure as Code significantly improves reproducibility.
-   Configuration Management removes manual setup errors.
-   CI/CD pipelines reduce deployment time and improve consistency.
-   Containerization simplifies portability across environments.
-   Kubernetes provides scalability and high availability.
-   Troubleshooting skills are as important as implementation skills in
    real-world DevOps environments.

------------------------------------------------------------------------

## Final Outcome

All major issues were successfully resolved and the platform achieved:

-   Automated Infrastructure Provisioning
-   Automated Configuration Management
-   Automated CI/CD Pipeline
-   Automated Docker Image Deployment
-   Automated Kubernetes Rollout

The project successfully demonstrated an end-to-end DevOps lifecycle
implementation.