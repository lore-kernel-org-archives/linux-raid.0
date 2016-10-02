From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 5/13] md/multipath: Less function calls in multipath_run()
 after error detection
Date: Sun, 2 Oct 2016 14:01:06 +0200
Message-ID: <0e0d240c-a386-25f4-9415-6185aabbcf21@users.sourceforge.net>
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
Date: Sat, 1 Oct 2016 21:48:59 +0200

The functions "kfree" and "mempool_destroy" were called in a few cases
by the function "multipath_run" during error handling even if
the passed data structure member contained a null pointer.

Adjust jump targets according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/multipath.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 7900426..2e4ceb9 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -408,7 +408,7 @@ static int multipath_run (struct mddev *mddev)
 				   sizeof(*conf->multipaths),
 				   GFP_KERNEL);
 	if (!conf->multipaths)
-		goto out_free_conf;
+		goto free_conf;
 
 	working_disks = 0;
 	rdev_for_each(rdev, mddev) {
@@ -434,18 +434,18 @@ static int multipath_run (struct mddev *mddev)
 	if (!working_disks) {
 		printk(KERN_ERR "multipath: no operational IO paths for %s\n",
 			mdname(mddev));
-		goto out_free_conf;
+		goto free_multipaths;
 	}
 	mddev->degraded = conf->raid_disks - working_disks;
 
 	conf->pool = mempool_create_kmalloc_pool(NR_RESERVED_BUFS,
 						 sizeof(struct multipath_bh));
 	if (!conf->pool)
-		goto out_free_conf;
+		goto free_multipaths;
 
 	mddev->thread = md_register_thread(multipathd, mddev, "multipath");
 	if (!mddev->thread)
-		goto out_free_conf;
+		goto destroy_pool;
 
 	printk(KERN_INFO
 		"multipath: array %s active with %d out of %d IO paths\n",
@@ -457,13 +457,14 @@ static int multipath_run (struct mddev *mddev)
 	md_set_array_sectors(mddev, multipath_size(mddev, 0, 0));
 
 	if (md_integrity_register(mddev))
-		goto out_free_conf;
+		goto destroy_pool;
 
 	return 0;
-
-out_free_conf:
+destroy_pool:
 	mempool_destroy(conf->pool);
+free_multipaths:
 	kfree(conf->multipaths);
+free_conf:
 	kfree(conf);
 	mddev->private = NULL;
 out:
-- 
2.10.0

