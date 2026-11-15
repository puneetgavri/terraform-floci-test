# terraform-floci-test

Test Terraform against the [Floci](https://hub.docker.com/r/hectorvent/floci) AWS emulator inside GitHub Codespaces — no real AWS account needed.

## Open in Codespaces

1. On the repo page, click **Code → Codespaces → Create codespace on main**
   (or use this link: https://codespaces.new/puneetgavri/terraform-floci-test).
2. Wait for the container to build. On start, `.devcontainer/start-emulator.sh` launches Floci on port 4566.
3. Dummy AWS credentials and `AWS_ENDPOINT_URL=http://localhost:4566` are preset via `containerEnv`.

## Test steps

```bash
terraform version
docker ps                      # should show the "floci" container

terraform init
terraform plan
terraform apply -auto-approve

terraform state list
terraform output

aws s3 ls
aws s3 cp s3://workshop-demo-bucket/hello.txt -   # prints "Hello from Terraform!"
aws dynamodb list-tables

terraform destroy -auto-approve
```

## Troubleshooting

**Connection refused on port 4566**
The emulator isn't running. Check with `docker ps`, then start it manually:
```bash
bash .devcontainer/start-emulator.sh
docker logs floci
```

**`AWS_ENDPOINT_URL` is empty**
Run `echo $AWS_ENDPOINT_URL`. If it's blank, the devcontainer env wasn't applied — rebuild the codespace
(**Command Palette → Codespaces: Rebuild Container**) or export it for the current shell:
```bash
export AWS_ENDPOINT_URL=http://localhost:4566
```

**Unsupported resource / API not implemented**
Floci may not support every AWS service or operation. Try LocalStack instead (requires an auth token):
```bash
docker rm -f floci
docker run -d --name localstack -p 4566:4566 \
  -e LOCALSTACK_AUTH_TOKEN=<your-token> \
  localstack/localstack
```
Then re-run `terraform apply`.
