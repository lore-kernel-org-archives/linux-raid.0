From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 4 - Honour the read-ahead for for reads in raid5.
Date: Tue, 26 Aug 2003 09:26:06 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19rQis-0002Br-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

If we get a failure trying to allocate a stripe_head for a read-ahead
request (the only time we can get a failure), we skip the rest of the
request and fail the whole bio.

 ----------- Diffstat output ------------
 ./drivers/md/raid5.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-08-24 07:03:43.000000000 +1000
+++ ./drivers/md/raid5.c	2003-08-24 08:07:16.000000000 +1000
@@ -1326,7 +1326,7 @@ static int make_request (request_queue_t
 			(unsigned long long)new_sector, 
 			(unsigned long long)logical_sector);
 
-		sh = get_active_stripe(conf, new_sector, pd_idx, 0/*(bi->bi_rw&RWA_MASK)*/);
+		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
 		if (sh) {
 
 			add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK));
@@ -1334,7 +1334,12 @@ static int make_request (request_queue_t
 			raid5_plug_device(conf);
 			handle_stripe(sh);
 			release_stripe(sh);
+		} else {
+			/* cannot get stripe for read-ahead, just give-up */
+			clear_bit(BIO_UPTODATE, &bi->bi_flags);
+			break;
 		}
+			
 	}
 	spin_lock_irq(&conf->device_lock);
 	if (--bi->bi_phys_segments == 0) {
