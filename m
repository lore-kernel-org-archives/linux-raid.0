From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 2 of 2 - get raid5 to work with a large bio
Date: Fri, 14 Jun 2002 21:34:50 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15625.54490.149933.4686@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Make raid5 work for big bios

The code for handling big bios was simply buggy..

This patch also fixes a couple of problems that only
surface when you compile with debugging turned on.



 ----------- Diffstat output ------------
 ./drivers/md/md.c    |    2 +-
 ./drivers/md/raid5.c |   13 ++++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

--- ./drivers/md/raid5.c	2002/06/14 11:25:27	1.2
+++ ./drivers/md/raid5.c	2002/06/14 11:30:59	1.3
@@ -633,7 +633,6 @@
 		else 
 			page_offset = (signed)(sector - bio->bi_sector) * -512;
 		bio_for_each_segment(bvl, bio, i) {
-			char *ba = __bio_kmap(bio, i);
 			int len = bio_iovec_idx(bio,i)->bv_len;
 			int clen;
 			int b_offset = 0;			
@@ -648,13 +647,16 @@
 				clen = STRIPE_SIZE - page_offset;	
 			else clen = len;
 			
-			if (len > 0) {
+			if (clen > 0) {
+				char *ba = __bio_kmap(bio, i);
 				if (frombio)
 					memcpy(pa+page_offset, ba+b_offset, clen);
 				else
 					memcpy(ba+b_offset, pa+page_offset, clen);
-			}
-			__bio_kunmap(bio, i);
+				__bio_kunmap(bio, i);
+			}	
+			if (clen < len) /* hit end of page */
+				break;
 			page_offset +=  len;
 		}
 	}
@@ -809,6 +811,8 @@
 	spin_unlock_irq(&conf->device_lock);
 	spin_unlock(&sh->lock);
 
+	PRINTK("added bi b#%lu to stripe s#%lu, disk %d.\n", bi->bi_sector, sh->sector, dd_idx);
+
 	if (forwrite) {
 		/* check if page is coverred */
 		sector_t sector = sh->dev[dd_idx].sector;
@@ -823,7 +827,6 @@
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
 	}
 
-	PRINTK("added bi b#%lu to stripe s#%lu, disk %d.\n", bi->bi_sector, sh->sector, dd_idx);
 }
 
 
--- ./drivers/md/md.c	2002/06/14 11:25:27	1.2
+++ ./drivers/md/md.c	2002/06/14 11:30:59	1.3
@@ -3050,7 +3050,7 @@
 	kdev_t rdev = to_kdev_t(bdev->bd_dev);
 
 	dprintk("md_error dev:(%d:%d), rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
-		major(dev),minor(dev),major(rdev),minor(rdev),
+		MD_MAJOR,mdidx(mddev),major(rdev),minor(rdev),
 		__builtin_return_address(0),__builtin_return_address(1),
 		__builtin_return_address(2),__builtin_return_address(3));
 
