module Book.FirstChapter exposing (firstChapter)

import ElmBook.Chapter as EB
import Html as H


firstChapter : EB.Chapter x
firstChapter =
    EB.chapter "The First Chapter"
        |> EB.withComponent component
        |> EB.render content


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
