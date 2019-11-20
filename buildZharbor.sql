
/********************************************************************************************
delete tables
********************************************************************************************/

drop table zharbor.sellerFee;
drop table zharbor.effectiveBidHistory;
drop table zharbor.maxUserBid;
drop table zharbor.auction;
drop table zharbor.seller;
drop table zharbor.item;
drop table zharbor.buyer;


/********************************************************************************************
create tables
********************************************************************************************/

--item table is separate to accomodate future store front features
--id, itemName
create table zharbor.item (
	id numeric(18,0) not null primary key,
	itemName varchar(50) not null
	);
	
	
--id, buyerName, buyerAddress, phone, email
create table zharbor.buyer (
	id numeric(18,0) not null primary key,
	buyerName varchar(50),
	buyerAddress varchar(50),
	phone varchar(12),
	email varchar(50)
	);

--id, displayName, taxid, legalName, phone, email, sellerAddress
create table zharbor.seller (
	id numeric(18,0) not null primary key,
	displayName varchar(50),
	taxid numeric(18,0),
	legalName varchar(50),
	phone varchar(12),
	email varchar(50),
	sellerAddress varchar(50)
	);

--id, sellerid, itemid, startDate, endDate, minBid, buyout
create table zharbor.auction (
	id numeric(18,0) not null primary key,
	sellerid numeric (18,0) not null foreign key references zharbor.seller(id),
	itemid numeric (18,0) not null foreign key references zharbor.item(id), 
	startDate datetime,
	endDate datetime,
	minBid numeric(18,2),
	buyout numeric (18,2),
	currentStatus varchar(20) not null check (	currentStatus = 'active' or 
												currentStatus = 'closed' or 
												currentStatus = 'closed_BN'),
	topBuyerid numeric(18,0) foreign key references zharbor.buyer(id),
	topEffBid numeric (18,2) 
	);

--auctionid, buyerid, bid, bidDate
create table zharbor.maxUserBid (
	auctionid numeric (18,0) not null foreign key references zharbor.auction(id),
	buyerid numeric (18,0) not null foreign key references zharbor.buyer(id),
	bid numeric (18,2) not null,
	bidDate datetime not null
	);

--id, auctionid, buyerid, bid, bidDate
create table zharbor.effectiveBidHistory (
	id numeric(18,0) not null primary key,
	auctionid numeric(18,0) not null foreign key references zharbor.auction(id),
	buyerid numeric (18,0) not null foreign key references zharbor.buyer(id),
	bid numeric (18,2) not null,
	bidDate datetime not null
	);


create table zharbor.sellerFee (
	id numeric(18,0) not null primary key,
	sellerid numeric(18,0) not null foreign key references zharbor.seller(id),
	amount numeric(18,2) not null,
	feeType varchar(20) not null check (feeType = 'listing' or 
										feeType = 'closing' or 
										feeType = 'buyNow'),
	auctionid numeric(18,0) foreign key references zharbor.auction(id) not null,
	chargeDate datetime
	);
go

/********************************************************************************************
SEQUENCES
********************************************************************************************/
drop sequence zharbor.buyerseq;
drop sequence zharbor.itemseq;
drop sequence zharbor.auctionseq;
drop sequence zharbor.bidHistseq;
drop sequence zharbor.sellerFeeseq;


create sequence zharbor.buyerseq start with 5 increment by 1;
create sequence zharbor.itemseq start with 5 increment by 1;
create sequence zharbor.auctionseq start with 5 increment by 1;
create sequence zharbor.bidHistseq start with 5 increment by 1;
create sequence zharbor.sellerFeeseq start with 5 increment by 1;

go


/********************************************************************************************
FUNCTIONS: 
	getListingFee
	getClosingFee
	getBidIncrement
	calcCurrentWinningBid
	findOverdueAuction
********************************************************************************************/

drop function zharbor.getListingFee;
go

create function zharbor.getListingFee (@amount numeric(18,2))
returns numeric(18,2)
as begin
	set @amount = round(@amount, 2);
	if (@amount <= 9.99) set @amount = .05
	else if @amount <= 99.99 set @amount = .25
	else if @amount <= 999.99 set @amount = .5
	else set @amount = 1.0;
	return @amount;
end;
go


