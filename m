From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] md:array cannot be opened again after 'md_set_readonly'
Date: Mon, 27 Mar 2017 15:52:25 +0800
Message-ID: <1490601145-5865-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com, shli@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

This is a bug about array cannot be opened again after 'md_set_readonly',
because the MD_CLOSING bit is still waiting for clear.
MD_CLOSING should only be set for a short period or time to avoid certain
races. After the operation that set it completes, it should be cleared.

Reviewed-by: NeilBrown <neilb@suse.com>
Cc: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f6ae1d6..7f2db7c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5588,6 +5588,7 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 	int err = 0;
 	int did_freeze = 0;
 
+	test_and_clear_bit(MD_CLOSING, &mddev->flags);
 	if (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
 		did_freeze = 1;
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-- 
2.6.6

