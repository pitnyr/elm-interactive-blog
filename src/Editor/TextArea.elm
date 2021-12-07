module Editor.TextArea exposing (main)

-- Ohanhis method: https://gist.github.com/ohanhi/cb42ba2587fefbdae6962518176d114a
-- Expands only

import Browser
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Json.Decode as JD


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
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
        , shawView model
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


shawView : Model -> H.Html Msg
shawView model =
    H.div []
        [ H.h1 [] [ H.text "Shaw's Method" ]
        , H.label
            [ HA.class "input-sizer"
            , HA.class "stacked"
            , HA.attribute "data-value" model.inputText
            ]
            [ H.span [] [ H.text "Fixed Heading" ]
            , H.textarea
                [ HE.onInput EditorInput
                , HA.rows 1
                , HA.placeholder "Placeholder"
                , HA.value model.inputText
                ]
                []
            ]
        ]
