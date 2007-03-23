From: Neil Brown <neilb@suse.de>
Subject: Re: 2.6.20.3 AMD64 oops in CFQ code
Date: Fri, 23 Mar 2007 11:44:58 +1100
Message-ID: <17923.8970.917375.917772@notabene.brown>
References: <20070322184155.GY19922@kernel.dk>
	<20070322185413.13929.qmail@science.horizon.com>
	<20070322190052.GA19922@kernel.dk>
	<17923.6258.855467.589548@notabene.brown>
	<e9c3a7c20703221731p2eeb727eo44eb12ec9287d2c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Thursday March 22
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux@horizon.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@dale.us, cebbert@redhat.com
List-Id: linux-raid.ids

On Thursday March 22, dan.j.williams@intel.com wrote:
> 
> Not a cfq failure, but I have been able to reproduce a different oops
> at array stop time while i/o's were pending.  I have not dug into it
> enough to suggest a patch, but I wonder if it is somehow related to
> the cfq failure since it involves congestion and drives going away:

Thanks.   I know about that one and have a patch about to be posted
which should fix it.  But I don't completely understand it.

When a raid5 array shuts down, it clears mddev->private, but doesn't
clean q->backing_dev_info.congested_fn.  So if someone tries to call
that congested_fn, it will try to dereference mddev->private and Oops.

Only by the time that raid5 is shutting down, no-one should have a
reference to the device any more, and no-one should be in a position
to call congested_fn !!

Maybe pdflush is just trying to sync the block device, even though
there is no dirty date .... dunno....

But I don't think it is related to the cfq problem as this one is only
a problem when the array is being stopped.

Thanks,
NeilBrown
