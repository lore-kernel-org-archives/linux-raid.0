From: NeilBrown <neilb@suse.de>
Subject: [PATCH 005 of 7] md: Lock address when changing attributes of component devices.
Date: Fri, 14 Dec 2007 17:26:35 +1100
Message-ID: <1071214062635.1891@suse.de>
References: <20071214171950.1308.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-12-14 16:09:01.000000000 +1100
+++ ./drivers/md/md.c	2007-12-14 16:09:03.000000000 +1100
@@ -2080,12 +2080,18 @@ rdev_attr_store(struct kobject *kobj, st
 {
 	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
 	mdk_rdev_t *rdev = container_of(kobj, mdk_rdev_t, kobj);
+	int rv;
 
 	if (!entry->store)
 		return -EIO;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	return entry->store(rdev, page, length);
+	rv = mddev_lock(rdev->mddev);
+	if (!rv) {
+		rv = entry->store(rdev, page, length);
+		mddev_unlock(rdev->mddev);
+	}
+	return rv;
 }
 
 static void rdev_free(struct kobject *ko)
