# Start Instance

import logging
import boto3

# region = 'us-east-1'
session = boto3.session.Session()
region = session.region_name

from shared.error import handle_error, preflight_env_check
from shared.lambda_types import LambdaDict, LambdaContext


logger = logging.getLogger()
logger.setLevel(logging.INFO)

ec2 = boto3.client('ec2', region_name=region)




def lambda_handler(event, context):
    try:
        ec2.start_instances(InstanceIds=[event['instanceId']])
        event['status'] = 'running'
        return event
    except Exception as e:
        print(e)
        message = 'Error starting instance'
        print(message)
        event['status'] = "FAILED"
        raise e


def event_handler(event: LambdaDict, context: LambdaContext = None) -> LambdaDict:
    try:
        log_event_and_context(context, event)
        stage = preflight_env_check("STAGE")
        logger.info(f"## stage:{stage} ##")
        if len(event) == 0:
            raise Exception("no event received")
        response = {"status": "success", "event": event}
        logger.info(response)
        return response
    except Exception as error:
        handle_error(logger, error)
        raise error



def log_event_and_context(event: LambdaDict, context: LambdaContext = None):
    if event:
        logger.info("## event ##")
        logger.info(event)
    if context:
        logger.info("## context ##")  # https://docs.aws.amazon.com/lambda/latest/dg/python-context-object.html
        if hasattr(context, 'log_stream_name'):
            logger.info("Log stream name: %s", context.log_stream_name)
        if hasattr(context, 'log_group_name'):
            logger.info("Log group name: %s", context.log_group_name)
        if hasattr(context, 'aws_request_id'):
            logger.info("Request ID: %s", context.aws_request_id)
        if hasattr(context, 'memory_limit_in_mb'):
            logger.info("Mem. limits(MB): %s", context.memory_limit_in_mb)


