# `format_md_table`: Format Markdown Table

## Description

In converted markdown files, the markup can be a bit funny and will render
properly. This is caused by extra spaces, no spaces between column
characters, and multiple backticks around arguments. This function cleans
markdown tables.

## Usage

```r
format_md_table(x)
```

## Arguments

| Argument | Description |
| -------- | ----------- |
| `x` | a string or array containing markdown |

