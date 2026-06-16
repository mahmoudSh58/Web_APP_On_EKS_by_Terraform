#!/bin/bash

aws eks update-kubeconfig   --region us-east-1   --name my-eks                                         

eksctl delete iamserviceaccount   --cluster my-eks   --namespace kube-system   --name aws-load-balancer-controller   --region us-east-1 || true

eksctl create iamserviceaccount     --cluster=my-eks     --namespace=kube-system     --name=aws-load-balancer-controller     --attach-policy-arn=arn:aws:iam::617998378772:policy/AWSLoadBalancerControllerIAMPolicy     --override-existing-serviceaccounts     --region us-east-1     --approve

cd /home/ec2-user/proj01/

helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=my-eks \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=$(terraform output -raw vpc_id)
  
sleep 20
echo "Wait ....."
kubectl get deployment -n kube-system aws-load-balancer-controller

kubectl apply -f eks/serviceAccount.yaml

helm repo add autoscaler https://kubernetes.github.io/autoscaler
helm repo update

helm install cluster-autoscaler autoscaler/cluster-autoscaler \
  -n kube-system \
  --set autoDiscovery.clusterName=my-eks \
  --set awsRegion=us-east-1 \
  --set rbac.serviceAccount.create=false \
  --set rbac.serviceAccount.name=cluster-autoscaler
sleep 20
echo "Wait ....."

kubectl apply -f eks/deployment.yaml
sleep 10
echo "Wait ....."

kubectl apply -f eks/ingress_alp.yaml
sleep 10
echo "Wait ....."

kubectl get -f eks/ingress_alp.yaml