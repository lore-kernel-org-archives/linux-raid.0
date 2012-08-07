From: Shaohua Li <shli@kernel.org>
Subject: [patch]raid5: fix directio regression
Date: Tue, 7 Aug 2012 11:22:40 +0800
Message-ID: <20120807032240.GA22495@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, majianpeng@gmail.com
List-Id: linux-raid.ids

My directIO randomwrite 4k workload shows a 10~20% regression caused by commit
895e3c5c58a80bb. directIO usually is random IO and if request size isn't big
(which is the common case), delay handling of the stripe hasn't any advantages.
For big size request, delay can still reduce IO.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-08-07 11:04:48.442834682 +0800
+++ linux/drivers/md/raid5.c	2012-08-07 11:09:08.743562203 +0800
@@ -4076,6 +4076,7 @@ static void make_request(struct mddev *m
 	struct stripe_head *sh;
 	const int rw = bio_data_dir(bi);
 	int remaining;
+	bool large_request;
 
 	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bi);
@@ -4089,6 +4090,11 @@ static void make_request(struct mddev *m
 	     chunk_aligned_read(mddev,bi))
 		return;
 
+	if (mddev->new_chunk_sectors < mddev->chunk_sectors)
+		large_request = (bi->bi_size >> 9) > mddev->new_chunk_sectors;
+	else
+		large_request = (bi->bi_size >> 9) > mddev->chunk_sectors;
+
 	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector = bi->bi_sector + (bi->bi_size>>9);
 	bi->bi_next = NULL;
@@ -4192,7 +4198,8 @@ static void make_request(struct mddev *m
 			finish_wait(&conf->wait_for_overlap, &w);
 			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
-			if ((bi->bi_rw & REQ_NOIDLE) &&
+			if ((bi->bi_rw & REQ_SYNC) &&
+			    ((bi->bi_rw & REQ_NOIDLE) || !large_request) &&
 			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
 			release_stripe_plug(mddev, sh);
