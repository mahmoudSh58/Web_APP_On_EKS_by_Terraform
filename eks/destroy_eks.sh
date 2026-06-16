#!/bin/bash                                       

kubectl delete -f eks/ingress_alp.yaml

kubectl delete -f eks/deployment.yaml

helm uninstall cluster-autoscaler -n kube-system 

kubectl delete -f eks/serviceAccount.yaml

helm uninstall aws-load-balancer-controller -n kube-system  

eksctl delete iamserviceaccount   --cluster my-eks   --namespace kube-system   --name aws-load-balancer-controller   --region us-east-1 
cd /home/ec2-user/proj01/











