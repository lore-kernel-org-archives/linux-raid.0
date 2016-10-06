From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 02/54] md/raid0: Less function calls in create_strip_zones()
 after error detection
Date: Thu, 6 Oct 2016 10:53:29 +0200
Message-ID: <95367971-fdc2-7bb8-e34e-bf54e480420d@users.sourceforge.net>
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
Date: Tue, 4 Oct 2016 10:43:33 +0200

The kfree() function was called in up to two cases
by the create_strip_zones() function during error handling even if
the passed data structure member (or variable) contained a null pointer.

Adjust jump targets according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid0.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 50e8a63..3c76451 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -146,7 +146,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		       mdname(mddev),
 		       mddev->chunk_sectors << 9, blksize);
 		err = -EINVAL;
-		goto abort;
+		goto free_conf;
 	}
 
 	err = -ENOMEM;
@@ -154,12 +154,12 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 				   sizeof(*conf->strip_zone),
 				   GFP_KERNEL);
 	if (!conf->strip_zone)
-		goto abort;
+		goto free_conf;
 	conf->devlist = kcalloc(conf->nr_strip_zones * mddev->raid_disks,
 				sizeof(*conf->devlist),
 				GFP_KERNEL);
 	if (!conf->devlist)
-		goto abort;
+		goto free_zone;
 
 	/* The first zone must contain all devices, so here we check that
 	 * there is a proper alignment of slots to devices and find them all
@@ -190,17 +190,17 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 			printk(KERN_ERR
 			       "md/raid0:%s: remove inactive devices before converting to RAID0\n",
 			       mdname(mddev));
-			goto abort;
+			goto free_device_list;
 		}
 		if (j >= mddev->raid_disks) {
 			printk(KERN_ERR "md/raid0:%s: bad disk number %d - "
 			       "aborting!\n", mdname(mddev), j);
-			goto abort;
+			goto free_device_list;
 		}
 		if (dev[j]) {
 			printk(KERN_ERR "md/raid0:%s: multiple devices for %d - "
 			       "aborting!\n", mdname(mddev), j);
-			goto abort;
+			goto free_device_list;
 		}
 		dev[j] = rdev1;
 
@@ -211,7 +211,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	if (cnt != mddev->raid_disks) {
 		printk(KERN_ERR "md/raid0:%s: too few disks (%d of %d) - "
 		       "aborting!\n", mdname(mddev), cnt, mddev->raid_disks);
-		goto abort;
+		goto free_device_list;
 	}
 	zone->nb_dev = cnt;
 	zone->zone_end = smallest->sectors * cnt;
@@ -271,9 +271,11 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	*private_conf = conf;
 
 	return 0;
-abort:
-	kfree(conf->strip_zone);
+free_device_list:
 	kfree(conf->devlist);
+free_zone:
+	kfree(conf->strip_zone);
+free_conf:
 	kfree(conf);
 	*private_conf = ERR_PTR(err);
 	return err;
-- 
2.10.1
