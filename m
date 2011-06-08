From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] md/raid10: get rid of duplicated conditional expression
Date: Wed,  8 Jun 2011 20:35:25 +0900
Message-ID: <1307532925-1853-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Variable 'first' is initialized to zero and updated to @rdev->raid_disk
only if it is greater than 0. Thus condition '>= first' always implies
'>= 0' so the latter is not needed.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid10.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index fc56bdd8c3fb..fcb86e86bc31 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1093,8 +1093,7 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
 
-	if (rdev->saved_raid_disk >= 0 &&
-	    rdev->saved_raid_disk >= first &&
+	if (rdev->saved_raid_disk >= first &&
 	    conf->mirrors[rdev->saved_raid_disk].rdev == NULL)
 		mirror = rdev->saved_raid_disk;
 	else
-- 
1.7.5.2

