<!-- badges: start -->
![GitHub package.json version](https://img.shields.io/github/package-json/v/davidruvolo51/rdConvert?color=ACECF7&label=version&logo=R)
<!-- badges: end -->

# rdConvert

`rdConvert` is a workflow for converting and preparing `Rd` files for use in web frameworks outside the R ecosystem. For example, [Gatsby](https://www.gatsbyjs.com), [Svelte](https://svelte.dev), or [Vue.js](https://vuejs.org). This allows you to integrate R package documentation into your existing web projects. This workflow was created using the [Rd2md](https://github.com/quantsch/Rd2md), [Rd2roxygen](https://github.com/yihui/Rd2roxygen), and [roxygen2md](https://github.com/r-lib/roxygen2md) packages.

## Usage

Install `rdConvert` using `devtools` or `remotes`.

```r
remotes::install_github("davidruvolo51/rdConvert")
```

## Workflow

The `rdConvert` workflow is desired for creating markdown files for use in documentation sites using a static site generator. Steps 1 through 5 can be used for any project. The optional steps (6+) were created to align with the Gatsby JS template [Rocket Docs](https://github.com/Rocketseat/gatsby-starter-rocket-docs).

### 1. Create a new converter

To get started, create a new instance of `convert`. Set the project name and the destination directory (i.e., where the markdown files will be written).

```r
pkg <- rdConvert::convert$new(
    pkg_name = "My Cool Project",
    dest_dir = "gatsby/src/pages/"
)
```

By default, all output files are written to markdown format using the same filename as the Rd file. You can also set the output file format to `md` or `mdx` using the `file_format` argument.

```r
pkg <- rdConvert::convert$new(
    pkg_name = "My Cool Project",
    dest_dir = "gatsby/src/pages/",
    file_format = "mdx"
)
```

### 2. Define entry and output points

Next, run `$set_entries`. This will collate the entry and output points based on Rd file names. Use `$entries` to view the result.

```r
pkg$set_entries()   # build paths
pkg$entries         # view
```

### 3. Validate and Create Output Points

When you have confirmed the entry and destination points, create the destination paths.

```r
pkg$set_destinations()
```

### 4. Convert Rd to Md

Then, `$convert_rds` will convert Rd files to markdown using the paths defined in the previous step.

```r
pkg$convert_rds()
```

### 5. Formatting Markdown Files

The rendered markdown files may not always be perfect. Extra lines and leading blank spaces are common, and markdown tables may include extract characters that can effect the layouts. Running `$format_markdown` will *clean* the converted markdown files.

```r
pkg$format_markdown()
```

### 5. Add YAML

Lastly, you can add a YAML to each file. This is useful if for blog generators (e.g., Gatsby).

```r
pkg$add_yaml()
```

### Optional Steps

The following steps are useful for aligning markdown files for use in the Gatsby JS template [Rocket Docs](https://github.com/Rocketseat/gatsby-starter-rocket-docs). This template provides the necessary elements for creating a site from the documentation.

To get started, make [nodejs](https://nodejs.org/en/) is installed. In the terminal, install [Gatsby](https://www.gatsbyjs.com/docs/quick-start/).

```shell
npm install -g gatsby-cli
```

Create a new [rocket docs project](https://rocketdocs.netlify.app/getting-started). I recommend creating a subproject within your R package to prevent conflicts with existing package configuration files.

```shell
gatsby new rocket-docs https://github.com/rocketseat/gatsby-starter-rocket-docs
```

In R, set the destination path to align with Rocket Docs: `src/docs/usage/`.

```r
# create new converter
pkg <- rdConvert::convert$new(
    pkg_name = "My Cool Package",
    dest_dir = "rocket-docs/src/docs/usage"
)
```

#### 6. Set Sidebar YML

Rocket Docs uses a yml configuration file to render the sidebar navigation. The functions `$set_sidebar_yml` and `$save_sidebar_yml` can help automate this process using the object `$entries`.

```r
# generate sidebar.yml
pkg$set_sidebar_yml(repo_url = "https://github.com/davidruvolo51/rdConvert")
mkyPkg$yml

# save
pkg$save_sidebar_yml(path = "rocket-docs/src/config/")
```

For information and examples on customizing your site, see the [Rocket Docs documentation](https://github.com/rocketseat/gatsby-starter-rocket-docs).

## To Do

This package is experimental and will likely change. I would like to add the following features.

- The ability to customize the YAML
- Improve directory and file validation
- Customize the destination structure
- [x] Improve formatting of Rd content (specifically markdown tables)
- [x] Investigate / integrate markdown formatters (wrote basic regex)
- [x] Integration with a Gatsby template