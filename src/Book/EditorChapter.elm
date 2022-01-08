module Book.EditorChapter exposing (EditorModel, chapter, initOne, initTwo)

import Css as C
import Css.Global as CG
import ElmBook.Actions as BA
import ElmBook.Chapter as BC
import ElmBook.ElmCSS as CS
import Html.Styled as H
import Html.Styled.Attributes as HA
import Html.Styled.Events as HE


type alias SharedState x =
    { x
        | editorOne : EditorModel
        , editorTwo : EditorModel
    }


setEditorOne : EditorModel -> SharedState x -> SharedState x
setEditorOne editor state =
    { state | editorOne = editor }


setEditorTwo : EditorModel -> SharedState x -> SharedState x
setEditorTwo editor state =
    { state | editorTwo = editor }


type alias EditorModel =
    { header : Maybe String
    , placeholder : Maybe String
    , text : String
    }


initOne : EditorModel
initOne =
    { header = Nothing
    , placeholder = Just "First input"
    , text = ""
    }


initTwo : EditorModel
initTwo =
    { header = Just "Fixed Header"
    , placeholder = Just "Second input"
    , text = ""
    }


updateEditorOne : String -> EditorModel -> EditorModel
updateEditorOne text editor =
    { editor | text = text }


updateEditorTwo : String -> EditorModel -> EditorModel
updateEditorTwo text editor =
    { editor | text = text }


chapter : CS.Chapter (SharedState x)
chapter =
    BC.chapter "Editor Chapter"
        |> BC.withStatefulComponentList
            [ ( "editorOne", editorComponent .editorOne setEditorOne updateEditorOne BA.updateStateWith )
            , ( "editorTwo", editorComponent .editorTwo setEditorTwo updateEditorTwo BA.updateStateWith )
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


editorComponent :
    (state -> EditorModel)
    -> (EditorModel -> state -> state)
    -> (String -> EditorModel -> EditorModel)
    -> ((String -> state -> state) -> String -> msg)
    -> state
    -> H.Html msg
editorComponent getter setter updateEditor updateState stateForView =
    editorView (getter stateForView)
        (updateState
            (\text stateForUpdate ->
                setter
                    (getter stateForUpdate |> updateEditor text)
                    stateForUpdate
            )
        )


editorView : EditorModel -> (String -> msg) -> H.Html msg
editorView model onInput =
    H.label [ HA.css editorStyle ]
        ([ H.div [ HA.class "styled-editor-content" ] (styledText model.text)
         , H.textarea
            ([ HE.onInput onInput
             , HA.value model.text
             , HA.rows 1
             ]
                |> addOptional model.placeholder HA.placeholder
            )
            []
         ]
            |> addOptional model.header (\t -> H.span [] [ H.text t ])
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
    , C.width (C.pct 100)
    , C.fontFamily C.monospace
    , CG.descendants
        [ CG.each [ CG.class "styled-editor-content", CG.textarea ]
            [ C.property "grid-area" "2/1"
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
    ]
