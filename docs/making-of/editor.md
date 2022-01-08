# Feature: Editor

Goal: Users should be able to enter Elm code,
which later could be parsed, maybe highlighted and executed


## Details

Must

- [x] [Input area for entering and editing monospaced text](#input-area-for-editing-text)
- [x] [Possibility to programmatically set text and selection](#programmatically-set-text-and-selection)
- [x] [Integrated as an elm-book component](#elm-book-component)

Important

- [x] [Pasting styled content should not be possible](#commit-2021-12-07-14-37)

Optional

- [x] [Programmatically highlight text](#commit-2021-12-07-22-03)
- [x] [Be notified upon changes](#input-area-for-editing-text)


## Input area for editing text

There are very different ways to implement this. Here are some of them:

- **Use a simple textarea.**
  Relatively easy to implement.
  Care must be taken to enlarge the area as needed.
  No syntax highlighting.

- **Toggle between textarea and code block**
  There could be a toggle to either show the unhighlighted textarea
  or a properly highlighted code block.
  Maybe the styling can be adapted to have the same font and the same character positions?
  The user has to perform a finishing action anyway.
  No highlighting while editing.

- **Use one of the available Rich Text editors**
  Some of them are really small, but most of them offer way too much functionality.
  Highlighting while editing will not be easy.

- **Use one of the do-it-all-yourself Elm text editors**
  They have relatively much code for dealing with things like cursor positioning.
  Maybe no "standard" key bindings.

- **Implement everything using contenteditable**
  Use a div with contenteditable and add the missing features.
  There are many warnings about using contenteditable.
  At first it seems to be doable though, even with Elm.
  Special care would need to be taken to prevent pasting styled text.

Maybe it's the "not invented here" syndrome, but I prefer the textarea toggle
or the do-it-yourself contenteditable solution.

Textarea Toggle:
- (+) Relatively easy to implement with pure Elm
- (-) Two display modes
- (-) No highlighting while editing

Contenteditable
- (+) Theoretical possibility of live parsing and highlighting
- (-) More complex to implement, maybe with custom elements
- (-) Amount of work unclear

It is unclear, whether live highlighting would be possible anyway.
I'd have to have a fault tolerant parser for the Elm code.

I think I'll start trying the textarea toggle.
After all, my main goal is to write some tutorials...


<a id="commit-2021-12-07-07-33"></a>

### Self adjusting textarea

I remember having seen something in the internet...
- Here's one: <https://gist.github.com/ohanhi/cb42ba2587fefbdae6962518176d114a>
- Something else: <https://css-tricks.com/the-cleanest-trick-for-autogrowing-textareas/>
- Or here in action: <https://codepen.io/shshaw/pen/bGNJJBE>

I changed Ohanhi's implementation to work with the current Elm version,
and it works as described. (It automatically expands, but doesn't shrink.)

[commit-2021-12-07-07-33](https://github.com/pitnyr/elm-interactive-blog/commit/2365d2a15459b491013841e0bf8aca23684d6d28)
```email
subject: Add auto-expanding pure Elm textarea
```

<a id="commit-2021-12-07-14-37"></a>

I'll also try the solution of Stephen Shaw. This involves some (for my taste) heavy SCSS tricks.
Since I don't know how to implement this within Elm, I'll copy them into a index.html file...

First I had to install SASS (via npm).
Then I create a TextArea.scss file with the scss code of Stephen Shaw's example.
I generate a .css and a .js file in a new "dist" subfolder like so:

```text
sass --no-source-map src/Editor/TextArea.scss dist/TextArea.css
elm make src/Editor/TextArea.elm --output=dist/Textarea.js
```

I then create an index.html file to load the generated .css and .js files.
The code seem's to work!

[commit-2021-12-07-14-37](https://github.com/pitnyr/elm-interactive-blog/commit/0ee04ea4f9a0763b26430d95bbf0e65a3f4b48d8)
```email
subject: Add Stephen Shaw's auto-resize textarea example
```

<a id="commit-2021-12-07-17-53"></a>

For my purposes I can omit some things to make it even smaller.

[commit-2021-12-07-17-53](https://github.com/pitnyr/elm-interactive-blog/commit/89b29a6d8aa3b6cc8d7476c58c7f1a4a7297a9b3)
```email
subject: Delete some unneeded features
```

<a id="commit-2021-12-07-22-03"></a>

Could I use the enclosing element to show the highlighted text?
Turns out: yes, but unfortunately I can't style parts of the content,
because it's a pseudo-element.

But: we can use a different replica, which we can style.

[commit-2021-12-07-22-03](https://github.com/pitnyr/elm-interactive-blog/commit/2d9751f5889f749cf14539b553ff964f1a0ec0e2)
```email
subject: Add a styled replica
```

<a id="commit-2021-12-07-22-32"></a>

If we always hide the textarea, can we then have live highlightung?
Yes, this works!

[commit-2021-12-07-22-32](https://github.com/pitnyr/elm-interactive-blog/commit/49a057e7c0564a429e835c45d8b4d70e3658d6a4)
```email
subject: Implement live styled text
```

<a id="commit-2021-12-11-09-11"></a>

In Elm, I don't even need to use Javascript anymore, just CSS.
So, could this be implemented with elm-css in pure Elm?

Yes it does !!!

Besides that this is pretty cool, it should make it easier to integrate this component in elm-book.

[commit-2021-12-11-09-11](https://github.com/pitnyr/elm-interactive-blog/commit/20312718f9ee5713eba6cafccda9ece688d61473)
```email
subject: Pure Elm: delete SCSS and special index.html file
```

The last things I'd like to change:
* Use a monospaced font
* Don't wrap long lines, but show a horizontal scrollbar if needed

Both should be possible with some style changes...

As it turns out, monospaced is easy, but scrolling is hard.
It is possible to get the desired effect for the textarea with the HTML attribute "wrap" set to "off" (at least in Safari).
But when scrolling horizontally, I would need to synchronize the scroll position with the styled replica.
I think that this should be possible somehow, but currently it isn't that important to me, so I'll leave it as it is.

<a id="commit-2021-12-15-07-44"></a>

[commit-2021-12-15-07-44](https://github.com/pitnyr/elm-interactive-blog/commit/694f501af77ddeb46f1d52f4d943b6325816ed57)
```email
subject: Monospaced font, bold, initial text

Plus some minor code optimizations
```


<a id="commit-2022-01-07-18-21"></a>

## Programmatically set text and selection

Setting text shouldn't be a problem --> Indeed, just set the field in the model.

What about the selection? Is this possible without Javascript?
Found an [old reddit post](https://www.reddit.com/r/elm/comments/7e6obz/comment/dq3cocs/?utm_source=share&utm_medium=web2x&context=3):
it uses custom properties "selectionStart" and "selectionEnd".
The post is more than 4 years old, but it still works!

Problem solved :-)

[commit-2022-01-07-18-21](https://github.com/pitnyr/elm-interactive-blog/commit/1841cfff78eb8c2d9659be88e90fc3f72bb045c7)
```email
subject: Programmatically set text and selection
```


<a id="commit-2022-01-08-08-57"></a>

## Elm-book component

Adding the existing editor code to the book example kind of works, but

- converting from Elm-CSS to Elm-Html has to be done for every editor component
- the fixed header is displayed at the bottom of the textarea

[commit-2022-01-08-08-57](https://github.com/pitnyr/elm-interactive-blog/commit/7249af185525a705dc646786402c5c21e50a9d35)
```email
subject: First version of elm-book editor component
```

<a id="commit-2022-01-08-09-05"></a>

There is a CSS interop package for elm-book. I'll try this and see whether this changes anything...

Yeah - now it works as expected!

The styling and the code itself could still be nicer, but at least it works!

[commit-2022-01-08-09-05](https://github.com/pitnyr/elm-interactive-blog/commit/9bc99e5d5963c801177f0fc7c8b0f7c0bad59f3a)
```email
subject: Working version of elm-book editor component

Changed to use dtwrks/elm-book-interop-elm-css
```

<a id="commit-2022-01-08-13-19"></a>

[commit-2022-01-08-13-19](https://github.com/pitnyr/elm-interactive-blog/commit/7c83e33d18968c4404af42ed38445f9462d49c71)
```email
subject: Nicer version of the elm-book editor component

Better CSS styling
Better Code organization
```


## Done

OK, I think I'm done with this substantial feature!
Ready to be [merged into the main branch](main.md#commit-2022-01-08-13-27).