module Book.FirstChapter exposing (firstChapter)

import Book.CounterChapter as CounterChapter
import Book.InputChapter as InputChapter
import ElmBook.Chapter as BC
import ElmBook.ElmCSS as CS
import Html.Styled as H


type alias SharedState x =
    { x
        | inputModel : InputChapter.Model
        , counterModel : CounterChapter.Model
    }


firstChapter : CS.Chapter (SharedState x)
firstChapter =
    BC.chapter "The First Chapter"
        |> BC.withComponentList
            [ ( "component", component ) ]
        |> BC.withStatefulComponentList
            [ ( "counterValue"
              , \{ counterModel } ->
                    H.text <|
                        if counterModel > 0 then
                            "Hey, you've found the Counter Chapter! The actual count is " ++ String.fromInt counterModel ++ "."

                        else
                            ""
              )
            , ( "inputValue"
              , \{ inputModel } ->
                    H.text <|
                        if String.isEmpty inputModel.value then
                            ""

                        else
                            "The value from the Input Chapter is \"" ++ inputModel.value ++ "\"."
              )
            ]
        |> BC.render content


component : H.Html msg
component =
    H.button [] [ H.text "Click me!" ]


content : String
content =
    """
# It all starts with a chapter

Oh, look – A wild real component!

<component with-label="component" />

Test

 <component with-label="counterValue" with-hidden-label="true" with-display="inline" /><component with-label="inputValue" with-hidden-label="true" with-display="inline" />

Noch irgendein Text, der sich vielleicht idealerweise gleich über mehrere (inbesondere mehr als eine) Zeilen erstreckt.

Woof! Moving on...
"""
