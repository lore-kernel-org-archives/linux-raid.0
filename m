From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/4] md/r5cache: read data into orig_page for prexor of cached data
Date: Thu, 12 Jan 2017 17:22:41 -0800
Message-ID: <20170113012243.3246467-2-songliubraving@fb.com>
References: <20170113012243.3246467-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170113012243.3246467-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

With write back cache, we use orig_page to do prexor. This patch
makes sure we read data into orig_page for it.

Flag R5_OrigPageUPTDODATE is added to show whether orig_page
has the latest data from raid disk.

We introduce a helper function uptodate_for_rmw() to simplify
the a couple conditions in handle_stripe_dirtying().

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c |  2 ++
 drivers/md/raid5.c       | 44 +++++++++++++++++++++++++++++++++++---------
 drivers/md/raid5.h       |  5 +++++
 3 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 2bbc38b..248fede 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2459,6 +2459,8 @@ void r5c_release_extra_page(struct stripe_head *sh)
 			struct page *p = sh->dev[i].orig_page;
 
 			sh->dev[i].orig_page = sh->dev[i].page;
+			clear_bit(R5_OrigPageUPTDODATE, &sh->dev[i].flags);
+
 			if (!using_disk_info_extra_page)
 				put_page(p);
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0d2082d..3e75289 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1056,7 +1056,17 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
 				WARN_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
-			sh->dev[i].vec.bv_page = sh->dev[i].page;
+
+			if (!op_is_write(op) &&
+			    test_bit(R5_InJournal, &sh->dev[i].flags))
+				/*
+				 * issuing read for a page in journal, this
+				 * must be preparing for prexor in rmw; read
+				 * the data into orig_page
+				 */
+				sh->dev[i].vec.bv_page = sh->dev[i].orig_page;
+			else
+				sh->dev[i].vec.bv_page = sh->dev[i].page;
 			bi->bi_vcnt = 1;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;
@@ -2421,6 +2431,13 @@ static void raid5_end_read_request(struct bio * bi)
 		} else if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
 			clear_bit(R5_ReadNoMerge, &sh->dev[i].flags);
 
+		if (test_bit(R5_InJournal, &sh->dev[i].flags))
+			/*
+			 * end read for a page in journal, this
+			 * must be preparing for prexor in rmw
+			 */
+			set_bit(R5_OrigPageUPTDODATE, &sh->dev[i].flags);
+
 		if (atomic_read(&rdev->read_errors))
 			atomic_set(&rdev->read_errors, 0);
 	} else {
@@ -3635,6 +3652,21 @@ static void handle_stripe_clean_event(struct r5conf *conf,
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
@@ -3666,9 +3698,7 @@ static int handle_stripe_dirtying(struct r5conf *conf,
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
@@ -3680,7 +3710,6 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 		    i != sh->pd_idx && i != sh->qd_idx &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||
-		      test_bit(R5_InJournal, &dev->flags) ||
 		      test_bit(R5_Wantcompute, &dev->flags))) {
 			if (test_bit(R5_Insync, &dev->flags))
 				rcw++;
@@ -3734,9 +3763,7 @@ static int handle_stripe_dirtying(struct r5conf *conf,
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
@@ -3763,7 +3790,6 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 			    i != sh->pd_idx && i != sh->qd_idx &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
-			      test_bit(R5_InJournal, &dev->flags) ||
 			      test_bit(R5_Wantcompute, &dev->flags))) {
 				rcw++;
 				if (test_bit(R5_Insync, &dev->flags) &&
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index c582086..50855ad 100644
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

