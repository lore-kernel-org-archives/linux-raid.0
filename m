From: Yuri Tikhonov <yur@emcraft.com>
Subject: [PATCH] Skip bio copy in full-stripe write ops
Date: Fri, 23 Nov 2007 15:14:28 +0300
Message-ID: <200711231514.28584.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Hello all,

 Here is a patch which allows to skip intermediate data copying between the bio
requested to write and the disk cache in <sh> if the full-stripe write operation is
on the way.

 This improves the performance of write operations for some dedicated cases
when big chunks of data are being sequentially written to RAID array, but in
general eliminating disk cache slows the performance down.

 The performance results obtained on the ppc440spe-based board using the
PPC440SPE ADMA driver, Xdd benchmark, and the RAID-5 of 4 disks are as
follows:

 SKIP_BIO_SET = 'N': 40 MBps;
 SKIP_BIO_SET = 'Y': 70 MBps.

 The actual test commands used:

# mdadm -C /dev/md0 -c 16 -l 5 -n 4 /dev/sd[a-d]
# xdd -op write -kbytes 48000 -reqsize 48 -dio -syncwrite -passes 3 -verbose -target /dev/md0

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Mikhail Cherkashin <mike@emcraft.com>
--
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 9b6fbf0..7a709aa 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -137,6 +137,18 @@ config MD_RAID456
 
 	  If unsure, say Y.
 
+config MD_RAID_SKIP_BIO_COPY
+	bool "Skip intermediate bio->cache copy"
+	depends on MD_RAID456
+	default n
+	---help---
+	  Skip intermediate data copying between the bio requested to write and
+	  the disk cache in <sh> if the full-stripe write operation is on the way.
+	  This might improve the performance of write operations in some dedicated
+	  cases but generally eliminating disk cache slows the performance down.
+
+	  If unsure, say N.
+
 config MD_RAID5_RESHAPE
 	bool "Support adding drives to a raid-5 array"
 	depends on MD_RAID456
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9a4959a..904b27e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -996,6 +996,9 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
 	struct stripe_queue *sq = sh->sq;
 	int disks = sq->disks;
 	int pd_idx = sq->pd_idx;
+#ifdef CONFIG_MD_RAID_SKIP_BIO_COPY
+	int fswrite = 1;
+#endif
 	int i;
 
 	/* check if prexor is active which means only process blocks
@@ -1006,6 +1009,70 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
 
+#ifdef CONFIG_MD_RAID_SKIP_BIO_COPY
+	/* initially assume that the operation is a full-stripe write*/
+	for (i = disks; i-- ;) {
+		struct r5dev *dev;
+
+		if (unlikely(i == pd_idx))
+			continue;
+		if (unlikely(!sq->dev[i].towrite || prexor))
+			goto do_copy;
+		dev = &sh->dev[i];
+		if ((test_bit(R5_OVERWRITE, &dev->flags)) &&
+		    !r5_next_bio(sq->dev[i].towrite, sq->dev[i].sector)) {
+			/* now check if there is only one bio_vec within
+			 * the bio covers the sh->dev[i]
+			 */
+			struct bio *pbio = sq->dev[i].towrite;
+			struct bio_vec *bvl;
+			int found = 0;
+			int bvec_page = pbio->bi_sector << 9, k;
+			int dev_page = sq->dev[i].sector << 9;
+
+			/* search for the bio_vec that covers dev[i].page */
+			bio_for_each_segment(bvl, pbio, k) {
+				if (bvec_page == dev_page &&
+				    bio_iovec_idx(pbio,k)->bv_len ==
+				      STRIPE_SIZE) {
+					/* found the vector which covers the
+					 * strip fully
+					 */
+					found = 1;
+					break;
+				}
+				bvec_page += bio_iovec_idx(pbio,k)->bv_len;
+			}
+
+			if (found) {
+				/* save the direct pointer to buffer */
+				BUG_ON(dev->dpage);
+				dev->dpage = bio_iovec_idx(pbio,k)->bv_page;
+				continue;
+			}
+		}
+
+do_copy:
+		/* come here in two cases:
+		 * - the dev[i] is not covered fully with the bio;
+		 * - there are more than one bios cover the dev[i].
+		 * in both cases do copy from bio to dev[i].page
+		 */
+		pr_debug("%s: do copy because of disk %d\n", __FUNCTION__, i);
+		do {
+			/* restore dpages set */
+			sh->dev[i].dpage = NULL;
+		} while (i++ != disks);
+		fswrite = 0;
+		break;
+	}
+
+	if (fswrite) {
+		/* won't add new txs right now, so run ops currently pending */
+		async_tx_issue_pending_all();
+	}
+#endif
+
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		struct r5_queue_dev *dev_q = &sq->dev[i];
@@ -1034,6 +1101,14 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
 			wbi = dev_q->written = chosen;
 			spin_unlock(&sq->lock);
 
+#ifdef CONFIG_MD_RAID_SKIP_BIO_COPY
+			if (fswrite) {
+				/* just update dev bio vec pointer */
+				dev->vec.bv_page = dev->dpage;
+				continue;
+			}
+#endif
+			/* schedule the copy op(s) */
 			while (wbi && wbi->bi_sector <
 				dev_q->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(1, wbi, dev->page,
@@ -1072,6 +1147,11 @@ static void ops_complete_write(void *stripe_head_ref)
 		struct r5_queue_dev *dev_q = &sq->dev[i];
 
 		if (dev_q->written || i == pd_idx)
+			/*  actually, in case of full-stripe write operation the
+			 * dev->page remains not UPTODATE. We need this flag
+			 * to determine the completeness of disk operations in
+			 * handle_stripe5(), so set it here, but clear then.
+			 */
 			set_bit(R5_UPTODATE, &dev->flags);
 	}
 
@@ -1112,14 +1192,16 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
 			struct r5_queue_dev *dev_q = &sq->dev[i];
 
 			if (dev_q->written)
-				xor_srcs[count++] = dev->page;
+				xor_srcs[count++] = dev->dpage ?
+					dev->dpage : dev->page;
 		}
 	} else {
 		xor_dest = sh->dev[pd_idx].page;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if (i != pd_idx)
-				xor_srcs[count++] = dev->page;
+				xor_srcs[count++] = dev->dpage ?
+					dev->dpage : dev->page;
 		}
 	}
 
@@ -2647,6 +2729,16 @@ static void handle_completed_write_requests(raid5_conf_t *conf,
 				spin_lock_irq(&conf->device_lock);
 				wbi = dev_q->written;
 				dev_q->written = NULL;
+
+				if (dev->dpage) {
+					/* with full-stripe write disk-cache
+					 * actually is not UPTODATE
+					 */
+					clear_bit(R5_UPTODATE, &dev->flags);
+					dev->vec.bv_page = dev->page;
+					dev->dpage = NULL;
+				}
+
 				while (wbi && wbi->bi_sector <
 					dev_q->sector + STRIPE_SECTORS) {
 					wbi2 = r5_next_bio(wbi, dev_q->sector);
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index effd34f..6e7dfd0 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -186,6 +186,7 @@ struct stripe_head {
 		struct bio	req;
 		struct bio_vec	vec;
 		struct page	*page;
+		struct page	*dpage; /* direct ptr to a bio buffer */
 		unsigned long flags;
 	} dev[1]; /* allocated with extra space depending of RAID geometry */
 };

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
