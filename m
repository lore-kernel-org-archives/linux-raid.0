From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 4 - Fix raid5 bug where wrong 'dev' is used.
Date: Thu, 05 Jun 2003 11:51:41 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19Njun-0005Fi-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

4 assorted bug fixes for md...

### Comments for ChangeSet

 ----------- Diffstat output ------------
 ./drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-06-02 14:08:41.000000000 +1000
+++ ./drivers/md/raid5.c	2003-06-02 14:08:41.000000000 +1000
@@ -940,7 +940,7 @@ static void handle_stripe(struct stripe_
 			/* and fail all 'written' */
 			bi = sh->dev[i].written;
 			sh->dev[i].written = NULL;
-			while (bi && bi->bi_sector < dev->sector + STRIPE_SECTORS) {
+			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS) {
 				struct bio *bi2 = bi->bi_next;
 				clear_bit(BIO_UPTODATE, &bi->bi_flags);
 				if (--bi->bi_phys_segments == 0) {
