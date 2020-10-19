# `format_blank_lines`: Format Sequential blank lines

## Description

In some instances, there may be more than one blank line in between
paragraphs. This function ensures there is only 1 blank line.

## Usage

```r
format_blank_lines(x)
```

## Arguments

| Argument | Description |
| -------- | ----------- |
| `x` | a character |

## Examples

```r
format_blank_lines(c("This has", "", "", "", "multiple", "", "","", "", "blank lines"))

```

