module Book.InputChapter exposing (Model, chapter, init)

import ElmBook.Actions as BA
import ElmBook.Chapter as BC
import ElmBook.ElmCSS as CS
import Html.Styled as H
import Html.Styled.Attributes as HA
import Html.Styled.Events as HE


type alias SharedState x =
    { x | inputModel : Model }


updateSharedState : String -> SharedState x -> SharedState x
updateSharedState value x =
    { x | inputModel = { value = value } }


type alias Model =
    { value : String
    }


init : Model
init =
    { value = ""
    }


chapter : CS.Chapter (SharedState x)
chapter =
    BC.chapter "Input Chapter"
        |> BC.withStatefulComponent
            (\{ inputModel } ->
                myInput
                    { value = inputModel.value
                    , onInput = BA.updateStateWith updateSharedState
                    }
            )
        |> BC.render content


myInput : { value : String, onInput : String -> msg } -> H.Html msg
myInput { value, onInput } =
    H.div []
        [ H.input [ HE.onInput onInput, HA.value value ] []
        , H.text value
        ]


content : String
content =
    """
# A chapter with a text input component

Oh, look – A wild live text input component!

<component />

Woof! Moving on...
"""
