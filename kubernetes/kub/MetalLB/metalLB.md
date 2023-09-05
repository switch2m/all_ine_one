# MetalLB

docs: https://metallb.universe.tf/installation/
first u need to install all the necessary object of metalLB
```
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.11/config/manifests/metallb-native.yaml
```
after that u need to configure two metalLB CRDs
IPAddressPool 
```yaml
apiVersion: metallb.io/v1beta1 
kind: IPAddressPool 
metadata:  
  name: first-pool
  namespace: metallb-system 
spec:
  addresses:  
  -  192.168.1.240-192.168.1.250 #here it should be in the range of ur k8s internal ip adresses u can check ur nodes internal ip address to get an idea of the internal ip range
```
L2Advertisement
```yaml
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: example
  namespace: metallb-system
spec:
  ipAddressPools: #this section is used to instruct metalLB to use any of the ip addess available in this example its gonna use one in the range defined on the IPAddressPool/metallb-system (192.168.1.240-192.168.1.250)
  - first-pool
```
