From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 4] md: Fix a couple more bugs in raid5/6 aligned reads
Date: Tue, 14 Nov 2006 11:22:46 +1100
Message-ID: <1061114002246.31198@suse.de>
References: <20061114111600.31061.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


1/ We don't de-reference the rdev when the read completes.
   This means we need to record the rdev to so it is still
   available in the end_io routine.  Fortunately
   bi_next in the original bio is unused at this point so
   we can stuff it in there.

2/ We leak a cloned by if the target rdev is not usasble.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-11-14 11:00:51.000000000 +1100
+++ ./drivers/md/raid5.c	2006-11-14 11:06:44.000000000 +1100
@@ -2699,6 +2699,7 @@ static int raid5_align_endio(struct bio 
 	mddev_t *mddev;
 	raid5_conf_t *conf;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
+	mdk_rdev_t *rdev;
 
 	if (bi->bi_size)
 		return 1;
@@ -2706,6 +2707,10 @@ static int raid5_align_endio(struct bio 
 
 	mddev = raid_bi->bi_bdev->bd_disk->queue->queuedata;
 	conf = mddev_to_conf(mddev);
+	rdev = (void*)raid_bi->bi_next;
+	raid_bi->bi_next = NULL;
+
+	rdev_dec_pending(rdev, conf->mddev);
 
 	if (!error && uptodate) {
 		bio_endio(raid_bi, bytes, 0);
@@ -2762,6 +2767,7 @@ static int chunk_aligned_read(request_qu
 	if (rdev && test_bit(In_sync, &rdev->flags)) {
 		atomic_inc(&rdev->nr_pending);
 		rcu_read_unlock();
+		raid_bio->bi_next = (void*)rdev;
 		align_bi->bi_bdev =  rdev->bdev;
 		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
 		align_bi->bi_sector += rdev->data_offset;
@@ -2777,6 +2783,7 @@ static int chunk_aligned_read(request_qu
 		return 1;
 	} else {
 		rcu_read_unlock();
+		bio_put(align_bi);
 		return 0;
 	}
 }
