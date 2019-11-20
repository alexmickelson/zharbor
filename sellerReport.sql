

	declare @seller numeric(18,0) = (select top 1 s.id from zharbor.seller s order by newid());

--seller can see ongoing auctions
	exec zharbor.listActiveAuction @seller;

	update zharbor.auction 
	set currentStatus = 'closed'
	where sellerid=@seller;

--seller can see closed auctions
	exec zharbor.listClosedAuction @seller;

--seller can see fees due
	select	a.id Auction, 
			i.itemName Item, 
			a.startDate startDate, 
			(select sf.amount from zharbor.sellerFee sf where sf.auctionid = a.id and sf.feeType='listing') ListFee,
			(select sf.amount from zharbor.sellerFee sf where sf.auctionid=a.id and sf.feeType='buyNow') BuyNowFee,
			a.endDate endDate,
			a.topEffBid endAmt,
			(select sf.amount from zharbor.sellerFee sf where sf.auctionid=a.id and sf.feeType='closing') closeFee,
			(select sum(sf.amount) from zharbor.sellerFee sf where sf.auctionid=a.id) ttlFee

	from zharbor.auction a 
		inner join zharbor.item i on (a.itemid = i.id)
	where a.sellerid=@seller;



