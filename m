From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 2/2] md/raid5: use consistency_policy to remove journal feature
Date: Thu, 16 Mar 2017 15:14:09 -0700
Message-ID: <20170316221409.3283344-2-songliubraving@fb.com>
References: <20170316221409.3283344-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170316221409.3283344-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

When journal device of an array fails, the array is forced into read-only
mode. To make the array normal without adding another journal device, we
need to remove journal _feature_ from the array.

This patch allows remove journal _feature_ from an array, For journal
existing journal should be either missing or faulty.

To remove journal feature, one can simply echo into the sysfs file:

 cat /sys/block/md0/md/consistency_policy
 journal

 echo resync > /sys/block/md0/md/consistency_policy
 cat /sys/block/md0/md/consistency_policy
 resync

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7a6e7ea..2302ec4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8369,11 +8369,19 @@ static int raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
 		if (!err)
 			raid5_reset_stripe_cache(mddev);
 		mddev_resume(mddev);
-	} else if (strncmp(buf, "resync", 6) == 0 && raid5_has_ppl(conf)) {
-		mddev_suspend(mddev);
-		log_exit(conf);
-		raid5_reset_stripe_cache(mddev);
-		mddev_resume(mddev);
+	} else if (strncmp(buf, "resync", 6) == 0) {
+		if (raid5_has_ppl(conf)) {
+			mddev_suspend(mddev);
+			log_exit(conf);
+			raid5_reset_stripe_cache(mddev);
+			mddev_resume(mddev);
+		} else if (test_bit(MD_HAS_JOURNAL, &conf->mddev->flags) &&
+			   r5l_log_disk_error(conf)) {
+			mddev_suspend(mddev);
+			clear_bit(MD_HAS_JOURNAL, &mddev->flags);
+			mddev_resume(mddev);
+		} else
+			err = -EINVAL;
 	} else {
 		err = -EINVAL;
 	}
-- 
2.9.3

