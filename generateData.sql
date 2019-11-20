
/********************************************************************************************
DATA GENERATION FROM BASEDATA 10,000 BUYERS 500 SELLERS 2000 AUCTIONS runs in 42, 36 seconds
********************************************************************************************/
--clean up any old data
	delete from zharbor.sellerFee;
	delete from zharbor.effectiveBidHistory
	delete from zharbor.maxUserBid
	delete from zharbor.auction;
	delete from zharbor.seller;
	delete from zharbor.item;
	delete from zharbor.buyer;


--Generate Buyers
	delete from zharbor.buyer;

	declare namecurs cursor	for select * from zharbor.fullName;
	declare addrcurs cursor for select * from zharbor.addr;
	declare numcurs cursor for select * from zharbor.phone;
	declare emailcurs cursor for select * from zharbor.email;
	open namecurs;
	open addrcurs;
	open numcurs;
	open emailcurs;
	go
	declare @name varchar(50);
	declare @addr varchar(50);
	declare @phone varchar(12);
	declare @email varchar(50);

	fetch next from namecurs into @name;
	fetch next from addrcurs into @addr;
	fetch next from numcurs into @phone;
	fetch next from emailcurs into @email;

	insert into zharbor.buyer
	select
		(next value for zharbor.buyerseq) id,
		@name buyerName,
		@addr buyerAddress,
		@phone phone,
		@email email
	go 10000
	delete from zharbor.seller;
	go
--sellers while we are here

	declare @name varchar(50);
	declare @addr varchar(50);
	declare @phone varchar(12);
	declare @email varchar(50);
	declare @name2 varchar(50);

	fetch next from namecurs into @name;
	fetch next from namecurs into @name2;
	fetch next from addrcurs into @addr;
	fetch next from numcurs into @phone;
	fetch next from emailcurs into @email;

	insert into zharbor.seller
	select
		(next value for zharbor.buyerseq) id,
		@name displayname,
		abs(CHECKSUM(NEWID())) taxid,
		@name2 legalName,
		@phone phone,
		@email email,
		@addr sellerAddress
	go 500

	close namecurs;
	close addrcurs;
	close numcurs;
	close emailcurs;
	deallocate namecurs;
	deallocate addrcurs;
	deallocate numcurs;
	deallocate emailcurs;

--items
	insert into zharbor.item
	select (next value for zharbor.itemseq), m.name from Fall2018.Lab3.F18merchandise m
--auctions
	delete from zharbor.sellerFee;
	delete from zharbor.auction;
	go
	insert into zharbor.auction
	select
		(next value for zharbor.auctionseq) id,
		(select top 1 a.id from zharbor.seller a order by newid()) sellerid,
		(select top 1 a.id from zharbor.item a order by newid()) itemid,
		GETDATE() startDate,
		DATEADD(DAY, abs(checksum(newid()))%65530, GETDATE()) endDate,
		abs(CHECKSUM(newid())%50) minBid,
		case CHECKSUM(newid())%2 when 0 then abs(CHECKSUM(newid())%200) + 100 else null end buyout,
		'active' currentStatus,
		null topBuyerid,
		null topEffBid
	go 2000
	
select count(*) buyer from zharbor.buyer;
select count(*) seller from zharbor.seller;
select count(*) auction from zharbor.auction;



select * from zharbor.buyer;
select * from zharbor.seller;
select * from zharbor.auction;

