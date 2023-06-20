CREATE TABLE IF NOT EXISTS public.readers
(	  ticket_number	bigint	not null	primary key
	, reader_name	varchar
	, address		varchar
	, phone_number	varchar
);

CREATE TABLE IF NOT EXISTS public.publisher
(	  publisher_id	bigint	not null	primary key
	, name			varchar
	, city			varchar
);

CREATE TABLE IF NOT EXISTS public.books
(	  book_code			bigint  not null	primary key
	, title				varchar
	, publish_year		int
	, vol				int
	, price				decimal
	, fund_cnt			int
	, publisher_id		bigint				references public.publisher (publisher_id)
);

CREATE TABLE IF NOT EXISTS public.reader_book_link
(	  link_id	bigint  not null	primary key
	, reader_tn	bigint				references public.readers (ticket_number)
	, book_code	bigint				references public.books (book_code)
	, date_from	date	not null
	, date_to	date
);

CREATE TABLE IF NOT EXISTS public.authors
(	  author_id	bigint	not null	primary key
	, name		varchar
);

CREATE TABLE IF NOT EXISTS public.book_author_link
(	  link_id	bigint	primary key
	, author_id	bigint	references public.authors (author_id)
	, book_code	bigint	references public.books (book_code)
	
	, unique (author_id, book_code)
);

CREATE TABLE IF NOT EXISTS public.lost_book_link
(	  link_id	bigint	primary key
	, book_code	bigint	references public.books (book_code)
	, reader_tn	bigint
	, lost_date	date
)