--table to store test result
drop table zharbor.test;
create table zharbor.test (id numeric(18,2), testName varchar(50), testStatus varchar(4));


/********************************************************************************************
TEST:
	edge tests bidIncrement, getListingFee, getClosingFee
	if all tests pass these 3 functions will behave reliably
********************************************************************************************/

declare @testnum numeric(18,2);

set @testnum=0.0; insert into zharbor.test select 1, @testnum testnum, case zharbor.getBidIncrement(@testnum) when 0.0 then 'PASS' ELSE 'FAIL' END;
set @testnum=.01; insert into zharbor.test select 2, @testnum testnum, case zharbor.getBidIncrement(@testnum) when .05 then 'PASS' ELSE 'FAIL' END;
set @testnum=.99; insert into zharbor.test select 3,@testnum testnum, case zharbor.getBidIncrement(@testnum) when .05 then 'PASS' ELSE 'FAIL' END;
set @testnum=1; insert into zharbor.test select 4,@testnum testnum, case zharbor.getBidIncrement(@testnum) when .25 then 'PASS' ELSE 'FAIL' END;
set @testnum=4.99; insert into zharbor.test select 5,@testnum testnum, case zharbor.getBidIncrement(@testnum) when .25 then 'PASS' ELSE 'FAIL' END;
set @testnum=5; insert into zharbor.test select 6,@testnum testnum, case zharbor.getBidIncrement(@testnum) when .5 then 'PASS' ELSE 'FAIL' END;
set @testnum=24.99; insert into zharbor.test select 7,@testnum testnum, case zharbor.getBidIncrement(@testnum) when .5 then 'PASS' ELSE 'FAIL' END;
set @testnum=25; insert into zharbor.test select 8,@testnum testnum, case zharbor.getBidIncrement(@testnum) when 1 then 'PASS' ELSE 'FAIL' END;
set @testnum=99.99; insert into zharbor.test select 9,@testnum testnum, case zharbor.getBidIncrement(@testnum) when 1 then 'PASS' ELSE 'FAIL' END;
set @testnum=100; insert into zharbor.test select 10,@testnum testnum, case zharbor.getBidIncrement(@testnum) when 2.5 then 'PASS' ELSE 'FAIL' END;
set @testnum=249.99; insert into zharbor.test select 11,@testnum testnum, case zharbor.getBidIncrement(@testnum) when 2.5 then 'PASS' ELSE 'FAIL' END;
set @testnum=250; insert into zharbor.test select 12,@testnum testnum, case zharbor.getBidIncrement(@testnum) when 5 then 'PASS' ELSE 'FAIL' END;
set @testnum=499.99; insert into zharbor.test select 13,@testnum testnum, case zharbor.getBidIncrement(@testnum) when 5 then 'PASS' ELSE 'FAIL' END;
set @testnum=500; insert into zharbor.test select 14,@testnum testnum, case zharbor.getBidIncrement(@testnum) when 10 then 'PASS' ELSE 'FAIL' END;
set @testnum=999.99; insert into zharbor.test select 15,@testnum testnum, case zharbor.getBidIncrement(@testnum) when 10 then 'PASS' ELSE 'FAIL' END;
set @testnum=1000; insert into zharbor.test select 16,@testnum testnum, case zharbor.getBidIncrement(@testnum) when 25 then 'PASS' ELSE 'FAIL' END;
set @testnum=2499.99; insert into zharbor.test select 17,@testnum testnum, case zharbor.getBidIncrement(@testnum) when 25 then 'PASS' ELSE 'FAIL' END;
set @testnum=2500; insert into zharbor.test select 18,@testnum testnum, case zharbor.getBidIncrement(@testnum) when 50 then 'PASS' ELSE 'FAIL' END;
set @testnum=4999.99; insert into zharbor.test select 19,@testnum testnum, case zharbor.getBidIncrement(@testnum) when 50 then 'PASS' ELSE 'FAIL' END;
set @testnum=5000; insert into zharbor.test select 20,@testnum testnum, case zharbor.getBidIncrement(@testnum) when 100 then 'PASS' ELSE 'FAIL' END;

