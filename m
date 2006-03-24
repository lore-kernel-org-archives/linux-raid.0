From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 3] md: Fix md grow/size code to correctly find the maximum available space.
Date: Fri, 24 Mar 2006 17:00:01 +1100
Message-ID: <1060324060001.2459@suse.de>
References: <20060324165531.2372.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1423161AbWCXGCF@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


An md array can be asked to change the amount of each device that it
is using, and in particular can be asked to use the maximum available
space.  This currently only works if the first device is not larger
than the rest.  As 'size' gets changed and so 'fit' becomes wrong.
So check if a 'fit' is required early and don't corrupt it.

Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-03-24 14:01:30.000000000 +1100
+++ ./drivers/md/md.c	2006-03-24 14:06:49.000000000 +1100
@@ -3575,6 +3575,7 @@ static int update_size(mddev_t *mddev, u
 	mdk_rdev_t * rdev;
 	int rv;
 	struct list_head *tmp;
+	int fit = (size == 0);
 
 	if (mddev->pers->resize == NULL)
 		return -EINVAL;
@@ -3592,7 +3593,6 @@ static int update_size(mddev_t *mddev, u
 		return -EBUSY;
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		sector_t avail;
-		int fit = (size == 0);
 		if (rdev->sb_offset > rdev->data_offset)
 			avail = (rdev->sb_offset*2) - rdev->data_offset;
 		else
