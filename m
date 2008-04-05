From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 7/8] md: update_size(): Remove useless variable "fit".
Date: Sat, 5 Apr 2008 15:54:49 +0200
Message-ID: <S1756174AbYGHQdn/20080708163344Z+61@vger.kernel.org>
References: <20080708155541.GS23944@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080708155541.GS23944@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3f22ec7..98a024c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4459,7 +4459,6 @@ static int update_size(mddev_t *mddev, unsigned long size)
 	mdk_rdev_t * rdev;
 	int rv;
 	struct list_head *tmp;
-	int fit = (size == 0);
 
 	if (mddev->pers->resize == NULL)
 		return -EINVAL;
@@ -4479,7 +4478,7 @@ static int update_size(mddev_t *mddev, unsigned long size)
 		sector_t avail;
 		avail = rdev->size * 2;
 
-		if (fit && (size == 0 || size > avail/2))
+		if (size == 0 || size > avail/2)
 			size = avail/2;
 		if (avail < ((sector_t)size << 1))
 			return -ENOSPC;
-- 
1.5.3.8

