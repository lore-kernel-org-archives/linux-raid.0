Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5583A9D92
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 10:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775557613; cv=none; b=um3dbpc96ofwkI/kQ1S6VYrJGv4PGaZMGhD4enlPw3nuSUs0Loj8OxeyCN6YYBnIgA8u/8eryl/ODQL4Oy0KqCumg4zog6MkcBD0hVSSoJY+L5A4xssUJClG6SNf7c5LLJSjqgiOChX+FOdYnzlnFJJMzBo6+aO6dlWq8G2FSv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775557613; c=relaxed/simple;
	bh=ec0T5+dSSiziXQZ8m6cfbClFUmspgg6ML6xsz093RDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkQQpkqmuKfUOKk6AVRZWL5Om50sVLJumdGCTndn5BtL+NBN9UNBKzU+TijYvWg5pLRYxevXCdCfZ+NyjEkXfKaIAl4uEP7Z2YAd7CqEJx67HC0fFWMjCU1cEQCuk5kyRUmruHG2IZNyDuucmT0L2GgqDNHNvaACvViesCVkovQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SJUuD+0+; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SJUuD+0+"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4887f49ec5aso66278195e9.1
        for <linux-raid@vger.kernel.org>; Tue, 07 Apr 2026 03:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775557610; x=1776162410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pHGnWNTcauy0nOTpQe9UEhrHN7VUJf8Bn9kq0mIOyVU=;
        b=SJUuD+0+sviCKiLs4Q536VKkpnUw1H+LQ3+X8DJweI4mGisRcBfWtI9KJmc8qfE0vT
         6Ai6r2WHMpFqZGnesfe9VXqZlQnSwvkdtNy8wQnDWShp0biO4cqVl2mHc+FaeqGCxMgU
         JwJw0kbBJ4e6TYMqCidEw9AoKDGo6NSkWmy//+/htJR1xhDsEV1oSt+zYb/qnOIju6e1
         d6Wu9DxFt2XfoE/2/fg0pywpz2KZcD3YYlMavbt0Qc0PNk59eAp2Z0PffrxCCmrlSt8t
         vGvIh1qgix+/T8iF2R1OfR65LOE4zg8p25puaddsxq7muGyKA9L2FLHVWdIqqn3LyfXC
         HuRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775557610; x=1776162410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pHGnWNTcauy0nOTpQe9UEhrHN7VUJf8Bn9kq0mIOyVU=;
        b=Rl/eN08/jDRrHHEM3i3aloZmTBTYqGL4TVTYXd3I/vACkqgj7tvaSK2vtDpYvg0TC/
         XJXwYFLObwhkvlJw7AUPu03ZxCdr00yxlp2+4f365Cy4G1Wj/mEiHD5Ut61HlhZX4RrA
         ayYPBtgHN9oPwlwkId7PLMWXIZPp5SKEIPvPvnHQASAHW+l/9GOGjpTK81bUMs4KQFtP
         towTABlg4XEzp+LSphCC7EY7BCAwaLAQNj3Yhv2bQ1SK+6/TDWzYPCZY8OFaow4j0luE
         zoOnLAtyJ1hhw7TnQbENhP42QTllS02ZaxSMR4QdY6edd896bwbkLuolDaoJc4V92JXl
         jc0Q==
X-Gm-Message-State: AOJu0Yy+TkvAhWOhkjklXBni9A8bj1pMgDuX8ABu2TPQ9nAn1z1B+qph
	AQqL1dtSdER7tGoxgBMIqy9E12VuR3W96ki3Wy3cjtTUule/sMJMLv04XWNxzAzQM0upcYRMPng
	HbZMIrAIQ1w==
X-Gm-Gg: AeBDiettrRH70SBHbTHN3EWp+Y0XT0u81Rq3wJqQh5ZI64mVTQjWNoLwOHDzYDJv8L4
	jFhGURxinkHefL85fI6RW/tZyXjl5LWXL4zg9E9VCSymkgM5p+OSBRFwpEGT+eBELSD+e7pD0df
	/e/LLuMBZKYFrPg4XDSQu6DuAS5n0FlD9HvmrXONCN/MhFDLrHE49U4peXfLzGu6cTmvDb9A5nK
	M0JLcw0lUouKHYk3ww055Tzy6WTGCoKrm1ohXsGBNHNEx4R4tPLs8o/3Ry9qGjMu4qscS//gyo0
	ZifhrBcAUoU6cKXMYbY4yYMgbDQMqoP9wa/mwlX4CmrTEty7/hYm+Vdi4iSalHjYdnVidcgTuZU
	g5kf+a1qbKxHcJIAfqh9+0D8I9IwjwaGvD3JJDskH/up2gzsm577gKt3Is1aJkBiGpE1UbC/GF8
	dXXF+fTeV89mxKrCoFfkmAFmt7IRTan5wAnZ/VqBRf
