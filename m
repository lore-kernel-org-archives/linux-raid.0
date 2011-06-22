From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 2/5] md/raid5: factor out dev_need_read()
Date: Wed, 22 Jun 2011 13:50:27 +0900
Message-ID: <1308718230-2536-3-git-send-email-namhyung@gmail.com>
References: <1308718230-2536-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308718230-2536-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Factor out common condition checking code to dev_need_read()
in the hope that it would improve readability somewhat.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid5.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0f71aa9a07c5..892a95fe6e8f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2313,6 +2313,15 @@ handle_failed_stripe(raid5_conf_t *conf, struct stripe_head *sh,
 			md_wakeup_thread(conf->mddev->thread);
 }
 
+static bool dev_need_read(struct r5dev *dev)
+{
+	if (dev->toread ||
+	    (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)))
+		return true;
+
+	return false;
+}
+
 /* fetch_block5 - checks the given member device to see if its data needs
  * to be read or computed to satisfy a request.
  *
@@ -2328,13 +2337,9 @@ static int fetch_block5(struct stripe_head *sh, struct stripe_head_state *s,
 	/* is the data in this block needed, and can we get it? */
 	if (!test_bit(R5_LOCKED, &dev->flags) &&
 	    !test_bit(R5_UPTODATE, &dev->flags) &&
-	    (dev->toread ||
-	     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
+	    (dev_need_read(dev) ||
 	     s->syncing || s->expanding ||
-	     (s->failed &&
-	      (failed_dev->toread ||
-	       (failed_dev->towrite &&
-		!test_bit(R5_OVERWRITE, &failed_dev->flags)))))) {
+	     (s->failed && dev_need_read(failed_dev)))) {
 		/* We would like to get this block, possibly by computing it,
 		 * otherwise read it if the backing disk is insync
 		 */
@@ -2401,8 +2406,7 @@ static int fetch_block6(struct stripe_head *sh, struct stripe_head_state *s,
 
 	if (!test_bit(R5_LOCKED, &dev->flags) &&
 	    !test_bit(R5_UPTODATE, &dev->flags) &&
-	    (dev->toread ||
-	     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
+	    (dev_need_read(dev) ||
 	     s->syncing || s->expanding ||
 	     (s->failed >= 1 &&
 	      (fdev[0]->toread || s->to_write)) ||
-- 
1.7.5.2

