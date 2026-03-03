Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4934375AD6
	for <linux-raid@vger.kernel.org>; Tue,  3 Mar 2026 03:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772509070; cv=none; b=KlsJps5pFaYabyPpuhGpPV7TD/tEKsBeFeoY0V/05de4f3Jt44h4YUCmzzq74Zet0e+AWYP0ra8oBAi1D1gnuE7CF28kr/u+ZWk79Y77524AX0yEX/xkNSZXRGmdhb9yQVpqYhqi+cdFd+tXwxulj6d5pQ/dgomfbnE/+nocC7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772509070; c=relaxed/simple;
	bh=C053Gq2BnmScbk0bRYfA7jfV7S8WBNi1wBRgx98IylM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGvdfNdJdal9BZKJXNDOSLcVjGoIz17RTJTIO0EQTHgueJGVC+Bo6+L+dxThhFE2m64qZKkPTXaDwQkpIaYqTG639OyH2IbxyJlUDbFUyp6P/0sp16WRgq9ee/c0bjykK+V+50ZZvkqEPpa8UW8XWzCHVrpN09w3TZheZBqLggY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dFNx3lLt; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dFNx3lLt"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48379a42f76so41799655e9.0
        for <linux-raid@vger.kernel.org>; Mon, 02 Mar 2026 19:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772509067; x=1773113867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b0trcV9AWeOiePko/n4NB3U+Rs3q0qCcMmuW2x1F9Jw=;
        b=dFNx3lLtp4wsWyPAUP74y2IQ35t+3NzoAWtEgr4Mf3+eLjcHOIiugczsDOP1eNuIDq
         B4r5+sBQR4Vtvzz7RCyMV4Q/9bkfKb1pjcQx+AD3AAdHUSo+0pauNBF4+Oek2w0/KxeP
         c4GP/1D1xdbkmAGgUGHN1k68Gh7lTAsELwy5Tpw2hOsCpJkfXyKINTvXss1qJnXRNks9
         QA4G/HDbD/GyirwlOedNRxQEq+mjYQAFfa4X3jxIHi5etpdj/7YUtLBc56YtUEOl9vbz
         nGwbWS6F2gs0Iv63006tRevgopzYfQImZYoDU/4pJ088I9v2JBDCIrH16tEgR1iyLsFF
         0BAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772509067; x=1773113867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b0trcV9AWeOiePko/n4NB3U+Rs3q0qCcMmuW2x1F9Jw=;
        b=H2cs87Y34O5UVclxmtheNx+AIymJt2JDlWk8morIU0gwAT/UKIHwN79Sw37fNVEmfu
         awuhjOfERUVl8ok3BynXm4ky/krw9bfTDXO1S3OPzsEu+qDbo99FAqtmG+BXlyZRdEnh
         eXC7aJ4ARHRWoBtR5USkqKSTMrVXLCW3g4MPOf7trpxzJc7pBfg3e5Y6cmR2ofW/hfxz
         AI+rmEGnbESys7al5qcEUk3G543kFytkBEVT6glQv3MA+JSTamCVm8VaWqXsIWWsfLse
         kMZtg94M8CH1yQiWd71RftDjdr01M5et6QRQtwBwM69+1Qrn2zy7BPLeixceV68O0vje
         lh5w==
X-Gm-Message-State: AOJu0YzIUzf020JNwmx/ZQtdt2APJn57DvloEn8ZnC9D3uZowpY2wrqY
	I5C8ZhJjtaYlaFHbDHMJWwf8cYG6eRQQZitlJJrU9p5VXqJcnb/lJ5mqE4jzCONlbQLMx+JZt5a
	Z2mVW5JD3u8VV
X-Gm-Gg: ATEYQzzlz/RTeHSQ+daN0YXSvltxjg7sqfvyj9seQph4aYDfkDqTZ/UGg2UQLNiG9kY
	oNrnaMVW0guZLHp2eBPtHHU4AjaPH4RsTYZM1ChlIH8N64lGfsXXnAcoIA/ZXTLrkDH1KZD0n2/
	8WvMYaj8vx1E8+rUW3kVqg91wx7X9vo7Qr/25n0Lym+76oAhvOf+C3EB8A3j9JU1m823wDPazR9
	lAcBTqMkCJULbfRXnxIwLFBTkz42sOSxwX7f8XRYI+FwoOfxiMmblPpzFyfjWYCbqXrb3QrrTxD
	VKhtmuZEK8jwKeMs2VhI+YykTqP8TL0Rgq/pQDDZVhBqOMlqnoNzOYs+KqriQML/jBSXjF5O+gn
	RgXMbtViuUXvb+zF+KkkVD0yYqLhExJgms7GxlRuagDFlvuyngX7bpswupCXUsQAUqv7oTMPd7N
	3/dxvwuzLmfpyWa7Gt34OLhG7UnNNx0Csa5uOcJQHhpiG0Vro/lQ==
X-Received: by 2002:a05:600c:828c:b0:482:dbd7:a1c1 with SMTP id 5b1f17b1804b1-483c9c23c72mr219902855e9.34.1772509066924;
        Mon, 02 Mar 2026 19:37:46 -0800 (PST)
Received: from MacBookPro.lan ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be16992009sm3929104eec.3.2026.03.02.19.37.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Mar 2026 19:37:45 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	xni@redhat.com,
	linan122@huawei.com,
	yukuai@fnnas.com,
	heming.zhao@suse.com,
	l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH 1/3] md: restore bitmap/location to fix wrong bitmap offset while growing
Date: Tue,  3 Mar 2026 11:37:29 +0800
Message-ID: <20260303033731.83885-2-glass.su@suse.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260303033731.83885-1-glass.su@suse.com>
References: <20260303033731.83885-1-glass.su@suse.com>
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

