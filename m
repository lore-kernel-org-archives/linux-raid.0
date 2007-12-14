From: NeilBrown <neilb@suse.de>
Subject: [PATCH 006 of 7] md: Allow an md array to appear with 0 drives if it has external metadata.
Date: Fri, 14 Dec 2007 17:26:41 +1100
Message-ID: <1071214062641.1908@suse.de>
References: <20071214171950.1308.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-12-14 16:09:03.000000000 +1100
+++ ./drivers/md/md.c	2007-12-14 16:09:09.000000000 +1100
@@ -4650,9 +4650,10 @@ static int md_ioctl(struct inode *inode,
 	 */
 	/* if we are not initialised yet, only ADD_NEW_DISK, STOP_ARRAY,
 	 * RUN_ARRAY, and GET_ and SET_BITMAP_FILE are allowed */
-	if (!mddev->raid_disks && cmd != ADD_NEW_DISK && cmd != STOP_ARRAY
-			&& cmd != RUN_ARRAY && cmd != SET_BITMAP_FILE
-	    		&& cmd != GET_BITMAP_FILE) {
+	if ((!mddev->raid_disks && !mddev->external)
+	    && cmd != ADD_NEW_DISK && cmd != STOP_ARRAY
+	    && cmd != RUN_ARRAY && cmd != SET_BITMAP_FILE
+	    && cmd != GET_BITMAP_FILE) {
 		err = -ENODEV;
 		goto abort_unlock;
 	}
