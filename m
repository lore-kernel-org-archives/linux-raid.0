From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 14/54] md/raid1: Move assignments for the variable "err" in
 setup_conf()
Date: Thu, 6 Oct 2016 11:10:17 +0200
Message-ID: <3af74de2-8347-4833-740e-2602f8f0f971@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 4 Oct 2016 17:34:10 +0200

One local variable was set to an error code in a few cases before
a concrete error situation was detected. Thus move the corresponding
assignments into if branches to indicate a software failure there.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid1.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 74346f5..4d2fcbc 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2775,7 +2775,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	int i;
 	struct raid1_info *disk;
 	struct md_rdev *rdev;
-	int err = -ENOMEM;
+	int err;
 
 	conf = kzalloc(sizeof(struct r1conf), GFP_KERNEL);
 	if (!conf)
@@ -2784,26 +2784,33 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	conf->mirrors = kcalloc(mddev->raid_disks * 2,
 				sizeof(*conf->mirrors),
 				GFP_KERNEL);
-	if (!conf->mirrors)
+	if (!conf->mirrors) {
+		err = -ENOMEM;
 		goto abort;
+	}
 
 	conf->tmppage = alloc_page(GFP_KERNEL);
-	if (!conf->tmppage)
+	if (!conf->tmppage) {
+		err = -ENOMEM;
 		goto abort;
+	}
 
 	conf->poolinfo = kzalloc(sizeof(*conf->poolinfo), GFP_KERNEL);
-	if (!conf->poolinfo)
+	if (!conf->poolinfo) {
+		err = -ENOMEM;
 		goto abort;
+	}
+
 	conf->poolinfo->raid_disks = mddev->raid_disks * 2;
 	conf->r1bio_pool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
 					  r1bio_pool_free,
 					  conf->poolinfo);
-	if (!conf->r1bio_pool)
+	if (!conf->r1bio_pool) {
+		err = -ENOMEM;
 		goto abort;
+	}
 
 	conf->poolinfo->mddev = mddev;
-
-	err = -EINVAL;
 	spin_lock_init(&conf->device_lock);
 	rdev_for_each(rdev, mddev) {
 		struct request_queue *q;
@@ -2816,8 +2823,11 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 		else
 			disk = conf->mirrors + disk_idx;
 
-		if (disk->rdev)
+		if (disk->rdev) {
+			err = -EINVAL;
 			goto abort;
+		}
+
 		disk->rdev = rdev;
 		q = bdev_get_queue(rdev->bdev);
 
@@ -2838,8 +2848,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 
 	conf->start_next_window = MaxSector;
 	conf->current_window_requests = conf->next_window_requests = 0;
-
-	err = -EIO;
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 
 		disk = conf->mirrors + i;
@@ -2854,9 +2862,13 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 				disk->rdev =
 					disk[conf->raid_disks].rdev;
 				disk[conf->raid_disks].rdev = NULL;
-			} else if (!test_bit(In_sync, &disk->rdev->flags))
-				/* Original is not in_sync - bad */
-				goto abort;
+			} else {
+				if (!test_bit(In_sync, &disk->rdev->flags)) {
+					/* Original is not in_sync - bad */
+					err = -EIO;
+					goto abort;
+				}
+			}
 		}
 
 		if (!disk->rdev ||
@@ -2868,12 +2880,12 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 		}
 	}
 
-	err = -ENOMEM;
 	conf->thread = md_register_thread(raid1d, mddev, "raid1");
 	if (!conf->thread) {
 		printk(KERN_ERR
 		       "md/raid1:%s: couldn't allocate thread\n",
 		       mdname(mddev));
+		err = -ENOMEM;
 		goto abort;
 	}
 
-- 
2.10.1
