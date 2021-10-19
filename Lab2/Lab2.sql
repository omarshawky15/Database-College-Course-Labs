drop schema if exists LIBRARY ;
/* First Requirment */

create schema LIBRARY ;
use LIBRARY ; 

create table PUBLISHER (
    Phone int,
    Name varchar(255) NOT NULL,
    Address varchar(255),
	PRIMARY KEY (Name)
);

create table Book (
    Book_id int NOT NULL,
    Title varchar(255),
    Publisher_name varchar(255),
	PRIMARY KEY (Book_id),
	foreign key (Publisher_name) REFERENCES PUBLISHER(Name)
);

create table BOOK_AUTHORS (
    Book_id int,
    Author_name varchar(255) NOT NULL,
	foreign key (Book_id) REFERENCES Book(Book_id),
	PRIMARY KEY (Author_name,Book_id)
);
create table LIBRARY_BRANCH (    
    Branch_id int not null,
	Branch_name varchar(255),
    Address varchar(255),
	PRIMARY KEY (Branch_id)
);
create table BORROWER (
    Card_no int not null,
	Name varchar(255),
	Address varchar(255),
	Phone int,
	PRIMARY KEY (Card_no)
);
create table BOOK_LOANS (
    Book_id int,
    Branch_id int,
    Card_no int,
	Date_out date,
    Due_date date,
	foreign key (Book_id) REFERENCES Book(Book_id),
	foreign key (Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id),
	foreign key (Card_no) REFERENCES BORROWER(Card_no),
	PRIMARY KEY (Card_no,Branch_id,Book_id)
);

create table BOOK_COPIES (
    Book_id int ,
    Branch_id int ,
    No_of_copies int ,
	foreign key (Book_id) REFERENCES Book(Book_id),
	foreign key (Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id),
	PRIMARY KEY (Branch_id,Book_id)
);

/* Second Requirment */

INSERT INTO publisher (Phone, Name, Address)
VALUES (5425670, 'omar shawky', 'London, 2nd floor');
select * from publisher ; 
UPDATE publisher SET Address = 'London, 4th floor' WHERE name = 'omar shawky';
select * from publisher ; 
DELETE FROM publisher WHERE  name = 'omar shawky';
select * from publisher ; 

/* Third requirement */ 
INSERT INTO publisher (Phone, Name, Address)
VALUES (5425670, 'omar shawky', 'London, 2nd floor');
INSERT INTO Book (Book_id, Title, Publisher_name)
VALUES (1, 'Book title', 'omar shawky');
select * from publisher ; 
select * from book ; 
UPDATE publisher SET Address = 'London, 4th floor' WHERE name = 'omar shawky';
select * from publisher ; 
#UPDATE publisher SET name = 'mohaned ayman' WHERE name = 'omar shawky';
select * from publisher ; 
#DELETE FROM publisher WHERE  name = 'omar shawky';
select * from publisher ; 

/* Fourth requirement */
/*a-How many copies of the book titled The Lost Tribe are owned by the
library branch whose name is ‘Sharpstown’? */
SELECT No_of_copies
FROM Book NATURAL JOIN (BOOK_COPIES NATURAL JOIN library_branch )
where branch_name ='Sharpstown' and title = 'The Lost Tribe';
/*b-How many copies of the book titled The Lost Tribe are owned by each library
branch?*/
select branch_id ,branch_name,no_of_copies 
FROM Book NATURAL JOIN (BOOK_COPIES NATURAL JOIN library_branch )
 where title = 'The Lost Tribe' 
 group by branch_id; 

/*c-Retrieve the names of all borrowers who do not have any books checked out.*/
SELECT name FROM borrower WHERE NOT EXISTS (
    SELECT 1
    FROM (borrower NATURAL JOIN book_loans)
    WHERE borrower.card_no = book_loans.card_no
);

/*d-For each book that is loaned out from the Sharpstown branch and whose Due_date
is today, retrieve the book title, the borrower’s name, and the borrower’saddress.*/
Select title,name,Address FROM (
	Select * from  Book_loans  
	NATURAL JOIN (select Branch_id,Branch_name,address as Branch_address  from  library_branch )
	where branch_name = 'Sharpstown' and due_date= CAST(CURRENT_TIMESTAMP () AS Date ) ) As R1
NATURAL JOIN (BOOK NATURAL JOIN borrower); 

/*e-For each library branch, retrieve the branch name and the total number of books
loaned out from that branch*/
SELECT branch_name,COUNT(book_id) as total_number_of_books
FROM (library_branch natural join book_loans)
GROUP BY branch_id;

/*f-Retrieve the names, addresses, and number of books checked out for all borrowers
who have more than five books checked out*/
Select * from (
	SELECT name,address,COUNT(book_id) as total_number_of_books
	FROM (borrower natural join book_loans)
	GROUP BY card_no) as R1
where total_number_of_books >=5 ;

/*g-For each book authored (or coauthored) by Stephen King, retrieve the title and the
number of copies owned by the library branch whose name is Central.*/
(Select title , sum(no_of_copies) as total_number_of_copies 
from ((library_branch natural join book_copies) natural join book_authors) natural join  book
where author_name = 'Stephen King' and branch_name = 'Central'
group by book_id )
union 
#co-authored == publisher
(Select title , sum(no_of_copies) as total_number_of_copies 
from (select name as publisher_name,address as publisher_address,phone from publisher) as publisher
natural join (book  natural join (library_branch natural join book_copies))
where publisher_name = 'Stephen King' and branch_name = 'Central'
group by book_id );
