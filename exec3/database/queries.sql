--Определить, сколько книг прочитал каждый читатель в текущем году. Вывести рейтинг читателей по убыванию.
select		  rbl.reader_tn
			, count(*) as cnt
from		reader_book_link as rbl
where		date_part('year', rbl.date_from) = date_part('year', now())
			and rbl.date_to is not null
group by	rbl.reader_tn
order by	cnt desc;

--Определить, сколько книг у читателей на руках на текущую дату.
select	count(*) as cnt
from	reader_book_link
where	date_to is null;

--Определить читателей, у которых на руках определенная книга.
select	distinct
		rbl.reader_tn
from	reader_book_link as rbl
where	rbl.date_to is null
		and rbl.book_code = 1;

--Определите, какие книги на руках читателей.
select	distinct
		rbl.book_code
from	reader_book_link rbl
where	rbl.date_to is null;

--Вывести количество должников на текущую дату.
select	count(distinct reader_tn)
from	reader_book_link rbl
where	date_to is null
		and EXTRACT(DAY FROM now()::timestamp - date_from::timestamp) > 14;

--Книги какого издательства были самыми востребованными у читателей? Отсортируйте издательства по убыванию востребованности книг.
select		b.publisher_id, count(*) as cnt
from		reader_book_link rbl
join		books b on rbl.book_code = b.book_code
group by	b.publisher_id
order by	cnt desc;

--Определить самого издаваемого автора.
with tbl as	(	select		  author_id
							, count(*) as cnt
				from		book_author_link bal
				group by	author_id
			)

select	author_id
from	tbl
where	cnt = (select max(tbl.cnt) from tbl);

--Определить среднее количество прочитанных страниц читателем за день.
select	  t.reader_tn
		, avg(sum_vol/sum_days)
from	(	select		  rbl.reader_tn
						, sum(EXTRACT(DAY FROM now()::timestamp - date_from::timestamp)) as sum_days
						, sum(b.vol) as sum_vol
			from		reader_book_link rbl
			join		books b on rbl.book_code = b.book_code
			group by	rbl.reader_tn
		) as t
group by reader_tn;

--Напишите sql запрос, который определяет, терял ли определенный читатель книги.
select		case
				when	exists (select link_id from lost_book_link lbl where lbl.reader_tn = r.ticket_number)
				then	true
				else	false
			end
from		readers r
where		r.ticket_number = 1;

--При потере книг количество доступных книг фонда меняется. Напишите sql запрос на обновление соответствующей информации.
update	books
set		fund_cnt = fund_cnt -	(	select	count(*)
									from	lost_book_link lbl
									where lbl.book_code = books.book_code
								);

--Определить сумму потерянных книг по каждому кварталу в течение года.

select		  extract(qtr from lost_date)
			, extract(yr from lost_date)
			, count(book_code)
from		lost_book_link
group by	  extract(qtr from lost_date)
			, extract(yr from lost_date);