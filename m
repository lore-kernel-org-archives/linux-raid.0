From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 32/34] md/raid5: Avoid BUG caused by multiple failures.
Date: Thu, 21 Jul 2011 12:32:28 +1000
Message-ID: <20110721023228.6728.66319.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

While preparing to write a stripe we keep the parity block or blocks
locked (R5_LOCKED) - towards the end of schedule_reconstruction.

If the array is discovered to have failed before this write completes
we can leave those blocks LOCKED, and init_stripe will notice that a
free stripe still has a locked block and will complain.

So clear the R5_LOCKED flag in handle_failed_stripe, and demote the
'BUG' to a 'WARN_ON'.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ee26f50..6337768 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -340,7 +340,7 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 			       (unsigned long long)sh->sector, i, dev->toread,
 			       dev->read, dev->towrite, dev->written,
 			       test_bit(R5_LOCKED, &dev->flags));
-			BUG();
+			WARN_ON(1);
 		}
 		dev->flags = 0;
 		raid5_build_block(sh, i, previous);
@@ -2301,6 +2301,10 @@ handle_failed_stripe(raid5_conf_t *conf, struct stripe_head *sh,
 		if (bitmap_end)
 			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
 					STRIPE_SECTORS, 0, 0);
+		/* If we were in the middle of a write the parity block might
+		 * still be locked - so just clear all R5_LOCKED flags
+		 */
+		clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	}
 
 	if (test_and_clear_bit(STRIPE_FULL_WRITE, &sh->state))


