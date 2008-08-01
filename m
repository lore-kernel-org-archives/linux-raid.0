From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PULL REQUEST] md bug fixes and minor improvements
Date: Fri, 1 Aug 2008 19:22:33 +0200
Message-ID: <20080801172231.GF20055@kernel.dk>
References: <18578.31924.259887.735206@notabene.brown> <alpine.LFD.1.10.0808011007240.3277@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755862AbYHARWr@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808011007240.3277@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Neil Brown <neilb@suse.de>, Arthur Jones <ajones@riverbed.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
List-Id: linux-raid.ids

On Fri, Aug 01 2008, Linus Torvalds wrote:
> 
> 
> On Fri, 1 Aug 2008, Neil Brown wrote:
> > 
> > Hi Linus,
> >  please pull the following bugfixes for drivers/md.
> 
> Hmm. This doesn't seem to include any fix for the reported unlocked 
> blk_plug() from MD?
> 
> See the emails from Rafael on the kernel mailing list for details 
> (WARNING: at /home/rafael/src/linux-next/include/linux/blkdev.h:447), but 
> it boils down to
> 
> 	WARNING: at /home/rafael/src/linux-2.6/include/linux/blkdev.h:447 blk_plug_device+0x9b/0xb0()
> 	Pid: 2268, comm: kjournald Not tainted 2.6.27-rc1-git #211
> 
> 	Call Trace:
> 	 [<ffffffff8023af5f>] warn_on_slowpath+0x5f/0x80
> 	 [<ffffffff8034fc7b>] blk_plug_device+0x9b/0xb0
> 	 [<ffffffff8044d5bf>] bitmap_startwrite+0xbf/0x1b0
> 
> where it really looks like "bitmap_startwrite()" just calls 
> blk_plug_device() without holding the queue lock. The rule for that 
> function is documented to be:
> 
>  * This is called with interrupts off and no requests on the queue and
>  * with the queue lock held.
> 
> Hmm?
> 
> Now, admittedly, the blk interfaces here are a bit inconsistent: I think 
> blk_unplug() is supposed to be called _without_ the lock, so it's a bit 
> odd that blk_plug_device() is supposed to b called with it held, but 
> somebody should double-check me on that one.

It is a bit asymmetrical, largely due to the fact that the ->unplug_fn()
itself grabs the lock. The below patch should fix it, since Neil has
added a proper queue lock to the md queues. If someone can confirm that
this fixes it, I'll queue up a patch with proper descriptions.

> I guess Jens is gone too..

I'm back, just been busy this week :-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 621a272..f19b52f 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1234,7 +1234,9 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 		case 0:
 			bitmap_file_set_bit(bitmap, offset);
 			bitmap_count_page(bitmap,offset, 1);
+			spin_lock_irq(&bitmap->mddev->queue->queue_lock);
 			blk_plug_device(bitmap->mddev->queue);
+			spin_unlock_irq(&bitmap->mddev->queue->queue_lock);
 			/* fall through */
 		case 1:
 			*bmc = 2;

-- 
Jens Axboe
