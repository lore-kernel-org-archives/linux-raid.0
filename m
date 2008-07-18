From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 1/4] md: Fix check for overlapping devices.
Date: Fri, 18 Jul 2008 14:00:16 +0200
Message-ID: <1216382419-2560-2-git-send-email-maan@systemlinux.org>
References: <1216382419-2560-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1216382419-2560-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

The checks in overlaps() expect all parameters either in block-based
or sector-based quantities. However, its single caller passes two
rdev->data_offset arguments as well as two rdev->size arguments, the
former being sector counts while the latter are measured in 1K blocks.

This could cause rdev_size_store() to accept an invalid size from user
space. Fix it by passing only sector-based quantities to overlaps().

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 95466bb..1bfa1f2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2143,8 +2143,8 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 				if (test_bit(AllReserved, &rdev2->flags) ||
 				    (rdev->bdev == rdev2->bdev &&
 				     rdev != rdev2 &&
-				     overlaps(rdev->data_offset, rdev->size,
-					    rdev2->data_offset, rdev2->size))) {
+				     overlaps(rdev->data_offset, rdev->size * 2,
+					    rdev2->data_offset, rdev2->size * 2))) {
 					overlap = 1;
 					break;
 				}
-- 
1.5.3.8

