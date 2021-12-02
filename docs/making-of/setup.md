# Feature: Project Setup

Goal: Project setup is ready to begin.


## Details

- [x] [Git repository on Github](#git-repository-on-github)
- [x] [Making-Of setup on Github Pages](#making-of-setup-on-github-pages)
- [x] [VS Code setup](#vs-code-setup)
- [x] [Empty Elm project](#empty-elm-project)
- [x] [Elm-Book trial](#elm-book-trial)


## Git repository on Github

I start with my Github user for "not yet ready" projects.
This project is named "elm-interactive-blog".
The main branch is "main".

For accessing the Github repository I execute the following steps:

```text
$ git config credential.github.com.usehttppath true
$ git credential approve
url=https://github.com/<user>
username=<user>
password=<personal-access-token>
<newline>
```

After that I'm able to push to the repository.


## Making-Of setup on Github Pages

The branch name is "gh-pages".
It is an orphaned branch,
so its commit history is independent of the other branches.

The contents is located in the "docs" subdirectory.

In order to have both the Making-Of docs and the sources checked out simultaneously,
I create a git-ignored subdirectory named ".gh-pages".
In this subdirectory I have the "gh-pages" branch checked out.


## VS Code setup

I create a workspace with both the top-level and the ".gh-pages" folders.
Because this workspace is needed mainly to be able to edit the Making-Of docs in parallel,
I name the workspace file "making-of.code-workspace".

Of course I use my VS Code extension [making-of-vscode](https://github.com/pitnyr/making-of-vscode) 😀

The configuration is pretty normal:
```text
making-of.localPath  = /docs/
making-of.publishUrl = https://pitnyr.github.io/elm-interactive-blog/
making-of.sourceUrl  = https://github.com/pitnyr/elm-interactive-blog/
```


## Empty Elm project

All there is to do is executing "elm init" and creating a simple "Main.elm" file.

I also add a short README.


<a id="commit-2021-12-01-16-56"></a>

## Summary so far

Nothing very special so far. To summarize the commit:

```text
.gitignore               - for elm-stuff and .gh-pages directories
README.md                - short text with link to GH Pages docs
elm.json                 - generated
making-of.code-workspace - VS Code workspace (2 folders, settings)
src/Main.elm             - Hello world Elm code
```

[commit-2021-12-01-16-56](https://github.com/pitnyr/elm-interactive-blog/commit/fb8d62644b3dd949398b8c5c246fda8f42f27a58)
```email
subject: Create basic project structure
```


## Elm-Book trial

Now it's getting more interesting.
For the blog I'm planning to use [elm-book](https://package.elm-lang.org/packages/dtwrks/elm-book/latest/)
from Georges Boris.
Let's see if there's something like a getting-started or tutorial...

Of course there is 👍
I start simple with the demo book consisting of one demo chapter:

<a id="commit-2021-12-01-17-23"></a>

[commit-2021-12-01-17-23](https://github.com/pitnyr/elm-interactive-blog/commit/af725812ec0f27c48fce94539e3b4cb01828b232)
```email
subject: Create demo book with one demo chapter
```

<a id="commit-2021-12-01-18-55"></a>

The second (and last) thing I want to try in the "setup" feature branch are so-called "stateful" chapters.

[commit-2021-12-01-18-55](https://github.com/pitnyr/elm-interactive-blog/commit/ff5a9f92f3ea580c5760068afc9a3b4fcef3ae0c)
```email
subject: Add two chapters with state
```

<a id="commit-2021-12-02-20-39"></a>

Oh, and it is possible to create something like stateful markdown by using components with tag attribute
`with-display="inline"`. (It doesn't seem to work if the tag is at the beginning of a line, though.
In the example I used a space character in front of the component tag...)

[commit-2021-12-02-20-39](https://github.com/pitnyr/elm-interactive-blog/commit/7da6fd9d9e5f7c4bd321043ed6e8365cee2f81be)
```email
subject: Add example for stateful-like markdown
```


## Done

OK, ready to be [merged into the main branch](main.md#commit-2021-12-02-20-50).