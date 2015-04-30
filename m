From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 2/2] md/raid5: trivial coding style fix
Date: Thu, 30 Apr 2015 15:01:17 +0800
Message-ID: <1430377277-6167-2-git-send-email-yuanhan.liu@linux.intel.com>
References: <1430377277-6167-1-git-send-email-yuanhan.liu@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430377277-6167-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
List-Id: linux-raid.ids

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/md/raid5.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2651bda..bae3e2c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5789,8 +5789,7 @@ static void raid5d(struct md_thread *thread)
 		if (released)
 			clear_bit(R5_DID_ALLOC, &conf->cache_state);
 
-		if (
-		    !list_empty(&conf->bitmap_list)) {
+		if (!list_empty(&conf->bitmap_list)) {
 			/* Now is a good time to flush some bitmap updates */
 			conf->seq_flush++;
 			spin_unlock_irq(&conf->device_lock);
-- 
1.9.0
