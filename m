From: Peter Landmann <sfrazt@googlemail.com>
Subject: Re: RAID 5 doesn't scale
Date: Wed, 3 Apr 2013 21:12:59 +0000 (UTC)
Message-ID: <loom.20130403T230943-304@post.gmane.org>
References: <loom.20130403T122905-373@post.gmane.org> <515C2C3C.3020400@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Note also that you're doing 4KB random writes against RAID5.  This is
> going to generate substantial RMW cycles.  The Intel X25-M G2 is not a
> speed daemon.  Its published max 4KB IOPS throughput is for purely
> random writes, not the read+write pattern created by parity RMW.  So
> while your random read should get a nice jump with this test, your
> random write may not improve as much.  The limitation here is a function
> of the SSD controller on the X25-M G2, not md/RAID5.  If you test 5
> drives in md/RAID0 you'll see a bump in random write IOPS.
> 

It seems so. I let fio run a bit longer and in each settings the ssd-
performance decreased after few minutes. While mpstat still showed ~100% ssd-
utilization.




