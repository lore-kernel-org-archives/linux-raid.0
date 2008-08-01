From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PULL REQUEST] md bug fixes and minor improvements
Date: Fri, 1 Aug 2008 10:16:57 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0808011007240.3277@nehalem.linux-foundation.org>
References: <18578.31924.259887.735206@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18578.31924.259887.735206@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Arthur Jones <ajones@riverbed.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-raid.ids



On Fri, 1 Aug 2008, Neil Brown wrote:
> 
> Hi Linus,
>  please pull the following bugfixes for drivers/md.

Hmm. This doesn't seem to include any fix for the reported unlocked 
blk_plug() from MD?

See the emails from Rafael on the kernel mailing list for details 
(WARNING: at /home/rafael/src/linux-next/include/linux/blkdev.h:447), but 
it boils down to

	WARNING: at /home/rafael/src/linux-2.6/include/linux/blkdev.h:447 blk_plug_device+0x9b/0xb0()
	Pid: 2268, comm: kjournald Not tainted 2.6.27-rc1-git #211

	Call Trace:
	 [<ffffffff8023af5f>] warn_on_slowpath+0x5f/0x80
	 [<ffffffff8034fc7b>] blk_plug_device+0x9b/0xb0
	 [<ffffffff8044d5bf>] bitmap_startwrite+0xbf/0x1b0

where it really looks like "bitmap_startwrite()" just calls 
blk_plug_device() without holding the queue lock. The rule for that 
function is documented to be:

 * This is called with interrupts off and no requests on the queue and
 * with the queue lock held.

Hmm?

Now, admittedly, the blk interfaces here are a bit inconsistent: I think 
blk_unplug() is supposed to be called _without_ the lock, so it's a bit 
odd that blk_plug_device() is supposed to b called with it held, but 
somebody should double-check me on that one.

I guess Jens is gone too..

		Linus
