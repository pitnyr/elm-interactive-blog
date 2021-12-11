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
    , inputText = ""
    }


type Msg
    = NewValues String Int
    | EditorInput String


update : Msg -> Model -> Model
update msg model =
    case msg of
        NewValues inputText height ->
            { model
                | inputText = inputText
                , rows = getRows height
            }

        EditorInput text ->
            { model | inputText = text }


getRows : Int -> Int
getRows scrollHeight =
    ((toFloat scrollHeight - 2 * config.padding) / config.lineHeight)
        |> ceiling
        |> clamp config.minRows config.maxRows


view : Model -> H.Html Msg
view model =
    H.div []
        [ ohanhiView model
        , shawViewInElm model
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
        , editorComponent model.inputText (styledText model.inputText) (Just "Fixed Heading") (Just "Placeholder 1")
        , editorComponent model.inputText (styledText model.inputText) Nothing (Just "Placeholder 2")
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
                    [ HA.style "color"
                        (if modBy 2 idx > 0 then
                            "red"

                         else
                            "blue"
                        )
                    ]
                    [ H.text <| word ++ " " ]
            )


editorComponent : String -> List (H.Html Msg) -> Maybe String -> Maybe String -> H.Html Msg
editorComponent plainContent styledContent firstLine placeholder =
    let
        withOptionalFirstLine : List (H.Html Msg) -> List (H.Html Msg)
        withOptionalFirstLine children =
            case firstLine of
                Just firstLineText ->
                    H.span [] [ H.text firstLineText ] :: children

                Nothing ->
                    children

        withOptionalPlaceholder : List (H.Attribute Msg) -> List (H.Attribute Msg)
        withOptionalPlaceholder attributes =
            case placeholder of
                Just placeholderText ->
                    HA.placeholder placeholderText :: attributes

                Nothing ->
                    attributes
    in
    H.label [ HA.css editorStyle ]
        (withOptionalFirstLine
            [ H.div [ HA.class "styled-editor-content" ] styledContent
            , H.textarea
                (withOptionalPlaceholder
                    [ HE.onInput EditorInput
                    , HA.value plainContent
                    , HA.rows 1
                    ]
                )
                []
            ]
        )


editorStyle : List C.Style
editorStyle =
    [ C.property "display" "inline-grid"
    , C.verticalAlign C.top
    , C.position C.relative
    , C.border2 (C.px 1) C.solid
    , C.padding (C.em 0.5)
    , C.margin (C.px 5)
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
        , CG.descendants
            [ CG.textarea
                [ C.focus
                    [ C.outline C.none
                    ]
                ]
            ]
        ]
    ]
