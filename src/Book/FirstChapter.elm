module Book.FirstChapter exposing (firstChapter)

import ElmBook.Chapter as BC
import Html as H


firstChapter : BC.Chapter x
firstChapter =
    BC.chapter "The First Chapter"
        |> BC.withComponent component
        |> BC.render content


component : H.Html msg
component =
    H.button [] [ H.text "Click me!" ]


content : String
content =
    """
# It all starts with a chapter

Oh, look – A wild real component!

<component />

Woof! Moving on...
"""
