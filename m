From: Tejun Heo <tj@kernel.org>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Wed, 6 Apr 2011 03:16:00 -0700
Message-ID: <20110406101600.GB4142@mtj.dyndns.org>
References: <201103251725.21180.thomas.jarosch@intra2net.com>
 <4D90E580.7020406@intra2net.com>
 <20110329082503.GI6736@htj.dyndns.org>
 <201103291153.06495.thomas.jarosch@intra2net.com>
 <20110329100744.GK6736@htj.dyndns.org>
 <20110405134629.664b946c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110405134629.664b946c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey, Neil.

On Tue, Apr 05, 2011 at 01:46:29PM +1000, NeilBrown wrote:
> After mddev_find returns the new mddev, md_open calls flush_workqueue
> and as the work item to complete the delete has definitely been queued, it
> should wait for that work item to complete.
> 
> So the next time around the retry loop in __blkdev_get the old gendisk will
> not be found....
> 
> Where is my logic wrong??
>
> To put it another way matching your description Tejun, the put path has a
> chance to run firstly while mddev_find is waiting for the spinlock, and then
> while flush_workqueue is waiting for the rest of the put path to complete.

I don't think the logic is wrong per-se.  It's more likely that the
implemented code doesn't really follow the model described by the
logic.

Probably the best way would be reproducing the problem and throwing in
some diagnostic code to tell the sequence of events?  If work is being
queued first but it still ends up busy looping, that would be a bug in
flush_workqueue(), but I think it's more likely that the restart
condition somehow triggers in an unexpected way without the work item
queued as expected.

Thanks.

-- 
tejun
