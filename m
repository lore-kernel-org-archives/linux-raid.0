From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/4] md: Fix compilation warning
Date: Thu, 16 Jul 2020 13:54:40 +0900
Message-ID: <20200716045443.662056-2-damien.lemoal@wdc.com>
References: <20200716045443.662056-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200716045443.662056-1-damien.lemoal@wdc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Remove the if statement around the calls to sysfs_link_rdev() to avoid
the compilation warnings:

warning: suggest braces around empty body in an ‘if’ statement

when compiling with W=1. For the call to sysfs_create_link() generating
the same warning, use the err variable to store the function result,
avoiding triggering another warning as the function is declared
as 'warn_unused_result'.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/md.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fc33f2f8a415..9d740e4181ff 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2469,8 +2469,8 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 		goto fail;
 
 	ko = &part_to_dev(rdev->bdev->bd_part)->kobj;
-	if (sysfs_create_link(&rdev->kobj, ko, "block"))
-		/* failure here is OK */;
+	/* failure here is OK */
+	err = sysfs_create_link(&rdev->kobj, ko, "block");
 	rdev->sysfs_state = sysfs_get_dirent_safe(rdev->kobj.sd, "state");
 	rdev->sysfs_unack_badblocks =
 		sysfs_get_dirent_safe(rdev->kobj.sd, "unacknowledged_bad_blocks");
@@ -3238,8 +3238,8 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 			return err;
 		} else
 			sysfs_notify_dirent_safe(rdev->sysfs_state);
-		if (sysfs_link_rdev(rdev->mddev, rdev))
-			/* failure here is OK */;
+		/* failure here is OK */;
+		sysfs_link_rdev(rdev->mddev, rdev);
 		/* don't wakeup anyone, leave that to userspace. */
 	} else {
 		if (slot >= rdev->mddev->raid_disks &&
@@ -9113,8 +9113,8 @@ static int remove_and_add_spares(struct mddev *mddev,
 			rdev->recovery_offset = 0;
 		}
 		if (mddev->pers->hot_add_disk(mddev, rdev) == 0) {
-			if (sysfs_link_rdev(mddev, rdev))
-				/* failure here is OK */;
+			/* failure here is OK */
+			sysfs_link_rdev(mddev, rdev);
 			if (!test_bit(Journal, &rdev->flags))
 				spares++;
 			md_new_event(mddev);
-- 
2.26.2
