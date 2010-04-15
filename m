From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 09/28] md: Correctly handle device removal via sysfs
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062107.5126.56846.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Maciej Trela <Maciej.Trela@intel.com>
List-Id: linux-raid.ids

From: Maciej Trela <Maciej.Trela@intel.com>

Writing "none" to "../md/dev-xx/slot" removes that device
from being an active part of the array, but it didn't
set ->raid_disk to -1 to record this fact.


Signed-off-by: Maciej Trela <Maciej.Trela@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index be16462..30389bc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2358,6 +2358,7 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 			return err;
 		sprintf(nm, "rd%d", rdev->raid_disk);
 		sysfs_remove_link(&rdev->mddev->kobj, nm);
+		rdev->raid_disk = -1;
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
 		md_wakeup_thread(rdev->mddev->thread);
 	} else if (rdev->mddev->pers) {


