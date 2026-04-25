Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185F18462;
	Sat, 25 Apr 2026 02:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777085189; cv=none; b=rKRWqxlTRbEBGD4ZMm+zT+FxAnIxLjdkF4DzbGugDbBv9OKzfNCKpjCbsY9N1E0G7kvAGluQ8fjkMLP37VL7WKLcnwLQzYG1eGkpQoMXTBSauwYkAMHtkgkEmgPwY4Ij9//WM9T1HSVQtq7Xax4iaQx2lUXhU1Cn6uX7BTrmiEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777085189; c=relaxed/simple;
	bh=j+8UypclIg8fFVQe8YHsv0pwMGB2YYGf37++QcbGb7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4rNxJqjueorsz1L68gyVWyISvIIpiYon9Ygd++xZ29qWqPBprPo9xQFZhWWIKwaIAwwHJtsOktGBKFPLU6LGeaavaNq4pVxt6mYzpmmAzKM2ercCmb6RSrOcN1Is3bagvoakIdnjuo1CB19g/y8tzg16HHLHtztFjc5zLK+SiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46ED6C19425;
	Sat, 25 Apr 2026 02:46:27 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: Song Liu <song@kernel.org>
Cc: glass.su@suse.com,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v13 1/3] md: factor bitmap creation away from sysfs handling
Date: Sat, 25 Apr 2026 10:46:13 +0800
Message-ID: <20260425024615.1696892-2-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260425024615.1696892-1-yukuai@fnnas.com>
References: <20260425024615.1696892-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Factor bitmap creation and destruction into helpers that do not touch
bitmap sysfs registration.

This prepares the bitmap sysfs rework so callers such as the sysfs
bitmap location path can create or destroy a bitmap backend without
coupling that to sysfs group lifetime management.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.c | 78 +++++++++++++++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 29 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ebaf47fb9de6..99aa1367c991 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -679,7 +679,25 @@ static void active_io_release(struct percpu_ref *ref)
 
 static void no_op(struct percpu_ref *r) {}
 
-static bool mddev_set_bitmap_ops(struct mddev *mddev)
+static void md_bitmap_sysfs_add(struct mddev *mddev)
+{
+	if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
+		pr_warn("md: cannot register extra bitmap attributes for %s\n",
+			mdname(mddev));
+	else
+		/*
+		 * Inform user with KOBJ_CHANGE about new bitmap
+		 * attributes.
+		 */
+		kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
+}
+
+static void md_bitmap_sysfs_del(struct mddev *mddev)
+{
+	sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
+}
+
+static bool mddev_set_bitmap_ops_nosysfs(struct mddev *mddev)
 {
 	struct bitmap_operations *old = mddev->bitmap_ops;
 	struct md_submodule_head *head;
@@ -703,18 +721,6 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
 
 	mddev->bitmap_ops = (void *)head;
 	xa_unlock(&md_submodule);
-
-	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group) {
-		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
-			pr_warn("md: cannot register extra bitmap attributes for %s\n",
-				mdname(mddev));
-		else
-			/*
-			 * Inform user with KOBJ_CHANGE about new bitmap
-			 * attributes.
-			 */
-			kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
-	}
 	return true;
 
 err:
@@ -722,15 +728,6 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
 	return false;
 }
 
-static void mddev_clear_bitmap_ops(struct mddev *mddev)
-{
-	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
-	    mddev->bitmap_ops->group)
-		sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
-
-	mddev->bitmap_ops = NULL;
-}
-
 int mddev_init(struct mddev *mddev)
 {
 	int err = 0;
@@ -6531,7 +6528,7 @@ static enum md_submodule_id md_bitmap_get_id_from_sb(struct mddev *mddev)
 	return id;
 }
 
-static int md_bitmap_create(struct mddev *mddev)
+static int md_bitmap_create_nosysfs(struct mddev *mddev)
 {
 	enum md_submodule_id orig_id = mddev->bitmap_id;
 	enum md_submodule_id sb_id;
@@ -6540,7 +6537,7 @@ static int md_bitmap_create(struct mddev *mddev)
 	if (mddev->bitmap_id == ID_BITMAP_NONE)
 		return -EINVAL;
 
-	if (!mddev_set_bitmap_ops(mddev))
+	if (!mddev_set_bitmap_ops_nosysfs(mddev))
 		return -ENOENT;
 
 	err = mddev->bitmap_ops->create(mddev);
@@ -6552,7 +6549,7 @@ static int md_bitmap_create(struct mddev *mddev)
 	 * doesn't match, and mdadm is not the latest version to set
 	 * bitmap_type, set bitmap_ops based on the disk version.
 	 */
-	mddev_clear_bitmap_ops(mddev);
+	mddev->bitmap_ops = NULL;
 
 	sb_id = md_bitmap_get_id_from_sb(mddev);
 	if (sb_id == ID_BITMAP_NONE || sb_id == orig_id)
@@ -6562,27 +6559,50 @@ static int md_bitmap_create(struct mddev *mddev)
 		mdname(mddev), orig_id, sb_id);
 
 	mddev->bitmap_id = sb_id;
-	if (!mddev_set_bitmap_ops(mddev)) {
+	if (!mddev_set_bitmap_ops_nosysfs(mddev)) {
 		mddev->bitmap_id = orig_id;
 		return -ENOENT;
 	}
 
 	err = mddev->bitmap_ops->create(mddev);
 	if (err) {
-		mddev_clear_bitmap_ops(mddev);
+		mddev->bitmap_ops = NULL;
 		mddev->bitmap_id = orig_id;
 	}
 
 	return err;
 }
 
-static void md_bitmap_destroy(struct mddev *mddev)
+static int md_bitmap_create(struct mddev *mddev)
+{
+	int err;
+
+	err = md_bitmap_create_nosysfs(mddev);
+	if (err)
+		return err;
+
+	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group)
+		md_bitmap_sysfs_add(mddev);
+
+	return 0;
+}
+
+static void md_bitmap_destroy_nosysfs(struct mddev *mddev)
 {
 	if (!md_bitmap_registered(mddev))
 		return;
 
 	mddev->bitmap_ops->destroy(mddev);
-	mddev_clear_bitmap_ops(mddev);
+	mddev->bitmap_ops = NULL;
+}
+
+static void md_bitmap_destroy(struct mddev *mddev)
+{
+	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
+	    mddev->bitmap_ops->group)
+		md_bitmap_sysfs_del(mddev);
+
+	md_bitmap_destroy_nosysfs(mddev);
 }
 
 int md_run(struct mddev *mddev)
-- 
2.51.0

