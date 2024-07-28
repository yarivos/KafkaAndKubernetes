# Yariv's Assignment
## Prerequisites
1. Docker Enigne
2. K8s Command Line Tool
3. minikube
4. helm
5. Copy of Yariv's Yotpo-Assignment, found on GitHub https://github.com/yarivos/KafkaAndKubernetes

## Instructions
#### Running on minikube

1. Make sure docker engine is running
2. In shell run minikube using ```minikube start``` command
3. Navigate your shell destination to the assignment folder
4. run command ```helm install yariv .``` to install the chart to kubernetes.
5. View logs of consumer container using the command  ```kubectl logs -l app=consumer -f ```

## Architecture Explanation
Assignment is running on minikube which allows to run kubernetes locally.

1. Producer - a kubernetes deployment which fetches data from an api and pushes it to Kafka.
2. Kafka Brokers/Controllers - A kubernetes StatefulSet which holds 4 replicas. 
    Includes 4 brokers in order to ensure high availablitiy of the kafka ecosystem.
    Kafka ecosystem holds one topic named "breeds" which has 2 partitions in order to allow faster streaming of data to consumers.
3. Consumer - a kubernetes deployment which pulls data from kafka and streams it to std out.
    Includes 2 replicas in order to ensure flow of data.

Producer and Consumer are containers built for this project.