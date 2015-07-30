From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/9] md: override md superblock recovery_offset for cache device
Date: Wed, 29 Jul 2015 17:38:42 -0700
Message-ID: <42ac39ae4466dda63b1dee827c2bd3741d669860.1438215986.git.shli@fb.com>
References: <cover.1438215986.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1438215986.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Cache device stores data in a log structure. We need record the log
start. Here we override md superblock recovery_offset for this purpose.
This field of a cache device is meaningless otherwise.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fd84f16..9861f34 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1664,6 +1664,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 				  "cache feature, ignoring the device\n");
 				return -EINVAL;
 			}
+			rdev->recovery_offset = le64_to_cpu(sb->recovery_offset);
 			set_bit(WriteCache, &rdev->flags);
 			break;
 		default:
@@ -1830,6 +1831,9 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 			sb->dev_roles[i] = cpu_to_le16(0xffff);
 	}
 
+	if (test_bit(WriteCache, &rdev->flags))
+		sb->recovery_offset = cpu_to_le64(rdev->recovery_offset);
+
 	sb->sb_csum = calc_sb_1_csum(sb);
 }
 
-- 
1.8.5.6