drop function zharbor.getClosingFee;
go
create function zharbor.getClosingFee (@amount numeric(18,2))
returns numeric(18,2)
as begin
	if @amount=0 return 0.0
	else if @amount<10.00 return round(@amount*.02, 2);
	else if @amount<50.00 return round(@amount*.019, 2);
	else if @amount<1000.00 return round(@amount*.018, 2);
	else if @amount<=20000.00 return round(@amount*.015, 2);
	return round(@amount*.012, 2);
end;
go


drop function zharbor.getBidIncrement;
go
create function zharbor.getBidIncrement (@amount numeric(18,2))
returns numeric(18,2)
as begin
	if @amount=0 return 0.0;
	else if @amount < 1 return .05;
	else if @amount < 5 return .25
	else if @amount < 25 return .5
	else if @amount < 100 return 1
	else if @amount < 250 return 2.5
	else if @amount < 500 return 5
	else if @amount < 1000 return 10
	else if @amount < 2500 return 25
	else if @amount < 5000 return 50
	return(100);
end

go


drop function zharbor.calcCurrentWinningBid;
go
create function zharbor.calcCurrentWinningBid (@auctionid numeric(18,0))
returns @response table(id numeric(18,0), bid numeric(18,2))
as begin
--variables
	declare @upper numeric(18,2), @lower numeric(18,2), @upperid numeric(18,0), @lowerid numeric(18,0);
--cursor gets the top 2 relevent rows
	declare bidCursor cursor for
		select top 2 bl.buyerid, bl.bid 
		from zharbor.maxUserBid bl
		where bl.auctionid=@auctionid
		order by bl.bid desc, bl.bidDate desc --if tie oldest wins;
	open bidCursor;
--put data into variables for logic
	fetch next from bidCursor into @upperid, @upper;
	fetch next from bidCursor into @lowerid, @lower;
	close bidCursor;
	deallocate bidCursor;
--return apropriate value
	if (@lower is not null) --2+ bids
	begin
		set @lower = @lower + zharbor.getBidIncrement(@lower);
		if (@lower > @upper) --highest bid is not greater than bid increment
			insert into @response select @upperid, @upper;
		else
			insert into @response select @upperid, @lower;
	end
	else if (@upper is not null) -- 1 bid return minimum bid
		insert into @response select @upperid, (select a.minBid from zharbor.auction a where a.id = @auctionid);
	return; --empty table if error
end
go



drop function zharbor.findOverdueAuction;
go
--gives a list of all auctionids that are overdue
create function zharbor.findOverdueAuction ()
returns @response table(id numeric(18,0))
as begin
	insert into @response
		select a.id	
		from zharbor.auction a
		where a.endDate < GETDATE() and a.currentStatus = 'active';

	return;
end
go



/********************************************************************************************
TRIGGERS: 
	updateEffectiveBid
	insertmaxUserBid validation
	logNewAuctionFee
	logClosingFee
********************************************************************************************/

--drop trigger zharbor.updateEffectiveBid;	--uncomment when running only this section of code
											--drops with table
go
--creates a row in bid history updating the current bid
create trigger zharbor.updateEffectiveBid on zharbor.maxUserBid
after insert, update 
as begin
	declare @auctionid numeric(18,0) = cast((select top 1 i.auctionid from inserted i) as numeric(18,0));
	declare @buyerid numeric(18,0) = cast((select cwb.id from zharbor.calcCurrentWinningBid(@auctionid) cwb) as numeric(18,0));
	declare @bid numeric(18,2) = cast((select cwb.bid from zharbor.calcCurrentWinningBid(@auctionid) cwb) as numeric(18,2));

	insert into zharbor.effectiveBidHistory
	select 
		(next value for zharbor.bidHistseq) id,
		@auctionid aucitonid,
		@buyerid buyerid,
		@bid bid,
		getDate() bidDate
	from inserted i; 

	update zharbor.auction
	set topBuyerid = @buyerid, topEffBid = @bid
	where id = @auctionid;
end
go

--drop trigger zharbor.insertmaxUserBid;
go

