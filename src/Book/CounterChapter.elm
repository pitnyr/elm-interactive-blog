module Book.CounterChapter exposing (Model, chapter, init)

import ElmBook.Actions as BA
import ElmBook.Chapter as BC
import Html as H
import Html.Events as HE


type alias SharedState x =
    { x | counterModel : Model }


updateSharedState : SharedState x -> SharedState x
updateSharedState x =
    { x | counterModel = x.counterModel + 1 }


type alias Model =
    Int


init : Model
init =
    0


chapter : BC.Chapter (SharedState x)
chapter =
    BC.chapter "Counter Chapter"
        |> BC.withStatefulComponent
            (\{ counterModel } ->
                myCounter
                    { value = counterModel
                    , onIncrease = BA.updateState updateSharedState
                    }
            )
        |> BC.render content


myCounter : { value : Model, onIncrease : msg } -> H.Html msg
myCounter { value, onIncrease } =
    H.div []
        [ H.button [ HE.onClick onIncrease ] [ H.text "Inc" ]
        , H.text (String.fromInt value)
        ]


content : String
content =
    """
# A chapter with a counter

Oh, look – A wild live counter component!

<component />

Woof! Moving on...
"""
