From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/3] md: MD_RECOVERY_NEEDED is set for mddev->recovery
Date: Thu, 8 Dec 2016 15:48:18 -0800
Message-ID: <8c8e0b996b721fb9747fb7b7d312d59dbba3b4c4.1481240632.git.shli@fb.com>
References: <cover.1481240632.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1481240632.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com
List-Id: linux-raid.ids

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 84dc891..5e66648 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6856,7 +6856,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 		/* need to ensure recovery thread has run */
 		wait_event_interruptible_timeout(mddev->sb_wait,
 						 !test_bit(MD_RECOVERY_NEEDED,
-							   &mddev->flags),
+							   &mddev->recovery),
 						 msecs_to_jiffies(5000));
 	if (cmd == STOP_ARRAY || cmd == STOP_ARRAY_RO) {
 		/* Need to flush page cache, and ensure no-one else opens
-- 
2.9.3

