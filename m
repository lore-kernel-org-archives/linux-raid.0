From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: disk testing
Date: Tue, 14 Sep 2004 19:06:14 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16710.46214.532578.693502@cse.unsw.edu.au>
References: <20040914085007.486103E2F@xprdmailfe12.nwk.excite.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from harry on Tuesday September 14
To: hfranklin97@excite.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 14, hfranklin97@excite.com wrote:
> 
> I just bought 3 sata drives and set them up in a raid5 array. About
> 45% into syncing them, the first disk gets an error and goes
> offline. I figure I did something wrong, so I retrace my steps and
> try again, and again, I get an error about 45% of the way through,
> the first disk errors and goes offline.  
> 

Presumably a read-error.  Did the kernel logs indicate the error type?


> So, I think I have a bad disk. But wait! I created a raid 1 array on
> the remaining two to see if there are any other errors later on
> those two (there weren't), and I create a normal partition/fs on the
> failing disk. I begin writing various bitpatterns across the entire
> disk and reading them back, trying to find the problem. So far, I've
> done about 5 passes over the entire disk without error! 

Maybe when you wrote it caused the drive to fix up the bad sector.

Try building the raid5 again?

NeilBrown
