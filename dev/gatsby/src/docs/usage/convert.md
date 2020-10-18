# `convert`: Rd to Md Workflow

## Description

As R6 class for converting Rd files to markdown with YAML headers. This may
be useful if you wish to use package documentation in static site generators
outside of the R ecosystem (e.g., React, Vue, Svelte, Gatsby, etc.). By
default, Rd files are rendered into their own directory with an independent
`index.md` file. The Rd name is parsed and set as the child directory name.

For example, if you have the file `man/my_cool_function.Rd` , the output
path and file will be: `my_cool_function/index.md`

The entry point will always be `man` .

## Value

Convert Rd files to Markdown files

