import json
import urllib.parse
import boto3
import os
from os import environ
import piexif

print('Loading function')

s3 = boto3.client('s3')


def lambda_handler(event, context):
    Bucket_A = event['Records'][0]['s3']['bucket']['name']
    Bucket_B = os.environ.get('Bucket_B')

    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    try:
        response = s3.get_object(Bucket=Bucket_A, Key=key)
        download_response = s3.download_file(Bucket_A, key, "/tmp/{}".format(key))
        print('Object {} was successfully downloaded'.format(key))
    except Exception as e:
        print(e)
        print('Error uploading object {} to bucket: {}.'.format(key, Bucket_B))
        raise e
        
    try: 
        piexif.remove("/tmp/{}".format(key))
        upload_response = s3.upload_file("/tmp/{}".format(key), Bucket_B, key)
        print('Object {} was successfully uploaded to bucket: {}'.format(key, Bucket_B))
        return upload_response
    except Exception as e:
        print(e)
        print('Error uploading object {} to bucket: {}.'.format(key, Bucket_B))
        raise e