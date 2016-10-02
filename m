From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 10/13] md/multipath: Add some spaces for better code
 readability
Date: Sun, 2 Oct 2016 14:06:33 +0200
Message-ID: <c9a99ef0-8164-2fb1-22e2-eb47ae144681@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Jens Axboe <axboe@fb.com>, NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 2 Oct 2016 10:20:52 +0200

Use space characters at some source code places according to
the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/multipath.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index a5a639d..23c7c29 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -98,7 +98,7 @@ static void multipath_end_request(struct bio *bio)
 		char b[BDEVNAME_SIZE];
 		md_error(mp_bh->mddev, rdev);
 		printk(KERN_ERR "multipath: %s: rescheduling sector %llu\n",
-		       bdevname(rdev->bdev,b),
+		       bdevname(rdev->bdev, b),
 		       (unsigned long long)bio->bi_iter.bi_sector);
 		multipath_reschedule_retry(mp_bh);
 	} else
@@ -238,8 +238,8 @@ static void print_multipath_conf(struct mpconf *conf)
 		tmp = conf->multipaths + i;
 		if (tmp->rdev)
 			printk(" disk%d, o:%d, dev:%s\n",
-				i,!test_bit(Faulty, &tmp->rdev->flags),
-			       bdevname(tmp->rdev->bdev,b));
+			       i, !test_bit(Faulty, &tmp->rdev->flags),
+			       bdevname(tmp->rdev->bdev, b));
 	}
 }
 
@@ -353,13 +353,13 @@ static void multipathd(struct md_thread *thread)
 		if (mp_bh->path < 0) {
 			printk(KERN_ALERT "multipath: %s: unrecoverable IO read"
 				" error for block %llu\n",
-				bdevname(bio->bi_bdev,b),
+				bdevname(bio->bi_bdev, b),
 				(unsigned long long)bio->bi_iter.bi_sector);
 			multipath_end_bh_io(mp_bh, -EIO);
 		} else {
 			printk(KERN_ERR "multipath: %s: redirecting sector %llu"
 				" to another IO path\n",
-				bdevname(bio->bi_bdev,b),
+				bdevname(bio->bi_bdev, b),
 				(unsigned long long)bio->bi_iter.bi_sector);
 			*bio = *(mp_bh->master_bio);
 			bio->bi_iter.bi_sector +=
@@ -487,18 +487,18 @@ static void multipath_free(struct mddev *mddev, void *priv)
 
 static struct md_personality multipath_personality =
 {
-	.name		= "multipath",
-	.level		= LEVEL_MULTIPATH,
-	.owner		= THIS_MODULE,
-	.make_request	= multipath_make_request,
-	.run		= multipath_run,
-	.free		= multipath_free,
-	.status		= multipath_status,
-	.error_handler	= multipath_error,
-	.hot_add_disk	= multipath_add_disk,
-	.hot_remove_disk= multipath_remove_disk,
-	.size		= multipath_size,
-	.congested	= multipath_congested,
+	.name            = "multipath",
+	.level           = LEVEL_MULTIPATH,
+	.owner           = THIS_MODULE,
+	.make_request    = multipath_make_request,
+	.run             = multipath_run,
+	.free            = multipath_free,
+	.status          = multipath_status,
+	.error_handler   = multipath_error,
+	.hot_add_disk    = multipath_add_disk,
+	.hot_remove_disk = multipath_remove_disk,
+	.size            = multipath_size,
+	.congested       = multipath_congested,
 };
 
 static int __init multipath_init(void)
-- 
2.10.0

