From: Neil Brown <neilb@suse.de>
Subject: Re: Incorrect in-kernel bitmap on raid10
Date: Fri, 1 May 2009 12:11:43 +1000
Message-ID: <18938.23135.726382.733302@notabene.brown>
References: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org>
	<18922.50050.860008.242658@notabene.brown>
	<slrnguupf4.911.Mario.Holbe@darkside.dyn.samba-tng.org>
	<slrngve39c.8a2.Mario.Holbe@darkside.dyn.samba-tng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mario 'BitKoenig' Holbe on Tuesday April 28
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 28, Mario.Holbe@TU-Ilmenau.DE wrote:
> Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE> wrote:
> > Neil Brown <neilb@suse.de> wrote:
> >> Could you let me know if that following patch helps?
> > Hmmm, it looks like the patch doesn't fully fix it.
> > root@darkside:~# echo 0-268275 > /sys/block/md7/md/bitmap_set_bits
> > However, in-kernel it should also allocate all pages, but it does not:
> 
> *push*

Thanks for persisting.

> 
> I forgot to clarify the (new) issue:
> While now the amount of pages needed in-kernel is calculated correctly,
> only the half of them seems to be actually used, even if all bits are
> set.
> 

This is not necessarily a bug.  If the attempt to allocate a page
fails, we can persevere but using fewer counters with much larger
granularity.  So we might not alway allocate all the pages that are
required. 
However I don't think that is the case here.  There some other places
where are are overflowing on a shift.  One of those (in
bitmap_dirty_bits) can cause the problem you see.
This patch should fix it.  Please confirm.

NeilBrown

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 1fb91ed..fcbf439 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1016,8 +1016,11 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		kunmap_atomic(paddr, KM_USER0);
 		if (b) {
 			/* if the disk bit is set, set the memory bit */
-			bitmap_set_memory_bits(bitmap, i << CHUNK_BLOCK_SHIFT(bitmap),
-					       ((i+1) << (CHUNK_BLOCK_SHIFT(bitmap)) >= start)
+			int needed = ((sector_t)(i+1) << (CHUNK_BLOCK_SHIFT(bitmap))
+				      >= start);
+			bitmap_set_memory_bits(bitmap,
+					       (sector_t)i << CHUNK_BLOCK_SHIFT(bitmap),
+					       needed);
 				);
 			bit_cnt++;
 			set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
@@ -1154,8 +1157,9 @@ void bitmap_daemon_work(struct bitmap *bitmap)
 			spin_lock_irqsave(&bitmap->lock, flags);
 			clear_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 		}
-		bmc = bitmap_get_counter(bitmap, j << CHUNK_BLOCK_SHIFT(bitmap),
-					&blocks, 0);
+		bmc = bitmap_get_counter(bitmap,
+					 (sector_t)j << CHUNK_BLOCK_SHIFT(bitmap),
+					 &blocks, 0);
 		if (bmc) {
 /*
   if (j < 100) printk("bitmap: j=%lu, *bmc = 0x%x\n", j, *bmc);
@@ -1169,7 +1173,8 @@ void bitmap_daemon_work(struct bitmap *bitmap)
 			} else if (*bmc == 1) {
 				/* we can clear the bit */
 				*bmc = 0;
-				bitmap_count_page(bitmap, j << CHUNK_BLOCK_SHIFT(bitmap),
+				bitmap_count_page(bitmap,
+						  (sector_t)j << CHUNK_BLOCK_SHIFT(bitmap),
 						  -1);
 
 				/* clear the bit */
@@ -1514,7 +1519,7 @@ void bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e)
 	unsigned long chunk;
 
 	for (chunk = s; chunk <= e; chunk++) {
-		sector_t sec = chunk << CHUNK_BLOCK_SHIFT(bitmap);
+		sector_t sec = (sector_t)chunk << CHUNK_BLOCK_SHIFT(bitmap);
 		bitmap_set_memory_bits(bitmap, sec, 1);
 		bitmap_file_set_bit(bitmap, sec);
 	}
