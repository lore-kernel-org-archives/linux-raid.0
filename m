From: Neil Brown <neilb@suse.de>
Subject: Re: md: md6_raid5 crash 2.6.20
Date: Mon, 12 Feb 2007 11:15:38 +1100
Message-ID: <17871.45482.186152.158022@notabene.brown>
References: <20070211071527.M31642@liquid-nexus.net>
	<17871.37497.786198.834303@notabene.brown>
	<20070212000042.M73586@liquid-nexus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Marc Marais on Monday February 12
Sender: linux-raid-owner@vger.kernel.org
To: Marc Marais <marcm@liquid-nexus.net>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 12, marcm@liquid-nexus.net wrote:
> 
> Thanks for the quick response Neil unfortunately the kernel doesn't build with
> this patch due to a missing symbol:
> 
> WARNING: "blk_recount_segments" [drivers/md/raid456.ko] undefined!
> 
> Is that in another file that needs patching or within raid5.c?

Yes.  I keep forgetting about that bit. Sorry.


diff -puN block/ll_rw_blk.c~md-fix-various-bugs-with-aligned-reads-in-raid5-fix block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~md-fix-various-bugs-with-aligned-reads-in-raid5-fix
+++ a/block/ll_rw_blk.c
@@ -1264,7 +1264,7 @@ new_hw_segment:
 	bio->bi_hw_segments = nr_hw_segs;
 	bio->bi_flags |= (1 << BIO_SEG_VALID);
 }
-
+EXPORT_SYMBOL(blk_recount_segments);
 
 static int blk_phys_contig_segment(request_queue_t *q, struct bio *bio,
 				   struct bio *nxt)
_
