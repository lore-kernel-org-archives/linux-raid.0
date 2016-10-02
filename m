From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/13] md/multipath: Delete four error messages for a failed
 memory allocation
Date: Sun, 2 Oct 2016 13:59:14 +0200
Message-ID: <6726e88c-2ad0-fd5e-6ef4-4f5e796a68b9@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Jens Axboe <axboe@fb.com>, NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>, Wolfram Sang <wsa@the-dreams.de>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 21:15:45 +0200

Omit extra messages for a memory allocation failure in this function.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/multipath.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 7fdabb1..be7c0b9 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -401,22 +401,14 @@ static int multipath_run (struct mddev *mddev)
 
 	conf = kzalloc(sizeof(*conf), GFP_KERNEL);
 	mddev->private = conf;
-	if (!conf) {
-		printk(KERN_ERR
-			"multipath: couldn't allocate memory for %s\n",
-			mdname(mddev));
+	if (!conf)
 		goto out;
-	}
 
 	conf->multipaths = kcalloc(mddev->raid_disks,
 				   sizeof(*conf->multipaths),
 				   GFP_KERNEL);
-	if (!conf->multipaths) {
-		printk(KERN_ERR
-			"multipath: couldn't allocate memory for %s\n",
-			mdname(mddev));
+	if (!conf->multipaths)
 		goto out_free_conf;
-	}
 
 	working_disks = 0;
 	rdev_for_each(rdev, mddev) {
@@ -448,21 +440,14 @@ static int multipath_run (struct mddev *mddev)
 
 	conf->pool = mempool_create_kmalloc_pool(NR_RESERVED_BUFS,
 						 sizeof(struct multipath_bh));
-	if (conf->pool == NULL) {
-		printk(KERN_ERR
-			"multipath: couldn't allocate memory for %s\n",
-			mdname(mddev));
+	if (!conf->pool)
 		goto out_free_conf;
-	}
 
 	{
 		mddev->thread = md_register_thread(multipathd, mddev,
 						   "multipath");
-		if (!mddev->thread) {
-			printk(KERN_ERR "multipath: couldn't allocate thread"
-				" for %s\n", mdname(mddev));
+		if (!mddev->thread)
 			goto out_free_conf;
-		}
 	}
 
 	printk(KERN_INFO
-- 
2.10.0

