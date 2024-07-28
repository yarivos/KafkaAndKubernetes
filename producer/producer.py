from producer_config import *

import requests
import random
import time
from kafka import KafkaProducer
import json
import os
import logging
logging.basicConfig(level=logging.INFO)

# Reduce kafka logs 
kafka_logger = logging.getLogger('kafka')
kafka_logger.setLevel(logging.WARN)

# Kafka producer setup -> Changed Kafka SP to PLAINTEXT insead of SASL
producer = KafkaProducer(
    bootstrap_servers=os.getenv('KAFKA_BROKERS').split(','),
    # security_protocol=os.getenv('KAFKA_SECURITY_PROTOCOL'),
    # sasl_mechanism=os.getenv('KAFKA_SASL_MECHANISM'),
    # sasl_plain_username="user1",
    # sasl_plain_password="",
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

def get_all_breeds():
    url = f"{endpoint}v1/breeds"
    headers = {'x-api-key': f'{api_key}'}
    response = requests.get(url, headers=headers)
    
    if response.status_code == 200:
        return response.json()
    else:
        raise Exception(f"Failed to fetch breeds: {response.status_code}")

def get_random_breeds(breeds, count=10):
    if len(breeds) < count:
        raise ValueError("Not enough breeds to select from")
    return random.sample(breeds, count)

def main():
    while True:
        try:
            breeds = get_all_breeds()
            random_breeds = get_random_breeds(breeds)
            
            logging.info("Random Dog Breeds:")
            for breed in random_breeds:
                logging.info(breed['name']) # for debuging
                # Send the breed to Kafka
                producer.send('breeds', {'name': breed['name']})
            
            producer.flush()
            logging.info("\nWaiting for 60 seconds...\n")
            time.sleep(60)  # wait for 60 seconds before the next request
        except Exception as e:
            logging.info(f"Error: {e}")
            break  # exit the loop if an error occurs

if __name__ == "__main__":
    main()
