# EKS cluster with applications

This project is used to deploy AWS EKS cluster from scratch with some testing applications.  

## Prerequisites
This approach is tested on Ubuntu 22.04.3 LTS on Windows WSL2.  
You need to have AWS account with S3 bucket deployed to store terrafrom state files.

### 1. Install Docker and Act (local runner for GitHub actions)

* Docker: https://docs.docker.com/engine/install/ubuntu/ 
* Act: https://github.com/nektos/act

### 2. Generate self-signed certificate
#### a. Generate a private key using the following command.

`mkdir .certificates/`
`openssl genrsa -out .certificates/secure-api.key 2048`

#### b. Generate a public key with the following command. I set “*.svc.cluster.aws” as “Common Name”.

`openssl req -x509 -new -nodes -days 365 -key ./.certificates/secure-api.key -out ./.certificates/secure-api.crt -subj "/CN=secure-api.svc.cluster.aws" -addext "subjectAltName = DNS:secure-api.svc.cluster.aws" `

### 3. Create file with AWS credentials and other environment variables

```
Example:

cat << EOF > .env
AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXX
AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXX
AWS_DEFAULT_REGION=<region>
TFSTATE_BUCKET=<bucket_name>
TFSTATE_REGION=<bucket_region>

# These vars will be passed to k8s secret
TF_VAR_PSP_ENCRYPTION_SALT=01
TF_VAR_PSP_ENCRYPTION_KEY=XXXXXXXXXXXXXXX
TF_VAR_HCHA_URL=https://vault.service
TF_VAR_HCHA_PORT=8443
TF_VAR_HC_VAULT_TOKEN=XXXXXXXXXXXXXXXXXXX
TF_VAR_HC_VAULT_ACCESSOR=XXXXXXXXXXXXXXXXXXXXXXXXXX
EOF
```  

## 4. Deploy EKS and applications using Act. File with env vars should be passed to the Act runtime.

```act -j eks-deploy --env-file .env```

## 5. Configure access to the applications

After job finishes sucessfully you will get an output with NLB DNS name
```
Outputs:

nlb_dns_name = "ae4a0df51676948d2b637d8c16ac9efc-57bda13f48aff47b.elb.eu-west-1.amazonaws.com"
```
You need to resolve this DNS name to IP and update `/etc/hosts` (or `C:\Windows\System32\drivers\etc\hosts` in case of Windows WSL2) file to have an access to services in cluster through NLB (1 NLB public IP is enough)
```
52.48.166.10  secure-api.svc.cluster.aws
```

Now you can reach out application over browser

* https://secure-api.svc.cluster.aws/

## Destroy EKS and applications using Act

```act -j eks-destroy --env-file .env```


<!-- eksctl get iamidentitymapping --cluster main

eksctl create iamidentitymapping \
    --cluster main \
    --arn arn:aws:iam::659192515497:user/reader \
    --username readonly-user -->