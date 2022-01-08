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
    , editorModel : EditorChapter.Model
    }


initialState : SharedState
initialState =
    { inputModel = InputChapter.init
    , counterModel = CounterChapter.init
    , editorModel = EditorChapter.init
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
