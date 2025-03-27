# My Terraform AWS Serverless Project

This project provides a serverless architecture on AWS using Terraform. It includes an API Gateway, AWS Lambda functions, DynamoDB, S3, and AWS Glue, all configured to work together seamlessly.

## Project Structure

```
my-terraform-aws-serverless
├── main.tf                # Main Terraform configuration file
├── provider.tf            # AWS provider configuration
├── variables.tf           # Input variables for Terraform
├── outputs.tf             # Outputs from the Terraform configuration
├── modules                # Contains reusable Terraform modules
│   ├── api_gateway        # API Gateway module
│   │   └── main.tf
│   ├── lambda             # Lambda functions module
│   │   └── main.tf
│   ├── iam_role           # IAM role module
│   │   └── main.tf
│   ├── dynamodb           # DynamoDB module
│   │   └── main.tf
│   ├── s3                 # S3 module
│   │   └── main.tf
│   └── glue               # Glue module
│       └── main.tf
├── lambda_functions        # Contains Lambda function code
│   ├── process_dynamodb.py
│   ├── process_s3.py
│   └── process_glue.py
└── README.md              # Project documentation
```

## Requirements

- Terraform installed on your local machine.
- AWS account with appropriate permissions to create the resources defined in this project.

## Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd my-terraform-aws-serverless
   ```

2. **Configure AWS Credentials**
   Ensure your AWS credentials are configured. You can set them up using the AWS CLI:
   ```bash
   aws configure
   ```

3. **Initialize Terraform**
   Run the following command to initialize the Terraform project:
   ```bash
   terraform init
   ```

4. **Plan the Deployment**
   Generate an execution plan to see what resources will be created:
   ```bash
   terraform plan
   ```

5. **Apply the Configuration**
   Deploy the infrastructure by applying the Terraform configuration:
   ```bash
   terraform apply
   ```

6. **Access the API Gateway**
   After deployment, you will receive the API Gateway URL in the output. Use this URL to access the endpoints.

## Usage

- **/records**: Interacts with DynamoDB.
- **/processobject**: Manages objects in S3.
- **/startglue**: Triggers the AWS Glue job.

## Outputs

After running `terraform apply`, the following outputs will be available:
- API Gateway URL
- Lambda function ARNs
- S3 bucket URL for the Storage Browser

## Cleanup

To remove all resources created by this project, run:
```bash
terraform destroy
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.