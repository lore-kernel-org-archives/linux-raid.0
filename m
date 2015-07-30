From: Shaohua Li <shli@fb.com>
Subject: [PATCH 9/9] raid5: skip resync if cache(log) is enabled
Date: Wed, 29 Jul 2015 17:38:49 -0700
Message-ID: <406d69eccd47d2eb57fca57bbafb9871e0858dcf.1438215986.git.shli@fb.com>
References: <cover.1438215986.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1438215986.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

If cache(log) is enabled, the log structure will guarantee data
consistency, so skip resync for unclean shutdown

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 26ea100..330550a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6967,6 +6967,15 @@ static int run(struct mddev *mddev)
 		}
 	}
 
+	if (conf->log) {
+		if (mddev->recovery_cp == 0) {
+			printk(KERN_NOTICE
+				"md/raid:%s: skip resync with caching enabled\n",
+				mdname(mddev));
+			mddev->recovery_cp = MaxSector;
+		}
+	}
+
 	return 0;
 abort:
 	md_unregister_thread(&mddev->thread);
-- 
1.8.5.6

