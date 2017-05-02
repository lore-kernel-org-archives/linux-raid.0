From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/6] md: Adjust four function calls together with a variable
 assignment
Date: Tue, 2 May 2017 16:27:21 +0200
Message-ID: <7d82f7ed-6d1d-a666-0d55-2769f27a4ef3@users.sourceforge.net>
References: <f05bfc4e-7935-7e87-cc85-f0d9c5e3846a@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f05bfc4e-7935-7e87-cc85-f0d9c5e3846a@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 May 2017 15:07:21 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: do not use assignment in if condition

Thus fix affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 65233a91e5e2..60580095a5de 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2153,7 +2153,8 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 	rdev->mddev = mddev;
 	pr_debug("md: bind<%s>\n", b);
 
-	if ((err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
+	err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b);
+	if (err)
 		goto fail;
 
 	ko = &part_to_dev(rdev->bdev->bd_part)->kobj;
@@ -7306,7 +7307,8 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 	}
 	BUG_ON(mddev != bdev->bd_disk->private_data);
 
-	if ((err = mutex_lock_interruptible(&mddev->open_mutex)))
+	err = mutex_lock_interruptible(&mddev->open_mutex);
+	if (err)
 		goto out;
 
 	if (test_bit(MD_CLOSING, &mddev->flags)) {
@@ -8927,10 +8929,12 @@ static int __init md_init(void)
 	if (!md_misc_wq)
 		goto err_misc_wq;
 
-	if ((ret = register_blkdev(MD_MAJOR, "md")) < 0)
+	ret = register_blkdev(MD_MAJOR, "md");
+	if (ret < 0)
 		goto err_md;
 
-	if ((ret = register_blkdev(0, "mdp")) < 0)
+	ret = register_blkdev(0, "mdp");
+	if (ret < 0)
 		goto err_mdp;
 	mdp_major = ret;
 
-- 
2.12.2
