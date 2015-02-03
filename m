From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 17/26] md: remove mddev_lock() from md_attr_show()
Date: Wed, 04 Feb 2015 08:42:29 +1100
Message-ID: <20150203214229.3448.46056.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Most attributes can be read safely without any locking.
A race might lead to a slightly out-dated value, but nothing wrong.

We already have locking in some places where needed.
All that remains is can_clear_show(), behind_writes_used_show()
and action_show() which are easily fixed.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |   13 ++++++++++---
 drivers/md/md.c     |   23 ++++++++++-------------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 3424b1915fc4..3a5767968ba0 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -2211,11 +2211,13 @@ __ATTR(metadata, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
 static ssize_t can_clear_show(struct mddev *mddev, char *page)
 {
 	int len;
+	spin_lock(&mddev->lock);
 	if (mddev->bitmap)
 		len = sprintf(page, "%s\n", (mddev->bitmap->need_sync ?
 					     "false" : "true"));
 	else
 		len = sprintf(page, "\n");
+	spin_unlock(&mddev->lock);
 	return len;
 }
 
@@ -2240,10 +2242,15 @@ __ATTR(can_clear, S_IRUGO|S_IWUSR, can_clear_show, can_clear_store);
 static ssize_t
 behind_writes_used_show(struct mddev *mddev, char *page)
 {
+	ssize_t ret;
+	spin_lock(&mddev->lock);
 	if (mddev->bitmap == NULL)
-		return sprintf(page, "0\n");
-	return sprintf(page, "%lu\n",
-		       mddev->bitmap->behind_writes_used);
+		ret = sprintf(page, "0\n");
+	else
+		ret = sprintf(page, "%lu\n",
+			      mddev->bitmap->behind_writes_used);
+	spin_unlock(&mddev->lock);
+	return ret;
 }
 
 static ssize_t
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4caa414fe6a3..b7f48238a92d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4042,20 +4042,21 @@ static ssize_t
 action_show(struct mddev *mddev, char *page)
 {
 	char *type = "idle";
-	if (test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
+	unsigned long recovery = mddev->recovery;
+	if (test_bit(MD_RECOVERY_FROZEN, &recovery))
 		type = "frozen";
-	else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
-	    (!mddev->ro && test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))) {
-		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
+	else if (test_bit(MD_RECOVERY_RUNNING, &recovery) ||
+	    (!mddev->ro && test_bit(MD_RECOVERY_NEEDED, &recovery))) {
+		if (test_bit(MD_RECOVERY_RESHAPE, &recovery))
 			type = "reshape";
-		else if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
-			if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+		else if (test_bit(MD_RECOVERY_SYNC, &recovery)) {
+			if (!test_bit(MD_RECOVERY_REQUESTED, &recovery))
 				type = "resync";
-			else if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
+			else if (test_bit(MD_RECOVERY_CHECK, &recovery))
 				type = "check";
 			else
 				type = "repair";
-		} else if (test_bit(MD_RECOVERY_RECOVER, &mddev->recovery))
+		} else if (test_bit(MD_RECOVERY_RECOVER, &recovery))
 			type = "recover";
 	}
 	return sprintf(page, "%s\n", type);
@@ -4572,11 +4573,7 @@ md_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 	mddev_get(mddev);
 	spin_unlock(&all_mddevs_lock);
 
-	rv = mddev_lock(mddev);
-	if (!rv) {
-		rv = entry->show(mddev, page);
-		mddev_unlock(mddev);
-	}
+	rv = entry->show(mddev, page);
 	mddev_put(mddev);
 	return rv;
 }


