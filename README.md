# lambda-invoking-lambda
This project demonstrates the mechanism of invoking one lambda from another lambda.

# Usage
Creating zip

 `zip first_lambda.zip first_lambda.py`
 
 `zip first_lambda.zip first_lambda.py` 
 
Run the following commands to create the infrastructure.

 `terraform init`

 `terraform plan`
 
 `terraform apply`
 
 `terraform destroy`

To run the lambda chain just use the following command and then check lambda logs for both the lambdas in cloudwatch

 `aws lambda invoke --function-name first_lambda out --log-type Tail`
 
 
