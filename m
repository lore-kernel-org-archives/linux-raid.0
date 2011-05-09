From: NeilBrown <neilb@suse.de>
Subject: Re: md question re: max_hw_sectors_kb
Date: Tue, 10 May 2011 09:52:43 +1000
Message-ID: <20110510095243.0a23874b@notabene.brown>
References: <4DC0639E.1070707@sgi.com>
	<yq17ha6z6tu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq17ha6z6tu.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Reed <mdr@sgi.com>, linux-raid@vger.kernel.org, Jeremy Higdon <jeremy@sgi.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-raid.ids

On Wed, 04 May 2011 13:58:05 -0400 "Martin K. Petersen"
<martin.petersen@oracle.com> wrote:

> >>>>> "Michael" == Michael Reed <mdr@sgi.com> writes:
> 
> Michael> There is code in blk_queue_make_request() which lowers the
> Michael> default value from INT_MAX to BLK_SAFE_MAX_SECTORS, which is
> Michael> 255.  This is generally lower than all the underlying devices
> Michael> with which I use md.
> 
> Yeah, the SAFE value is there to appease legacy low-level drivers.
> 
> 
> Michael> As md appears to be a stacking driver, i.e., it calls
> Michael> disk_stack_limits() for each member of a volume, it would seem
> Michael> reasonable for md to use the, INT_MAX setting for
> Michael> max_hw_sectors_kb instead of BLK_SAFE_MAX_SECTORS.
> 
> Your fix is functionally correct. However, another case just popped up
> this week where we need to distinguish between stacking driver and LLD
> defaults. So I think we should try to handle this at the block layer
> instead of explicitly tweaking this knob in MD.
> 
> I'll get this fixed up and will CC: you on the patch.
> 

What case is this?

The is another problem that I am aware of with this patch - maybe it is the
same was what you are thinking of - maybe not.

If you have FS -> DM -> MD, then any change that MD makes to
max_hw_sectors_kb will not be visible to the FS.  So adding and activating a
hot spare with smaller max_hw_sectors_kb cause cause it to receive requests
that are too big.

With the current default of BLK_SAFE_MAX_SECTORS, that only seems to affect a
few USB devices.  If we raise the default we could see problems happening
more often.

So we really need a propery resolution to this problem first.  i.e. A way for
'dm' to notice when 'md' changes its parameters - or in general any stacking
deivce to find out when an underlying device changes in any way.

I would implement this by having blkdev_get{,_by_path,_by_dev} take an extra
arg which is a pointer to a struct of functions.  In the first instance there
would be just one which tells the claimer that something in queue.limits has
changed.  Later we could add other calls to help with size changes.

So when md adds a new device, it call disk_stack_limits to updates its
limits, then if the bdev for the mddev is claimed with a non-NULL operations
pointer, it calls the 'limits_have_changed' function.

Thoughts?

NeilBrown
