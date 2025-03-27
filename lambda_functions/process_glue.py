def lambda_handler(event, context):
    import boto3
    import json

    glue_client = boto3.client('glue')

    # Extract job name from the event
    job_name = event.get('job_name', 'HelloWorld')

    try:
        # Start the Glue job
        response = glue_client.start_job_run(JobName=job_name)
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Glue job started successfully',
                'job_run_id': response['JobRunId']
            })
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Failed to start Glue job',
                'error': str(e)
            })
        }