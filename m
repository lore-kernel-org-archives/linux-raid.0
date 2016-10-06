From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 05/54] md/raid0: Move another variable assignment in
 create_strip_zones()
Date: Thu, 6 Oct 2016 10:57:44 +0200
Message-ID: <bc309a57-5684-d0f5-b876-a463cb112777@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 4 Oct 2016 13:54:36 +0200

One local variable was set to an error code before a concrete
error situation was detected. Thus move the corresponding assignment
to the end to indicate a software failure there.
Use it finally in four if branches for exception handling.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid0.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 3079c3e..0315f1e 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -173,7 +173,6 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	cnt = 0;
 	smallest = NULL;
 	dev = conf->devlist;
-	err = -EINVAL;
 	rdev_for_each(rdev1, mddev) {
 		int j = rdev1->raid_disk;
 
@@ -194,17 +193,17 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		if (j < 0) {
 			pr_err("%s: remove inactive devices before converting to RAID0\n",
 			       mdname(mddev));
-			goto free_device_list;
+			goto e_inval;
 		}
 		if (j >= mddev->raid_disks) {
 			pr_err("%s: bad disk number %d%s",
 			       mdname(mddev), j, " - aborting!\n");
-			goto free_device_list;
+			goto e_inval;
 		}
 		if (dev[j]) {
 			pr_err("%s: multiple devices for %d%s",
 			       mdname(mddev), j, " - aborting!\n");
-			goto free_device_list;
+			goto e_inval;
 		}
 		dev[j] = rdev1;
 
@@ -215,7 +214,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	if (cnt != mddev->raid_disks) {
 		pr_err("%s: too few disks (%d of %d)%s",
 		       mdname(mddev), cnt, mddev->raid_disks, " - aborting!\n");
-		goto free_device_list;
+		goto e_inval;
 	}
 	zone->nb_dev = cnt;
 	zone->zone_end = smallest->sectors * cnt;
@@ -280,6 +279,9 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	kfree(conf);
 	*private_conf = ERR_PTR(err);
 	return err;
+e_inval:
+	err = -EINVAL;
+	goto free_device_list;
 }
 
 /* Find the zone which holds a particular offset
-- 
2.10.1

