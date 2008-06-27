From: NeilBrown <neilb@suse.de>
Subject: [PATCH 013 of 29] md: Don't reject HOT_REMOVE_DISK request for an array that is not yet started.
Date: Fri, 27 Jun 2008 16:50:44 +1000
Message-ID: <1080627065044.10508@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


There is really no need for this test here, and there are valid
cases for selectively removing devices from an array that
it not actually active.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    3 ---
 1 file changed, 3 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 16:20:38.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 16:22:01.000000000 +1000
@@ -4300,9 +4300,6 @@ static int hot_remove_disk(mddev_t * mdd
 	char b[BDEVNAME_SIZE];
 	mdk_rdev_t *rdev;
 
-	if (!mddev->pers)
-		return -ENODEV;
-
 	rdev = find_rdev(mddev, dev);
 	if (!rdev)
 		return -ENXIO;
