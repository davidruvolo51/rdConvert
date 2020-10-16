# rdConvert

`rdConvert` is a workflow for converting and preparing `Rd` files for use in web frameworks outside the R ecosystem. For example, [Gatsby](https://www.gatsbyjs.com), [Svelte](https://svelte.dev), or [Vue.js](https://vuejs.org). This allows you to integrate R package documentation into your existing projects or workflows.

Markdown files are parsed using the `Rd2markdown` file from the [Rd2md package](https://github.com/quantsch/Rd2md). Markdown YAML's are generated by parsing Rd files using `parse_file` from the [Rd2roxygen package](https://github.com/yihui/Rd2roxygen) and rendered using `markdownify` from [roxygen2md](https://github.com/r-lib/roxygen2md).

## Usage

You can install `rdConvert` using `devtools` or `remotes`.

```r
remotes::install_github("davidruvolo51/rdConvert")
```

This workflow is desired for existing or active package development projects. 

### 1. Create a new converter

To get started, create a new instance of `convert` and set a destination directory (i.e., where the markdown files will be written).

```r
myPkg <- rdConvert::convert$new(destDir = "gatsby/src/pages/")
```

### 2. Define entry and output points

Next, run `$set_entries`. This will collate the entry and output points based on Rd file names. Use `$files` to view the result.

```r
myPkg$set_entries()   # build paths
myPkg$files           # view
```

### 3. Convert Rd to Md

Then, `$convert_rds` will convert Rd files to markdown using the paths defined in the previous step.

```r
myPkg$convert_rds()
```

### 4. Add YAML

Lastly, you can add a YAML to each file. This is useful if for blog generators (e.g., Gatsby).

```r
myPkg$add_yaml()
```

## To Do

This package is experimental and will likely change. I would like to add the following features.

- The ability to customize the YAML
- Improve formatting of Rd content (specifically markdown tables)
- Improve directory and file validation
- Investigate / integrate markdown formatters (from NPM?)
- Customize the destination structure: by default, files are rendered into `rd_file_name/index.md`. For example, if you have a `Rd` file named `my_function.Rd`, the output path would be `my_function/index.md`. (I decided to align the output folder structure with Gatsby blog project. Perhaps this could be modified post `$set_entries`.)

Depending on your preferred text editor / IDE, a markdown formatter could be helpful for further file optimizations. 