def lambda_handler(event, context):
    import boto3
    import json

    s3_client = boto3.client('s3')
    bucket_name = 'your-s3-bucket-name'  # Replace with your S3 bucket name

    if event['httpMethod'] == 'POST':
        # Store an object in S3
        body = json.loads(event['body'])
        object_key = body['key']
        object_data = body['data']

        s3_client.put_object(Bucket=bucket_name, Key=object_key, Body=object_data)
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Object stored successfully', 'key': object_key})
        }

    elif event['httpMethod'] == 'GET':
        # Retrieve an object from S3
        object_key = event['queryStringParameters']['key']

        try:
            response = s3_client.get_object(Bucket=bucket_name, Key=object_key)
            object_data = response['Body'].read().decode('utf-8')
            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'Object retrieved successfully', 'data': object_data})
            }
        except s3_client.exceptions.NoSuchKey:
            return {
                'statusCode': 404,
                'body': json.dumps({'message': 'Object not found'})
            }

    return {
        'statusCode': 400,
        'body': json.dumps({'message': 'Invalid request'})
    }