From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] raid5: revert commit 11367799f3d1
Date: Tue, 25 Oct 2016 17:17:18 +0200
Message-ID: <1477408638-4539-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Revert commit 11367799f3d1 ("md: Prevent IO hold during accessing to faulty
raid5 array") as it doesn't comply with commit c3cce6cda162 ("md/raid5:
ensure device failure recorded before write request returns."). That change
is not required anymore as the problem is resolved by commit 16f889499a52
("md: report 'write_pending' state when array in sync") - read request is
stuck as array state is not reported correctly via sysfs attribute.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 drivers/md/raid5.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f94472d..323d3c7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4645,9 +4645,7 @@ finish:
 	}
 
 	if (!bio_list_empty(&s.return_bi)) {
-		if (test_bit(MD_CHANGE_PENDING, &conf->mddev->flags) &&
-				(s.failed <= conf->max_degraded ||
-					conf->mddev->external == 0)) {
+		if (test_bit(MD_CHANGE_PENDING, &conf->mddev->flags))
 			spin_lock_irq(&conf->device_lock);
 			bio_list_merge(&conf->return_bi, &s.return_bi);
 			spin_unlock_irq(&conf->device_lock);
-- 
1.8.3.1

