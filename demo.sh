#!/bin/bash

function echo_title () {
  echo -e "\033[1m$@\033[0m"
}

echo_title "Cleaning up kubernetes cluster"
kubectl delete svc/echoheaders deploy/echoheaders-deploy 2>/dev/null
kubectl delete svc/echoheaders2 deploy/echoheaders2-deploy 2>/dev/null
kubectl delete svc/default-http-backend deploy/default-http-backend-deploy 2>/dev/null
kubectl delete service/nginx-ingress deployment/nginx-ingress-controller ingress/nginx-ingress 2>/dev/null
kubectl delete service/haproxy-ingress deployment/haproxy-ingress-controller ingress/haproxy-ingress 2>/dev/null
kubectl delete service/vtm-ingress deployment/vtm-ingress-controller ingress/vtm-ingress 2>/dev/null

echo
read -rsp $'\033[1mReady to start??? Press any key...\033[0m\n' -n1 key

echo
echo_title "starting up vTM and HAProxy load-balancer"
kubectl create -f vtm-ingress-deploy.yaml
kubectl create -f vtm-ingress-svc.yaml
kubectl create -f haproxy-ingress-deploy.yaml
kubectl create -f haproxy-ingress-svc.yaml
read -rsp $'\033[1mPress any key to continue...\033[0m\n' -n1 key

echo
echo_title "starting 2 applications"
kubectl create -f echoheaders-deploy.yaml
kubectl create -f echoheaders-svc.yaml
kubectl create -f default-http-backend-deploy.yaml
kubectl create -f default-http-backend-svc.yaml
read -rsp $'\033[1mPress any key to continue...\033[0m\n' -n1 key

echo
echo_title "configuring LBing rules for 2 applications"
kubectl create -f vtm-ingress-ing.yaml
kubectl create -f haproxy-ingress-ing.yaml
read -rsp $'\033[1mPress any key to continue...\033[0m\n' -n1 key

echo
echo_title "scalling out an application"
echo "kubectl scale deployment/echoheaders-deploy --replicas=4"
kubectl scale deployment/echoheaders-deploy --replicas=4
read -rsp $'\033[1mPress any key to continue...\033[0m\n' -n1 key

echo
echo_title "adding one more LBing rule for a new application"
kubectl create -f echoheaders2-deploy.yaml
kubectl create -f echoheaders2-svc.yaml
kubectl replace -f vtm-ingress-add-rule.yaml
kubectl replace -f haproxy-ingress-add-rule.yaml
read -rsp $'\033[1mPress any key to continue...\033[0m\n' -n1 key

echo
echo_title "scalling out an other application"
echo "kubectl scale deployment/echoheaders2-deploy --replicas=6"
kubectl scale deployment/echoheaders2-deploy --replicas=6
read -rsp $'\033[1mPress any key to continue...\033[0m\n' -n1 key

echo
echo_title "scalling in an application"
echo "kubectl scale deployment/echoheaders-deploy --replicas=2"
kubectl scale deployment/echoheaders-deploy --replicas=2
read -rsp $'\033[1mPress any key to continue...\033[0m\n' -n1 key

echo
echo_title "deleting an application"
kubectl replace -f vtm-ingress-rm-rule.yaml
kubectl replace -f haproxy-ingress-rm-rule.yaml
kubectl delete svc/echoheaders2 deploy/echoheaders2-deploy 2>/dev/null
read -rsp $'\033[1mPress any key to continue...\033[0m\n' -n1 key

