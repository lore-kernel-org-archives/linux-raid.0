From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 17/36] md/raid5: avoid reading from known bad blocks.
Date: Thu, 21 Jul 2011 12:58:49 +1000
Message-ID: <20110721025849.8422.92268.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There are two times that we might read in raid5:
1/ when a read request fits within a chunk on a single
   working device.
   In this case, if there is any bad block in the range of
   the read, we simply fail the cache-bypass read and
   perform the read though the stripe cache.

2/ when reading into the stripe cache.  In this case we
   mark as failed any device which has a bad block in that
   strip (1 page wide).
   Note that we will both avoid reading and avoid writing.
   This is correct (as we will never read from the block, there
   is no point writing), but not optimal (as writing could 'fix'
   the error) - that will be addressed later.

If we have not seen any write errors on the device yet, we treat a bad
block like a recent read error.  This will encourage an attempt to fix
the read error which will either generate a write error, or will
ensure good data is stored there.  We don't yet forget the bad block
in that case.  That comes later.

Now that we honour bad blocks when reading we can allow devices with
bad blocks into the array.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   46 ++++++++++++++++++++++++++++++++--------------
 1 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7a3fb72..52bedc6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2916,6 +2916,9 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 	spin_lock_irq(&conf->device_lock);
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
+		sector_t first_bad;
+		int bad_sectors;
+		int is_bad = 0;
 
 		dev = &sh->dev[i];
 
@@ -2952,15 +2955,32 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		if (dev->written)
 			s->written++;
 		rdev = rcu_dereference(conf->disks[i].rdev);
-		if (s->blocked_rdev == NULL &&
-		    rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
-			s->blocked_rdev = rdev;
-			atomic_inc(&rdev->nr_pending);
+		if (rdev) {
+			is_bad = is_badblock(rdev, sh->sector, STRIPE_SECTORS,
+					     &first_bad, &bad_sectors);
+			if (s->blocked_rdev == NULL
+			    && (test_bit(Blocked, &rdev->flags)
+				|| is_bad < 0)) {
+				if (is_bad < 0)
+					set_bit(BlockedBadBlocks,
+						&rdev->flags);
+				s->blocked_rdev = rdev;
+				atomic_inc(&rdev->nr_pending);
+			}
 		}
 		clear_bit(R5_Insync, &dev->flags);
 		if (!rdev)
 			/* Not in-sync */;
-		else if (test_bit(In_sync, &rdev->flags))
+		else if (is_bad) {
+			/* also not in-sync */
+			if (!test_bit(WriteErrorSeen, &rdev->flags)) {
+				/* treat as in-sync, but with a read error
+				 * which we can now try to correct
+				 */
+				set_bit(R5_Insync, &dev->flags);
+				set_bit(R5_ReadError, &dev->flags);
+			}
+		} else if (test_bit(In_sync, &rdev->flags))
 			set_bit(R5_Insync, &dev->flags);
 		else {
 			/* in sync if before recovery_offset */
@@ -3471,6 +3491,9 @@ static int chunk_aligned_read(mddev_t *mddev, struct bio * raid_bio)
 	rcu_read_lock();
 	rdev = rcu_dereference(conf->disks[dd_idx].rdev);
 	if (rdev && test_bit(In_sync, &rdev->flags)) {
+		sector_t first_bad;
+		int bad_sectors;
+
 		atomic_inc(&rdev->nr_pending);
 		rcu_read_unlock();
 		raid_bio->bi_next = (void*)rdev;
@@ -3478,8 +3501,10 @@ static int chunk_aligned_read(mddev_t *mddev, struct bio * raid_bio)
 		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
 		align_bi->bi_sector += rdev->data_offset;
 
-		if (!bio_fits_rdev(align_bi)) {
-			/* too big in some way */
+		if (!bio_fits_rdev(align_bi) ||
+		    is_badblock(rdev, align_bi->bi_sector, align_bi->bi_size>>9,
+				&first_bad, &bad_sectors)) {
+			/* too big in some way, or has a known bad block */
 			bio_put(align_bi);
 			rdev_dec_pending(rdev, mddev);
 			return 0;
@@ -4671,10 +4696,6 @@ static int run(mddev_t *mddev)
 	 * 0 for a fully functional array, 1 or 2 for a degraded array.
 	 */
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
-		if (rdev->badblocks.count) {
-			printk(KERN_ERR "md/raid5: cannot handle bad blocks yet\n");
-			goto abort;
-		}
 		if (rdev->raid_disk < 0)
 			continue;
 		if (test_bit(In_sync, &rdev->flags)) {
@@ -4983,9 +5004,6 @@ static int raid5_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	int first = 0;
 	int last = conf->raid_disks - 1;
 
-	if (rdev->badblocks.count)
-		return -EINVAL;
-
 	if (has_failed(conf))
 		/* no point adding a device */
 		return -EINVAL;


