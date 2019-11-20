
ORDER OF FILES TO RUN:
	buildZharbor - builds the database, defines tables functions etc
	myTests - my unit and integration tests, the output are all failed tests
			- deletes any data in the database
	generateData	- fills the database with 2000 auctions, 500 sellers, and 10000 buyers
					- deletes old database data
	Provable	- these are the test cases pulled from the requirments sheet
				- some fail if there are not exactly 2000 auctions ect...
	buyerReport and sellerReport
				- displays reports
				- comments explain what the report displays
	baseData - dont run this, it was only set up to be run once, it sets up the data that I use in generateData 
	

TABLES:
		item
			(id, itemName)

		buyer
			(id, buyerName, buyerAddress, phone, email)

		seller
			(id, displayName, taxid, legalName, phone, email, sellerAddress)

		auction
			(id, sellerid, itemid, startDate, endDate, minBid, buyout)

		maxUserBid
			(auctionid, buyerid, bid, bidDate)

	effectiveBidHistory
			(id, auctionid, buyerid, bid, bidDate)

		sellerFee
			(id, sellerid, amount, feeType, auctionid, chargeDate)

SEQUENCES:
	buyerseq 
	itemseq 
	auctionseq 
	bidHistSeq
	sellerFeeseq 

FUNCTIONS: 
	getListingFee	
			(@amount numeric(18,2))
			returns numeric(18,2)

	getClosingFee 	
			(@amount numeric(18,2))
			returns numeric(18,2)

	getBidIncrement	
			(@amount numeric(18,2))
			returns numeric(18,2)

	getCurrentWinningBid 
			(@auctionid numeric(18,0))
			returns @response table(id numeric(18,0), bid numeric(18,2))

	findOverdueAuction 
			()
			returns @response table(id numeric(18,0))


TRIGGERS: 
	updateEffectiveBid aiu maxUserBid

	insertmaxUserBid instead of insert maxUserBid

	logNewAuctionFee ai auction

	logClosingFee au auction

	logBuyNowFees ai on auction


PROCEDURES: 
	makeItem	
			(@id numeric(18,0), 
			@itemName varchar(50))

	startAuction	
			(@itemName varchar(50),
			@sellerid numeric (18,0),
			@endDate datetime,
			@minbid numeric(18,2),
			@buyout numeric(18,2))

	placeBidPct	
			(@buyerid numeric(18,0), 
			@auctionid numeric(18,0),
			@pct numeric(18,2))

	proccessbid	
			(@buyerid numeric(18,0), 
			@auctionid numeric(18,0), 
			@amount numeric(18,2))

	listActiveAuction 
			(@sellerid numeric(18,0))

	listClosedAuction 
			(@sellerid numeric(18,0))

	placeBidAmt	
			(@buyerid numeric(18,0), 
			@auctionid numeric(18,0), 
			@amount numeric(18,2))

	displayEffBidHist 
			(@auctionid numeric(18,0))

	closeOverdueAuction 
			()

	buyItNow
			()






