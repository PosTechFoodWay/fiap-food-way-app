init:
	@terraform init

validate:
	@terraform validate

lint:
	@terraform fmt

plan:
	@terraform plan

apply:
	@terraform apply --auto-approve

destroy:
	@terraform destroy