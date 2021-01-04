# Test GO-chaos

This is code is to perform a test for ec2 functionality
in GO-chaos. 

```
terraform init 
terraform plan
terraform apply
```

Once the infrastructure is created you can start the chaos engineering test with go chaos 

```
go-chaos template ec2.json
```

