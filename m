From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/3] md: don't export log device
Date: Wed, 30 Sep 2015 16:15:39 -0700
Message-ID: <78d0cd55e9c1476869933454e06b3f74ad88ce9c.1443653794.git.shli@fb.com>
References: <cover.1443653794.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1443653794.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

If there is IO error in log device, don't export it like other raid
disks. Otherwise we get kernel crash in different places since
rdev->bdev, rdev->mddev becomes NULL

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f1cbb08..0b1d7ef 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2519,7 +2519,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		else
 			err = -EBUSY;
 	} else if (cmd_match(buf, "remove")) {
-		if (rdev->raid_disk >= 0)
+		if (rdev->raid_disk >= 0 || test_bit(Journal, &rdev->flags))
 			err = -EBUSY;
 		else {
 			struct mddev *mddev = rdev->mddev;
@@ -6040,7 +6040,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 	clear_bit(Blocked, &rdev->flags);
 	remove_and_add_spares(mddev, rdev);
 
-	if (rdev->raid_disk >= 0)
+	if (rdev->raid_disk >= 0 || test_bit(Journal, &rdev->flags))
 		goto busy;
 
 	if (mddev_is_clustered(mddev))
-- 
2.4.6

