From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 3/5] md/raid5: factor out dev_need_for_write()
Date: Wed, 22 Jun 2011 13:50:28 +0900
Message-ID: <1308718230-2536-4-git-send-email-namhyung@gmail.com>
References: <1308718230-2536-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308718230-2536-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Factor out common condition checking code to dev_need_for_write()
to improve readability - please suggest a better name :)

Besides, a couple of wierd whitespace fixes are contained also.
Maybe the checkpatch hates some change but it looks more natural
to fix IMHO.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid5.c |   47 ++++++++++++++++++++++++-----------------------
 1 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 892a95fe6e8f..12f3b939e56d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2542,6 +2542,18 @@ static void handle_stripe_clean_event(raid5_conf_t *conf,
 			md_wakeup_thread(conf->mddev->thread);
 }
 
+static bool dev_need_for_write(struct r5dev *dev)
+{
+	if (test_bit(R5_LOCKED, &dev->flags))
+		return false;
+
+	if (!test_bit(R5_UPTODATE, &dev->flags) &&
+	    !test_bit(R5_Wantcompute, &dev->flags))
+		return true;
+
+	return false;
+}
+
 static void handle_stripe_dirtying5(raid5_conf_t *conf,
 		struct stripe_head *sh,	struct stripe_head_state *s, int disks)
 {
@@ -2550,20 +2562,18 @@ static void handle_stripe_dirtying5(raid5_conf_t *conf,
 		/* would I have to read this buffer for read_modify_write */
 		struct r5dev *dev = &sh->dev[i];
 		if ((dev->towrite || i == sh->pd_idx) &&
-		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !(test_bit(R5_UPTODATE, &dev->flags) ||
-		      test_bit(R5_Wantcompute, &dev->flags))) {
+		    dev_need_for_write(dev)) {
 			if (test_bit(R5_Insync, &dev->flags))
 				rmw++;
 			else
 				rmw += 2*disks;  /* cannot read it */
 		}
 		/* Would I have to read this buffer for reconstruct_write */
-		if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
-		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !(test_bit(R5_UPTODATE, &dev->flags) ||
-		    test_bit(R5_Wantcompute, &dev->flags))) {
-			if (test_bit(R5_Insync, &dev->flags)) rcw++;
+		if (!test_bit(R5_OVERWRITE, &dev->flags) &&
+		    i != sh->pd_idx &&
+		    dev_need_for_write(dev)) {
+			if (test_bit(R5_Insync, &dev->flags))
+				rcw++;
 			else
 				rcw += 2*disks;
 		}
@@ -2576,12 +2586,9 @@ static void handle_stripe_dirtying5(raid5_conf_t *conf,
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if ((dev->towrite || i == sh->pd_idx) &&
-			    !test_bit(R5_LOCKED, &dev->flags) &&
-			    !(test_bit(R5_UPTODATE, &dev->flags) ||
-			    test_bit(R5_Wantcompute, &dev->flags)) &&
+			    dev_need_for_write(dev) &&
 			    test_bit(R5_Insync, &dev->flags)) {
-				if (
-				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+				if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 					pr_debug("Read_old block "
 						"%d for r-m-w\n", i);
 					set_bit(R5_LOCKED, &dev->flags);
@@ -2599,12 +2606,9 @@ static void handle_stripe_dirtying5(raid5_conf_t *conf,
 			struct r5dev *dev = &sh->dev[i];
 			if (!test_bit(R5_OVERWRITE, &dev->flags) &&
 			    i != sh->pd_idx &&
-			    !test_bit(R5_LOCKED, &dev->flags) &&
-			    !(test_bit(R5_UPTODATE, &dev->flags) ||
-			    test_bit(R5_Wantcompute, &dev->flags)) &&
+			    dev_need_for_write(dev) &&
 			    test_bit(R5_Insync, &dev->flags)) {
-				if (
-				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+				if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 					pr_debug("Read_old block "
 						"%d for Reconstruct\n", i);
 					set_bit(R5_LOCKED, &dev->flags);
@@ -2645,15 +2649,12 @@ static void handle_stripe_dirtying6(raid5_conf_t *conf,
 		/* check if we haven't enough data */
 		if (!test_bit(R5_OVERWRITE, &dev->flags) &&
 		    i != pd_idx && i != qd_idx &&
-		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !(test_bit(R5_UPTODATE, &dev->flags) ||
-		      test_bit(R5_Wantcompute, &dev->flags))) {
+		    dev_need_for_write(dev)) {
 			rcw++;
 			if (!test_bit(R5_Insync, &dev->flags))
 				continue; /* it's a failed drive */
 
-			if (
-			  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+			if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 				pr_debug("Read_old stripe %llu "
 					"block %d for Reconstruct\n",
 				     (unsigned long long)sh->sector, i);
-- 
1.7.5.2

