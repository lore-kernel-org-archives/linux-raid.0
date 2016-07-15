From: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Subject: [PATCH] md: Prevent IO hold during accessing to failed raid5 array
Date: Fri, 15 Jul 2016 15:24:27 +0200
Message-ID: <1468589067-1966-1-git-send-email-aleksey.obitotskiy@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After array enters in failed state (e.g. number of failed drives
becomes more then accepted for raid5 level) it sets error flags
(one of this flags is MD_CHANGE_PENDING). This flag prevents to
finish all new or non-finished IOs to array and hold them in
pending state. In some cases this can leads to deadlock situation.

For example udev handle array state changes (drives becomes faulty)
and blkid started but unable to finish reads due to IO hold.
At the same time we unable to get exclusive access to array
(to stop array in our case) because another external application
still use this array (blkid in our case).

Fix makes possible to return IO with errors immediately.
So external application can finish working with array and
give exclusive access to other applications.

Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
---
 drivers/md/raid5.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6c1149d..99471b6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4692,7 +4692,9 @@ finish:
 	}
 
 	if (!bio_list_empty(&s.return_bi)) {
-		if (test_bit(MD_CHANGE_PENDING, &conf->mddev->flags)) {
+		if (test_bit(MD_CHANGE_PENDING, &conf->mddev->flags) &&
+				(s.failed <= conf->max_degraded ||
+					conf->mddev->external == 0)) {
 			spin_lock_irq(&conf->device_lock);
 			bio_list_merge(&conf->return_bi, &s.return_bi);
 			spin_unlock_irq(&conf->device_lock);
-- 
2.7.4

