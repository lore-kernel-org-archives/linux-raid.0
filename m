From: NeilBrown <neilb@suse.de>
Subject: [PATCH] md: Remove the 'super' sysfs attribute from devices in an 'md' array.
Date: Fri, 14 Mar 2008 15:38:25 +1100
Message-ID: <1080314043825.11111@suse.de>
References: <20080314153739.11056.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Exposing the binary blob which is the md 'super-block' via sysfs
doesn't really fit with the sysfs model, and since commit
   8118a859dc7abd873193986c77a8d9bdb877adc8
it doesn't actually work at all (as the size of the blob is often one page).

So just remove it altogether.  It isn't really useful.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   12 ------------
 1 file changed, 12 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-03-14 15:16:48.000000000 +1100
+++ ./drivers/md/md.c	2008-03-14 15:18:12.000000000 +1100
@@ -1864,17 +1864,6 @@ static struct rdev_sysfs_entry rdev_stat
 __ATTR(state, S_IRUGO|S_IWUSR, state_show, state_store);
 
 static ssize_t
-super_show(mdk_rdev_t *rdev, char *page)
-{
-	if (rdev->sb_loaded && rdev->sb_size) {
-		memcpy(page, page_address(rdev->sb_page), rdev->sb_size);
-		return rdev->sb_size;
-	} else
-		return 0;
-}
-static struct rdev_sysfs_entry rdev_super = __ATTR_RO(super);
-
-static ssize_t
 errors_show(mdk_rdev_t *rdev, char *page)
 {
 	return sprintf(page, "%d\n", atomic_read(&rdev->corrected_errors));
@@ -2060,7 +2049,6 @@ __ATTR(size, S_IRUGO|S_IWUSR, rdev_size_
 
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
-	&rdev_super.attr,
 	&rdev_errors.attr,
 	&rdev_slot.attr,
 	&rdev_offset.attr,
