From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 10 - Don't allow raid5 rebuild to swamp raid5 stripe cache
Date: Fri, 16 Jan 2004 12:19:37 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AhIe9-0002U2-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


raid5 rebuild takes stripes so agressively that other
access cannot get a look-in.
With this patch, the rebuild pauses slightly if there is a 
shortage of stripes to let other processes have a chance.

 ----------- Diffstat output ------------
 ./drivers/md/raid5.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletion(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-01-16 11:58:51.000000000 +1100
+++ ./drivers/md/raid5.c	2004-01-16 11:59:17.000000000 +1100
@@ -1395,7 +1395,14 @@ static int sync_request (mddev_t *mddev,
 
 	first_sector = raid5_compute_sector(stripe*data_disks*sectors_per_chunk
 		+ chunk_offset, raid_disks, data_disks, &dd_idx, &pd_idx, conf);
-	sh = get_active_stripe(conf, sector_nr, pd_idx, 0);
+	sh = get_active_stripe(conf, sector_nr, pd_idx, 1);
+	if (sh == NULL) {
+		sh = get_active_stripe(conf, sector_nr, pd_idx, 0);
+		/* make sure we don't swamp the stripe cache if someone else
+		 * is trying to get access 
+		 */
+		yield();
+	}
 	spin_lock(&sh->lock);	
 	set_bit(STRIPE_SYNCING, &sh->state);
 	clear_bit(STRIPE_INSYNC, &sh->state);
