create database hashtag;

use hashtag;

create table crawlingdata
(
     cdno int auto_increment primary key comment '�Խñ۰�����ȣ',
     cdblogaddress varchar(100) comment '��α��ּ�',
     cdtitle varchar(200) comment '����',
     cdwdate varchar(20) comment '�ۼ���',
     cdnote text comment '����',
     cdhashtag text comment '�ؽ��±׸�',
     cdheart varchar(5) comment '������',
     cdregion varchar(5) comment '�����ؽ��±�'
);

create table refinehashtag
(
     rhtagno int auto_increment comment '��α׺��ؽ��±��Ϸù�ȣ',    
     rhrefine varchar(5) comment '��������',
     rhno int comment '�Խñ۰�����ȣ',
     rhhashtag varchar(50) comment '�ؽ��±׸�',
     rhregiontag varchar(10) comment '�����ؽ��±׸�',
     rhwdate varchar(20) comment '�ۼ���',
     foreign key(rhno) references crawlingdata(cdno),
     constraint refinehashtag_PK primary key(rhtagno, rhrefine, rhno)
);

create table refineadjective
(
     ratagno int auto_increment comment '��α׺�������Ϸù�ȣ',
     rarefine varchar(5) comment '��������',
     rano int comment '�Խñ۰�����ȣ',
     raadj varchar(20) comment '�����',
     raregiontag varchar(10) comment '�����ؽ��±׸�',
     rawdate varchar(20) comment '�ۼ���',
     racount varchar(5) comment '�Խñۺ��Ǽ�',
     foreign key(rano) references crawlingdata(cdno),
     constraint refinehashtag_PK primary key(ratagno, rarefine, rano)
);


create table cityhashtag
(
     chno int auto_increment primary key comment '�ؽð�����ȣ',
     chregiontag varchar(10) comment '�����ؽ��±׸�',
     chreltag varchar(50) comment '�����ؽ��±׸�',
     chcount varchar(5) comment '�󵵼�'
);


create table nowtrend
(
     ntclick datetime default now() comment 'Ŭ���Ͻ�',
     ntno int comment '�ؽð�����ȣ',
     ntip varchar(20) comment '������',
     foreign key(ntno) references cityhashtag(chno),
     constraint nowtrend_PK primary key(ntclick, ntno)
);


create table adjectivedict
(
     adadjective varchar(20) primary key comment '�����',
     adsort varchar(2) default 'M' comment '��������'
);

create table hashtagtree
(
     htno int auto_increment primary key comment 'Ʈ��������ȣ',
     htregiontag varchar(10) comment '�����ؽ��±׸�',
     hashtag1 varchar(50) comment '�ؽ��±�1',
     hashtag2 varchar(50) comment '�ؽ��±�2',
     htweight float comment '����ġ'
);


