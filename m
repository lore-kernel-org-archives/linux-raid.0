From: NeilBrown <neilb@suse.de>
Subject: [PATCH 006 of 9] md: Lock access to rdev attributes properly
Date: Mon, 3 Mar 2008 11:17:39 +1100
Message-ID: <1080303001739.23653@suse.de>
References: <20080303111240.23302.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


When we access attributes of an rdev (component device on an md array)
through sysfs, we really need to lock the array against concurrent
changes.  We currently do that when we change an attribute, but not
when we read an attribute.  We need to lock when reading as well else
rdev->mddev could become NULL while we are accessing it.

So add appropriate locking (mddev_lock) to rdev_attr_show.

rdev_size_store requires some extra care as well as it needs to unlock
the mddev while scanning other mddevs for overlapping regions.  We
currently assume that rdev->mddev will still be unchanged after the
scan, but that cannot be certain.  So take a copy of rdev->mddev for
use at the end of the function.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-02-22 15:46:52.000000000 +1100
+++ ./drivers/md/md.c	2008-02-22 15:56:20.000000000 +1100
@@ -2001,9 +2001,11 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 	char *e;
 	unsigned long long size = simple_strtoull(buf, &e, 10);
 	unsigned long long oldsize = rdev->size;
+	mddev_t *my_mddev = rdev->mddev;
+
 	if (e==buf || (*e && *e != '\n'))
 		return -EINVAL;
-	if (rdev->mddev->pers)
+	if (my_mddev->pers)
 		return -EBUSY;
 	rdev->size = size;
 	if (size > oldsize && rdev->mddev->external) {
@@ -2016,7 +2018,7 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 		int overlap = 0;
 		struct list_head *tmp, *tmp2;
 
-		mddev_unlock(rdev->mddev);
+		mddev_unlock(my_mddev);
 		for_each_mddev(mddev, tmp) {
 			mdk_rdev_t *rdev2;
 
@@ -2036,7 +2038,7 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 				break;
 			}
 		}
-		mddev_lock(rdev->mddev);
+		mddev_lock(my_mddev);
 		if (overlap) {
 			/* Someone else could have slipped in a size
 			 * change here, but doing so is just silly.
@@ -2048,8 +2050,8 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 			return -EBUSY;
 		}
 	}
-	if (size < rdev->mddev->size || rdev->mddev->size == 0)
-		rdev->mddev->size = size;
+	if (size < my_mddev->size || my_mddev->size == 0)
+		my_mddev->size = size;
 	return len;
 }
 
@@ -2070,10 +2072,21 @@ rdev_attr_show(struct kobject *kobj, str
 {
 	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
 	mdk_rdev_t *rdev = container_of(kobj, mdk_rdev_t, kobj);
+	mddev_t *mddev = rdev->mddev;
+	ssize_t rv;
 
 	if (!entry->show)
 		return -EIO;
-	return entry->show(rdev, page);
+
+	rv = mddev ? mddev_lock(mddev) : -EBUSY;
+	if (!rv) {
+		if (rdev->mddev == NULL)
+			rv = -EBUSY;
+		else
+			rv = entry->show(rdev, page);
+		mddev_unlock(mddev);
+	}
+	return rv;
 }
 
 static ssize_t
@@ -2082,15 +2095,19 @@ rdev_attr_store(struct kobject *kobj, st
 {
 	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
 	mdk_rdev_t *rdev = container_of(kobj, mdk_rdev_t, kobj);
-	int rv;
+	ssize_t rv;
+	mddev_t *mddev = rdev->mddev;
 
 	if (!entry->store)
 		return -EIO;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	rv = mddev_lock(rdev->mddev);
+	rv = mddev ? mddev_lock(mddev): -EBUSY;
 	if (!rv) {
-		rv = entry->store(rdev, page, length);
+		if (rdev->mddev == NULL)
+			rv = -EBUSY;
+		else
+			rv = entry->store(rdev, page, length);
 		mddev_unlock(rdev->mddev);
 	}
 	return rv;
