import os
import boto3
import json
ENV = os.environ.get('environment')
FIRST_STRING = os.environ.get('value_one')
SECOND_STRING = os.environ.get('value_tow')

BOTO_LAMBDA = 'lambda'
LAMBDA_CLIENT = None


def lambda_handler(event, context):

    global LAMBDA_CLIENT
    if not LAMBDA_CLIENT:
        LAMBDA_CLIENT = boto3.client(BOTO_LAMBDA)

    encoded_payload = json.dumps({'first_value': FIRST_STRING, 'second_value':SECOND_STRING}).encode('utf-8')

    invoke_resp = LAMBDA_CLIENT.invoke(
        FunctionName='second_lambda',
        InvocationType='RequestResponse',
        Payload=encoded_payload)

    status_code = invoke_resp['StatusCode']
    if status_code != 200:
        raise RuntimeError('Call to target lambda failed')

    results = {}
    if invoke_resp['Payload']:
        payload = invoke_resp['Payload'].read()
        results = json.loads(payload)

    print('---------------------------------------------')
    print(results)
