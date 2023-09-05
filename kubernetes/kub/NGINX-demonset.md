 # NGINX Controller as a DeamonSet

first u need to setup nginx controller on your k8s cluster
```
helm repo add ingress-nginx https://kubernetes.git
hub.io/ingress-nginx
```
if u wanna edit the values run this command and customize the values yaml file
in here u should enable the hostPort and also set the the hostNetwork to true in case ur cluster was boostraped using kubeadm:
hostNetwork: false
kind: DaemonSet
```
helm show values ingress-nginx --repo https://kubernetes.github.io/ingress-nginx > values.yaml
```
then u can run this command to install nginx on  ur cluster
```
helm install my-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace -f values.yaml
```
