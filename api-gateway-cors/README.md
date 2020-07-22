To support CORS at Api gateway level, an `OPTIONS` method needs to be added to each resource.
This method needs to expose 3 key headers with specific values. This is a lot of boiler plate code, that this module prevents.

```tf
# CORS
module "proxy_cors" {
  source = "git@github.com:PerxTech/terraform-modules.git//api-gateway-cors"
  resource_id = aws_api_gateway_resource.proxy.id
  api_id = aws_api_gateway_rest_api.api.id
}
```
