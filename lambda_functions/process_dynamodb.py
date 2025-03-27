def lambda_handler(event, context):
    import json
    import boto3

    # Initialize DynamoDB client
    dynamodb = boto3.resource('dynamodb')
    table_name = 'YourDynamoDBTableName'  # Replace with your DynamoDB table name
    table = dynamodb.Table(table_name)

    # Handle different HTTP methods
    http_method = event['httpMethod']
    
    if http_method == 'GET':
        # Retrieve item from DynamoDB
        key = event['queryStringParameters']['key']  # Assuming key is passed as a query parameter
        response = table.get_item(Key={'id': key})  # Replace 'id' with your primary key
        item = response.get('Item', {})
        return {
            'statusCode': 200,
            'body': json.dumps(item)
        }

    elif http_method == 'POST':
        # Write item to DynamoDB
        body = json.loads(event['body'])
        item = {
            'id': body['id'],  # Replace 'id' with your primary key
            'data': body['data']  # Replace 'data' with your data attributes
        }
        table.put_item(Item=item)
        return {
            'statusCode': 201,
            'body': json.dumps({'message': 'Item created successfully'})
        }

    else:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'Unsupported method'})
        }