Here restore sysfs file bitmap/location for ID_BITMAP_NONE and ID_BITMAP.
And it d adds the entry for llbitmap too.

New attribute_group md_bitmap_common_group is introduced and created in
md_alloc() as before commit fb8cc3b0d9db.
Add New operations register_group and unregister_group to struct bitmap_operations.

Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_ops until creating bitmap")
Signed-off-by: Su Yue <glass.su@suse.com>
---
 drivers/md/md-bitmap.c   | 32 +++++++++++++++++++++++++++++++-
 drivers/md/md-bitmap.h   |  5 +++++
 drivers/md/md-llbitmap.c | 13 +++++++++++++
 drivers/md/md.c          | 16 ++++++++++++----
 4 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 83378c033c72..8ff1dc94ed78 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2956,7 +2956,6 @@ __ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
        behind_writes_used_show, behind_writes_used_reset);
 
 static struct attribute *md_bitmap_attrs[] = {
-	&bitmap_location.attr,
 	&bitmap_space.attr,
 	&bitmap_timeout.attr,
 	&bitmap_backlog.attr,
@@ -2967,11 +2966,40 @@ static struct attribute *md_bitmap_attrs[] = {
 	NULL
 };
 
+static struct attribute *md_bitmap_common_attrs[] = {
+	&bitmap_location.attr,
+	NULL
+};
+
 static struct attribute_group md_bitmap_group = {
 	.name = "bitmap",
 	.attrs = md_bitmap_attrs,
 };
 
+static struct attribute_group md_bitmap_common_group = {
+	.name = "bitmap",
+	.attrs = md_bitmap_common_attrs,
+};
+
+int md_sysfs_create_common_group(struct mddev *mddev)
+{
+	return sysfs_create_group(&mddev->kobj, &md_bitmap_common_group);
+}
+
+static int bitmap_register_group(struct mddev *mddev)
+{
+	/*
+	 * md_bitmap_group and md_bitmap_common_group are using same name
+	 * 'bitmap'.
+	 */
+	return sysfs_merge_group(&mddev->kobj, &md_bitmap_group);
+}
+
+static void bitmap_unregister_group(struct mddev *mddev)
+{
+	sysfs_unmerge_group(&mddev->kobj, &md_bitmap_group);
+}
+
 static struct bitmap_operations bitmap_ops = {
 	.head = {
 		.type	= MD_BITMAP,
@@ -3013,6 +3041,8 @@ static struct bitmap_operations bitmap_ops = {
 	.set_pages		= bitmap_set_pages,
 	.free			= md_bitmap_free,
 
+	.register_group		= bitmap_register_group,
+	.unregister_group	= bitmap_unregister_group,
 	.group			= &md_bitmap_group,
 };
 
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index b42a28fa83a0..371791e9011d 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -125,6 +125,9 @@ struct bitmap_operations {
 	void (*set_pages)(void *data, unsigned long pages);
 	void (*free)(void *data);
 
+	int (*register_group)(struct mddev *mddev);
+	void (*unregister_group)(struct mddev *mddev);
+
 	struct attribute_group *group;
 };
 
@@ -169,6 +172,8 @@ static inline void md_bitmap_end_sync(struct mddev *mddev, sector_t offset,
 	mddev->bitmap_ops->end_sync(mddev, offset, blocks);
 }
 
+int md_sysfs_create_common_group(struct mddev *mddev);
+
 #ifdef CONFIG_MD_BITMAP
 int md_bitmap_init(void);
 void md_bitmap_exit(void);
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index bf398d7476b3..24ff5f7f8751 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1561,6 +1561,16 @@ static struct attribute_group md_llbitmap_group = {
 	.attrs = md_llbitmap_attrs,
 };
 
+static int llbitmap_register_group(struct mddev *mddev)
+{
+	return sysfs_create_group(&mddev->kobj, &md_llbitmap_group);
+}
+
+static void llbitmap_unregister_group(struct mddev *mddev)
+{
+	sysfs_remove_group(&mddev->kobj, &md_llbitmap_group);
+}
+
 static struct bitmap_operations llbitmap_ops = {
 	.head = {
 		.type	= MD_BITMAP,
@@ -1597,6 +1607,9 @@ static struct bitmap_operations llbitmap_ops = {
 	.dirty_bits		= llbitmap_dirty_bits,
 	.write_all		= llbitmap_write_all,
 
+	.register_group		= llbitmap_register_group,
+	.unregister_group	= llbitmap_unregister_group,
+
 	.group			= &md_llbitmap_group,
 };
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3ce6f9e9d38e..ab969e950ea8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -703,8 +703,8 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
 	mddev->bitmap_ops = (void *)head;
 	xa_unlock(&md_submodule);
 
-	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group) {
-		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
+	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->register_group) {
+		if (mddev->bitmap_ops->register_group(mddev))
 			pr_warn("md: cannot register extra bitmap attributes for %s\n",
 				mdname(mddev));
 		else
@@ -724,8 +724,8 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
 static void mddev_clear_bitmap_ops(struct mddev *mddev)
 {
 	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
-	    mddev->bitmap_ops->group)
-		sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
+	    mddev->bitmap_ops->unregister_group)
+		mddev->bitmap_ops->unregister_group(mddev);
 
 	mddev->bitmap_ops = NULL;
 }
@@ -6369,6 +6369,14 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		return ERR_PTR(error);
 	}
 
+	/*
+	 * md_sysfs_remove_common_group is not needed because mddev_delayed_delete
+	 * calls kobject_put(&mddev->kobj) if mddev is to be deleted.
+	 */
+	if (md_sysfs_create_common_group(mddev))
+		pr_warn("md: cannot register common bitmap attributes for %s\n",
+			mdname(mddev));
+
 	kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
-- 
2.53.0

