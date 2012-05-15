From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH] md: check the return of mddev_find()
Date: Tue, 15 May 2012 14:26:40 +0800
Message-ID: <1337063200-11174-1-git-send-email-yuanhan.liu@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
List-Id: linux-raid.ids

Check the return of mddev_find(), since it may fail due to out of
memeory or out of usable minor number.

The reason I chose -ENODEV instead of -ENOMEM or something else is
md_alloc() function chose that ;)

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/md/md.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 477eb2e..0bd44e3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6371,6 +6371,9 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 	struct mddev *mddev = mddev_find(bdev->bd_dev);
 	int err;
 
+	if (!mddev)
+		return -ENODEV;
+
 	if (mddev->gendisk != bdev->bd_disk) {
 		/* we are racing with mddev_put which is discarding this
 		 * bd_disk.
-- 
1.7.7.6
