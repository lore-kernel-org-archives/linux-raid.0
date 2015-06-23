From: Shaohua Li <shli@fb.com>
Subject: [PATCH V4 13/13] raid5: skip resync if caching is enabled
Date: Tue, 23 Jun 2015 14:38:03 -0700
Message-ID: <bccf8383eca2dac5624af42709245b4de860531c.1435094582.git.shli@fb.com>
References: <cover.1435094582.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1435094582.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

If caching is enabled, the caching layer will guarantee data
consistency, so skip resync for unclean shutdown

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9faa5c6..a91ff75 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6998,6 +6998,13 @@ static int run(struct mddev *mddev)
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