--validates input on maxUserBid, doesnt allow data less than current bid 
create trigger zharbor.insertmaxUserBid on zharbor.maxUserBid
instead of insert as
begin
	declare @auctionid numeric(18,0) = cast((select i.auctionid from inserted i) as numeric(18,0));
	declare @buyerid numeric(18,0) = cast((select i.buyerid from inserted i) as numeric(18,0));
	
	--check if auction is past closing time
	if (select a.currentStatus from inserted i inner join zharbor.auction a on (a.id = i.auctionid)) = 'active'
		and
		(select a.endDate from inserted i inner join zharbor.auction a on (a.id = i.auctionid)) > getdate()
	begin
		--if bidder has bid on item
		if (exists (select i.auctionid,	i.buyerid
					from inserted i	inner join zharbor.maxUserBid bl on (i.auctionid = bl.auctionid)
					where (i.buyerid = bl.buyerid)))
		begin
			if cast((select top 1 i.bid from inserted i) as numeric(18,2)) > cast((select top 1 bh.bid from zharbor.maxUserBid bh where bh.buyerid = @buyerid) as numeric(18,2))
			begin
				update zharbor.maxUserBid 
				set bid = cast((select i.bid from inserted i) as numeric(18,2))
				where buyerid = cast((select i.buyerid from inserted i) as numeric(18,0))
					and auctionid = cast((select i.auctionid from inserted i) as numeric(18,0));
			end

		end	else begin	--if bidder has not already bid on item
						--you cannot lower a bid
			insert into zharbor.maxUserBid
				select
					i.auctionid,
					i.buyerid,
					i.bid,
					i.bidDate
				from inserted i
		end
	end
end
go


--logs fees on new auctions to sellerFee table
create trigger zharbor.logNewAuctionFee on zharbor.auction
after insert
as begin
	insert into zharbor.sellerFee
	select 
		(next value for zharbor.sellerFeeseq) id,
		i.sellerid sellerid,
		(zharbor.getListingFee(i.minBid)) amount,
		'listing' feeType,
		i.id auctionid,
		null chargeDate
	from inserted i;
end
go


--logs closing fees from auctions that close
create trigger zharbor.logClosingFee on zharbor.auction
after update
as begin
	insert into zharbor.sellerFee
	select 
		(next value for zharbor.sellerFeeseq) id,
		i.sellerid sellerid,
		zharbor.getClosingFee(max(ebh.bid)) amount,
		'closing' feeType,
		i.id auctionid,
		null chargeDate
	from inserted i 
		inner join deleted d on (d.id = i.id)
		inner join zharbor.effectiveBidHistory ebh on (ebh.auctionid = i.id)
	where i.currentStatus = 'closed'
		and
		d.currentStatus = 'active'
	group by i.sellerid, i.id
	having
		count(ebh.id) > 0;
end
go


--logs buy now fees
create trigger zharbor.logBuyNowFees on zharbor.auction
after insert
as begin
	insert into zharbor.sellerFee
	select 
		(next value for zharbor.sellerFeeseq) id,
		i.sellerid sellerid,
		.25 amount,
		'buyNow' feeType,
		i.id auctionid,
		null chargeDate
	from inserted i 
	where i.buyout > 0
end
go



/********************************************************************************************
PROCEDURES:
		makeItem
		startAuction
		placeBidPct
		processBid
		listActiveAuction
		listClosedAuction
		placeBidAmt
		displayEffBidHist
		closeOverdueAuction
		buyItNow
********************************************************************************************/



drop procedure zharbor.makeItem;
go

create procedure zharbor.makeItem(@id numeric(18,0), @itemName varchar(50))
as begin

	insert into zharbor.item values (@id, @itemName); 

end 
go

drop procedure zharbor.startAuction; 
go
--makes an auction
--id, sellerid, itemid, startDate, endDate, minBid, buyout
create procedure zharbor.startAuction (
									@itemName varchar(50),
									@sellerid numeric (18,0),
									@endDate datetime,
									@minbid numeric(18,2),
									@buyout numeric(18,2))

as begin
	--get itemid if item exists already
	declare @itemid numeric(18,0) = next value for zharbor.itemseq;

	exec zharbor.makeItem @itemid, @itemName;

	insert into zharbor.auction
	select 
		(next value for zharbor.auctionseq),
		@sellerid,  
		@itemid,
		getDate(),
		@endDate, 
		@minbid,
		@buyout,
		'active',
		null,
		null
end; 
go


drop procedure zharbor.placeBidPct; 
go

--used to simulate loads, makes a bid a certain % higher than the current
create procedure zharbor.placeBidPct	(@buyerid numeric(18,0), 
										@auctionid numeric(18,0),
										@pct numeric(18,2))
as begin
	insert into zharbor.maxUserBid values (
		@auctionid , 
		@buyerid,
		(select a.topEffBid from zharbor.auction a where a.id=@auctionid) * (1+@pct), 
		GETDATE()
		);
end; 
go 

drop procedure zharbor.proccessbid; 
go

