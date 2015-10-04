From: Shaohua Li <shli@fb.com>
Subject: [PATCH 4/6] md: don't export log device
Date: Sun, 4 Oct 2015 09:20:14 -0700
Message-ID: <7aecea0895b46e28c2b8a876a83da10d7f30d7f1.1443973492.git.shli@fb.com>
References: <cover.1443973492.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1443973492.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

If there is IO error in log device, don't export it like other raid
disks. Otherwise we get kernel crash in different places since
rdev->bdev, rdev->mddev becomes NULL

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c    | 4 ++--
 drivers/md/raid5.c | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c643c9a..ec6574d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2523,7 +2523,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		else
 			err = -EBUSY;
 	} else if (cmd_match(buf, "remove")) {
-		if (rdev->raid_disk >= 0)
+		if (rdev->raid_disk >= 0 || test_bit(Journal, &rdev->flags))
 			err = -EBUSY;
 		else {
 			struct mddev *mddev = rdev->mddev;
@@ -6044,7 +6044,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 	clear_bit(Blocked, &rdev->flags);
 	remove_and_add_spares(mddev, rdev);
 
-	if (rdev->raid_disk >= 0)
+	if (rdev->raid_disk >= 0 || test_bit(Journal, &rdev->flags))
 		goto busy;
 
 	if (mddev_is_clustered(mddev))
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 216fa3c..c164501 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7128,6 +7128,8 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	struct disk_info *p = conf->disks + number;
 
 	print_raid5_conf(conf);
+	if (test_bit(Journal, &rdev->flags))
+		return -EBUSY;
 	if (rdev == p->rdev)
 		rdevp = &p->rdev;
 	else if (rdev == p->replacement)
-- 
2.4.6

