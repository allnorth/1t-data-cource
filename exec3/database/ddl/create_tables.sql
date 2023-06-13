CREATE TABLE IF NOT EXISTS public.readers
(     ticket_number bigint NOT NULL primary key
    , reader_name   varchar
    , address       varchar
    , phone_number  varchar
);

CREATE TABLE IF NOT EXISTS public.publisher
(     publisher_id  bigint NOT NULL primary key
    , name          varchar
    , city          varchar
);

CREATE TABLE IF NOT EXISTS public.books
(     book_code     bigint NOT NULL primary key
    , title         varchar
    , authors       varchar[]
    , publish_year  int
    , vol           int
    , price         decimal
    , fund_cnt      int
    , publisher_id  bigint REFERENCES public.publisher (publisher_id)
);

CREATE TABLE IF NOT EXISTS public.reader_book_link
(     link_id               bigint NOT NULL primary key
    , reader_ticket_number  bigint REFERENCES public.readers (ticket_number)
    , book_code             bigint REFERENCES public.books (book_code)
    , date_from             date NOT NULL
    , data_to               date
);