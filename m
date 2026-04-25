Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452AB146588;
	Sat, 25 Apr 2026 02:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777085191; cv=none; b=Lf6coyo1Txfp6nN4+WnwKdoZX6TpFwus9waGYzey1yDHfP+BMtFWhNEDxaPs+98Y47AQ5LhNX1c+gUKR3OjjhrT1PTn5Ws3st6BF1lgNC+S5f6atVjEi72TPfS+5k3Z+6+J9E/4IypEQ8Rv2m/0V49iSfXkLPw0CS7oPD6/F6Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777085191; c=relaxed/simple;
	bh=fXkgHjDzT0FGJUgFm/p82x/WIzOixbfumqEbkaGe05k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bubQckZGf1HZ9mxoEhp286osU0fkZ2b6oXTPj9a37h24RZaVZhL+kmB6yZkjgvxDas6y2/198UXX4DwrOhlDyL/QVxAKUuEjjjklU56P3ioFDbaOvtChOO0oHopNGwNxLlWYZ1t1Nl8Rdyjn/e6YnX2GF7Qav726BqbEJUszTnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F30C19425;
	Sat, 25 Apr 2026 02:46:29 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: Song Liu <song@kernel.org>
Cc: glass.su@suse.com,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v13 2/3] md/md-bitmap: split bitmap sysfs groups
Date: Sat, 25 Apr 2026 10:46:14 +0800
Message-ID: <20260425024615.1696892-3-yukuai@fnnas.com>
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

Split the classic bitmap sysfs files into a common bitmap group with
the location attribute and a separate internal bitmap group for the
remaining files.

At the same time, convert bitmap operations from a single sysfs group
to a sysfs group array so backends can share part of their sysfs
layout while adding backend-specific attributes separately.

Switch the bitmap sysfs helpers to use sysfs_update_groups() for the
add and update path, and remove groups in reverse order so shared named
groups are unmerged before the last group removes the directory.

Also make bitmap operation lookup depend only on the currently selected
bitmap id matching the installed backend. This prepares the lookup path
for a later registered none backend.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-bitmap.c   | 23 +++++++++++++++++++----
 drivers/md/md-bitmap.h   |  2 +-
 drivers/md/md-llbitmap.c |  7 ++++++-
 drivers/md/md.c          | 21 ++++++++++++++-------
 4 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 83378c033c72..eba649703a1c 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2955,8 +2955,12 @@ static struct md_sysfs_entry max_backlog_used =
 __ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
        behind_writes_used_show, behind_writes_used_reset);
 
-static struct attribute *md_bitmap_attrs[] = {
+static struct attribute *md_bitmap_common_attrs[] = {
 	&bitmap_location.attr,
+	NULL
+};
+
+static struct attribute *md_bitmap_internal_attrs[] = {
 	&bitmap_space.attr,
 	&bitmap_timeout.attr,
 	&bitmap_backlog.attr,
@@ -2967,9 +2971,20 @@ static struct attribute *md_bitmap_attrs[] = {
 	NULL
 };
 
-static struct attribute_group md_bitmap_group = {
+static struct attribute_group md_bitmap_common_group = {
+	.name = "bitmap",
+	.attrs = md_bitmap_common_attrs,
+};
+
+static struct attribute_group md_bitmap_internal_group = {
 	.name = "bitmap",
-	.attrs = md_bitmap_attrs,
+	.attrs = md_bitmap_internal_attrs,
+};
+
+static const struct attribute_group *bitmap_groups[] = {
+	&md_bitmap_common_group,
+	&md_bitmap_internal_group,
+	NULL,
 };
 
 static struct bitmap_operations bitmap_ops = {
@@ -3013,7 +3028,7 @@ static struct bitmap_operations bitmap_ops = {
 	.set_pages		= bitmap_set_pages,
 	.free			= md_bitmap_free,
 
-	.group			= &md_bitmap_group,
+	.groups			= bitmap_groups,
 };
 
 int md_bitmap_init(void)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index b42a28fa83a0..214f623c7e79 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -125,7 +125,7 @@ struct bitmap_operations {
 	void (*set_pages)(void *data, unsigned long pages);
 	void (*free)(void *data);
 
-	struct attribute_group *group;
+	const struct attribute_group **groups;
 };
 
 /* the bitmap API */
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 9e7e6b1a6f15..1adc5b117821 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1738,6 +1738,11 @@ static struct attribute_group md_llbitmap_group = {
 	.attrs = md_llbitmap_attrs,
 };
 
+static const struct attribute_group *md_llbitmap_groups[] = {
+	&md_llbitmap_group,
+	NULL,
+};
+
 static struct bitmap_operations llbitmap_ops = {
 	.head = {
 		.type	= MD_BITMAP,
@@ -1774,7 +1779,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.dirty_bits		= llbitmap_dirty_bits,
 	.write_all		= llbitmap_write_all,
 
-	.group			= &md_llbitmap_group,
+	.groups			= md_llbitmap_groups,
 };
 
 int md_llbitmap_init(void)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 99aa1367c991..0ef81d116191 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -681,7 +681,7 @@ static void no_op(struct percpu_ref *r) {}
 
 static void md_bitmap_sysfs_add(struct mddev *mddev)
 {
-	if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
+	if (sysfs_update_groups(&mddev->kobj, mddev->bitmap_ops->groups))
 		pr_warn("md: cannot register extra bitmap attributes for %s\n",
 			mdname(mddev));
 	else
@@ -694,16 +694,23 @@ static void md_bitmap_sysfs_add(struct mddev *mddev)
 
 static void md_bitmap_sysfs_del(struct mddev *mddev)
 {
-	sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
+	int nr_groups = 0;
+
+	for (nr_groups = 0; mddev->bitmap_ops->groups[nr_groups]; nr_groups++)
+		;
+
+	while (--nr_groups >= 1)
+		sysfs_unmerge_group(&mddev->kobj,
+				    mddev->bitmap_ops->groups[nr_groups]);
+	sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->groups[0]);
 }
 
 static bool mddev_set_bitmap_ops_nosysfs(struct mddev *mddev)
 {
-	struct bitmap_operations *old = mddev->bitmap_ops;
 	struct md_submodule_head *head;
 
-	if (mddev->bitmap_id == ID_BITMAP_NONE ||
-	    (old && old->head.id == mddev->bitmap_id))
+	if (mddev->bitmap_ops &&
+	    mddev->bitmap_ops->head.id == mddev->bitmap_id)
 		return true;
 
 	xa_lock(&md_submodule);
@@ -6581,7 +6588,7 @@ static int md_bitmap_create(struct mddev *mddev)
 	if (err)
 		return err;
 
-	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group)
+	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->groups)
 		md_bitmap_sysfs_add(mddev);
 
 	return 0;
@@ -6599,7 +6606,7 @@ static void md_bitmap_destroy_nosysfs(struct mddev *mddev)
 static void md_bitmap_destroy(struct mddev *mddev)
 {
 	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
-	    mddev->bitmap_ops->group)
+	    mddev->bitmap_ops->groups)
 		md_bitmap_sysfs_del(mddev);
 
 	md_bitmap_destroy_nosysfs(mddev);
-- 
2.51.0

