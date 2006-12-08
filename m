From: Neil Brown <neilb@suse.de>
Subject: Re: Odd (slow) RAID performance
Date: Fri, 8 Dec 2006 17:01:41 +1100
Message-ID: <17784.65477.993729.508985@cse.unsw.edu.au>
References: <456F4872.2090900@tmr.com>
	<20061201092211.4ACDB12EDE@bluewhale.planbit.co.uk>
	<45710EDC.9050805@tmr.com>
	<e9c3a7c20612041733h5999ac0erc7ab4a7174882683@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Monday December 4
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Roger Lucas <roger@planbit.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday December 4, dan.j.williams@gmail.com wrote:
> 
> Here is where I step into supposition territory.  Perhaps the
> discrepancy is related to the size of the requests going to the block
> layer.  raid5 always makes page sized requests with the expectation
> that they will coalesce into larger requests in the block layer.
> Maybe we are missing coalescing opportunities in raid5 compared to
> what happens in the raid0 case?  Are there any io scheduler knobs to
> turn along these lines?

This can be measured.  /proc/diskstats reports the number of requests
as well as the number of sectors.
The number of write requests is column 8.  The number of write sectors
is column 10.  Comparing these you can get an average request size.

I have found that the average request size is proportional to the size
of the stripe cache (roughly, with limits) but increasing it doesn't
increase through put.
I have measured very slow write throughput for raid5 as well, though
2.6.18 does seem to have the same problem.  I'll double check and do a
git bisect and see what I can come up with.

NeilBrown
