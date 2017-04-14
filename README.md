# meetup_k8s_soft_loadbalancers
Yaml files used during the meetup about Kubernetes and software loadbalancers.

Slides from the meetup:

  * https://www.slideshare.net/haproxytech/kubernetes-and-software-load-balancers-73598367

The following actions are performed during this demo:

  * clean up of the kubernetes cluster
  * setup of **HAProxy** and **Brocade vTM** load-balancers
  * setup of 2 applications: **echoheaders** and **default-http-backend**
  * setup of **ingress** rules for both load-balancer and *watch auto-configuration happening*
  * scalling out **echoheaders** application and *watch auto-configuration happening*
  * add a new application **echoheaders2** and update the **ingress** rules and *watch auto-configuration happening*
  * scalling out **echoheaders2** application and *watch auto-configuration happening*
  * scalling in **echoheaders** application and *watch auto-configuration happening*
  * Remove **echoheaders2** application and update the ingress rules and *watch auto-configuration happening*

