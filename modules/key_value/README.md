<!-- BEGIN_TF_DOCS -->


<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.9)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (>= 1.13, < 3)

## Resources

The following resources are used by this module:

- [azapi_resource.keyvaules](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_app_configuration"></a> [app\_configuration](#input\_app\_configuration)

Description: The App Configuration resource for which replicas are being created

Type:

```hcl
object({
    resource_id = string
  })
```

### <a name="input_content_type"></a> [content\_type](#input\_content\_type)

Description: Content type of the key

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: Name of the key

Type: `string`

### <a name="input_value"></a> [value](#input\_value)

Description: Value of the key

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Tags for the key

Type: `map(string)`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_name"></a> [name](#output\_name)

Description: The name of the key value that was deployed.

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: The resource ID of the replica that was deployed.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->