﻿USE master
CREATE DATABASE HappiNovel
GO
USE HappiNovel

CREATE TABLE ACCOUNT (
	USERID					VARCHAR(5),
	USERNAME				VARCHAR(20) NOT NULL,
	ACCOUNTNAME				NVARCHAR(50) NOT NULL, --Tên Profile
	ACCOUNTPASSWORD			VARCHAR(20) NOT NULL,
	BIO						NVARCHAR(255) NULL,
	JOBS					NVARCHAR(255) NULL,
	FAVORITES				NVARCHAR(255) NULL,
	DOB						DATE NOT NULL, --Date of birth
	AVATARURL				VARCHAR(255) NULL,
	ACCOUNTSTATUS			BIT DEFAULT 0, -- 0 = active, 1 = banned
	REGDATE					DATE,
	PERMISSION				CHAR(1), -- 0 = user, 1 = mod, 2 = admin
	SDT					CHAR(10),
	UNIQUE (USERNAME),
	PRIMARY KEY (USERID),
);

CREATE TABLE BOOK (
	BOOKID					VARCHAR(5),
	TITLE					NVARCHAR(50) NOT NULL,
	AUTHOR					VARCHAR(5) NOT NULL,
	NOTE					VARCHAR(255) NULL,
	SUMMARY					VARCHAR(255) NULL,
	PUBLISHDATE				DATE,
	COVERIMAGE				VARCHAR(255) NULL,
	BOOKSTATUS				CHAR(1) DEFAULT '0', -- 0 = Tạm ngưng, 1 = Đang tiến hành, 2 = Hoàn thành
	TOTALVIEW				INT DEFAULT 0,
	PRIMARY KEY (BOOKID),
);

CREATE TABLE VOLUME (
	BOOKID					VARCHAR(5),
	VOLID					VARCHAR(5),
	VOLNAME					NVARCHAR(50),
	PRIMARY KEY (BOOKID, VOLID),
);

CREATE TABLE CHAPTER (
	BOOKID					VARCHAR(5),
	VOLID					VARCHAR(5),
	CHAPID					VARCHAR(5),
	CHAPNAME				NVARCHAR(50) NOT NULL,
	PUBLISHDATE				DATE,
	CONTENTFILE				VARCHAR(255) NOT NULL,
	PRIMARY KEY (BOOKID, VOLID, CHAPID),
);

CREATE TABLE GENRE (
	GENREID				VARCHAR(5),
	GENRENAME			VARCHAR(20) NOT NULL,
	PRIMARY KEY (GENREID),
);

CREATE TABLE BOOKGENRES (
	BOOKID				VARCHAR(5),
	GENREID				VARCHAR(5),
	PRIMARY KEY (BOOKID, GENREID),
);

CREATE TABLE BOOKMARK (
	USERID				VARCHAR(5),
	BOOKID				VARCHAR(5),
	PRIMARY KEY (USERID, BOOKID),
);

CREATE TABLE READINGHISTORY (
	USERID				VARCHAR(5),
	BOOKID				VARCHAR(5),
	VOLID				VARCHAR(5),
	CHAPID				VARCHAR(5),
	PRIMARY KEY (USERID, BOOKID),
);

CREATE TABLE RATING (
	BOOKID				VARCHAR(5),
	USERID				VARCHAR(5),
	CONTENTFILE			VARCHAR(255),
	SCORE				FLOAT, -- Thang 5 sao (0 --> 5)
	PRIMARY KEY	(BOOKID, USERID),
);

CREATE TABLE COMMENT (
	COMMENTID			VARCHAR(5),
	BOOKID				VARCHAR(5),
	USERID				VARCHAR(5),
	CONTENTFILE			VARCHAR(255) NOT NULL,
	PUBLISHDATE			DATE,
	COMMENTSTATUS		BIT DEFAULT 0, -- 1 = Reported
	PRIMARY KEY (COMMENTID),
);

