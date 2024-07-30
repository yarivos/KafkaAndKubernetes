from kafka import KafkaConsumer
import os
import json
import logging
logging.basicConfig(level=logging.INFO,
                    format='%(message)s') 

# Reduce Kafka logs to minimum to make stdout readable.
kafka_logger = logging.getLogger('kafka')
kafka_logger.setLevel(logging.WARN)


brokers = os.getenv('KAFKA_BROKERS').split(',')
logging.info(f"Brokers: {brokers}")  # Self Check, Broker Has Been Set By ENV

consumer = KafkaConsumer(
    'breeds',
    bootstrap_servers=brokers,
    group_id=os.getenv('KAFKA_GROUP_ID'),
    value_deserializer=lambda m: json.loads(m.decode('utf-8'),
    )
)

for message in consumer:
    logging.info(f"Received breed: {message.value['name']}")
