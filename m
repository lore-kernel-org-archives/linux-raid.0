From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 07/34] md/raid5: Protect some more code with ->device_lock.
Date: Thu, 21 Jul 2011 12:32:25 +1000
Message-ID: <20110721023225.6728.43609.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Other places that change or follow dev->towrite and dev->written take
the device_lock as well as the sh->lock.
So it should really be held in these places too.
Also, doing so will allow sh->lock to be discarded.

with merged fixes by: Namhyung Kim <namhyung@gmail.com>


Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f2f2ab3..9985138 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1021,10 +1021,12 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 			struct bio *wbi;
 
 			spin_lock(&sh->lock);
+			spin_lock_irq(&sh->raid_conf->device_lock);
 			chosen = dev->towrite;
 			dev->towrite = NULL;
 			BUG_ON(dev->written);
 			wbi = dev->written = chosen;
+			spin_unlock_irq(&sh->raid_conf->device_lock);
 			spin_unlock(&sh->lock);
 
 			while (wbi && wbi->bi_sector <
@@ -2141,7 +2143,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	raid5_conf_t *conf = sh->raid_conf;
 	int firstwrite=0;
 
-	pr_debug("adding bh b#%llu to stripe s#%llu\n",
+	pr_debug("adding bi b#%llu to stripe s#%llu\n",
 		(unsigned long long)bi->bi_sector,
 		(unsigned long long)sh->sector);
 
@@ -2167,19 +2169,6 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 		bi->bi_next = *bip;
 	*bip = bi;
 	bi->bi_phys_segments++;
-	spin_unlock_irq(&conf->device_lock);
-	spin_unlock(&sh->lock);
-
-	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
-		(unsigned long long)bi->bi_sector,
-		(unsigned long long)sh->sector, dd_idx);
-
-	if (conf->mddev->bitmap && firstwrite) {
-		bitmap_startwrite(conf->mddev->bitmap, sh->sector,
-				  STRIPE_SECTORS, 0);
-		sh->bm_seq = conf->seq_flush+1;
-		set_bit(STRIPE_BIT_DELAY, &sh->state);
-	}
 
 	if (forwrite) {
 		/* check if page is covered */
@@ -2194,6 +2183,19 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
 	}
+	spin_unlock_irq(&conf->device_lock);
+	spin_unlock(&sh->lock);
+
+	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
+		(unsigned long long)(*bip)->bi_sector,
+		(unsigned long long)sh->sector, dd_idx);
+
+	if (conf->mddev->bitmap && firstwrite) {
+		bitmap_startwrite(conf->mddev->bitmap, sh->sector,
+				  STRIPE_SECTORS, 0);
+		sh->bm_seq = conf->seq_flush+1;
+		set_bit(STRIPE_BIT_DELAY, &sh->state);
+	}
 	return 1;
 
  overlap:


