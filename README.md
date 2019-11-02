# dirac-eks
Deployment and Management of Dirac Kubernetes Cluster on AWS

# Installation
You will need to have `kubectl` installed along with `eksctl`. You can find an install script in each of the directories here to deploy that Kubernetes application.

**Note**: In the current deployment, each application is assigned to t3.large nodes in our cluster. This is achieved through a node taint and label. We patch each application to have a toleration for the node taint "dirac.washington.edu/instance-name=t3-small:NoSchedule" and apply the nodeSelector "dirac.washington.edu/instance-name: t3-small".
