From: Eric Engestrom <eric.engestrom@imgtec.com>
Subject: [PATCH] md/bitmap: remove redundant check
Date: Mon, 7 Mar 2016 12:01:05 +0000
Message-ID: <1457352065-28994-1-git-send-email-eric.engestrom@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Eric Engestrom <eric.engestrom@imgtec.com>
List-Id: linux-raid.ids

daemon_sleep is an unsigned, so testing if it's 0 or less than 1 does
the same thing.

Signed-off-by: Eric Engestrom <eric.engestrom@imgtec.com>
---
 drivers/md/bitmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index d80cce4..bbe7b64 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -510,8 +510,7 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
 	sb->chunksize = cpu_to_le32(chunksize);
 
 	daemon_sleep = bitmap->mddev->bitmap_info.daemon_sleep;
-	if (!daemon_sleep ||
-	    (daemon_sleep < 1) || (daemon_sleep > MAX_SCHEDULE_TIMEOUT)) {
+	if (!daemon_sleep || (daemon_sleep > MAX_SCHEDULE_TIMEOUT)) {
 		printk(KERN_INFO "Choosing daemon_sleep default (5 sec)\n");
 		daemon_sleep = 5 * HZ;
 	}
-- 
2.7.1