CREATE TABLE NOTIFY (
	NOTIFYID			VARCHAR(5),
	TYPEID				CHAR(1), -- 6 loại thông báo (0 --> 5)
	CONTENT				NVARCHAR(255),
	PRIMARY KEY (NOTIFYID),
);

CREATE TABLE NOTIFYOFUSER (
	NOTIFYID			VARCHAR(5),
	USERID				VARCHAR(5),
	PRIMARY KEY (NOTIFYID, USERID),
);

ALTER TABLE ACCOUNT
ADD
CONSTRAINT C_ACCOUNT_ACCOUNTSTATUS CHECK (ACCOUNTSTATUS IN(0, 1)),
CONSTRAINT C_ACCOUNT_PERMISSION CHECK(PERMISSION IN('0', '1', '2'));

ALTER TABLE BOOK
ADD
CONSTRAINT FK_BOOK_ACCOUNT FOREIGN KEY(AUTHOR) REFERENCES ACCOUNT(USERID),
CONSTRAINT C_BOOK_BOOKSTATUS CHECK(BOOKSTATUS IN ('0', '1', '2')),
CONSTRAINT C_BOOK_TOTALVIEW CHECK(TOTALVIEW >= 0);

ALTER TABLE VOLUME
ADD 
CONSTRAINT FK_VOLUME_BOOK FOREIGN KEY(BOOKID) REFERENCES BOOK(BOOKID);

ALTER TABLE CHAPTER
ADD
CONSTRAINT FK_CHAPTER_VOLUME FOREIGN KEY(BOOKID, VOLID) REFERENCES VOLUME(BOOKID, VOLID);

ALTER TABLE BOOKGENRES
ADD
CONSTRAINT FK_BOOKGENRES_BOOK FOREIGN KEY(BOOKID) REFERENCES BOOK(BOOKID),
CONSTRAINT FK_BOOKGENRES_GENRE FOREIGN KEY(GENREID) REFERENCES GENRE(GENREID);

ALTER TABLE BOOKMARK
ADD
CONSTRAINT FK_BOOKMARK_BOOK FOREIGN KEY(BOOKID) REFERENCES BOOK(BOOKID),
CONSTRAINT FK_BOOKMARK_ACCOUNT FOREIGN KEY(USERID) REFERENCES ACCOUNT(USERID);

ALTER TABLE READINGHISTORY
ADD
CONSTRAINT FK_READINGHISTORY_CHAPTER FOREIGN KEY(BOOKID, VOLID, CHAPID) REFERENCES CHAPTER(BOOKID, VOLID, CHAPID),
CONSTRAINT FK_READINGHISTORY_ACCOUNT FOREIGN KEY(USERID) REFERENCES ACCOUNT(USERID);

ALTER TABLE RATING
ADD
CONSTRAINT FK_RATING_BOOK FOREIGN KEY(BOOKID) REFERENCES BOOK(BOOKID),
CONSTRAINT FK_RATING_ACCOUNT FOREIGN KEY(USERID) REFERENCES ACCOUNT(USERID),
CONSTRAINT C_RATING_SCORE CHECK(0 <= SCORE AND SCORE <= 5);

ALTER TABLE COMMENT
ADD
CONSTRAINT FK_COMMENT_BOOK FOREIGN KEY(BOOKID) REFERENCES BOOK(BOOKID),
CONSTRAINT FK_COMMENT_ACCOUNT FOREIGN KEY(USERID) REFERENCES ACCOUNT(USERID);

ALTER TABLE NOTIFY
ADD
CONSTRAINT C_NOTIFY_TYPEID CHECK('0' <= TYPEID AND TYPEID <= '5');

ALTER TABLE NOTIFYOFUSER
ADD
CONSTRAINT FK_NOTIFYOFUSER_ACCOUNT FOREIGN KEY(USERID) REFERENCES ACCOUNT(USERID),
CONSTRAINT FK_NOTIFYOFUSER_NOTIFY FOREIGN KEY(NOTIFYID) REFERENCES NOTIFY(NOTIFYID);


--USE master
--DROP DATABASE HappiNovel
