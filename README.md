<!-- badges: start -->
![GitHub package.json version](https://img.shields.io/github/package-json/v/davidruvolo51/rdConvert?color=ACECF7&label=version&logo=R)
<!-- badges: end -->

# rdConvert

**rdConvert** is an R package for creating a package documentation site using [Gatsby JS](https://www.gatsbyjs.com) or your preferred web framework. Included in this package, is a workflow for converting Rd files to markdown using the code documentation started developed by [RocketSeat](https://github.com/rocketseat/gatsby-themes).

See the [rdConvert package documentation](https://davidruvolo51.github.io/rdConvert/) for more information on how to integrate `rdConvert` into your current projects, as well as view an example site.

## Usage

Install `rdConvert` using `devtools` or `remotes`.

```r
remotes::install_github("davidruvolo51/rdConvert")
```

For information and examples on customizing your site, see the [Rocket Docs documentation](https://github.com/rocketseat/gatsby-starter-rocket-docs).

## To Do

This package is experimental and will likely change. I would like to add the following features.

- [ ] The ability to customize the YAML
- [ ] Improve directory and file validation
- [ ] Customize the destination structure
- [x] Improve formatting of Rd content (specifically markdown tables)
- [x] Investigate / integrate markdown formatters (wrote basic regex)
- [x] Integration with a Gatsby template