--procedure replaces insert for maxUserBid
create procedure zharbor.proccessBid	(@buyerid numeric(18,0), 
										@auctionid numeric(18,0), 
										@amount numeric(18,2))
as begin
	insert into zharbor.maxUserBid values(
		@auctionid,
		@buyerid,
		@amount,
		GETDATE()
	);
end;
go




drop procedure zharbor.listActiveAuction; 
go

--gives the seller a list of all the items they are selling
create procedure zharbor.listActiveAuction (@sellerid numeric(18,0))
as begin
	select a.id auctionid, i.itemName, a.endDate endDate, mxbid.buyerName buyerName, mxbid.maxbid highestBid 
							from zharbor.auction a
							inner join zharbor.item i on (i.id = a.itemid)
							left join (select top 1 a.id auctionid, h.bidDate, b.buyerName buyerName, max(h.bid) maxbid
											from zharbor.effectiveBidHistory h 
												inner join zharbor.auction a on (a.id = h.auctionid)
												inner join zharbor.buyer b on (b.id = h.buyerid) 
											where (a.sellerid = @sellerid)
											group by a.id, h.bidDate, b.buyerName
											order by h.bidDate desc)
												mxbid on (mxbid.auctionid = a.id) 
	where (a.sellerid = @sellerid)
		and 
			a.currentStatus = 'active'
	order by highestBid desc;
end; 
go


drop procedure zharbor.listClosedAuction;
go

--gives the seller a list of sold items
create procedure zharbor.listClosedAuction (@sellerid numeric(18,0))
as begin
	select a.id auctionid, i.itemName, a.endDate endDate, mxbid.buyerName buyerName, mxbid.maxbid highestBid 
							from zharbor.auction a
							inner join zharbor.item i on (i.id = a.itemid)
							--inner join zharbor.effectiveBidHistory h on (h.auctionid = a.id)
							left join (select top 1 a.id auctionid, h.bidDate, b.buyerName buyerName, max(h.bid) maxbid
											from zharbor.effectiveBidHistory h 
												inner join zharbor.auction a on (a.id = h.auctionid)
												inner join zharbor.buyer b on (b.id = h.buyerid) 
											where (a.sellerid = @sellerid)
											group by a.id, h.bidDate, b.buyerName
											order by h.bidDate desc)
												mxbid on (mxbid.auctionid = a.id) 
	where (a.sellerid = @sellerid)
		and 
			a.currentStatus = 'closed'
	--group by a.id, i.itemName, a.endDate, b.buyerName
	order by highestBid desc;
end; 
go



--this procedure places a bid according to the parameters
drop procedure zharbor.placeBidAmt; 
go

create procedure zharbor.placeBidAmt	(@buyerid numeric(18,0), 
										@auctionid numeric(18,0), 
										@amount numeric(18,2))
as begin

	if ((select a.topEffBid from zharbor.auction a where a.id = @auctionid) is null)

	insert into zharbor.maxUserBid values( @auctionid, 
										@buyerid, 
										(cast((select a.minBid from zharbor.auction a where a.id = @auctionid) as numeric(18,2)) + @amount), 
										getDate());

	else 
	insert into zharbor.maxUserBid values( @auctionid, 
										@buyerid, 
										(cast((select top 1 a.topEffBid from zharbor.auction a where a.id = @auctionid) as numeric(18,2))+ @amount), 
										getDate());
end; 
go

drop procedure zharbor.displayEffBidHist;
go
--this procedure reports the history of the effective bid
create procedure zharbor.displayEffBidHist (@auctionid numeric(18,0))
as begin
	select *
	from zharbor.effectiveBidHistory ebh
	where ebh.auctionid = @auctionid
	order by ebh.bidDate desc;
end 
go


--this procedure changes all overdue auctions to closed
drop procedure zharbor.closeOverdueAuction; 
go
create procedure zharbor.closeOverdueAuction 
as begin
	update zharbor.auction 
	set currentStatus = 'closed'
	where endDate < GETDATE() and currentStatus = 'active';
end
go


--this procedure handles the buy it now functionality
drop procedure zharbor.buyItNow;
go
create procedure zharbor.buyItNow (@auctionid numeric(18,0), @buyerid numeric(18,0))
as begin
	update zharbor.auction 
	set currentStatus = 'closed_BN',
		topBuyerid =  @buyerid,
		topEffBid = buyout
	where id = @auctionid and topBuyerid is null;
end


