# MarkdownViewer

**MarkdownViewer** is an simple markdown previewer inspired by [YiViewer](http://yen3rc.blogspot.com/2012/01/yiviewer-pandoc-html-viewer.html).

## Screenshot

![screenshot](https://raw.github.com/jason2506/MarkdownViewer/master/screenshot.png)

## Description

**YiViewer** is an simple but useful lightweight markup language previewer written in Python. It can preview markdown, reStructuredText, latex, etc. as a html page. This tool, however, requires you to install additional dependencies before you use it.

I didn't want to install the dependencies just for a small script, so I wrote this previewer, which doesn't require you to install anything else, to do the same work (but it can *only* preview markdown files).

**MarkdownViewer** can only run on Mac OS X 10.7 or higher, and it has no ability to preview markup language except for markdown. If you are using the operating system other than Mac, or you need to preview other lightweight markup languages (e.g. reStructuredText), I thinks that **YiViewer** is still a good choice for you.

## Feature

* Auto update the html preview when the file is changed.
* No need to install anything before you use it.
* You can easily export the generated html preview.

## License

**MarkdownViewer** is provided under [BSD-licensed](http://www.opensource.org/licenses/BSD-3-Clause). See LICENSE file for more detail.

This project uses [sundown](https://github.com/tanoku/sundown) as the markdown parser. This library is provided under the [ISC License](http://www.isc.org/software/license).

The app icon is designed by [Visual Pharm](http://www.visualpharm.com/). This icon is released under [CC BY-ND 3.0](http://creativecommons.org/licenses/by-nd/3.0/).
