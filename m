From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 1/2] md/raid5: fix typo
Date: Thu, 30 Apr 2015 15:01:16 +0800
Message-ID: <1430377277-6167-1-git-send-email-yuanhan.liu@linux.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
List-Id: linux-raid.ids

bion -> bios

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 697d77a..2651bda 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2919,7 +2919,7 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 }
 
 /*
- * Each stripe/dev can have one or more bion attached.
+ * Each stripe/dev can have one or more bios attached.
  * toread/towrite point to the first in a chain.
  * The bi_next chain must be in order.
  */
-- 
1.9.0

