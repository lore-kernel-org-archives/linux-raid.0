From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 8/8] md: Simplify update_size().
Date: Fri, 25 Apr 2008 20:20:56 +0200
Message-ID: <S1754061AbYGHQUr/20080708162047Z+45@vger.kernel.org>
References: <20080708155541.GS23944@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080708155541.GS23944@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

The condition avail < ((sector_t)size << 1) is equivalent to
avail/2 < size and is thus never true because in this case we
set size = avail/2 in the line preceeding this test.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 98a024c..f4087bb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4474,15 +4474,9 @@ static int update_size(mddev_t *mddev, unsigned long size)
 	 */
 	if (mddev->sync_thread)
 		return -EBUSY;
-	rdev_for_each(rdev, tmp, mddev) {
-		sector_t avail;
-		avail = rdev->size * 2;
-
-		if (size == 0 || size > avail/2)
-			size = avail/2;
-		if (avail < ((sector_t)size << 1))
-			return -ENOSPC;
-	}
+	rdev_for_each(rdev, tmp, mddev)
+		if (size == 0 || size > rdev->size)
+			size = rdev->size;
 	rv = mddev->pers->resize(mddev, (sector_t)size *2);
 	if (!rv) {
 		struct block_device *bdev;
-- 
1.5.3.8
