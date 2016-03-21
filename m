From: Wei Fang <fangwei1@huawei.com>
Subject: [PATCH] md: fix a trivial typo in comments
Date: Mon, 21 Mar 2016 19:19:30 +0800
Message-ID: <1458559170-27823-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Wei Fang <fangwei1@huawei.com>
List-Id: linux-raid.ids

Fix a trivial typo in md_ioctl().

Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e55e6cf..9804355 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6883,7 +6883,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 
 	case ADD_NEW_DISK:
 		/* We can support ADD_NEW_DISK on read-only arrays
-		 * on if we are re-adding a preexisting device.
+		 * only if we are re-adding a preexisting device.
 		 * So require mddev->pers and MD_DISK_SYNC.
 		 */
 		if (mddev->pers) {
-- 
1.7.1