set @testnum=0.0; insert into zharbor.test select 21,@testnum testnum, case zharbor.getListingFee(@testnum) when 0.05 then 'PASS' ELSE 'FAIL' END;
set @testnum=9.99; insert into zharbor.test select 22,@testnum testnum, case zharbor.getListingFee(@testnum) when 0.05 then 'PASS' ELSE 'FAIL' END;
set @testnum=10.00; insert into zharbor.test select 23,@testnum testnum, case zharbor.getListingFee(@testnum) when 0.25 then 'PASS' ELSE 'FAIL' END;
set @testnum=99.99; insert into zharbor.test select 24,@testnum testnum, case zharbor.getListingFee(@testnum) when 0.25 then 'PASS' ELSE 'FAIL' END;
set @testnum=100.00; insert into zharbor.test select 25,@testnum testnum, case zharbor.getListingFee(@testnum) when 0.50 then 'PASS' ELSE 'FAIL' END;
set @testnum=999.99; insert into zharbor.test select 26,@testnum testnum, case zharbor.getListingFee(@testnum) when 0.50 then 'PASS' ELSE 'FAIL' END;
set @testnum=1000.00; insert into zharbor.test select 27,@testnum testnum, case zharbor.getListingFee(@testnum) when 1.00 then 'PASS' ELSE 'FAIL' END;
set @testnum=2000.00; insert into zharbor.test select 28,@testnum testnum, case zharbor.getListingFee(@testnum) when 1.00 then 'PASS' ELSE 'FAIL' END;

set @testnum=0.0; insert into zharbor.test select 29,@testnum testnum, case zharbor.getClosingFee(@testnum) when 0.0 then 'PASS' ELSE 'FAIL' END;
set @testnum=0.01; insert into zharbor.test select 30,@testnum testnum, case zharbor.getClosingFee(@testnum) when 0.0 then 'PASS' ELSE 'FAIL' END;
set @testnum=9.99; insert into zharbor.test select 31,@testnum testnum, case zharbor.getClosingFee(@testnum) when 0.2 then 'PASS' ELSE 'FAIL' END;
set @testnum=10.00; insert into zharbor.test select 32,@testnum testnum, case zharbor.getClosingFee(@testnum) when 0.19 then 'PASS' ELSE 'FAIL' END;
set @testnum=49.99; insert into zharbor.test select 33,@testnum testnum, case zharbor.getClosingFee(@testnum) when 0.95 then 'PASS' ELSE 'FAIL' END;
set @testnum=50; insert into zharbor.test select 34,@testnum testnum, case zharbor.getClosingFee(@testnum) when 0.9 then 'PASS' ELSE 'FAIL' END;
set @testnum=999.99; insert into zharbor.test select 35,@testnum testnum, case zharbor.getClosingFee(@testnum) when 18 then 'PASS' ELSE 'FAIL' END;
set @testnum=1000; insert into zharbor.test select 36,@testnum testnum, case zharbor.getClosingFee(@testnum) when 15 then 'PASS' ELSE 'FAIL' END;
set @testnum=20000; insert into zharbor.test select 37,@testnum testnum, case zharbor.getClosingFee(@testnum) when 300 then 'PASS' ELSE 'FAIL' END;
set @testnum=21000; insert into zharbor.test select 38,@testnum testnum, case zharbor.getClosingFee(@testnum) when 252 then 'PASS' ELSE 'FAIL' END;
go



/********************************************************************************************
TEST:
	make sure that current effective bid is acurate and retrievable
	tests integration of calcCurrentWinningBid function and updateEffectiveBid trigger and the effectiveBidHistory record
PROCEDURE:
	 set mock bids to test other auction ids
	 buyer	inserts	|	currentWinner	currentAmount
	 null	null	|	null			0
	 2		2		|	2				1
	 1		5		|	1				2.25
	 2		3		|	1				3.25
	 2		5		|	1				5
	 2		5.01	|	2				5.01

	
	sometimes behaves inconsistent, i believe it is a concurency issue with the effective bid history table
********************************************************************************************/
--clean up any old data
	delete from zharbor.sellerFee;
	delete from zharbor.effectiveBidHistory
	delete from zharbor.maxUserBid
	delete from zharbor.auction;
	delete from zharbor.seller;
	delete from zharbor.item;
	delete from zharbor.buyer;
