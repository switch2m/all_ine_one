# Setup jenkins agent on k8s cluster
setup Jenkins Master and Agents on a K8S Cluster (the master and the agents on the same cluster not separated)
**requirement**: for this setup to spin up properly we should provision a pvc or sc or pv u can follow the nfs.yaml file on the kuberenetes directory
first we need to add the stable/jenkins helm repo

    helm repo add stable https://charts.helm.sh/stable

create the following values yaml file to be applied to the chart


    ---
    master:
      adminPassword: admin
      resources:
        limits:
          cpu: "800m" #here its the depends on your kubernetes resources
          memory: "2048Mi" 
      serviceType: NodePort # here we configured the jenkins service to be exposed on the port 32323 on one of the workers node
      nodePort: 32323
    
    persistence:
      storageClass: "nfs-client"
      size: "5Gi"
    
    #Install Default RBAC roles and bindings
    rbac:
      create: true
      readSecrets: false


###
```shell
helm install jenkins stable/jenkins --values values.yaml --namespace jenkins --create-namespace --wait
```
this will deploy jenkins on a jenkins namespace
after that we should configure the global security first by changing the security realm field to Jenkins owner user database
an the Authorization field to logged in user can do anything
after that go the manage plugins and install the kubernetes plugin and all desired plugin 

After that we should configure the kubernetes plugin on the manage cloud field

![image](https://github.com/switch2m/all_ine_one/blob/d0c078f47ad95c98211392aa308e9aa636876cdd/jenkins/Capture1.PNG)
###
![image](https://github.com/switch2m/all_ine_one/blob/d0c078f47ad95c98211392aa308e9aa636876cdd/jenkins/Capture2.PNG)
###
![image](https://github.com/switch2m/all_ine_one/blob/d0c078f47ad95c98211392aa308e9aa636876cdd/jenkins/Capture3.PNG)
###
![image](https://github.com/switch2m/all_ine_one/blob/d0c078f47ad95c98211392aa308e9aa636876cdd/jenkins/Capture4.PNG)
###
![image](https://github.com/switch2m/all_ine_one/blob/d0c078f47ad95c98211392aa308e9aa636876cdd/jenkins/Capture6.PNG)


