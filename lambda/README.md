```tf
module "sample" {
  source = "git@github.com:PerxTech/terraform-modules.git//lambda"
  source_dir = "${path.module}/../dist/apps/sample"
}
```
