From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 14 - Handle concurrent failure of two drives in raid5
Date: Tue, 27 May 2003 13:01:12 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19KUi8-0003Gi-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

If two drives both fail during a write request, raid5 doesn't
cope properly and will eventually oops.

With this patch, blocks that have already been 'written'
are failed when double drive failure is noticed, as well as
blocks that are about to be written.

 ----------- Diffstat output ------------
 ./drivers/md/raid5.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletion(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-05-27 11:58:20.000000000 +1000
+++ ./drivers/md/raid5.c	2003-05-27 11:58:21.000000000 +1000
@@ -918,7 +918,7 @@ static void handle_stripe(struct stripe_
 	/* check if the array has lost two devices and, if so, some requests might
 	 * need to be failed
 	 */
-	if (failed > 1 && to_read+to_write) {
+	if (failed > 1 && to_read+to_write+written) {
 		spin_lock_irq(&conf->device_lock);
 		for (i=disks; i--; ) {
 			/* fail all writes first */
@@ -936,6 +936,20 @@ static void handle_stripe(struct stripe_
 				}
 				bi = nextbi;
 			}
+			/* and fail all 'written' */
+			bi = sh->dev[i].written;
+			sh->dev[i].written = NULL;
+			while (bi && bi->bi_sector < dev->sector + STRIPE_SECTORS) {
+				struct bio *bi2 = bi->bi_next;
+				clear_bit(BIO_UPTODATE, &bi->bi_flags);
+				if (--bi->bi_phys_segments == 0) {
+					md_write_end(conf->mddev);
+					bi->bi_next = return_bi;
+					return_bi = bi;
+				}
+				bi = bi2;
+			}
+
 			/* fail any reads if this device is non-operational */
 			if (!test_bit(R5_Insync, &sh->dev[i].flags)) {
 				bi = sh->dev[i].toread;
