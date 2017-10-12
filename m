From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] md: ensure sectors is nonzero when change component size
Date: Thu, 12 Oct 2017 16:30:51 +0800
Message-ID: <1507797051-18545-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Against the raids which chunk_size is meaningful, the component_size
must be >= chunk_size when require resize. If "new_size < chunk_size"
has required, the "mddev->pers->resize" will set sectors as '0', and
then the raids isn't meaningful any more due to mddev->dev_sectors is
'0'.

Cc: Neil Brown <neilb@suse.com>
Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 drivers/md/raid10.c | 2 ++
 drivers/md/raid5.c  | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 374df57..f3891f6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3871,6 +3871,8 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 
 	oldsize = raid10_size(mddev, 0, 0);
 	size = raid10_size(mddev, sectors, 0);
+	if (size == 0)
+		return -EINVAL;
 	if (mddev->external_size &&
 	    mddev->array_sectors > size)
 		return -EINVAL;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 928e24a..768767c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7725,6 +7725,8 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 	if (conf->log || raid5_has_ppl(conf))
 		return -EINVAL;
 	sectors &= ~((sector_t)conf->chunk_sectors - 1);
+	if (sectors == 0)
+		return -EINVAL;
 	newsize = raid5_size(mddev, sectors, mddev->raid_disks);
 	if (mddev->external_size &&
 	    mddev->array_sectors > newsize)
-- 
2.6.6

