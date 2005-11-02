From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 001 of 10] Make sure /block link in /sys/.../md/ goes to correct devices.
Date: Wed, 2 Nov 2005 21:14:52 +1100
Message-ID: <1051102101452.23840@suse.de>
References: <20051102205640.22689.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, Greg KH <greg@kroah.com>
List-Id: linux-raid.ids


If a block_device is a partition, then it's kobject is
  bdev->bd_part->kobj
otherwise (if it is a full device), the kobject is 
  bdev->bd_disk->kobj

As md wants back-links to the correct object (whether partition or
not), we need to respect this difference...
(Thus current code shows a link to the whole device, whether we are
using a partition or not, which is wrong).

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-11-02 17:32:28.000000000 +1100
+++ ./drivers/md/md.c	2005-11-02 17:32:41.000000000 +1100
@@ -1182,6 +1182,7 @@ static int bind_rdev_to_array(mdk_rdev_t
 {
 	mdk_rdev_t *same_pdev;
 	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
+	struct kobject *ko;
 
 	if (rdev->mddev) {
 		MD_BUG();
@@ -1221,7 +1222,11 @@ static int bind_rdev_to_array(mdk_rdev_t
 	rdev->kobj.parent = &mddev->kobj;
 	kobject_add(&rdev->kobj);
 
-	sysfs_create_link(&rdev->kobj, &rdev->bdev->bd_disk->kobj, "block");
+	if (rdev->bdev->bd_part)
+		ko = &rdev->bdev->bd_part->kobj;
+	else
+		ko = &rdev->bdev->bd_disk->kobj;
+	sysfs_create_link(&rdev->kobj, ko, "block");
 	return 0;
 }
 
