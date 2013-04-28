From: Shaohua Li <shli@kernel.org>
Subject: [patch]MD: ignore discard request for hard disks of hybid
 raid1/raid10 array
Date: Sun, 28 Apr 2013 18:26:38 +0800
Message-ID: <20130428102638.GB1753@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, M4rkusXXL@web.de
List-Id: linux-raid.ids

In SSD/hard disk hybid storage, discard request should be ignored for hard
disk. We used to be doing this way, but the unplug path forgets it.

This is suitable for stable tree since v3.6.

Reported-and-tested-by: Markus <M4rkusXXL@web.de>
Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid1.c  |    7 ++++++-
 drivers/md/raid10.c |    7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2013-03-07 14:14:05.950824173 +0800
+++ linux/drivers/md/raid1.c	2013-04-28 08:57:17.874058434 +0800
@@ -981,7 +981,12 @@ static void raid1_unplug(struct blk_plug
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
 		bio->bi_next = NULL;
-		generic_make_request(bio);
+		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
+			/* Just ignore it */
+			bio_endio(bio, 0);
+		else
+			generic_make_request(bio);
 		bio = next;
 	}
 	kfree(plug);
Index: linux/drivers/md/raid10.c
===================================================================
--- linux.orig/drivers/md/raid10.c	2013-03-07 14:14:05.950824173 +0800
+++ linux/drivers/md/raid10.c	2013-04-28 08:57:44.765719067 +0800
@@ -1133,7 +1133,12 @@ static void raid10_unplug(struct blk_plu
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
 		bio->bi_next = NULL;
-		generic_make_request(bio);
+		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
+			/* Just ignore it */
+			bio_endio(bio, 0);
+		else
+			generic_make_request(bio);
 		bio = next;
 	}
 	kfree(plug);
