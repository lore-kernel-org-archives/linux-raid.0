From: Shaohua Li <shli@fb.com>
Subject: [PATCH v3 6/8] raid5: skip resync if caching is enabled
Date: Wed, 3 Jun 2015 15:48:41 -0700
Message-ID: <2417cba382f6f457d8a7a22fb7b3ad70130c2b93.1433356864.git.shli@fb.com>
References: <cover.1433356864.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1433356864.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

If caching is enabled, the caching layer will guarantee data
consistency, so skip resync for unclean shutdown

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 29f49c7..b1c942c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6975,6 +6975,13 @@ static int run(struct mddev *mddev)
 		if (mddev->queue)
 			blk_queue_logical_block_size(mddev->queue, STRIPE_SIZE);
 		conf->skip_copy = 1;
+
+		if (mddev->recovery_cp == 0) {
+			printk(KERN_NOTICE
+				"md/raid:%s: skip resync with caching enabled\n",
+				mdname(mddev));
+			mddev->recovery_cp = MaxSector;
+		}
 	}
 
 	return 0;
-- 
1.8.1

