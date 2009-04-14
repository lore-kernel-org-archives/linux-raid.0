From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH 1/6] Handle possible bio_alloc failure in md
Date: Tue, 14 Apr 2009 16:36:32 +0530
Message-ID: <200904141636.32791.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Handle possible bio_alloc failure in md.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---


Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -532,6 +532,9 @@ void md_super_write(mddev_t *mddev, mdk_
 	struct bio *bio = bio_alloc(GFP_NOIO, 1);
 	int rw = (1<<BIO_RW) | (1<<BIO_RW_SYNCIO) | (1<<BIO_RW_UNPLUG);
 
+	if (unlikely(!bio))
+		md_error(rdev->mddev, rdev);
+
 	bio->bi_bdev = rdev->bdev;
 	bio->bi_sector = sector;
 	bio_add_page(bio, page, size, 0);
@@ -587,6 +590,9 @@ int sync_page_io(struct block_device *bd
 	struct completion event;
 	int ret;
 
+	if (unlikely(!bio))
+		return 0;
+
 	rw |= (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
 
 	bio->bi_bdev = bdev;


