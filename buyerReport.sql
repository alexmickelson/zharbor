
	
	declare @buyer numeric(18,0) = (select top 1 s.id from zharbor.buyer s order by newid());
	
	declare @auction numeric(18,0) = (select top 1 s.id from zharbor.auction s order by newid());
	exec zharbor.placeBidAmt @buyer, @auction, 10.00;
	set @auction = (select top 1 s.id from zharbor.auction s order by newid());
	exec zharbor.placeBidAmt @buyer, @auction, 10.00;
	set @auction = (select top 1 s.id from zharbor.auction s order by newid());
	exec zharbor.placeBidAmt @buyer, @auction, 10;
	set @auction = (select top 1 s.id from zharbor.auction s order by newid());
	exec zharbor.placeBidAmt @buyer, @auction, 10;
	set @auction = (select top 1 s.id from zharbor.auction s order by newid());
	exec zharbor.placeBidAmt @buyer, @auction, 10;
	
--buyer can see ongoing auctions
	select a.id Auction,
		i.itemName Item,
		a.startDate startDate,
		a.endDate endDate,
		a.topBuyerid curBidder,
		a.topEffBid curPrice
	from zharbor.auction a 
		inner join zharbor.item i on (a.itemid = i.id)
		inner join zharbor.maxUserBid mub on (mub.auctionid = a.id)
	where mub.buyerid=@buyer and a.currentStatus='active';


--close auctions
	update zharbor.auction
	set currentStatus='closed'
	where topBuyerid=@buyer;


--buyer can see won auctions
	select a.id auction,
		i.itemName item,
		a.startDate startDate,
		a.endDate endDate,
		a.topEffBid endAmt
	from zharbor.auction a 
		inner join zharbor.item i on (a.itemid = i.id)
	where a.topBuyerid=@buyer and a.currentStatus!='active';

--buyer can see bidding history
	select a.id auction,
		m.bidDate bidDate,
		m.bid bidAmt,
		a.startDate AuctionStart,
		a.endDate AuctionEnd,
		a.topEffBid auctionCurrentAmt
	from zharbor.maxUserBid m
	inner join zharbor.auction a on (a.id = m.auctionid)
	where m.buyerid=@buyer;