X-Received: by 2002:a05:600c:1381:b0:487:1108:48af with SMTP id 5b1f17b1804b1-488996a351bmr231100825e9.4.1775557609575;
        Tue, 07 Apr 2026 03:26:49 -0700 (PDT)
Received: from mbp.lan ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca760b0518sm16483880eec.0.2026.04.07.03.26.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Apr 2026 03:26:48 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	xni@redhat.com,
	linan122@huawei.com,
	yukuai@fnnas.com,
	heming.zhao@suse.com,
	l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2 3/5] md/md-bitmap: add dummy bitmap ops for none to fix wrong bitmap offset
Date: Tue,  7 Apr 2026 18:26:23 +0800
Message-ID: <20260407102625.5686-4-glass.su@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260407102625.5686-1-glass.su@suse.com>
References: <20260407102625.5686-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before commit fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_ops until creating bitmap")
if CONFIG_MD_BITMAP is enabled, both bitmap none, internal and clustered have
the sysfs file bitmap/location.

After the commit, if bitmap is none, bitmap/location doesn't exist anymore.
It breaks 'grow' behavior of a md array of madam with MD_FEATURE_BITMAP_OFFSET.
Take level=mirror and metadata=1.2 as an example:

$ mdadm  --create  /dev/md0 -f --bitmap=none --raid-devices=2 --level=mirror \
  --metadata=1.2 /dev/vdd /dev/vde
$ mdadm --grow /dev/md0 --bitmap=internal
$ cat /sys/block/md0/md/bitmap/location
Before:+8
After: +2

While growing bitmap from none to internal, clustered and llbitmap,
mdadm/Grow.c:Grow_addbitmap() tries to detect bitmap/location first.
1)If bitmap/location exists, it sets bitmap/location after getinfo_super().
2)If bitmap/location doesn't exist, mdadm just calls md_set_array_info() then
mddev->bitmap_info.default_offset will be used.
Situation can be worse if growing none to clustered, bitmap offset of the node
calling `madm --grow` will be changed but the other node are reading bitmap sb from
the old location.

Here introducing a dummy bitmap_operations for ID_BITMAP_NONE to restore sysfs
file bitmap/location for ID_BITMAP_NONE and ID_BITMAP.
location_store() now calls md_bitmap_(create|destroy) with false sysfs parameter then
(add,remove)_internal_bitmap() will be called to manage sysfs entries.

Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_ops until creating bitmap")
Suggested-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Su Yue <glass.su@suse.com>
---
 drivers/md/md-bitmap.c   | 116 ++++++++++++++++++++++++++++++++++++---
 drivers/md/md-bitmap.h   |   3 +
 drivers/md/md-llbitmap.c |  12 ++++
 drivers/md/md.c          |  16 +++---
 4 files changed, 130 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index ac06c9647bf0..a8a176428c61 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -240,6 +240,11 @@ static bool bitmap_enabled(void *data, bool flush)
 	       bitmap->storage.filemap != NULL;
 }
 
+static bool dummy_bitmap_enabled(void *data, bool flush)
+{
+	return false;
+}
+
 /*
  * check a page and, if necessary, allocate it (or hijack it if the alloc fails)
  *
@@ -2201,6 +2206,11 @@ static int bitmap_create(struct mddev *mddev)
 	return 0;
 }
 
+static int dummy_bitmap_create(struct mddev *mddev)
+{
+	return 0;
+}
+
 static int bitmap_load(struct mddev *mddev)
 {
 	int err = 0;
@@ -2594,6 +2604,9 @@ location_show(struct mddev *mddev, char *page)
 	return len;
 }
 
+static int create_internal_group(struct mddev *mddev);
+static void remove_internal_group(struct mddev *mddev);
+
 static ssize_t
 location_store(struct mddev *mddev, const char *buf, size_t len)
 {
@@ -2618,7 +2631,8 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			goto out;
 		}
 
-		md_bitmap_destroy(mddev, true);
+		md_bitmap_destroy(mddev, false);
+		remove_internal_group(mddev);
 		mddev->bitmap_info.offset = 0;
 		if (mddev->bitmap_info.file) {
 			struct file *f = mddev->bitmap_info.file;
@@ -2659,14 +2673,22 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			 */
 			mddev->bitmap_id = ID_BITMAP;
 			mddev->bitmap_info.offset = offset;
