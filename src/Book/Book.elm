module Book.Book exposing (main)

import Book.CounterChapter as CounterChapter
import Book.EditorChapter as EditorChapter
import Book.FirstChapter as FirstChapter
import Book.InputChapter as InputChapter
import ElmBook as B
import ElmBook.ElmCSS as CS
import ElmBook.StatefulOptions as BS


type alias SharedState =
    { inputModel : InputChapter.Model
    , counterModel : CounterChapter.Model
    , editorOne : EditorChapter.EditorModel
    , editorTwo : EditorChapter.EditorModel
    }


initialState : SharedState
initialState =
    { inputModel = InputChapter.init
    , counterModel = CounterChapter.init
    , editorOne = EditorChapter.initOne
    , editorTwo = EditorChapter.initTwo
    }


main : CS.Book SharedState
main =
    CS.book "Stateful Book"
        |> B.withStatefulOptions
            [ BS.initialState initialState
            ]
        |> B.withChapters
            [ FirstChapter.firstChapter
            , CounterChapter.chapter
            , InputChapter.chapter
            , EditorChapter.chapter
            ]
