From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] md: comment add_stripe_bio
Date: Tue, 05 Jun 2007 18:09:14 -0700
Message-ID: <1181092154.11156.10.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

Document the overloading of struct bio fields.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

[ drop this if you think it is too much commenting/unnecessary, but I figured I would leave some
  breadcrumbs for the next guy. ]

 drivers/md/raid5.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 061375e..065b8dc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1231,10 +1231,13 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 
 
 
-/*
- * Each stripe/dev can have one or more bion attached.
- * toread/towrite point to the first in a chain.
- * The bi_next chain must be in order.
+/* add_stripe_bio - attach a bio to the toread/towrite list for an
+ *	rdev in the given stripe.  This routine assumes that the toread/towrite
+ *	lists are in submission order
+ * @sh: stripe targeted by bi->bi_sector
+ * @bi: bio to add (this routines assumes ownership of the bi->bi_next field)
+ * @dd_idx: data disk determined from the logical sector
+ * @forwrite: read/write flag
  */
 static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
 {
@@ -1249,12 +1252,18 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 
 	spin_lock(&sh->lock);
 	spin_lock_irq(&conf->device_lock);
+	
+	/* pick the list to manipulate */
 	if (forwrite) {
 		bip = &sh->dev[dd_idx].towrite;
 		if (*bip == NULL && sh->dev[dd_idx].written == NULL)
 			firstwrite = 1;
 	} else
 		bip = &sh->dev[dd_idx].toread;
+
+	/* scroll through the list to see if this bio overlaps with a
+	 * pending request
+	 */
 	while (*bip && (*bip)->bi_sector < bi->bi_sector) {
 		if ((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector)
 			goto overlap;
@@ -1263,10 +1272,19 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	if (*bip && (*bip)->bi_sector < bi->bi_sector + ((bi->bi_size)>>9))
 		goto overlap;
 
+	/* add this bio into the chain and make sure we are not dropping
+	 * a link that was previously established
+	 */
 	BUG_ON(*bip && bi->bi_next && (*bip) != bi->bi_next);
 	if (*bip)
 		bi->bi_next = *bip;
+
+	/* attach the bio to the end of the list, if this is the first bio
+	 * added then we are directly manipulating toread/towrite
+	 */
 	*bip = bi;
+
+	/* keep count of the number of stripes that this bio touches */
 	bi->bi_phys_segments ++;
 	spin_unlock_irq(&conf->device_lock);
 	spin_unlock(&sh->lock);
