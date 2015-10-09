From: Shaohua Li <shli@fb.com>
Subject: [PATCH 3/9] raid5: journal disk can't be removed
Date: Thu, 8 Oct 2015 21:54:07 -0700
Message-ID: <7bdb9467130e7ce818053123e9f1e65058670a2b.1444360850.git.shli@fb.com>
References: <cover.1444360850.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1444360850.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

raid5-cache uses journal disk rdev->bdev, rdev->mddev in several places.
Don't allow journal disk disappear magically. On the other hand, we do
need to update superblock for other disks to bump up ->events, so next
time journal disk will be identified as stale.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 216fa3c..6430098 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7128,6 +7128,15 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	struct disk_info *p = conf->disks + number;
 
 	print_raid5_conf(conf);
+	if (test_bit(Journal, &rdev->flags)) {
+		/*
+		 * journal disk is not removable, but we need give a chance to
+		 * update superblock of other disks. Otherwise journal disk
+		 * will be considered as 'fresh'
+		 * */
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		return -EINVAL;
+	}
 	if (rdev == p->rdev)
 		rdevp = &p->rdev;
 	else if (rdev == p->replacement)
@@ -7190,6 +7199,8 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	int first = 0;
 	int last = conf->raid_disks - 1;
 
+	if (test_bit(Journal, &rdev->flags))
+		return -EINVAL;
 	if (mddev->recovery_disabled == conf->recovery_disabled)
 		return -EBUSY;
 
-- 
2.4.6

