module Book.EditorChapter exposing (Model, chapter, init)

import Css as C
import Css.Global as CG
import ElmBook.Actions as BA
import ElmBook.Chapter as BC
import ElmBook.ElmCSS as CS
import Html.Styled as H
import Html.Styled.Attributes as HA
import Html.Styled.Events as HE


type alias SharedState x =
    { x | editorModel : Model }


updateSharedState : (String -> Model -> Model) -> String -> SharedState x -> SharedState x
updateSharedState updateFun value x =
    { x | editorModel = updateFun value x.editorModel }


updateEditorOne : String -> Model -> Model
updateEditorOne value model =
    let
        oldModel =
            model.editorOne
    in
    { model | editorOne = { oldModel | text = value } }


updateEditorTwo : String -> Model -> Model
updateEditorTwo value model =
    let
        oldModel =
            model.editorTwo
    in
    { model | editorTwo = { oldModel | text = value } }


type alias Model =
    { editorOne : EditorModel
    , editorTwo : EditorModel
    }


type alias EditorModel =
    { header : Maybe String
    , placeholder : Maybe String
    , text : String
    }


init : Model
init =
    { editorOne =
        { header = Nothing
        , placeholder = Just "First input"
        , text = ""
        }
    , editorTwo =
        { header = Just "Fixed Header"
        , placeholder = Just "Second input"
        , text = ""
        }
    }


chapter : CS.Chapter (SharedState x)
chapter =
    BC.chapter "Editor Chapter"
        |> BC.withStatefulComponentList
            [ ( "editorOne"
              , \{ editorModel } ->
                    editorComponent
                        { value = editorModel.editorOne
                        , onInput = BA.updateStateWith (updateSharedState updateEditorOne)
                        }
              )
            , ( "editorTwo"
              , \{ editorModel } ->
                    editorComponent
                        { value = editorModel.editorTwo
                        , onInput = BA.updateStateWith (updateSharedState updateEditorTwo)
                        }
              )
            ]
        |> BC.render content


content : String
content =
    """
# A chapter with two editor components

Here's one:

<component with-label="editorOne" with-hidden-label="true" />

And another one:

<component with-label="editorTwo" with-hidden-label="true" />

Happy coding!
"""


editorComponent : { value : EditorModel, onInput : String -> msg } -> H.Html msg
editorComponent { value, onInput } =
    H.label [ HA.css editorStyle ]
        ([ H.div [ HA.class "styled-editor-content" ] (styledText value.text)
         , H.textarea
            ([ HE.onInput onInput
             , HA.value value.text
             , HA.rows 1
             ]
                |> addOptional value.placeholder HA.placeholder
            )
            []
         ]
            |> addOptional value.header (\t -> H.span [] [ H.text t ])
        )


addOptional : Maybe a -> (a -> b) -> List b -> List b
addOptional maybe fun list =
    case maybe of
        Just value ->
            fun value :: list

        Nothing ->
            list


styledText : String -> List (H.Html msg)
styledText text =
    text
        |> String.split "\n"
        |> List.map (\line -> H.div [] (styledLine line))


styledLine : String -> List (H.Html msg)
styledLine line =
    String.split " " line
        |> List.indexedMap
            (\idx word ->
                H.span
                    [ HA.style "color" (wordColor idx)
                    , HA.style "fontWeight" (wordWeight idx)
                    ]
                    [ H.text <| word ++ " " ]
            )


wordColor : Int -> String
wordColor index =
    if modBy 2 index > 0 then
        "red"

    else
        "blue"


wordWeight : Int -> String
wordWeight index =
    if modBy 3 index > 0 then
        "normal"

    else
        "bold"


editorStyle : List C.Style
editorStyle =
    [ C.property "display" "inline-grid"
    , C.verticalAlign C.bottom
    , C.position C.relative
    , C.border2 (C.px 1) C.solid
    , C.padding (C.em 0.5)
    , C.margin (C.px 5)
    , C.fontFamily C.monospace
    , CG.descendants
        [ CG.each [ CG.class "styled-editor-content", CG.textarea ]
            [ C.property "grid-area" "2/1"
            , C.width C.auto
            , C.minWidth (C.em 1)
            , C.property "font" "inherit"
            , C.padding C.zero
            , C.margin C.zero
            , C.resize C.none
            , C.property "appearance" "none"
            , C.property "border" "none"
            ]
        , CG.textarea
            [ C.property "background" "none"
            , C.outline C.none
            , C.color C.transparent
            , C.property "caret-color" "black"
            ]
        , CG.class "styled-editor-content"
            [ C.whiteSpace C.preWrap
            ]
        ]
    , C.pseudoClass "focus-within"
        [ C.outline3 (C.px 2) C.solid (C.hex "00F")
        , CG.children
            [ CG.span
                [ C.color (C.hex "00F")
                ]
            ]
        ]
    ]
