From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 1 of 22 - Fix three little compile problem when md or raid5 compiled with debugging
Date: Wed, 19 Jun 2002 10:42:30 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54134.847144.148088@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


It's patch-bomb time....

Here begins a series of 22 patches that achieve a substantial cleanup
of md.c and related code.

###Comments for ChangeSet

md: "dev" isn't defined any more.
raid5: must report on "bi" before reusing the variable
raid5: buffer_head should be bio (not a debugging thing)

 ----------- Diffstat output ------------
 ./drivers/block/umem.c |    5 +++--
 ./drivers/md/md.c      |    2 +-
 ./drivers/md/raid5.c   |    6 +++---
 3 files changed, 7 insertions(+), 6 deletions(-)

--- ./drivers/block/umem.c	2002/06/17 23:30:14	1.1
+++ ./drivers/block/umem.c	2002/06/17 23:31:00	1.2
@@ -340,8 +340,9 @@
 	offset = ((char*)desc) - ((char*)page->desc);
 	writel(cpu_to_le32((page->page_dma+offset)&0xffffffff),
 	       card->csr_remap + DMA_DESCRIPTOR_ADDR);
-	/* if sizeof(dma_addr_t) == 32, this will generate a warning, sorry */
-	writel(cpu_to_le32((page->page_dma)>>32),
+	/* Force the value to u64 before shifting otherwise >> 32 is undefined C
+	 * and on some ports will do nothing ! */
+	writel(cpu_to_le32(((u64)page->page_dma)>>32),
 	       card->csr_remap + DMA_DESCRIPTOR_ADDR + 4);
 
 	/* Go, go, go */
--- ./drivers/md/md.c	2002/06/17 23:28:08	1.1
+++ ./drivers/md/md.c	2002/06/17 23:28:59	1.2
@@ -3041,7 +3041,7 @@
 	kdev_t rdev = to_kdev_t(bdev->bd_dev);
 
 	dprintk("md_error dev:(%d:%d), rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
-		major(dev),minor(dev),major(rdev),minor(rdev),
+		MD_MAJOR,mdidx(mddev),major(rdev),minor(rdev),
 		__builtin_return_address(0),__builtin_return_address(1),
 		__builtin_return_address(2),__builtin_return_address(3));
 
--- ./drivers/md/raid5.c	2002/06/17 23:28:34	1.1
+++ ./drivers/md/raid5.c	2002/06/17 23:38:44	1.3
@@ -809,6 +809,8 @@
 	spin_unlock_irq(&conf->device_lock);
 	spin_unlock(&sh->lock);
 
+	PRINTK("added bi b#%lu to stripe s#%lu, disk %d.\n", bi->bi_sector, sh->sector, dd_idx);
+
 	if (forwrite) {
 		/* check if page is coverred */
 		sector_t sector = sh->dev[dd_idx].sector;
@@ -822,8 +824,6 @@
 		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
 	}
-
-	PRINTK("added bi b#%lu to stripe s#%lu, disk %d.\n", bi->bi_sector, sh->sector, dd_idx);
 }
 
 
@@ -1586,7 +1586,7 @@
 	}
 
 	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
-		 conf->raid_disks * ((sizeof(struct buffer_head) + PAGE_SIZE))) / 1024;
+		 conf->raid_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
 	if (grow_stripes(conf, conf->max_nr_stripes)) {
 		printk(KERN_ERR "raid5: couldn't allocate %dkB for buffers\n", memory);
 		shrink_stripes(conf);
