(window.webpackJsonp=window.webpackJsonp||[]).push([[7],{xQMu:function(e,t,a){"use strict";a.r(t);a("q1tI");var o=a("wx14"),n=a("zLVn"),i=a("7ljp"),c=a("qKvR"),r={_frontmatter:{}};function s(e){var t=e.components,a=Object(n.a)(e,["components"]);return Object(i.mdx)("wrapper",Object(o.a)({},r,a,{components:t,mdxType:"MDXLayout"}),Object(i.mdx)("p",null,Object(i.mdx)("img",Object(o.a)({parentName:"p"},{src:"https://img.shields.io/github/package-json/v/davidruvolo51/rdConvert?color=ACECF7&label=version&logo=R",alt:"GitHub package.json version"}))),Object(i.mdx)("h1",{id:"introduction",style:{position:"relative"}},Object(i.mdx)("a",Object(o.a)({parentName:"h1"},{href:"#introduction","aria-label":"introduction permalink",className:"anchor before"}),Object(i.mdx)("svg",Object(o.a)({parentName:"a"},{"aria-hidden":"true",focusable:"false",height:"16",version:"1.1",viewBox:"0 0 16 16",width:"16"}),Object(i.mdx)("path",Object(o.a)({parentName:"svg"},{fillRule:"evenodd",d:"M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"})))),"Introduction"),Object(i.mdx)("p",null,Object(i.mdx)("strong",{parentName:"p"},"rdConvert")," is an R package for creating a package documentation site using ",Object(i.mdx)("a",Object(o.a)({parentName:"p"},{href:"https://www.gatsbyjs.com"}),"Gatsby JS")," or your preferred web framework. Included in this package, is a workflow for converting Rd files to markdown using the code documentation started developed by ",Object(i.mdx)("a",Object(o.a)({parentName:"p"},{href:"https://github.com/rocketseat/gatsby-themes"}),"RocketSeat"),". This theme gives you the essential tools for generating a Gatsby site."),Object(i.mdx)("h2",{id:"motiviation",style:{position:"relative"}},Object(i.mdx)("a",Object(o.a)({parentName:"h2"},{href:"#motiviation","aria-label":"motiviation permalink",className:"anchor before"}),Object(i.mdx)("svg",Object(o.a)({parentName:"a"},{"aria-hidden":"true",focusable:"false",height:"16",version:"1.1",viewBox:"0 0 16 16",width:"16"}),Object(i.mdx)("path",Object(o.a)({parentName:"svg"},{fillRule:"evenodd",d:"M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"})))),"Motiviation"),Object(i.mdx)("p",null,"My motiviation for this project was to figure out how to integrated R package files with other web frameworks. I use React and Gatsby for other proejcts and I wanted to see if it was possible to create a Gatsby site from R man files. The idea behind this workflow is:"),Object(i.mdx)("blockquote",null,Object(i.mdx)("p",{parentName:"blockquote"},"If you want a well-documented nice looking site, then you must document it in your R files!")),Object(i.mdx)("p",null,"This workflow could not be possible without the ",Object(i.mdx)("a",Object(o.a)({parentName:"p"},{href:"https://github.com/quantsch/Rd2md"}),"Rd2md"),", ",Object(i.mdx)("a",Object(o.a)({parentName:"p"},{href:"https://github.com/yihui/Rd2roxygen"}),"Rd2roxygen"),", and ",Object(i.mdx)("a",Object(o.a)({parentName:"p"},{href:"https://github.com/r-lib/roxygen2md"}),"roxygen2md")," packages. Alternatively, you can opt out of Gatsby steps and use it as Rd to Md converter."),Object(i.mdx)("h2",{id:"have-questions",style:{position:"relative"}},Object(i.mdx)("a",Object(o.a)({parentName:"h2"},{href:"#have-questions","aria-label":"have questions permalink",className:"anchor before"}),Object(i.mdx)("svg",Object(o.a)({parentName:"a"},{"aria-hidden":"true",focusable:"false",height:"16",version:"1.1",viewBox:"0 0 16 16",width:"16"}),Object(i.mdx)("path",Object(o.a)({parentName:"svg"},{fillRule:"evenodd",d:"M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"})))),"Have questions?"),Object(i.mdx)("p",null,"If you have questions, feel free to open a new issue on ",Object(i.mdx)("a",Object(o.a)({parentName:"p"},{href:"https://github.com/davidruvolo51/rdConvert"}),"rdConvert GitHub repository"),". Take a look at the code and files to see how the project should be structured. Checkout the ",Object(i.mdx)("a",Object(o.a)({parentName:"p"},{href:"https://github.com/rocketseat/gatsby-themes"}),"RocketSeat Gatsby Theme GitHub repository")," for information on customizing the site."))}s.isMDXComponent=!0;var d=a("tnhK"),h=a("dcqB");function m(){return Object(c.d)(d.a,null,Object(c.d)(h.a,null),Object(c.d)(s,null))}t.default=function(){return Object(c.d)(m,null)}}}]);
//# sourceMappingURL=component---node-modules-rocketseat-gatsby-theme-docs-core-src-templates-homepage-query-js-5fd0e0bdc6eb7d47257e.js.map