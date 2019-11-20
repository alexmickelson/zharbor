
/********************************************************************************************
GIVEN TESTS THAT MUST PASS FOR GRADE
********************************************************************************************/
delete zharbor.test
	insert into zharbor.test select 1,'2,000auctions' testName, case (select count(*) from zharbor.auction) when 2000 then 'PASS' else 'FAIL' end;
	insert into zharbor.test select 2,'10,000buyers' testName, case (select count(*) from zharbor.buyer) when 10000 then 'PASS' else 'FAIL' end;
	insert into zharbor.test select 1,'500 sellers' testName, case (select count(*) from zharbor.seller) when 500 then 'PASS' else 'FAIL' end;



	declare @randauct numeric(18,0)= (select top 1 a.id from zharbor.auction a where currentStatus='active' order by NEWID());
	declare @randbuyer numeric(18,0) = (select top 1 a.id from zharbor.buyer a order by NEWID());
	declare @randbuyer2 numeric(18,0)= (select top 1 a.id from zharbor.buyer a order by NEWID());
	declare @minAmt numeric(18,2) = (select minBid from zharbor.auction a where a.id = @randauct);

--placebidpct
	--make sure there is a current effective bid
	insert into zharbor.maxUserBid values(@randauct, @randbuyer, @minAmt+100, getDate());--auctionid, buyerid, amount, date
	declare @prevAmt numeric(18,2) = (select top 1 a.bid from zharbor.effectiveBidHistory a where a.auctionid=@randauct order by a.id desc);
	exec zharbor.placeBidPct @randbuyer2, @randauct, .1;
	insert into zharbor.test select 3, 'place_bid_pct.1', case (select m.bid from zharbor.maxUserBid m where m.auctionid=@randauct and m.buyerid=@randbuyer2) when round( @prevAmt*1.1, 2) then 'PASS' else 'FAIL' end;


--placebidamt
	set @prevAmt  = (select a.topEffBid from zharbor.auction a where a.id=@randauct);
	declare @randbuyer3 numeric(18,0)= (select top 1 a.id from zharbor.buyer a order by NEWID());
	exec zharbor.placeBidAmt @randbuyer3, @randauct, 10;
	insert into zharbor.test select 4, 'place_bid_amt10', case (select m.bid from zharbor.maxUserBid m where m.auctionid=@randauct and m.buyerid=@randbuyer3) when (@prevAmt + 10) then 'PASS' else 'FAIL' end;
	

--auction can not be bid on after closedate/time
	--make endate in past
	set @randauct = (select top 1 a.id from zharbor.auction a order by NEWID());
	--make sure there is a current effective bid
	insert into zharbor.maxUserBid values(@randauct, @randbuyer, 1000, getDate());--auctionid, buyerid, amount, date
	update zharbor.auction 
		set endDate = getdate()-1
		where id=@randauct;
	set @prevAmt  = (select a.topEffBid from zharbor.auction a where a.id=@randauct);
	--check if you can bid
	insert into zharbor.maxUserBid values (@randauct, @randbuyer, 1000000, getDate());
	insert into zharbor.test select 5, 'bidOnOverdueAuction', case (select a.topEffBid from zharbor.auction a where a.id=@randauct) when @prevAmt then 'PASS' else 'FAIL' end;
	
--auctions are marked as closed after close time
	exec zharbor.closeOverdueAuction;	
	insert into zharbor.test select 6, 'closeOverdueAuction', case (select a.currentStatus from zharbor.auction a where a.id=@randauct) when 'closed' then 'PASS' else 'FAIL' end;
	
--auctions can only have valid status codes, try to make status taco
	declare @testvar varchar(4) = 'FAIL'
	begin try
		update zharbor.auction
			set currentStatus = 'taco'
			where id=@randauct;
	end try
	begin catch
		set @testvar = 'PASS'
	end catch
	insert into zharbor.test select 6, 'invalidStatus', @testvar;

--listing fee 99$ is $0.25
	insert into zharbor.test select 7, '$99ListingFee', case zharbor.getListingFee(99) when 0.25 then 'PASS' else 'FAIL' end;

--listing fee $100 is $0.50
	insert into zharbor.test select 8, '$100ListingFee', case zharbor.getListingFee(100) when 0.5 then 'PASS' else 'FAIL' end;

--close auction for 100$ is 1.08
	insert into zharbor.test select 9, 'ClosingFee$100', case zharbor.getClosingFee(100) when 1.80 then 'PASS' else 'FAIL' end;

--close auction for $1000 is $15.00
	insert into zharbor.test select 10, 'ClosingFee$1000', case zharbor.getClosingFee(1000) when 15 then 'PASS' else 'FAIL' end;

--close auction for $99.99 isi $18.00
	insert into zharbor.test select 11, 'ClosingFee$99.99', case zharbor.getClosingFee(999.99) when 18 then 'PASS' else 'FAIL' end;

	
/********************************************************************************************
ITEM LISTS FOR $10
	BUYER	MAXBID	EFF_BID	
	AA		$20		$10
	BBB		$22
	AA		$25
	BBB		$30
	AA		$33
	BBB		$40
	AA		$39.5	$40
--********************************************************************************************/
go
	declare @seller numeric(18,0) = (select top 1 s.id from zharbor.seller s order by newid());
	declare @AA numeric(18,0) = (select top 1 s.id from zharbor.buyer s order by newid());
	declare @BBB numeric(18,0) = (select top 1 s.id from zharbor.buyer s order by newid());
	declare @item numeric(18,0) = (select top 1 s.id from zharbor.item s order by newid());
	
	insert into zharbor.auction values (-1, @seller, @item, getDate(), '20191212 12:00:00 PM', 10, null, 'active', null, null);
	
	insert into zharbor.maxUserBid values (-1, @AA, 20, getDate());
	insert into zharbor.maxUserBid values (-1, @BBB, 22, getDate());
	insert into zharbor.maxUserBid values (-1, @AA, 25, getDate());
	insert into zharbor.maxUserBid values (-1, @BBB, 30, getDate());
	insert into zharbor.maxUserBid values (-1, @AA, 33, getDate());
	insert into zharbor.maxUserBid values (-1, @BBB, 40, getDate());
	insert into zharbor.maxUserBid values (-1, @AA, 39.5, getDate());
	
	select * from zharbor.maxUserBid ebh where ebh.auctionid = -1;
	select * from zharbor.effectiveBidHistory ebh where ebh.auctionid = -1;
	
	delete zharbor.sellerFee where auctionid=-1;
	delete zharbor.maxUserBid where auctionid=-1;
	delete zharbor.effectiveBidHistory where auctionid=-1;
	delete zharbor.auction where id=-1;

--buyitnow
	declare @auct numeric(18,0) = (select top 1 a.id from zharbor.auction a where a.currentStatus='active' and a.buyout is not null order by newid());
	declare @buyer numeric(18,0) = (select top 1 s.id from zharbor.buyer s order by newid());
	exec zharbor.buyItNow @auct, @buyer;
	--sold price = listing price
	insert into zharbor.test select 12, 'buyNowForListingPrice', case (select a.topEffBid from zharbor.auction a where a.id=@auct) when (select a.buyout from zharbor.auction a where a.id=@auct) then 'PASS' else 'FAIL' end;
	--listing fee correct
	insert into zharbor.test select 13, 'buyNowListingFee', case (select a.amount from zharbor.sellerFee a where a.auctionid=@auct and a.feeType='buyNow') when .25 then 'PASS' else 'FAIL' end;
	

	

select * from zharbor.test t where t.testStatus = 'FAIL';