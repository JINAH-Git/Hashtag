create database hashtag;

use hashtag;

create table crawlingdata
(
     cdno int auto_increment primary key comment '게시글관리번호',
     cdblogaddress varchar(100) comment '블로그주소',
     cdtitle varchar(200) comment '제목',
     cdwdate varchar(20) comment '작성일',
     cdnote text comment '내용',
     cdhashtag text comment '해시태그명',
     cdheart varchar(5) comment '공감수',
     cdregion varchar(5) comment '지역해시태그'
);

create table refinehashtag
(
     rhtagno int auto_increment comment '블로그별해시태그일련번호',    
     rhrefine varchar(5) comment '정제차수',
     rhno int comment '게시글관리번호',
     rhhashtag varchar(50) comment '해시태그명',
     rhregiontag varchar(10) comment '지역해시태그명',
     rhwdate varchar(20) comment '작성일',
     foreign key(rhno) references crawlingdata(cdno),
     constraint refinehashtag_PK primary key(rhtagno, rhrefine, rhno)
);

create table refineadjective
(
     ratagno int auto_increment comment '블로그별형용사일련번호',
     rarefine varchar(5) comment '정제차수',
     rano int comment '게시글관리번호',
     raadj varchar(20) comment '형용사',
     raregiontag varchar(10) comment '지역해시태그명',
     rawdate varchar(20) comment '작성일',
     racount varchar(5) comment '게시글별건수',
     foreign key(rano) references crawlingdata(cdno),
     constraint refinehashtag_PK primary key(ratagno, rarefine, rano)
);


create table cityhashtag
(
     chno int auto_increment primary key comment '해시고유번호',
     chregiontag varchar(10) comment '지역해시태그명',
     chreltag varchar(50) comment '관련해시태그명',
     chcount varchar(5) comment '빈도수'
);


create table nowtrend
(
     ntclick datetime default now() comment '클릭일시',
     ntno int comment '해시고유번호',
     ntip varchar(20) comment '아이피',
     foreign key(ntno) references cityhashtag(chno),
     constraint nowtrend_PK primary key(ntclick, ntno)
);


create table adjectivedict
(
     adadjective varchar(20) primary key comment '형용사',
     adsort varchar(2) default 'M' comment '감성지수'
);

create table hashtagtree
(
     htno int auto_increment primary key comment '트리관리번호',
     htregiontag varchar(10) comment '지역해시태그명',
     hashtag1 varchar(50) comment '해시태그1',
     hashtag2 varchar(50) comment '해시태그2',
     htweight float comment '가중치'
);


