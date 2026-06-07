import json
import logging
import urllib.parse

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    logger.info("Event received: %s", json.dumps(event))
    for record in event.get("Records", []):
        bucket = record["s3"]["bucket"]["name"]
        key = urllib.parse.unquote_plus(record["s3"]["object"]["key"], encoding="utf-8")
        size = record["s3"]["object"].get("size", "unknown")
        logger.info("Image received: %s", key)
        logger.info("Details — bucket: %s | key: %s | size: %s bytes", bucket, key, size)
    return {
        "statusCode": 200,
        "body": json.dumps({"message": "Asset processed successfully"})
    }
