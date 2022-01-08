module Editor.TextArea exposing (main)

-- Ohanhi's method: https://gist.github.com/ohanhi/cb42ba2587fefbdae6962518176d114a - Expands only
-- Shawns's method: https://codepen.io/shshaw/pen/bGNJJBE

import Browser
import Css as C
import Css.Global as CG
import Html.Styled as H
import Html.Styled.Attributes as HA
import Html.Styled.Events as HE
import Json.Decode as JD
import Json.Encode as JE


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view >> H.toUnstyled
        }


type alias Model =
    { rows : Int
    , inputText : String
    , selection : Maybe ( Int, Int )
    }


type alias Config =
    { padding : Float
    , lineHeight : Float
    , minRows : Int
    , maxRows : Int
    }


config : Config
config =
    { padding = 10
    , lineHeight = 20
    , minRows = 1
    , maxRows = 20
    }


init : Model
init =
    { rows = config.minRows
    , inputText = initialText
    , selection = Nothing
    }


initialText : String
initialText =
    """Fixed Heading

xxxShaw's Method in Elm
 xxShaw's Method in Elm
  xShaw's Method in Elm
   Shaw's Method in Elm"""


type Msg
    = NewValues String Int
    | EditorInput String
    | ResetTextAndSelection


update : Msg -> Model -> Model
update msg model =
    case msg of
        NewValues inputText height ->
            { model
                | inputText = inputText
                , rows = getRows height
                , selection = Nothing
            }

        EditorInput text ->
            { model
                | inputText = text
                , selection = Nothing
            }

        ResetTextAndSelection ->
            { model
                | inputText = initialText
                , selection = Just ( 90, 103 )
            }


getRows : Int -> Int
getRows scrollHeight =
    ((toFloat scrollHeight - 2 * config.padding) / config.lineHeight)
        |> ceiling
        |> clamp config.minRows config.maxRows


view : Model -> H.Html Msg
view model =
    H.div []
        [ controlView
        , ohanhiView model
        , shawViewInElm model
        ]


controlView : H.Html Msg
controlView =
    H.div []
        [ H.h1 [] [ H.text "Editor Component Tests" ]
        , H.button [ HE.onClick ResetTextAndSelection ] [ H.text "Reset Text and Selection" ]
        ]


ohanhiView : Model -> H.Html Msg
ohanhiView model =
    H.div [ HA.style "width" "400px" ]
        [ H.h1 [] [ H.text "Ohanhi's Method" ]
        , H.textarea
            [ HE.on "input" inputDecoder
            , HA.rows model.rows
            , HA.value model.inputText
            , HA.style "width" "100%"
            , HA.style "padding" (String.fromFloat config.padding ++ "px")
            , HA.style "border" "medium solid green"
            , HA.style "border-radius" "8px"
            , HA.style "line-height" (String.fromFloat config.lineHeight ++ "px")
            ]
            []
        , H.p []
            [ H.text ("Rows: " ++ String.fromInt model.rows)
            , H.br [] []
            , H.text ("Min: " ++ String.fromInt config.minRows)
            , H.br [] []
            , H.text ("Max: " ++ String.fromInt config.maxRows)
            ]
        ]


inputDecoder : JD.Decoder Msg
inputDecoder =
    JD.map2 NewValues
        (JD.at [ "target", "value" ] JD.string)
        (JD.at [ "target", "scrollHeight" ] JD.int)


shawViewInElm : Model -> H.Html Msg
shawViewInElm model =
    H.div []
        [ H.h1 [] [ H.text "Shaw's Method in Elm" ]
        , editorComponent model.inputText (styledText model.inputText) model.selection (Just "Fixed Heading") (Just "Placeholder 1")
        , editorComponent model.inputText (styledText model.inputText) model.selection Nothing (Just "Placeholder 2")
        ]


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


editorComponent : String -> List (H.Html Msg) -> Maybe ( Int, Int ) -> Maybe String -> Maybe String -> H.Html Msg
editorComponent plainContent styledContent selection firstLine placeholder =
    H.label [ HA.css editorStyle ]
        ([ H.div [ HA.class "styled-editor-content" ] styledContent
         , H.textarea
            ([ HE.onInput EditorInput
             , HA.value plainContent
             , HA.rows 1
             ]
                |> addOptional placeholder HA.placeholder
                |> addOptional selection (HA.property "selectionStart" << JE.int << Tuple.first)
                |> addOptional selection (HA.property "selectionEnd" << JE.int << Tuple.second)
            )
            []
         ]
            |> addOptional firstLine (\t -> H.span [] [ H.text t ])
        )


addOptional : Maybe a -> (a -> b) -> List b -> List b
addOptional maybe fun list =
    case maybe of
        Just value ->
            fun value :: list

        Nothing ->
            list


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
