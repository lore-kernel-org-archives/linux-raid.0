From: Neil Brown <neilb@suse.de>
Subject: Re: Ooops on read-only raid5 while unmounting as xfs
Date: Tue, 23 Jan 2007 12:31:49 +1100
Message-ID: <17845.25989.10063.901037@notabene.brown>
References: <fd8d0180701180218o66a48176q172b029673c22660@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Francois Barre on Thursday January 18
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday January 18, francois.barre@gmail.com wrote:
> Hi all,
> 
> I've hit the following bug while unmounting a xfs partition
> 
> ----------- [cut here ] --------- [please bite here ] ---------
> Kernel BUG at drivers/md/md.c:5035
....
> 
> Kernel : stock-kernel 2.6.18.6, x86_64
> Setup : xfs on raid5, on 5 250Go ieee1394 drives
> Way to reproduce :
> 1. assemble the array
> 2. mount the xfs array
> 3. mark the array read-only (mdadm -o)

You shouldn't be able to do this.  It should only be possible to set
an array to read-only when it is not in use.  The fact that you cannot
suggests something else if wrong.
Are you able to stop the array (mdadm -S) while the xfs filesystem is
still mounte?d?


> 4. umount the xfs array...
> 
> I guess the problem is hit in md.c:  md_write_start(), at the
> BUG_ON(mddev->ro == 1). It is obvious that my mddev->ro is set to 1,
> because I set it read-only.
> Nowhere before md_write_start() the check on mddev->ro == 1 is done,
> so that the upper layer never sees that the underlying device is
> read-only. As a result, when xfs wishes to write to it, bad things
> happen.
> 
> May it be possible to relax the BUG_ON() and be able to send to
> upper-layer a more gentle message ?

Maybe... but I think I would rather make sure that you cannot set to
read-only while mounted.

If there some particular reason you were doing this?

Thanks,
NeilBrown
