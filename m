From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 4/4] md/r5cache: shift complex rmw from read path to write path
Date: Thu, 12 Jan 2017 17:22:43 -0800
Message-ID: <20170113012243.3246467-4-songliubraving@fb.com>
References: <20170113012243.3246467-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170113012243.3246467-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

Write back cache requires a complex RMW mechanism, where old data is
read into dev->orig_page for prexor, and then xor is done with
dev->page. This logic is already implemented in the write path.

However, current read path is not awared of this requirement. When
the array is optimal, the RMW is not required, as the data are
read from raid disks. However, when the target stripe is degraded,
complex RMW is required to generate right data.

To keep read path as clean as possible, we handle read path by
flushing degraded, in-journal stripes before processing reads to
missing dev.

Specifically, when there is read requests to a degraded stripe
with data in journal, handle_stripe_fill() calls
r5c_make_stripe_write_out() and exits. Then handle_stripe_dirtying()
will do the complex RMW and flush the stripe to RAID disks. After
that, read requests are handled.

There is one more corner case when there is non-overwrite bio for
the missing (or out of sync) dev. handle_stripe_dirtying() will not
be able to process the non-overwrite bios without constructing the
data in handle_stripe_fill(). This is fixed by delaying non-overwrite
bios in handle_stripe_dirtying(). So handle_stripe_fill() works on
these bios after the stripe is flushed to raid disks.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5.c | 48 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d07a319..193acd3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2938,6 +2938,30 @@ sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous)
 	return r_sector;
 }
 
+/*
+ * There are cases where we want handle_stripe_dirtying() and
+ * schedule_reconstruction() to delay towrite to some dev of a stripe.
+ *
+ * This function checks whether we want to delay the towrite. Specifically,
+ * we delay the towrite when:
+ *   1. degraded stripe has a non-overwrite to the missing dev, AND this
+ *      stripe has data in journal (for other devices).
+ *
+ *      In this case, when reading data for the non-overwrite dev, it is
+ *      necessary to handle complex rmw of write back cache (prexor with
+ *      orig_page, and xor with page). To keep read path simple, we would
+ *      like to flush data in journal to RAID disks first, so complex rmw
+ *      is handled in the write patch (handle_stripe_dirtying).
+ *
+ *   2. to be added
+ */
+static inline bool delay_towrite(struct r5dev *dev,
+				   struct stripe_head_state *s)
+{
+	return dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags) &&
+		!test_bit(R5_Insync, &dev->flags) && s->injournal;
+}
+
 static void
 schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 			 int rcw, int expand)
@@ -2958,7 +2982,7 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 
-			if (dev->towrite) {
+			if (dev->towrite && !delay_towrite(dev, s)) {
 				set_bit(R5_LOCKED, &dev->flags);
 				set_bit(R5_Wantdrain, &dev->flags);
 				if (!expand)
@@ -3535,10 +3559,25 @@ static void handle_stripe_fill(struct stripe_head *sh,
 	 * midst of changing due to a write
 	 */
 	if (!test_bit(STRIPE_COMPUTE_RUN, &sh->state) && !sh->check_state &&
-	    !sh->reconstruct_state)
+	    !sh->reconstruct_state) {
+
+		/* for degraded stripe with data in journal, do not handle
+		 * read requests yet, instead, flush the stripe to raid
+		 * disks first, this avoids handling complex rmw of write
+		 * back cache (prexor with orig_page, and then xor with
+		 * page) in the read path
+		 */
+		if (s->injournal && s->failed) {
+			if (test_bit(STRIPE_R5C_CACHING, &sh->state))
+				r5c_make_stripe_write_out(sh);
+			goto out;
+		}
+
 		for (i = disks; i--; )
 			if (fetch_block(sh, s, i, disks))
 				break;
+	}
+out:
 	set_bit(STRIPE_HANDLE, &sh->state);
 }
 
@@ -3694,7 +3733,8 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 	} else for (i = disks; i--; ) {
 		/* would I have to read this buffer for read_modify_write */
 		struct r5dev *dev = &sh->dev[i];
-		if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx ||
+		if (((dev->towrite && !delay_towrite(dev, s)) ||
+		     i == sh->pd_idx || i == sh->qd_idx ||
 		     test_bit(R5_InJournal, &dev->flags)) &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(uptodate_for_rmw(dev) ||
@@ -3758,7 +3798,7 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if ((dev->towrite ||
+			if (((dev->towrite && !delay_towrite(dev, s)) ||
 			     i == sh->pd_idx || i == sh->qd_idx ||
 			     test_bit(R5_InJournal, &dev->flags)) &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
-- 
2.9.3

