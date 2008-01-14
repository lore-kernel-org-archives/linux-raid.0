From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 002 of 6] md: Fix use-after-free bug when dropping an rdev from an md array.
Date: Mon, 14 Jan 2008 17:28:44 +1100
Message-ID: <18315.284.774998.348672@notabene.brown>
References: <20080114123726.19968.patches@notabene>
	<1080114014531.20354@suse.de>
	<20080114020459.GN27894@ZenIV.linux.org.uk>
	<18314.54601.196877.828373@notabene.brown>
	<20080114034322.GO27894@ZenIV.linux.org.uk>
	<18314.59832.14451.334084@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Monday January 14
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 14, neilb@suse.de wrote:
> 
> Thanks.  I'll see what I can some up with.

How about this, against current -mm

On both the read and write path for an rdev attribute, we
call mddev_lock, first checking that mddev is not NULL.
Once we get the lock, we check again.
If rdev->mddev is not NULL, we know it will stay that way as it only
gets cleared under the same lock.

While in the rdev show/store routines, we know that the mddev cannot
get freed, do to the kobject relationships.

rdev_size_store is awkward because it has to drop the lock.  So we
take a copy of rdev->mddev before the drop, and we are safe...

Comments?

NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-01-14 12:26:15.000000000 +1100
+++ ./drivers/md/md.c	2008-01-14 17:05:53.000000000 +1100
@@ -1998,9 +1998,11 @@ rdev_size_store(mdk_rdev_t *rdev, const 
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
@@ -2013,7 +2015,7 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 		int overlap = 0;
 		struct list_head *tmp, *tmp2;
 
-		mddev_unlock(rdev->mddev);
+		mddev_unlock(my_mddev);
 		for_each_mddev(mddev, tmp) {
 			mdk_rdev_t *rdev2;
 
@@ -2033,7 +2035,7 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 				break;
 			}
 		}
-		mddev_lock(rdev->mddev);
+		mddev_lock(my_mddev);
 		if (overlap) {
 			/* Someone else could have slipped in a size
 			 * change here, but doing so is just silly.
@@ -2045,8 +2047,8 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 			return -EBUSY;
 		}
 	}
-	if (size < rdev->mddev->size || rdev->mddev->size == 0)
-		rdev->mddev->size = size;
+	if (size < my_mddev->size || my_mddev->size == 0)
+		my_mddev->size = size;
 	return len;
 }
 
@@ -2067,10 +2069,21 @@ rdev_attr_show(struct kobject *kobj, str
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
@@ -2079,15 +2092,19 @@ rdev_attr_store(struct kobject *kobj, st
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
