From: Shaohua Li <shli@fb.com>
Subject: [PATCH v2 6/6] raid5: skip resync if caching is enabled
Date: Mon, 18 May 2015 19:57:34 -0700
Message-ID: <c6376e76286b848ed06fa1f615c70968aa22221b.1432003804.git.shli@fb.com>
References: <cover.1432003804.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1432003804.git.shli@fb.com>
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
index 53f582d..52e016f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6941,6 +6941,13 @@ static int run(struct mddev *mddev)
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

