From: Neil Brown <neilb@suse.de>
Subject: Re: [RFC PATCH 0/2] a couple of readonly handling fixups
Date: Mon, 19 Jan 2009 10:07:43 +1100
Message-ID: <18803.46655.134295.118861@nbeee.brown>
References: <20090108072023.9577.3585.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Thursday January 8
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 8, dan.j.williams@intel.com wrote:
> The BUG_ON(mddev->ro == 1) in md_write_start can be triggered under two
> circumstances in recent kernels.  One was reported by Justin Maggard:

Hi Dan,
 Thanks for following up with this.....

(I meant to send this over a week ago, but I've been on vaction
in Tasmania and my mobile has no coverage....)

> 
> 1) Create an md array with >= 1 disk
> 2) Start a task writing to the array ("dd if=/dev/zero of=/dev/md0
> bs=1M count=10000 &" does the trick for me)
> 3) Force an improper reboot with reboot -fn
> 
> ...the other was discovered while investigating this issue.
> 
> 1) Set a raid5 readyonly with mdadm
> 2) Set the array writable with blockdev
> 3) Attempt to write to the array
> 
> ---
> 
> Dan Williams (2):
>       Revert "Restore force switch of md array to readonly at reboot time."

I'm not comfortable with this.  That patch itself fixed a regression.
In some situations, the reboot notifier is the only thing that makes
sure the array is marked clean at shutdown time.  This revert
effectively disables that so sometimes a reboot will leave an array
dirty, which is not good.

There must be some other recent change that causes IO still to be in
flight this late.  Maybe I'll try to track it down.

>       md: set mddev readonly flag on blkdev BLKROSET ioctl

This one I'm happy with.  I'll make sure it gets through.

Thanks,
NeilBrown
