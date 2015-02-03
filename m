From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 18/26] md: remove mddev_lock from rdev_attr_show()
Date: Wed, 04 Feb 2015 08:42:29 +1100
Message-ID: <20150203214229.3448.28776.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

No rdev attributes need locking for 'show', though
state_show() might benefit from ensuring it sees a
consistent set of flags.

None even use rdev->mddev, so testing for it isn't really
needed and it certainly doesn't need to be held constant.

So improve state_show() and remove the locking.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b7f48238a92d..cbbac7b7238a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2419,40 +2419,41 @@ state_show(struct md_rdev *rdev, char *page)
 {
 	char *sep = "";
 	size_t len = 0;
+	unsigned long flags = ACCESS_ONCE(rdev->flags);
 
-	if (test_bit(Faulty, &rdev->flags) ||
+	if (test_bit(Faulty, &flags) ||
 	    rdev->badblocks.unacked_exist) {
 		len+= sprintf(page+len, "%sfaulty",sep);
 		sep = ",";
 	}
-	if (test_bit(In_sync, &rdev->flags)) {
+	if (test_bit(In_sync, &flags)) {
 		len += sprintf(page+len, "%sin_sync",sep);
 		sep = ",";
 	}
-	if (test_bit(WriteMostly, &rdev->flags)) {
+	if (test_bit(WriteMostly, &flags)) {
 		len += sprintf(page+len, "%swrite_mostly",sep);
 		sep = ",";
 	}
-	if (test_bit(Blocked, &rdev->flags) ||
+	if (test_bit(Blocked, &flags) ||
 	    (rdev->badblocks.unacked_exist
-	     && !test_bit(Faulty, &rdev->flags))) {
+	     && !test_bit(Faulty, &flags))) {
 		len += sprintf(page+len, "%sblocked", sep);
 		sep = ",";
 	}
-	if (!test_bit(Faulty, &rdev->flags) &&
-	    !test_bit(In_sync, &rdev->flags)) {
+	if (!test_bit(Faulty, &flags) &&
+	    !test_bit(In_sync, &flags)) {
 		len += sprintf(page+len, "%sspare", sep);
 		sep = ",";
 	}
-	if (test_bit(WriteErrorSeen, &rdev->flags)) {
+	if (test_bit(WriteErrorSeen, &flags)) {
 		len += sprintf(page+len, "%swrite_error", sep);
 		sep = ",";
 	}
-	if (test_bit(WantReplacement, &rdev->flags)) {
+	if (test_bit(WantReplacement, &flags)) {
 		len += sprintf(page+len, "%swant_replacement", sep);
 		sep = ",";
 	}
-	if (test_bit(Replacement, &rdev->flags)) {
+	if (test_bit(Replacement, &flags)) {
 		len += sprintf(page+len, "%sreplacement", sep);
 		sep = ",";
 	}
@@ -2965,21 +2966,12 @@ rdev_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 {
 	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
 	struct md_rdev *rdev = container_of(kobj, struct md_rdev, kobj);
-	struct mddev *mddev = rdev->mddev;
-	ssize_t rv;
 
 	if (!entry->show)
 		return -EIO;
-
-	rv = mddev ? mddev_lock(mddev) : -EBUSY;
-	if (!rv) {
-		if (rdev->mddev == NULL)
-			rv = -EBUSY;
-		else
-			rv = entry->show(rdev, page);
-		mddev_unlock(mddev);
-	}
-	return rv;
+	if (!rdev->mddev)
+		return -EBUSY;
+	return entry->show(rdev, page);
 }
 
 static ssize_t


