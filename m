From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 21/36] md/raid5: Clear bad blocks on successful write.
Date: Thu, 21 Jul 2011 12:58:49 +1000
Message-ID: <20110721025849.8422.86592.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On a successful write to a known bad block, flag the sh
so that raid5d can remove the known bad block from the list.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   19 ++++++++++++++++++-
 drivers/md/raid5.h |    1 +
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 33ae4e2..204938c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1675,6 +1675,8 @@ static void raid5_end_write_request(struct bio *bi, int error)
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
+	sector_t first_bad;
+	int bad_sectors;
 
 	for (i=0 ; i<disks; i++)
 		if (bi == &sh->dev[i].req)
@@ -1691,7 +1693,9 @@ static void raid5_end_write_request(struct bio *bi, int error)
 	if (!uptodate) {
 		set_bit(WriteErrorSeen, &conf->disks[i].rdev->flags);
 		set_bit(R5_WriteError, &sh->dev[i].flags);
-	}
+	} else if (is_badblock(conf->disks[i].rdev, sh->sector, STRIPE_SECTORS,
+			       &first_bad, &bad_sectors))
+		set_bit(R5_MadeGood, &sh->dev[i].flags);
 
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
 	
@@ -3071,6 +3075,13 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 			} else
 				clear_bit(R5_WriteError, &dev->flags);
 		}
+		if (test_bit(R5_MadeGood, &dev->flags)) {
+			if (!test_bit(Faulty, &rdev->flags)) {
+				s->handle_bad_blocks = 1;
+				atomic_inc(&rdev->nr_pending);
+			} else
+				clear_bit(R5_MadeGood, &dev->flags);
+		}
 		if (!test_bit(R5_Insync, &dev->flags)) {
 			/* The ReadError flag will just be confusing now */
 			clear_bit(R5_ReadError, &dev->flags);
@@ -3340,6 +3351,12 @@ finish:
 					md_error(conf->mddev, rdev);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
+			if (test_and_clear_bit(R5_MadeGood, &dev->flags)) {
+				rdev = conf->disks[i].rdev;
+				rdev_clear_badblocks(rdev, sh->sector,
+						     STRIPE_SECTORS);
+				rdev_dec_pending(rdev, conf->mddev);
+			}
 		}
 
 	if (s.ops_request)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index d4729f5..9b96157 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -277,6 +277,7 @@ struct stripe_head_state {
 #define	R5_Wantdrain	13	/* dev->towrite needs to be drained */
 #define	R5_WantFUA	14	/* Write should be FUA */
 #define	R5_WriteError	15	/* got a write error - need to record it */
+#define	R5_MadeGood	16	/* A bad block has been fixed by writing to it*/
 /*
  * Write method
  */


