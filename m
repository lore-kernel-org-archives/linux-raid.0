From: Neil Brown <neilb@suse.de>
Subject: Re: Incorrect in-kernel bitmap on raid10
Date: Sun, 19 Apr 2009 16:24:02 +1000
Message-ID: <18922.50050.860008.242658@notabene.brown>
References: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mario 'BitKoenig' Holbe on Saturday April 18
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 18, Mario.Holbe@TU-Ilmenau.DE wrote:
> Hello,
> 
> I created a 4.5T RAID10 with internal bitmap out of 3 1.5T disks on a
> Debian 2.6.28-1-686-bigmem kernel:
> # mdadm --create -l raid10 -n 6 -c 512 -b internal -a md /dev/md7 /dev/sdc1 missing /dev/sdd1 missing /dev/sde1 missing
> and I get a strange inconsistency between the on-disk and the in-kernel
> bitmap representation:

oops...

Could you let me know if that following patch helps?
This bug will affect RAID4,5,6 when the device exceeds 2 terabytes,
but it affects RAID10 when the array exceeds 2 terabytes.
(For RAID1, the device size and array size are the same, if it fits in
both categories).

Thanks,
NeilBrown


diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index e4510c9..1fb91ed 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1590,7 +1590,7 @@ void bitmap_destroy(mddev_t *mddev)
 int bitmap_create(mddev_t *mddev)
 {
 	struct bitmap *bitmap;
-	unsigned long blocks = mddev->resync_max_sectors;
+	sector_t blocks = mddev->resync_max_sectors;
 	unsigned long chunks;
 	unsigned long pages;
 	struct file *file = mddev->bitmap_file;
@@ -1632,8 +1632,8 @@ int bitmap_create(mddev_t *mddev)
 	bitmap->chunkshift = ffz(~bitmap->chunksize);
 
 	/* now that chunksize and chunkshift are set, we can use these macros */
- 	chunks = (blocks + CHUNK_BLOCK_RATIO(bitmap) - 1) /
-			CHUNK_BLOCK_RATIO(bitmap);
+ 	chunks = (blocks + CHUNK_BLOCK_RATIO(bitmap) - 1) >>
+			CHUNK_BLOCK_SHIFT(bitmap);
  	pages = (chunks + PAGE_COUNTER_RATIO - 1) / PAGE_COUNTER_RATIO;
 
 	BUG_ON(!pages);
