From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/2] md/r5cache: read data into orig_page for prexor of cached data
Date: Wed, 7 Dec 2016 11:36:37 -0800
Message-ID: <20161207193637.3905500-2-songliubraving@fb.com>
References: <20161207193637.3905500-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161207193637.3905500-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

With write back cache, we use orig_page to do prexor. This patch
makes sure we read data into orig_page for it.

Flag R5_OrigPageUPTDODATE is added to make show when orig_page
has the latest data from raid disk.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c |  2 ++
 drivers/md/raid5.c       | 37 ++++++++++++++++++++++++++++---------
 drivers/md/raid5.h       |  5 +++++
 3 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 830bb7f..03cef8b 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2373,6 +2373,8 @@ void r5c_release_extra_page(struct stripe_head *sh)
 			struct page *p = sh->dev[i].orig_page;
 
 			sh->dev[i].orig_page = sh->dev[i].page;
+			clear_bit(R5_OrigPageUPTDODATE, &sh->dev[i].flags);
+
 			if (!using_disk_info_extra_page)
 				put_page(p);
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 524b041..eb7425a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1019,7 +1019,13 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
 				WARN_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
-			sh->dev[i].vec.bv_page = sh->dev[i].page;
+
+			if (!op_is_write(op) &&
+			    test_bit(R5_InJournal, &sh->dev[i].flags) &&
+			    sh->dev[i].page != sh->dev[i].orig_page)
+				sh->dev[i].vec.bv_page = sh->dev[i].orig_page;
+			else
+				sh->dev[i].vec.bv_page = sh->dev[i].page;
 			bi->bi_vcnt = 1;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;
@@ -2389,6 +2395,10 @@ static void raid5_end_read_request(struct bio * bi)
 		} else if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
 			clear_bit(R5_ReadNoMerge, &sh->dev[i].flags);
 
+		if (test_bit(R5_InJournal, &sh->dev[i].flags) &&
+		    sh->dev[i].page != sh->dev[i].orig_page)
+			set_bit(R5_OrigPageUPTDODATE, &sh->dev[i].flags);
+
 		if (atomic_read(&rdev->read_errors))
 			atomic_set(&rdev->read_errors, 0);
 	} else {
@@ -3603,6 +3613,21 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 		break_stripe_batch_list(head_sh, STRIPE_EXPAND_SYNC_FLAGS);
 }
 
+/*
+ * For RMW in write back cache, we need extra page in prexor to store the
+ * old data. This page is stored in dev->orig_page.
+ *
+ * This function checks whether we have data for prexor. The exact logic
+ * is:
+ *       R5_UPTODATE && (!R5_InJournal || R5_OrigPageUPTDODATE)
+ */
+static inline bool uptodate_for_rmw(struct r5dev *dev)
+{
+	return (test_bit(R5_UPTODATE, &dev->flags)) &&
+		(!test_bit(R5_InJournal, &dev->flags) ||
+		 test_bit(R5_OrigPageUPTDODATE, &dev->flags));
+}
+
 static int handle_stripe_dirtying(struct r5conf *conf,
 				  struct stripe_head *sh,
 				  struct stripe_head_state *s,
@@ -3634,9 +3659,7 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 		if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx ||
 		     test_bit(R5_InJournal, &dev->flags)) &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !((test_bit(R5_UPTODATE, &dev->flags) &&
-		       (!test_bit(R5_InJournal, &dev->flags) ||
-			dev->page != dev->orig_page)) ||
+		    !(uptodate_for_rmw(dev) ||
 		      test_bit(R5_Wantcompute, &dev->flags))) {
 			if (test_bit(R5_Insync, &dev->flags))
 				rmw++;
@@ -3648,7 +3671,6 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 		    i != sh->pd_idx && i != sh->qd_idx &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||
-		      test_bit(R5_InJournal, &dev->flags) ||
 		      test_bit(R5_Wantcompute, &dev->flags))) {
 			if (test_bit(R5_Insync, &dev->flags))
 				rcw++;
@@ -3702,9 +3724,7 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 			     i == sh->pd_idx || i == sh->qd_idx ||
 			     test_bit(R5_InJournal, &dev->flags)) &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
-			    !((test_bit(R5_UPTODATE, &dev->flags) &&
-			       (!test_bit(R5_InJournal, &dev->flags) ||
-				dev->page != dev->orig_page)) ||
+			    !(uptodate_for_rmw(dev) ||
 			      test_bit(R5_Wantcompute, &dev->flags)) &&
 			    test_bit(R5_Insync, &dev->flags)) {
 				if (test_bit(STRIPE_PREREAD_ACTIVE,
@@ -3731,7 +3751,6 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 			    i != sh->pd_idx && i != sh->qd_idx &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
-			      test_bit(R5_InJournal, &dev->flags) ||
 			      test_bit(R5_Wantcompute, &dev->flags))) {
 				rcw++;
 				if (test_bit(R5_Insync, &dev->flags) &&
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index b39fe46..6cc8d4c 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -322,6 +322,11 @@ enum r5dev_flags {
 			 * data and parity being written are in the journal
 			 * device
 			 */
+	R5_OrigPageUPTDODATE,	/* with write back cache, we read old data into
+				 * dev->orig_page for prexor. When this flag is
+				 * set, orig_page contains latest data in the
+				 * raid disk.
+				 */
 };
 
 /*
-- 
2.9.3

