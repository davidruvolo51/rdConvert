# `format_yaml_text`: Format YAML Text

## Description

Converted Rd files may not always render YAML markdown. This function
rendered Rd into Markdown and ensures YAML is quoted.

## Usage

```r
format_yaml_text(x)
```

## Arguments

| Argument | Description |
| -------- | ----------- |
| `x` | an Rd string |

## Examples

```r
format_yaml_text("This is a \\bold{cool} string")

```

