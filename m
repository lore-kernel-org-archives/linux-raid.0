From: "harry" <hfranklin97@excite.com>
Subject: disk testing
Date: Tue, 14 Sep 2004 04:50:07 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040914085007.486103E2F@xprdmailfe12.nwk.excite.com>
Reply-To: hfranklin97@excite.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I just bought 3 sata drives and set them up in a raid5 array. About 45% into syncing them, the first disk gets an error and goes offline. I figure I did something wrong, so I retrace my steps and try again, and again, I get an error about 45% of the way through, the first disk errors and goes offline. 

So, I think I have a bad disk. But wait! I created a raid 1 array on the remaining two to see if there are any other errors later on those two (there weren't), and I create a normal partition/fs on the failing disk. I begin writing various bitpatterns across the entire disk and reading them back, trying to find the problem. So far, I've done about 5 passes over the entire disk without error! 

So, any idea why raid would be getting errors from the disk, but I don't seem to be able to? (or, what I should tell the store I bought it from when I try to get it replaced?)

Thanks, Harry

ps, The only thing I can think of is that the first time through I had been using the array (created a partition, started moving files onto it), and the excessive thrashing of the heads caused an intermittent error to show itself, whereas the tests I'm currently running are strictly linear and easy enough on the disk that the problem doesn't appear. 



_______________________________________________
Join Excite! - http://www.excite.com
The most personalized portal on the Web!
