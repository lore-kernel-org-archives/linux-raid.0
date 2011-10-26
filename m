From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 02/16] md: take after reference to mddev during sysfs
 access.
Date: Wed, 26 Oct 2011 12:43:00 +1100
Message-ID: <20111026014300.21110.60661.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When we are accessing an mddev via sysfs we know that the
mddev cannot disappear because it has an embedded kobj which
is refcounted by sysfs.
And we also take the mddev_lock.
However this is not enough.

The final mddev_put could have been called and the
mddev_delayed_delete is waiting for sysfs to let go so it can destroy
the kobj and mddev.
In this state there are a lot of changes that should not be attempted.

To to guard against this we:
 - initialise mddev->all_mddevs in on last put so the state can be
   easily detected.
 - in md_attr_show and md_attr_store, check ->all_mddevs under
   all_mddevs_lock and mddev_get the mddev if it still appears to
   be active.

This means that if we get to sysfs as the mddev is being deleted we
will get -EBUSY.

rdev_attr_store and rdev_attr_show are similar but already have
sufficient protection.  They check that rdev->mddev still points to
mddev after taking mddev_lock.  As this is cleared  before delayed
removal which can only be requested under the mddev_lock, this
ensure the rdev and mddev are still alive.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fd68243..5905526 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -573,7 +573,7 @@ static void mddev_put(struct mddev *mddev)
 	    mddev->ctime == 0 && !mddev->hold_active) {
 		/* Array is not configured at all, and not held active,
 		 * so destroy it */
-		list_del(&mddev->all_mddevs);
+		list_del_init(&mddev->all_mddevs);
 		bs = mddev->bio_set;
 		mddev->bio_set = NULL;
 		if (mddev->gendisk) {
@@ -4492,11 +4492,20 @@ md_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 
 	if (!entry->show)
 		return -EIO;
+	spin_lock(&all_mddevs_lock);
+	if (list_empty(&mddev->all_mddevs)) {
+		spin_unlock(&all_mddevs_lock);
+		return -EBUSY;
+	}
+	mddev_get(mddev);
+	spin_unlock(&all_mddevs_lock);
+
 	rv = mddev_lock(mddev);
 	if (!rv) {
 		rv = entry->show(mddev, page);
 		mddev_unlock(mddev);
 	}
+	mddev_put(mddev);
 	return rv;
 }
 
@@ -4512,11 +4521,19 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 		return -EIO;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
+	spin_lock(&all_mddevs_lock);
+	if (list_empty(&mddev->all_mddevs)) {
+		spin_unlock(&all_mddevs_lock);
+		return -EBUSY;
+	}
+	mddev_get(mddev);
+	spin_unlock(&all_mddevs_lock);
 	rv = mddev_lock(mddev);
 	if (!rv) {
 		rv = entry->store(mddev, page, length);
 		mddev_unlock(mddev);
 	}
+	mddev_put(mddev);
 	return rv;
 }
 


