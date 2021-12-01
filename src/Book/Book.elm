module Book.Book exposing (main)

import Book.FirstChapter as FirstChapter
import ElmBook as EB


main : EB.Book ()
main =
    EB.book "Book"
        |> EB.withChapters
            [ FirstChapter.firstChapter
            ]
