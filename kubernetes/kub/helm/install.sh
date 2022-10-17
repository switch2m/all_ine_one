helm template -f values/redis-value.yaml charts/redis
helm template -f values/checkout-service-value.yaml charts/microservice
helm template -f values/email-service-value.yaml charts/microservice
 #sometime u could need to make the script executable by running this command chmod u+x install.sh 
 #on windows run the script using git bash terminal ./install.sh
