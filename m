From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 6/8] md: get_disk_info(): Don't convert between signed and unsigned and back.
Date: Sat, 29 Mar 2008 20:12:07 +0100
Message-ID: <S1755775AbYGHQdl/20080708163342Z+63@vger.kernel.org>
References: <20080708155541.GS23944@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080708155541.GS23944@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

The current code copies a signed int from user space, converts it to
unsigned and passes the unsigned value to find_rdev_nr() which expects
a signed value. Simply pass the signed value from user space directly.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 90b6d1d..3f22ec7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4025,15 +4025,12 @@ out:
 static int get_disk_info(mddev_t * mddev, void __user * arg)
 {
 	mdu_disk_info_t info;
-	unsigned int nr;
 	mdk_rdev_t *rdev;
 
 	if (copy_from_user(&info, arg, sizeof(info)))
 		return -EFAULT;
 
-	nr = info.number;
-
-	rdev = find_rdev_nr(mddev, nr);
+	rdev = find_rdev_nr(mddev, info.number);
 	if (rdev) {
 		info.major = MAJOR(rdev->bdev->bd_dev);
 		info.minor = MINOR(rdev->bdev->bd_dev);
-- 
1.5.3.8

