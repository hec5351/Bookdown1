setwd("/Users/haleyecurtis/WFS597/Bookdown")

# Create the folders (the hidden .github/workflows folders are created too)
dir.create("my-first-book/.github/workflows", recursive = TRUE)

# index.Rmd: the first page of the book
writeLines(r"(---
title: "My First Book"
site: bookdown::bookdown_site
---

# Welcome {-}

This is my first book, published with GitHub Pages.
)", "my-first-book/index.Rmd")

# 01-first-chapter.Rmd: a chapter containing a live code chunk.
# The object "fence" holds three backticks, which mark the start and end of a code chunk.
fence <- "```"
writeLines(c(
  "# My First Chapter",
  "",
  "This page was built from an RMarkdown file. The code below runs every time the book is built.",
  "",
  paste0(fence, "{r}"),
  "summary(cars)",
  fence
), "my-first-book/01-first-chapter.Rmd")

fence <- "```"
cat("\nHere is a plot of the built-in cars dataset:\n\n", fence, "{r}\nplot(cars)\n", fence, "\n",
    sep = "", file = "01-first-chapter.Rmd", append = TRUE)
bookdown::render_book("index.Rmd", output_format = "bookdown::gitbook")
browseURL("docs/index.html")

# _bookdown.yml: which files make up the book, and where the finished website goes
writeLines(r"(book_filename: "my-first-book"
output_dir: "docs"
delete_merged_file: true
rmd_files: ["index.Rmd", "01-first-chapter.Rmd"]
)", "my-first-book/_bookdown.yml")

# _output.yml: the output format (a GitBook-style website)
writeLines(r"(bookdown::gitbook:
  config:
    toc:
      collapse: section
)", "my-first-book/_output.yml")

# .gitignore: files Git should not track (the built website is rebuilt by GitHub)
writeLines(c(
  ".Rproj.user",
  ".Rhistory",
  ".RData",
  ".DS_Store",
  "/docs/",
  "/_book/",
  "/_bookdown_files/",
  "/my-first-book.Rmd",
  "/_main.Rmd",
  "*.knit.md",
  "*.utf8.md"
), "my-first-book/.gitignore")

# publish.yml: the GitHub Actions workflow that builds and publishes the book
writeLines(r"(name: Render and deploy book

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: r-lib/actions/setup-r@v2
        with:
          r-version: 'release'

      - uses: r-lib/actions/setup-pandoc@v2

      - name: Install R package dependencies
        run: |
          install.packages(c("bookdown", "rmarkdown"))
        shell: Rscript {0}

      - name: Render book
        run: |
          bookdown::render_book("index.Rmd", output_format = "bookdown::gitbook")
        shell: Rscript {0}

      - uses: actions/upload-pages-artifact@v3
        with:
          path: docs

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
)", "my-first-book/.github/workflows/publish.yml")

setwd("my-first-book")
bookdown::render_book("index.Rmd", output_format = "bookdown::gitbook")
browseURL("docs/index.html")

fence <- "```"
cat("\n", fence, "{r}\nlibrary(DBI)\n", fence, "\n", sep = "", file = "01-first-chapter.Rmd", append = TRUE)

fence <- "```"
cat("\n", fence, "{r}\nlibrary(DBI)\n", fence, "\n", sep = "", file = "01-first-chapter.Rmd", append = TRUE)
