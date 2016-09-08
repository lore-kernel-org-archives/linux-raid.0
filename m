From: Shaohua Li <shli@fb.com>
Subject: [PATCH] raid5: allow arbitrary max_hw_sectors
Date: Thu, 8 Sep 2016 10:49:06 -0700
Message-ID: <fc28382b625fc4efe7549c9385a1c9edaf128d5a.1473356605.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com
List-Id: linux-raid.ids

raid5 will split bio to proper size internally, there is no point to use
underlayer disk's max_hw_sectors. In my qemu system, without the change,
the raid5 only receives 128k size bio, which reduces the chance of bio
merge sending to underlayer disks.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b95c54c..fc0b600 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7066,6 +7066,8 @@ static int raid5_run(struct mddev *mddev)
 		else
 			queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD,
 						mddev->queue);
+
+		blk_queue_max_hw_sectors(mddev->queue, UINT_MAX);
 	}
 
 	if (journal_dev) {
-- 
2.8.0.rc2