-			rv = md_bitmap_create(mddev, true);
+			rv = md_bitmap_create(mddev, false);
 			if (rv)
 				goto out;
 
+			rv = create_internal_group(mddev);
+			if (rv) {
+				mddev->bitmap_info.offset = 0;
+				bitmap_destroy(mddev);
+				goto out;
+			}
+
 			rv = bitmap_load(mddev);
 			if (rv) {
+				remove_internal_group(mddev);
 				mddev->bitmap_info.offset = 0;
-				md_bitmap_destroy(mddev, true);
+				md_bitmap_destroy(mddev, false);
 				goto out;
 			}
 		}
@@ -2960,8 +2982,7 @@ static struct md_sysfs_entry max_backlog_used =
 __ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
        behind_writes_used_show, behind_writes_used_reset);
 
-static struct attribute *md_bitmap_attrs[] = {
-	&bitmap_location.attr,
+static struct attribute *internal_bitmap_attrs[] = {
 	&bitmap_space.attr,
 	&bitmap_timeout.attr,
 	&bitmap_backlog.attr,
@@ -2972,11 +2993,57 @@ static struct attribute *md_bitmap_attrs[] = {
 	NULL
 };
 
-static struct attribute_group md_bitmap_group = {
+static struct attribute_group internal_bitmap_group = {
 	.name = "bitmap",
-	.attrs = md_bitmap_attrs,
+	.attrs = internal_bitmap_attrs,
 };
 
+/* Only necessary attrs for compatibility */
+static struct attribute *common_bitmap_attrs[] = {
+	&bitmap_location.attr,
+	NULL
+};
+
+static const struct attribute_group common_bitmap_group = {
+	.name = "bitmap",
+	.attrs = common_bitmap_attrs,
+};
+
+static int create_internal_group(struct mddev *mddev)
+{
+	/*
+	 * md_bitmap_group and md_bitmap_common_group are using same name
+	 * 'bitmap'.
+	 */
+	return sysfs_merge_group(&mddev->kobj, &internal_bitmap_group);
+}
+
+static void remove_internal_group(struct mddev *mddev)
+{
+	sysfs_unmerge_group(&mddev->kobj, &internal_bitmap_group);
+}
+
+static int bitmap_register_groups(struct mddev *mddev)
+{
+	int ret;
+
+	ret = sysfs_create_group(&mddev->kobj, &common_bitmap_group);
+
+	if (ret)
+		return ret;
+
+	ret = sysfs_merge_group(&mddev->kobj, &internal_bitmap_group);
+	if (ret)
+		sysfs_remove_group(&mddev->kobj, &common_bitmap_group);
+
+	return ret;
+}
+
+static void bitmap_unregister_groups(struct mddev *mddev)
+{
+	sysfs_unmerge_group(&mddev->kobj, &internal_bitmap_group);
+}
+
 static struct bitmap_operations bitmap_ops = {
 	.head = {
 		.type	= MD_BITMAP,
@@ -3018,21 +3085,52 @@ static struct bitmap_operations bitmap_ops = {
 	.set_pages		= bitmap_set_pages,
 	.free			= md_bitmap_free,
 
-	.group			= &md_bitmap_group,
+	.register_groups	= bitmap_register_groups,
+	.unregister_groups	= bitmap_unregister_groups,
+};
+
+static int none_bitmap_register_groups(struct mddev *mddev)
+{
+	return sysfs_create_group(&mddev->kobj, &common_bitmap_group);
+}
+
+static struct bitmap_operations none_bitmap_ops = {
+	.head = {
+		.type	= MD_BITMAP,
+		.id	= ID_BITMAP_NONE,
+		.name	= "none",
+	},
+
+	.enabled		= dummy_bitmap_enabled,
+	.create			= dummy_bitmap_create,
+	.destroy		= bitmap_destroy,
+	.load			= bitmap_load,
+	.get_stats		= bitmap_get_stats,
+	.free			= md_bitmap_free,
+
+	.register_groups	= none_bitmap_register_groups,
+	.unregister_groups	= NULL,
 };
 
 int md_bitmap_init(void)
 {
+	int ret;
+
 	md_bitmap_wq = alloc_workqueue("md_bitmap", WQ_MEM_RECLAIM | WQ_UNBOUND,
 				       0);
 	if (!md_bitmap_wq)
 		return -ENOMEM;
 
-	return register_md_submodule(&bitmap_ops.head);
+	ret = register_md_submodule(&bitmap_ops.head);
+	if (ret)
+		return ret;
+
+	return register_md_submodule(&none_bitmap_ops.head);
 }
 
 void md_bitmap_exit(void)
 {
 	destroy_workqueue(md_bitmap_wq);
 	unregister_md_submodule(&bitmap_ops.head);
+	unregister_md_submodule(&none_bitmap_ops.head);
 }
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index b42a28fa83a0..10bc6854798c 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -125,6 +125,9 @@ struct bitmap_operations {
 	void (*set_pages)(void *data, unsigned long pages);
 	void (*free)(void *data);
 
+	int (*register_groups)(struct mddev *mddev);
+	void (*unregister_groups)(struct mddev *mddev);
+
 	struct attribute_group *group;
 };
 
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index bf398d7476b3..9b3ea4f1d268 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1561,6 +1561,16 @@ static struct attribute_group md_llbitmap_group = {
 	.attrs = md_llbitmap_attrs,
 };
 
+static int llbitmap_register_groups(struct mddev *mddev)
+{
+	return sysfs_create_group(&mddev->kobj, &md_llbitmap_group);
+}
+
+static void llbitmap_unregister_groups(struct mddev *mddev)
+{
+	sysfs_remove_group(&mddev->kobj, &md_llbitmap_group);
+}
+
 static struct bitmap_operations llbitmap_ops = {
 	.head = {
 		.type	= MD_BITMAP,
@@ -1597,6 +1607,8 @@ static struct bitmap_operations llbitmap_ops = {
 	.dirty_bits		= llbitmap_dirty_bits,
 	.write_all		= llbitmap_write_all,
 
+	.register_groups	= llbitmap_register_groups,
+	.unregister_groups	= llbitmap_unregister_groups,
 	.group			= &md_llbitmap_group,
 };
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d3c8f77b4fe3..55a95b227b83 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -683,8 +683,7 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev, bool create_sysfs)
 	struct bitmap_operations *old = mddev->bitmap_ops;
 	struct md_submodule_head *head;
 
-	if (mddev->bitmap_id == ID_BITMAP_NONE ||
-	    (old && old->head.id == mddev->bitmap_id))
+	if (old && old->head.id == mddev->bitmap_id)
 		return true;
 
 	xa_lock(&md_submodule);
@@ -703,8 +702,8 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev, bool create_sysfs)
 	mddev->bitmap_ops = (void *)head;
 	xa_unlock(&md_submodule);
 
-	if (create_sysfs && !mddev_is_dm(mddev) && mddev->bitmap_ops->group) {
-		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
+	if (create_sysfs && !mddev_is_dm(mddev) && mddev->bitmap_ops->register_groups) {
+		if (mddev->bitmap_ops->register_groups(mddev))
 			pr_warn("md: cannot register extra bitmap attributes for %s\n",
 				mdname(mddev));
 		else
@@ -724,8 +723,8 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev, bool create_sysfs)
 static void mddev_clear_bitmap_ops(struct mddev *mddev, bool remove_sysfs)
 {
 	if (remove_sysfs && !mddev_is_dm(mddev) && mddev->bitmap_ops &&
-	    mddev->bitmap_ops->group)
-		sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
+	    mddev->bitmap_ops->unregister_groups)
+		mddev->bitmap_ops->unregister_groups(mddev);
 
 	mddev->bitmap_ops = NULL;
 }
@@ -6610,8 +6609,9 @@ int md_run(struct mddev *mddev)
 			(unsigned long long)pers->size(mddev, 0, 0) / 2);
 		err = -EINVAL;
 	}
-	if (err == 0 && pers->sync_request &&
-	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
+	if (err == 0 && pers->sync_request) {
+		if (mddev->bitmap_info.offset == 0)
+			mddev->bitmap_id = ID_BITMAP_NONE;
 		err = md_bitmap_create(mddev, true);
 		if (err)
 			pr_warn("%s: failed to create bitmap (%d)\n",
-- 
2.53.0