--needed sample data
	insert into zharbor.item values (1, 'box');
	insert into zharbor.item values (2, 'car');
	insert into zharbor.buyer values(1, 'diego', 'colombia', '801', 'somewhere@somewhere.org');
	insert into zharbor.buyer values(2, 'mike', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.buyer values(3, 'kyler', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.seller values(1, 'diegoseller', 1, 'vanegas', '803', 'some@somwhere.org', 'also Utah');
	insert into zharbor.auction values(1, 1, 1, getDate(), '20191212 12:00:00 PM', 1, 200, 'active', null, null); -- minimum bid is 1
	insert into zharbor.auction values(2, 1, 2, getDate(), '20191212 12:00:00 PM', 1, 200, 'active', null, null);
	insert into zharbor.auction values(3, 1, 2, getDate(), '20191212 12:00:00 PM', 1, 200, 'active', null, null);

	
--check if returns nothing if no bids have been placed
	insert into zharbor.test select 39,'noBid' testName, case cast((select top 1 count(id) from zharbor.calcCurrentWinningBid(1)) as int) when 0 then 'PASS' else 'FAIL' END testStatus;
	insert into zharbor.test select 40,'noBidRecord', case (select count(*) from zharbor.effectiveBidHistory ebh) when 0 then 'PASS' else 'FAIL' END  testStatus;

--check if first bid is equal to minimum bid (1)
	insert into zharbor.maxUserBid values(1, 2, 2, getDate());--auctionid, buyerid, amount, date
	insert into zharbor.test select 41,'firstBid', case (select cwb.bid from zharbor.calcCurrentWinningBid(1) cwb) when 1 then 'PASS' else 'FAIL' END testStatus;
	insert into zharbor.test select  42,'firstBidRecord', case (select top 1 ebh.bid from zharbor.effectiveBidHistory ebh order by ebh.bidDate desc) when 1 then 'PASS' else 'FAIL' END testStatus;
	insert into zharbor.test select 42.1,'firstBidAuctionTopBuyerid', case (select a.topBuyerid from zharbor.auction a where a.id = 1) when 2 then 'PASS' else 'FAIL' END testStatus;
	insert into zharbor.test select 42.2,'firstBidAuctionTopEffBid', case (select a.topEffBid from zharbor.auction a where a.id = 1) when 1 then 'PASS' else 'FAIL' END testStatus;

--check if next bid will be 2 + increment after a new higher bid is placed
	insert into zharbor.maxUserBid values(1, 1, 5, getDate());
	insert into zharbor.test select  43,'secondBid', case (select cwb.bid from zharbor.calcCurrentWinningBid(1) cwb) when 2.25 then 'PASS' else 'FAIL' END testStatus;
	insert into zharbor.test select 44,'secondBidRecord', case (select top 1 ebh.bid from zharbor.effectiveBidHistory ebh order by ebh.bidDate desc) when 2.25 then 'PASS' else 'FAIL' END testStatus;
	insert into zharbor.test select 44.1,'secondBidAuctionTopBuyerid', case (select a.topBuyerid from zharbor.auction a where a.id = 1) when 1 then 'PASS' else 'FAIL' END testStatus;
	insert into zharbor.test select 44.2,'secondBidAuctionTopEffBid', case (select a.topEffBid from zharbor.auction a where a.id = 1) when 2.25 then 'PASS' else 'FAIL' END testStatus;
	
--check if when next bid is lower than the max bid but greater than the current the right person has the bid and the bid is correct
	insert into zharbor.maxUserBid values(1, 2, 3, getDate());
	insert into zharbor.test select 45,'thirdBidAmount', case (select cwb.bid from zharbor.calcCurrentWinningBid(1) cwb) when 3.25 then 'PASS' else 'FAIL' END  testStatus;
	insert into zharbor.test select 46,'thirdBidbuyerid', case (select cwb.id from zharbor.calcCurrentWinningBid(1) cwb) when 1 then 'PASS' else 'FAIL' END testStatus;
	insert into zharbor.test select 47,'thirdBidRecord', case (select top 1 ebh.bid from zharbor.effectiveBidHistory ebh order by ebh.bidDate desc) when 3.25 then 'PASS' else 'FAIL' END  testStatus;
	insert into zharbor.test select 47.1,'thirdBidAuctionTopBuyerid', case (select a.topBuyerid from zharbor.auction a where a.id = 1) when 1 then 'PASS' else 'FAIL' END testStatus;
	insert into zharbor.test select 47.2,'thirdBidAuctionTopEffBid', case (select a.topEffBid from zharbor.auction a where a.id = 1) when 3.25 then 'PASS' else 'FAIL' END testStatus;
	
--check if same amount is bid then the oldest bid has the current bid
	insert into zharbor.maxUserBid values(1, 2, 5, getDate());
	insert into zharbor.test select 48, 'sameBidAmount', case (select cwb.bid from zharbor.calcCurrentWinningBid(1) cwb) when 5 then 'PASS' else 'FAIL' END  testStatus;
	insert into zharbor.test select 49,'sameBidbuyerid', case (select cwb.id from zharbor.calcCurrentWinningBid(1) cwb) when 1 then 'PASS' else 'FAIL' END  testStatus;
	insert into zharbor.test select 50,'sameBidRecord', case (select top 1 ebh.bid from zharbor.effectiveBidHistory ebh order by ebh.bidDate desc) when 5 then 'PASS' else 'FAIL' END  testStatus;
	insert into zharbor.test select 50.1,'sameBidAuctionTopBuyerid', case (select a.topBuyerid from zharbor.auction a where a.id = 1) when 1 then 'PASS' else 'FAIL' END testStatus;
	insert into zharbor.test select 50.2,'sameBidAuctionTopEffBid', case (select a.topEffBid from zharbor.auction a where a.id = 1) when 5 then 'PASS' else 'FAIL' END testStatus;

--check if next bid is higher, but less than second+bidIncrement then correct amount and buyer are current
	insert into zharbor.maxUserBid values(1, 2, 5.01, getDate());
	insert into zharbor.test select 51,'lessThanIncrementBidAmount', case (select cwb.bid from zharbor.calcCurrentWinningBid(1) cwb) when 5.01 then 'PASS' else 'FAIL' END testStatus;
	insert into zharbor.test select 52,'lessThanIncrementBidbuyerid', case (select cwb.id from zharbor.calcCurrentWinningBid(1) cwb) when 2 then 'PASS' else 'FAIL' END testStatus;
	insert into zharbor.test select 53,'lessThanIncrementBidRecord', case (select top 1 ebh.bid from zharbor.effectiveBidHistory ebh order by ebh.bidDate desc) when 5.01 then 'PASS' else 'FAIL' END testStatus;
	insert into zharbor.test select 53.1,'lessThanIncrementAuctionTopBuyerid', case (select a.topBuyerid from zharbor.auction a where a.id = 1) when 2 then 'PASS' else 'FAIL' END testStatus;
	insert into zharbor.test select 53.2,'lessThanIncrementBidAuctionTopEffBid', case (select a.topEffBid from zharbor.auction a where a.id = 1) when 5.01 then 'PASS' else 'FAIL' END testStatus;

--check if added feature of curent effective bid and top buyer id columns in auction work
	insert into zharbor.test select 53.3,'auctionTopBuyerid', case (select a.topBuyerid from zharbor.auction a where a.id = 1) when 2 then 'PASS' else 'FAIL' END testStatus;
	insert into zharbor.test select 53.4,'auctionTopEffBid', case (select a.topEffBid from zharbor.auction a where a.id = 1) when 5.01 then 'PASS' else 'FAIL' END testStatus;


/********************************************************************************************
TEST:
	insertmaxUserBid Trigger
PROCEDURE:
	 make bids and ensure that the data is reliable
	 a single row:
	 blank first
	 one bid
	 auctionid	buyerid	bid
	 1			1		2
	 insert a higher bid from a buyer
	 auctionid	buyerid	bid
	 1			1		3
	 insert a lower bid from the same buyer, should reject attempt to lower
	 auctionid	buyerid	bid
	 1			1		3
	 bid on a second auction
	 auctionid	buyerid	bid
	 1			1		3
	 2			1		4
********************************************************************************************/

--clean up any old data
	delete from zharbor.sellerFee;
	delete from zharbor.effectiveBidHistory
	delete from zharbor.maxUserBid
	delete from zharbor.auction;
	delete from zharbor.seller;
	delete from zharbor.item;
	delete from zharbor.buyer;
--needed sample data
	insert into zharbor.item values (1, 'box');
	insert into zharbor.item values (2, 'car');
	insert into zharbor.buyer values(1, 'diego', 'colombia', '801', 'somewhere@somewhere.org');
	insert into zharbor.buyer values(2, 'mike', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.buyer values(3, 'kyler', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.seller values(1, 'diegoseller', 1, 'vanegas', '803', 'some@somwhere.org', 'also Utah');
	insert into zharbor.auction values(1, 1, 1, getDate(), '20191212 12:00:00 PM', 1, 200, 'active', null, null); -- minimum bid is 1
	insert into zharbor.auction values(2, 1, 2, getDate(), '20191212 12:00:00 PM', 1, 200, 'active', null, null);
	
	go
--no bids
--select case (select count(*) from zharbor.maxUserBid bl where bl.auctionid = 1) when 0 then 'PASS' else 'FAIL' end noData;
--put in a bid
	insert into zharbor.maxUserBid values(1, 1, 2, getDate());
	insert into zharbor.test select 54,'oneEntryAmount', case (select bl.bid from zharbor.maxUserBid bl where bl.auctionid = 1) when 2 then 'PASS' else 'FAIL' end testStatus;
	insert into zharbor.test select 55,'oneEntryId', case (select bl.buyerid from zharbor.maxUserBid bl where bl.auctionid = 1) when 1 then 'PASS' else 'FAIL' end testStatus;

--place another bid from same buyer
	insert into zharbor.maxUserBid values(1, 1, 3, getDate());
	insert into zharbor.test select 56,'anotherEntryAmount', case (select bl.bid from zharbor.maxUserBid bl where bl.auctionid = 1) when 3 then 'PASS' else 'FAIL' end testStatus;
	insert into zharbor.test select 57,'anotherEntryId case', case (select bl.buyerid from zharbor.maxUserBid bl where bl.auctionid = 1) when 1 then 'PASS' else 'FAIL' end testStatus;
	insert into zharbor.test select 58,'anotherEntrySingleRow', case (select count(bl.buyerid) from zharbor.maxUserBid bl where bl.auctionid = 1) when 1 then 'PASS' else 'FAIL' end testStatus;

--attempt to lower bid
	insert into zharbor.maxUserBid values(1, 1, 2, getDate());
	insert into zharbor.test select 59,'lowerEntryAmount', case (select bl.bid from zharbor.maxUserBid bl where bl.auctionid = 1) when 3 then 'PASS' else 'FAIL' end testStatus;
	insert into zharbor.test select 60,'lowerEntryId', case (select bl.buyerid from zharbor.maxUserBid bl where bl.auctionid = 1) when 1 then 'PASS' else 'FAIL' end testStatus;
	insert into zharbor.test select  61,'lowerEntrySingleRow', case (select count(bl.buyerid) from zharbor.maxUserBid bl where bl.auctionid = 1) when 1 then 'PASS' else 'FAIL' end testStatus;

--test that a second auction doesnt mess anything up
	insert into zharbor.maxUserBid values(2, 1, 4, getDate());
	insert into zharbor.test select 62,'auction1EntryAmount', case (select bl.bid from zharbor.maxUserBid bl where bl.auctionid = 1) when 3 then 'PASS' else 'FAIL' end testStatus;
	insert into zharbor.test select 63,'auction1EntryId', case (select bl.buyerid from zharbor.maxUserBid bl where bl.auctionid = 1) when 1 then 'PASS' else 'FAIL' end testStatus;
	insert into zharbor.test select 64,'auction1EntrySingleRow', case (select count(bl.buyerid) from zharbor.maxUserBid bl where bl.auctionid = 1) when 1 then 'PASS' else 'FAIL' end testStatus;
	
	insert into zharbor.test select 65,'auction2EntryAmount', case (select bl.bid from zharbor.maxUserBid bl where bl.auctionid = 2) when 4 then 'PASS' else 'FAIL' end testStatus;
	insert into zharbor.test select 66,'auction2EntryId', case (select bl.buyerid from zharbor.maxUserBid bl where bl.auctionid = 2) when 1 then 'PASS' else 'FAIL' end testStatus;
	insert into zharbor.test select 67,'auction2EntrySingleRow', case (select count(bl.buyerid) from zharbor.maxUserBid bl where bl.auctionid = 2) when 1 then 'PASS' else 'FAIL' end testStatus;

--Close the auction and see if you can bid
	update zharbor.auction set currentStatus = 'closed' where id = 1;	
	insert into zharbor.maxUserBid values(1, 3, 200, getDate());
	insert into zharbor.test select 68,'closedAuctionBuyerid', case (select bl.buyerid from zharbor.maxUserBid bl where bl.auctionid = 1) when 1 then 'PASS' else 'FAIL' end testStatus;

--if the auction is not 'closed' but is past the closing time see if you can bid
	
	insert into zharbor.auction values(3, 1, 2, getDate(), '20001212 12:00:00 PM', 1, 200, 'active', null, null); --ended in 2000
	insert into zharbor.maxUserBid values(3, 3, 200, getDate());
	insert into zharbor.test select 69,'overdueAuctionBid', case (select count(*) from zharbor.maxUserBid bl where bl.auctionid = 3) when 0 then 'PASS' else 'FAIL' end;




/********************************************************************************************
TEST:
	placeBidPct function
PROCEDURE:
	place a bid and see if it exists in the maxUserBid
		check if the amount is incremented appropriatly
********************************************************************************************/
--clean up any old data
	delete from zharbor.sellerFee;
	delete from zharbor.effectiveBidHistory
	delete from zharbor.maxUserBid
	delete from zharbor.auction;
	delete from zharbor.seller;
	delete from zharbor.item;
	delete from zharbor.buyer;
--needed sample data
	insert into zharbor.item values (1, 'box');
	insert into zharbor.item values (2, 'car');
	insert into zharbor.buyer values(1, 'diego', 'colombia', '801', 'somewhere@somewhere.org');
	insert into zharbor.buyer values(2, 'mike', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.buyer values(3, 'kyler', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.seller values(1, 'diegoseller', 1, 'vanegas', '803', 'some@somwhere.org', 'also Utah');
	insert into zharbor.auction values(1, 1, 1, getDate(), '20191212 12:00:00 PM', 1, 200, 'active', null, null); -- minimum bid is 1
	insert into zharbor.auction values(2, 1, 2, getDate(), '20191212 12:00:00 PM', 1, 200, 'active', null, null);
	insert into zharbor.auction values(3, 1, 2, getDate(), '20191212 12:00:00 PM', 1, 200, 'active', null, null);
	insert into zharbor.maxUserBid values(1, 1, 2, getDate()); --place a bid so there is a current winning bid
	go
--call function the current winning bid should be .05 greater than the minimum bid at this point
	exec zharbor.placeBidPct @buyerid=2, @auctionid=1, @pct=.05;
	insert into zharbor.test select 70,'firstBidIncrement', case (select cwb.bid from zharbor.calcCurrentWinningBid(1) cwb) when 1.3 then 'PASS' else 'FAIL' end testStatus;

--insert another and make it 300% greater, this should make it the current winning bid
	exec zharbor.placeBidPct @buyerid=2, @auctionid=1, @pct=3;
	insert into zharbor.test select 71,'secondBidIncrement', case (select cwb.bid from zharbor.calcCurrentWinningBid(1) cwb) when 2.25 then 'PASS' else 'FAIL' end testStatus;




/********************************************************************************************
TEST:
	placeBidAmt procedure
PROCEDURE:
	see if the bid amount is placed
	the trigger on maxUserBid validates so you dont need to test edges here
********************************************************************************************/
--clean up any old data
	delete from zharbor.sellerFee;
	delete from zharbor.effectiveBidHistory
	delete from zharbor.maxUserBid
	delete from zharbor.auction;
	delete from zharbor.seller;
	delete from zharbor.item;
	delete from zharbor.buyer;
--needed sample data
	insert into zharbor.item values (1, 'box');
	insert into zharbor.item values (2, 'car');
	insert into zharbor.buyer values(1, 'diego', 'colombia', '801', 'somewhere@somewhere.org');
	insert into zharbor.buyer values(2, 'mike', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.buyer values(3, 'kyler', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.seller values(1, 'diegoseller', 1, 'vanegas', '803', 'some@somwhere.org', 'also Utah');
	insert into zharbor.auction values(1, 1, 1, getDate(), '20191212 12:00:00 PM', 1, null, 'active', null, null); -- minimum bid is 1
	insert into zharbor.auction values(2, 1, 2, getDate(), '20191212 12:00:00 PM', 1, null, 'active', null, null);
	insert into zharbor.auction values(3, 1, 2, getDate(), '20191212 12:00:00 PM', 1, null, 'active', null, null);
	insert into zharbor.maxUserBid values(1, 1, 2, getDate()); --place a bid so there is a current winning bid
	
	exec zharbor.placeBidAmt @buyerid = 2, @auctionid = 1, @amount = 3;

	insert into zharbor.test select 72,'placeBidAmt_Auctionid', case (select top 1 mub.auctionid from zharbor.maxUserBid mub) when 1 then 'PASS' else 'FAIL' end;
	insert into zharbor.test select 73,'placeBidAmt_Buyerid', case (select top 1 mub.buyerid from zharbor.maxUserBid mub) when 1 then 'PASS' else 'FAIL' end;
	insert into zharbor.test select 74,'placeBidAmt_BidAmt', case (select top 1 mub.bid from zharbor.maxUserBid mub where mub.auctionid = 1 and mub.buyerid = 2) when 4 then 'PASS' else 'FAIL' end;

/********************************************************************************************
TEST:
	displayEffBidHist procedure
PROCEDURE:
	if all the effective bids are logged in history
	inputs			|	psudo rows in table
	 buyer	inserts	|	currentWinner	currentAmount
	 null	null	|	null			0
	 2		2		|	2				1
	 1		5		|	1				2.25
	 2		3		|	1				3.25
	 2		5		|	1				5
	 2		5.01	|	2				5.01
*******************************************************************************************
select exec displayEffBidHist;








exec zharbor.listActiveAuction 1;
exec zharbor.listClosedAuction 1;
*/




/********************************************************************************************
TEST:
	insert newAuctionfee trigger unit tests
********************************************************************************************/
--clean up any old data
	delete from zharbor.sellerFee;
	delete from zharbor.effectiveBidHistory
	delete from zharbor.maxUserBid
	delete from zharbor.auction;
	delete from zharbor.seller;
	delete from zharbor.item;
	delete from zharbor.buyer;
--needed sample data
	insert into zharbor.item values (1, 'box');
	insert into zharbor.item values (2, 'car');
	insert into zharbor.buyer values(1, 'diego', 'colombia', '801', 'somewhere@somewhere.org');
	insert into zharbor.buyer values(2, 'mike', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.buyer values(3, 'kyler', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.seller values(1, 'diegoseller', 1, 'vanegas', '803', 'some@somwhere.org', 'also Utah');
	insert into zharbor.seller values(2, 'mikeseller', 1, 'vanegas', '803', 'some@somwhere.org', 'also Utah');

--no auction = no fee
	insert into zharbor.test select 75,'noNewAuctionFee', case (select count(*) from zharbor.sellerFee) when 0 then 'PASS' else 'FAIL' end;

--1 auction 1 seller charges right person right amount
	insert into zharbor.auction values(1, 1, 1, getDate(), '20191212 12:00:00 PM', 1, null, 'active', null, null); 
	insert into zharbor.test select 76,'oneNewAuctionFeeAmount', case (select sum(sf.amount) from zharbor.sellerFee sf where sf.sellerid = 1) when .05 then 'PASS' else 'FAIL' end;

--add another auction on same seller
	insert into zharbor.auction values(2, 1, 2, getDate(), '20191212 12:00:00 PM', 10, null, 'active', null, null);
	insert into zharbor.test select 77,'twoNewAuctionFeeAmount', case (select sum(sf.amount) from zharbor.sellerFee sf where sf.sellerid = 1) when .3 then 'PASS' else 'FAIL' end ;
	
--add another auction from different seller
	insert into zharbor.auction values(3, 2, 1, getDate(), '20191212 12:00:00 PM', 150, null, 'active', null, null);
	insert into zharbor.test select 78,'twoNewAuctionFeeAmount', case (select sum(sf.amount) from zharbor.sellerFee sf where sf.sellerid = 2) when .5 then 'PASS' else 'FAIL' end;
	insert into zharbor.test select 79,'twoNewAuctionFeeAmount', case (select sum(sf.amount) from zharbor.sellerFee sf where sf.sellerid = 1) when .3 then 'PASS' else 'FAIL' end ;


	
/********************************************************************************************
TEST:
	logClosingFee trigger unit tests
********************************************************************************************/
--clean up any old data
	delete from zharbor.sellerFee;
	delete from zharbor.effectiveBidHistory
	delete from zharbor.maxUserBid
	delete from zharbor.auction;
	delete from zharbor.seller;
	delete from zharbor.item;
	delete from zharbor.buyer;
--needed sample data
	insert into zharbor.item values (1, 'box');
	insert into zharbor.item values (2, 'car');
	insert into zharbor.buyer values(1, 'diego', 'colombia', '801', 'somewhere@somewhere.org');
	insert into zharbor.buyer values(2, 'mike', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.buyer values(3, 'kyler', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.seller values(1, 'diegoseller', 1, 'vanegas', '803', 'some@somwhere.org', 'also Utah');
	insert into zharbor.seller values(2, 'diegoseller', 1, 'vanegas', '803', 'some@somwhere.org', 'also Utah');
	insert into zharbor.auction values(1, 1, 1, getDate(), '20191212 12:00:00 PM', 1, null, 'active', null, null); -- minimum bid is 1
	insert into zharbor.auction values(2, 1, 2, getDate(), '20191212 12:00:00 PM', 1, null, 'active', null, null); -- charged .05 for listing
	insert into zharbor.auction values(3, 2, 2, getDate(), '20191212 12:00:00 PM', 1, null, 'active', null, null);
	insert into zharbor.auction values(4, 2, 2, getDate(), '20191212 12:00:00 PM', 1, null, 'active', null, null); --auction with no bids
	insert into zharbor.maxUserBid values(1, 1, 2, getDate()); --place a bid so there is a current winning bid
	insert into zharbor.maxUserBid values(2, 1, 2, getDate()); --closing bid is 1
	insert into zharbor.maxUserBid values(3, 1, 2, getDate()); 
	
--no closed auctions
	insert into zharbor.test select 79,'noClosedAuctions', case (select sum(sf.amount) from zharbor.sellerFee sf where sf.sellerid = 1) when .1 then 'PASS' else 'FAIL' end;
	
--close the first auction
	update zharbor.auction set currentStatus = 'closed' where id = 1; 
	insert into zharbor.test select 80,'oneClosedAuction', case (select sum(sf.amount) from zharbor.sellerFee sf where sf.sellerid = 1) when .12 then 'PASS' else 'FAIL' end;

--close the second auction
	update zharbor.auction set currentStatus = 'closed' where id = 2; 
	insert into zharbor.test select 81,'twoClosedAuction', case (select sum(sf.amount) from zharbor.sellerFee sf where sf.sellerid = 1) when .14 then 'PASS' else 'FAIL' end;

--close someone elses auction
	update zharbor.auction set currentStatus = 'closed' where id = 3; 
	insert into zharbor.test select 82,'threeClosedAuction',  case (select sum(sf.amount) from zharbor.sellerFee sf where sf.sellerid = 1) when .14 then 'PASS' else 'FAIL' end;
	insert into zharbor.test select 83,'threeClosedAuction', case (select sum(sf.amount) from zharbor.sellerFee sf where sf.sellerid = 2) when .12 then 'PASS' else 'FAIL' end;

	--select * from zharbor.sellerFee;

--close the auction with no bids
	update zharbor.auction set currentStatus = 'closed' where id = 4;
	insert into zharbor.test select  84,'closedNoBidAuctionFee', case (select count(*) from zharbor.sellerFee sf where sf.auctionid = 4) when 1 then 'PASS' else 'FAIL' end;
	
	

/********************************************************************************************
TEST:
	listClosedAuction
	closeEndedAuction
PROCEDURE:
	make 3 auctions, all active, two with past closing dates
	see if you can list them
	see if the 2 ended ones will close
********************************************************************************************/
--clean up any old data
	delete from zharbor.sellerFee;
	delete from zharbor.effectiveBidHistory
	delete from zharbor.maxUserBid
	delete from zharbor.auction;
	delete from zharbor.seller;
	delete from zharbor.item;
	delete from zharbor.buyer;
--needed sample data
	insert into zharbor.item values (1, 'box');
	insert into zharbor.item values (2, 'car');
	insert into zharbor.buyer values(1, 'diego', 'colombia', '801', 'somewhere@somewhere.org');
	insert into zharbor.buyer values(2, 'mike', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.buyer values(3, 'kyler', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.seller values(1, 'diegoseller', 1, 'vanegas', '803', 'some@somwhere.org', 'also Utah');
	insert into zharbor.auction values(1, 1, 1, getDate()-1000, getDate()-500, 1, 200, 'active', null, null); -- minimum bid is 1
	insert into zharbor.auction values(2, 1, 2, getDate()-1000, '30001212 12:00:00 PM', 1, 200, 'active', null, null);
	insert into zharbor.auction values(3, 1, 2, getDate()-1000, getDate()-500, 1, 200, 'active', null, null);
	
	
--see if you can detect all the ovedue auctions
	insert into zharbor.test select 85,'findClosedAuctAmt', case(select count(*) from zharbor.findOverdueAuction()) when 2 then 'PASS' else 'FAIL' end;

--call closeOverdueAuction, see if 0 overdue auctions are detected
	exec zharbor.closeOverdueAuction ;
	insert into zharbor.test select 86,'findClosedAuctAmt', case(select count(*) from zharbor.findOverdueAuction()) when 0 then 'PASS' else 'FAIL' end ;

	
/********************************************************************************************
TEST:
	buy it now functionality
PROCEDURE:
	make an auction
	exec buyItNow 
	check if auction is closed
	check that auction was bought now
	check if the closed auciton has the correct bought amount

	make another auction
	place a bid
	exec buyItNow
	check that auction is open
	check that auction was not bought now

	check if the closed auciton has the correct bought amount

********************************************************************************************/
--clean up any old data
	delete from zharbor.sellerFee;
	delete from zharbor.effectiveBidHistory
	delete from zharbor.maxUserBid
	delete from zharbor.auction;
	delete from zharbor.seller;
	delete from zharbor.item;
	delete from zharbor.buyer;
--needed sample data
	insert into zharbor.item values (1, 'box');
	insert into zharbor.item values (2, 'car');
	insert into zharbor.buyer values(1, 'diego', 'colombia', '801', 'somewhere@somewhere.org');
	insert into zharbor.buyer values(2, 'mike', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.buyer values(3, 'kyler', 'utah', '802', 'somehere@somewhere.org');
	insert into zharbor.seller values(1, 'diegoseller', 1, 'vanegas', '803', 'some@somwhere.org', 'also Utah');



	
	insert into zharbor.auction values(1, 1, 1, getDate()-1000, getDate()-500, 1, 200, 'active', null, null); -- minimum bid is 1
	exec zharbor.buyItNow 1, 3;
	insert into zharbor.test select 87,'auction1Closed', case (select a.currentStatus from zharbor.auction a where a.id = 1) when 'closed_BN' then 'PASS' else 'FAIL' end;
	insert into zharbor.test select 88,'auction1Bought', case (select s.feeType from zharbor.sellerFee s where s.auctionid = 1 and s.amount=0.25) when 'buyNow' then 'PASS' else 'FAIL' end;
	
	insert into zharbor.test select 88.1, 'auction1Buyer', case (select a.topBuyerid from zharbor.auction a where a.id = 1) when 3 then 'PASS' ELSE 'FAIL' end;
	insert into zharbor.test select 88.2, 'auction1Price', case (select a.topEffBid from zharbor.auction a where a.id = 1) when 200 then 'PASS' ELSE 'FAIL' end;

	insert into zharbor.auction values(2, 1, 2, getDate()-1000, '30001212 12:00:00 PM', 1, 200, 'active', null, null);
	insert into zharbor.maxUserBid values (2, 1, 30, getDate());
	exec zharbor.buyItNow 2, 3;
	insert into zharbor.test select 89,'auction2Closed', case (select a.currentStatus from zharbor.auction a where a.id = 2) when 'active' then 'PASS' else 'FAIL' end;
	insert into zharbor.test select 90,'auction2Bought', case (select s.feeType from zharbor.sellerFee s where s.auctionid = 2 and s.amount=0.25) when 'buyNow' then 'PASS' else 'FAIL' end;






	select * from zharbor.test where testStatus = 'FAIL';