From: Neil Brown <neilb@suse.de>
Subject: Re: md: md6_raid5 crash 2.6.20
Date: Mon, 12 Feb 2007 09:02:33 +1100
Message-ID: <17871.37497.786198.834303@notabene.brown>
References: <20070211071527.M31642@liquid-nexus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Marc Marais on Sunday February 11
Sender: linux-raid-owner@vger.kernel.org
To: Marc Marais <marcm@liquid-nexus.net>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 11, marcm@liquid-nexus.net wrote:
> Greetings,
> 
> I've been running md on my server for some time now and a few days ago one of
> the (3) drives in the raid5 array starting giving read errors. The result was
> usually system hangs and this was with kernel 2.6.17.13. I upgraded to the
> latest production 2.6.20 kernel and experienced the same behaviour. 

System hangs suggest a problem with the drive controller.  However
this "kernel BUG" is something newly introduced in 2.6.20 which should
be fixed in 2.6.20.1.  Patch is below.

If you still get hangs with this patch installed, then please report
detail, and probably copy to linux-ide@vger.kernel.org.

NeilBrown


Fix various bugs with aligned reads in RAID5.

It is possible for raid5 to be sent a bio that is too big
for an underlying device.  So if it is a READ that we
pass stright down to a device, it will fail and confuse
RAID5.

So in 'chunk_aligned_read' we check that the bio fits within the
parameters for the target device and if it doesn't fit, fall back
on reading through the stripe cache and making lots of one-page
requests.

Note that this is the earliest time we can check against the device
because earlier we don't have a lock on the device, so it could change
underneath us.

Also, the code for handling a retry through the cache when a read
fails has not been tested and was badly broken.  This patch fixes that
code.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-02-07 10:22:22.000000000 +1100
+++ ./drivers/md/raid5.c	2007-02-06 19:19:01.000000000 +1100
@@ -2570,7 +2570,7 @@ static struct bio *remove_bio_from_retry
 	}
 	bi = conf->retry_read_aligned_list;
 	if(bi) {
-		conf->retry_read_aligned = bi->bi_next;
+		conf->retry_read_aligned_list = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_phys_segments = 1; /* biased count of active stripes */
 		bi->bi_hw_segments = 0; /* count of processed stripes */
@@ -2619,6 +2619,27 @@ static int raid5_align_endio(struct bio 
 	return 0;
 }
 
+static int bio_fits_rdev(struct bio *bi)
+{
+	request_queue_t *q = bdev_get_queue(bi->bi_bdev);
+
+	if ((bi->bi_size>>9) > q->max_sectors)
+		return 0;
+	blk_recount_segments(q, bi);
+	if (bi->bi_phys_segments > q->max_phys_segments ||
+	    bi->bi_hw_segments > q->max_hw_segments)
+		return 0;
+
+	if (q->merge_bvec_fn)
+		/* it's too hard to apply the merge_bvec_fn at this stage,
+		 * just just give up
+		 */
+		return 0;
+
+	return 1;
+}
+
+
 static int chunk_aligned_read(request_queue_t *q, struct bio * raid_bio)
 {
 	mddev_t *mddev = q->queuedata;
@@ -2665,6 +2686,13 @@ static int chunk_aligned_read(request_qu
 		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
 		align_bi->bi_sector += rdev->data_offset;
 
+		if (!bio_fits_rdev(align_bi)) {
+			/* too big in some way */
+			bio_put(align_bi);
+			rdev_dec_pending(rdev, mddev);
+			return 0;
+		}
+
 		spin_lock_irq(&conf->device_lock);
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    conf->quiesce == 0,
@@ -3055,7 +3083,9 @@ static int  retry_aligned_read(raid5_con
 	last_sector = raid_bio->bi_sector + (raid_bio->bi_size>>9);
 
 	for (; logical_sector < last_sector;
-	     logical_sector += STRIPE_SECTORS, scnt++) {
+	     logical_sector += STRIPE_SECTORS,
+		     sector += STRIPE_SECTORS,
+		     scnt++) {
 
 		if (scnt < raid_bio->bi_hw_segments)
 			/* already done this stripe */
@@ -3071,7 +3101,13 @@ static int  retry_aligned_read(raid5_con
 		}
 
 		set_bit(R5_ReadError, &sh->dev[dd_idx].flags);
-		add_stripe_bio(sh, raid_bio, dd_idx, 0);
+		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
+			release_stripe(sh);
+			raid_bio->bi_hw_segments = scnt;
+			conf->retry_read_aligned = raid_bio;
+			return handled;
+		}
+
 		handle_stripe(sh, NULL);
 		release_stripe(sh);
 		handled++;
