From: Shaohua Li <shli@fb.com>
Subject: [PATCH] raid5: guarantee enough stripes to avoid reshape hang
Date: Tue, 30 Aug 2016 10:29:33 -0700
Message-ID: <e855bdf2ccb11e440191e9512de460f3c5355dd2.1472578078.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com
List-Id: linux-raid.ids

If there aren't enough stripes, reshape will hang. We have a check for
this in new reshape, but miss it for reshape resume, hence we could see
hang in reshape resume. This patch forces enough stripes existed if
reshape resumes.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 62febe8..2fdb97b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6639,6 +6639,16 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	}
 
 	conf->min_nr_stripes = NR_STRIPES;
+	if (mddev->reshape_position != MaxSector) {
+		int stripes = max_t(int,
+			((mddev->chunk_sectors << 9) / STRIPE_SIZE) * 4,
+			((mddev->new_chunk_sectors << 9) / STRIPE_SIZE) * 4);
+		conf->min_nr_stripes = max(NR_STRIPES, stripes);
+		if (conf->min_nr_stripes != NR_STRIPES)
+			printk(KERN_INFO
+				"md/raid:%s: force stripe size %d for reshape\n",
+				mdname(mddev), conf->min_nr_stripes);
+	}
 	memory = conf->min_nr_stripes * (sizeof(struct stripe_head) +
 		 max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
 	atomic_set(&conf->empty_inactive_list_nr, NR_STRIPE_HASH_LOCKS);
-- 
2.8.0.rc2

