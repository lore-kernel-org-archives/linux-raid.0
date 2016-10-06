From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 09/54] md/raid0: Add some spaces for better code readability
Date: Thu, 6 Oct 2016 11:03:14 +0200
Message-ID: <925990b4-3683-ca3a-1c2f-1aaedfa29e66@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 4 Oct 2016 14:48:34 +0200

Use space characters at some source code places according to
the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid0.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 1abe1ee..39d407c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -55,7 +55,7 @@ static void dump_zones(struct mddev *mddev)
 	int raid_disks = conf->strip_zone[0].nb_dev;
 	pr_info("configuration for %s - %d zone%s\n",
 	       mdname(mddev),
-	       conf->nr_strip_zones, conf->nr_strip_zones==1?"":"s");
+	       conf->nr_strip_zones, conf->nr_strip_zones == 1 ? "" : "s");
 	for (j = 0; j < conf->nr_strip_zones; j++) {
 		pr_info("zone%d=[", j);
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
@@ -106,9 +106,9 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		rdev_for_each(rdev2, mddev) {
 			pr_debug("%s:   comparing %s(%llu) with %s(%llu)\n",
 				 mdname(mddev),
-				 bdevname(rdev1->bdev,b),
+				 bdevname(rdev1->bdev, b),
 				 (unsigned long long)rdev1->sectors,
-				 bdevname(rdev2->bdev,b2),
+				 bdevname(rdev2->bdev, b2),
 				 (unsigned long long)rdev2->sectors);
 			if (rdev2 == rdev1) {
 				pr_debug("%s:   END\n",
@@ -232,7 +232,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		smallest = NULL;
 		c = 0;
 
-		for (j=0; j<cnt; j++) {
+		for (j = 0; j < cnt; j++) {
 			rdev = conf->devlist[j];
 			if (rdev->sectors <= zone->dev_start) {
 				pr_debug("%s: checking %s ... nope\n",
@@ -418,8 +418,8 @@ static int raid0_run(struct mddev *mddev)
 		 */
 		int stripe = mddev->raid_disks *
 			(mddev->chunk_sectors << 9) / PAGE_SIZE;
-		if (mddev->queue->backing_dev_info.ra_pages < 2* stripe)
-			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
+		if (mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
+			mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
 	}
 
 	dump_zones(mddev);
-- 
2.10.1

