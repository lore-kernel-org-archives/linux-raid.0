From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [Evms-devel] 2.6.10-ac10 + 2.6.10udm1 + latest evms => not nice
Date: Fri, 21 Jan 2005 15:47:38 +0100
Message-ID: <20050121144738.GM25714@marowsky-bree.de>
References: <87brbinaey.87acr2naey@878y6mnaey.message.id>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87brbinaey.87acr2naey@878y6mnaey.message.id>
Sender: linux-raid-owner@vger.kernel.org
To: syrius.ml@no-log.org, evms-devel@lists.sourceforge.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On 2005-01-21T15:13:26, syrius.ml@no-log.org wrote:

> Don't know if it's related to evms or to dm.
> kernel is a 2.6.10-ac10 + 2.6.10-udm1 + evms kernel patches.
> (bd_claims + dm bbr + dm multipath)
> 
> Here is the nice welcome message I've just got :)

This looks like md on DM breakage, which Jens has just fixed in our
kernel. I'm not sure whether he has submitted it upstream yet, but you
can give it a try.

Does the attached patch apply & fix the problem for you?


Sincerely,
    Lars Marowsky-Brée <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=md-bio-on-stack

From: Jens Axboe <axboe@suse.de>
Subject: Fix md using bio on stack with bio clones
Patch-mainline: 
References: 49931

If md resides on top of a driver using bio_clone() (such as dm), it will
oops the kernel due to md submitting a botched bio that has a veclist but
doesn't have bio->bi_max_vecs set.

Acked-by: 
Signed-off-by: Jens Axboe <axboe@suse.de>

===== drivers/md/md.c 1.231 vs edited =====
--- 1.231/drivers/md/md.c	2004-12-01 09:13:51 +01:00
+++ edited/drivers/md/md.c	2005-01-19 13:23:30 +01:00
@@ -332,29 +332,26 @@
 static int sync_page_io(struct block_device *bdev, sector_t sector, int size,
 		   struct page *page, int rw)
 {
-	struct bio bio;
-	struct bio_vec vec;
+	struct bio *bio = bio_alloc(GFP_KERNEL, 1);
 	struct completion event;
+	int ret;
+
+	bio_get(bio);
 
 	rw |= (1 << BIO_RW_SYNC);
 
-	bio_init(&bio);
-	bio.bi_io_vec = &vec;
-	vec.bv_page = page;
-	vec.bv_len = size;
-	vec.bv_offset = 0;
-	bio.bi_vcnt = 1;
-	bio.bi_idx = 0;
-	bio.bi_size = size;
-	bio.bi_bdev = bdev;
-	bio.bi_sector = sector;
+	bio->bi_bdev = bdev;
+	bio->bi_sector = sector;
+	bio_add_page(bio, page, size, 0);
 	init_completion(&event);
-	bio.bi_private = &event;
-	bio.bi_end_io = bi_complete;
-	submit_bio(rw, &bio);
+	bio->bi_private = &event;
+	bio->bi_end_io = bi_complete;
+	submit_bio(rw, bio);
 	wait_for_completion(&event);
 
-	return test_bit(BIO_UPTODATE, &bio.bi_flags);
+	ret = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	bio_put(bio);
+	return ret;
 }
 
 static int read_disk_sb(mdk_rdev_t * rdev)

--82I3+IH0IqGh5yIs--
