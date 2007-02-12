From: "Marc Marais" <marcm@liquid-nexus.net>
Subject: Re: md: md6_raid5 crash 2.6.20
Date: Mon, 12 Feb 2007 08:03:57 +0800
Message-ID: <20070212000042.M73586@liquid-nexus.net>
References: <20070211071527.M31642@liquid-nexus.net> <17871.37497.786198.834303@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17871.37497.786198.834303@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 12 Feb 2007 09:02:33 +1100, Neil Brown wrote
> On Sunday February 11, marcm@liquid-nexus.net wrote:
> > Greetings,
> > 
> > I've been running md on my server for some time now and a few days ago one of
> > the (3) drives in the raid5 array starting giving read errors. The result was
> > usually system hangs and this was with kernel 2.6.17.13. I upgraded to the
> > latest production 2.6.20 kernel and experienced the same behaviour.
> 
> System hangs suggest a problem with the drive controller.  However
> this "kernel BUG" is something newly introduced in 2.6.20 which 
> should be fixed in 2.6.20.1.  Patch is below.
> 
> If you still get hangs with this patch installed, then please report
> detail, and probably copy to linux-ide@vger.kernel.org.
> 
> NeilBrown
> 
> Fix various bugs with aligned reads in RAID5.
> 
> It is possible for raid5 to be sent a bio that is too big
> for an underlying device.  So if it is a READ that we
> pass stright down to a device, it will fail and confuse
> RAID5.
> 
> So in 'chunk_aligned_read' we check that the bio fits within the
> parameters for the target device and if it doesn't fit, fall back
> on reading through the stripe cache and making lots of one-page
> requests.
> 
> Note that this is the earliest time we can check against the device
> because earlier we don't have a lock on the device, so it could 
> change underneath us.
> 
> Also, the code for handling a retry through the cache when a read
> fails has not been tested and was badly broken.  This patch fixes 
> that code.
> 
> Signed-off-by: Neil Brown <neilb@suse.de>
> 

Thanks for the quick response Neil unfortunately the kernel doesn't build with
this patch due to a missing symbol:

WARNING: "blk_recount_segments" [drivers/md/raid456.ko] undefined!

Is that in another file that needs patching or within raid5.c?

Marc

--
