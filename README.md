# sls-py-ssm-patch

####Function:
Serverless deployment of Lambdas and Step Function needed to patch instances
that are in a 'stopped' state in any particular active AIG AWS account.

####Lambda Functions Deployed:
Start EC2 Instance: Starts a stopped EC2 instance

arn:aws:lambda:[REGION]:[ACCOUNT]:function:ssm-patch-dev-ec2-start

Stop EC2 Instance:

arn:aws:lambda:[REGION]:[ACCOUNT]:function:ssm-patch-dev-ec2-stop

Patch EC2 Instance: 

arn:aws:lambda:[REGION]:[ACCOUNT]:function:ssm-patch-dev-ec2-patch

Poll Patching of EC2 Instance State: 

arn:aws:lambda:[REGION]:[ACCOUNT]:function:ssm-patch-dev-ec2-patch-poller

Poll EC2 Instance State: 

arn:aws:lambda:[REGION]:[ACCOUNT]:function:ssm-patch-dev-ec2-poller

#### Step Function Deployed:

SSMStepFunction

