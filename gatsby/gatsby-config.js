module.exports = {
  pathPrefix: "/rdConvert",
  siteMetadata: {
    siteTitle: `rdConvert`,
    defaultTitle: `rdConvert`,
    siteTitleShort: `rdConvert`,
    siteDescription: `Convert R package documentation for use in non-R web projects`,
    siteUrl: `https://davidruvolo51.github.io/rdConvert/`,
    siteAuthor: `@dcruvolo`,
    // siteImage: `/banner.png`,
    siteLanguage: `en`,
    themeColor: `#8257E6`,
    // basePath: "/rdConvert",
  },
  plugins: [
    {
      resolve: `@rocketseat/gatsby-theme-docs`,
      options: {
        configPath: `src/config`,
        docsPath: `src/docs`,
        githubUrl: `https://github.com/davidruvolo51/rdConvert`,
        baseDir: `gatsby`,
        branch: `prod`
      },
    },
    {
      resolve: `gatsby-plugin-manifest`,
      options: {
        name: `Rocketseat Gatsby Themes`,
        short_name: `RS Gatsby Themes`,
        // start_url: `/rdConvert`,
        // background_color: `#ffffff`,
        // display: `standalone`,
        // icon: `static/favicon.png`,
      },
    },
    `gatsby-plugin-sitemap`,
    `gatsby-plugin-remove-trailing-slashes`,
    {
      resolve: `gatsby-plugin-canonical-urls`,
      options: {
        siteUrl: `https://davidruvolo51.github.io/rdConvert`,
      },
    },
  ],
};
