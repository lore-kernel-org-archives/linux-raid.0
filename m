Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434FC38AC86
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 10:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775557608; cv=none; b=KOEChlzIPb8tKzmeOJFAd+MDa0KM2KAhbidKHBDabZLTNGuLdsnNxfuGLM8bapE1waCXI+UC3kLEOzmod23nahtMjuPaCbXzBh0YE7A5aXl6opVOrIdT3WdpIr+77V+Y1apyH3oPoehJCzjv+vr/ls5gvHVGRi6EPnfBez+zJhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775557608; c=relaxed/simple;
	bh=sg+8l43qyfk9iKwKBAy4klz7kuW8ICZxNFtf8OGj8J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrFZoCESkuEXc7PXzZNsRtvzH7wjb4ruXHtig2BuzhLGRvgWbBxicJPL865f5k3kEhcOxXditZDpdeJIf5hJw5C6WL0sWscKMg8MZaVT4yXc9L14m9YKUPw7wxFUxLAbvES5kyIGhlx5avhKAVinbUWwAyIrSiZ/B7usm36QfX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NUpHbump; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NUpHbump"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4888375f735so44131745e9.3
        for <linux-raid@vger.kernel.org>; Tue, 07 Apr 2026 03:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775557605; x=1776162405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FeB3+1jlkv/dtB8feyuzDjGgp/Y7R5WBlXi1SLfUt4E=;
        b=NUpHbumpfBeUw2BBkM3LSFPl7MDCz9ldcurbHfnK5L7jfVgrotOxzxuUJ9C1S7jsyv
         g4fet3PYU5wtnar9+vT7vFHUUayBWKaSfz9Pkf+UbpIjt143DQ2afNzIpcYpjPXbW1rp
         VCoVnnzKMHf8pYvnXHBGqhdBkWHNvRlnOPmSlFU5nRXCP054PXcHaC3Vyvj+lWaLEKeC
         wG1rhYmRdGHzFBqz/kRhwqW3FXdPNKMCQs9unLdVNWp9P35atxJ8wQt3HeknLD1SoQTS
         GfebUlC0rcqKyrcvbZrsgWU7Lica1ia7E4GjMLXpSzhIDaBJKN7qurNva605YWgFsL9i
         nwtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775557605; x=1776162405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FeB3+1jlkv/dtB8feyuzDjGgp/Y7R5WBlXi1SLfUt4E=;
        b=Lnsz6WFwvWJWQTyaU3Lf2lGE7L2r3bOXgqojZ+aIY8REe7kBS6VZUaL5cbuveLVJ+1
         bCtKRJiXZhJ/a6oaxq3lycC082kF5wjhWBm9/ikt9LzehD4yem8EWYS48gTIVRlyVHfu
         M+/C/U33VtW6AAscB3m6HUC5wgLrDdmrPlK9gahu+mN52kP+6jM0Fzb1Am4l+KTYtkhE
         RUccMj1wjOdxg5r2iKPzPLZfLW4CjzTC6Nr31mp5e5fU8MP4a8WA7JGmn8+8SlEg0sso
         tTeWYBbnDdRIoEKt1iXvsqFPVRiyckIDisNvQZ3IH1uXWGIwnE5Kdrm6wUq1ZP0DYWFK
         40rQ==
X-Gm-Message-State: AOJu0Yyuw/+L099Co8v9WSEyeL3Z0p8OMBPtuTBir4Up8qWw81tdroY4
	KOMgGEjHWg9cCrdMNI1AYcDVAYqh9TEO9n1r7wQv6KO0m1nuZ351p61DnMpT83XFrziVLKxoCbu
	2lbeoiD5GpQ==
X-Gm-Gg: AeBDieteLrxI3lhQjsRxzALu7i6UYNJ212GtKOwBZAbbrTlaqxxfCeK1iaIXeuYglDR
	ywuKn6V13gBh2RYxfXckXzTWl6BSts+nlAHOXw+hniDRL/lNYDlQMyYrGZrbNaiBO7RafJ1QppX
	SeFKbzceQJrU/SFEgjNXPafyQVx85Bxdi5NL/4YJNVgVI3OK5Dz0G5VzLCnM1jtO8GeT8AZZnRv
	gm1wZLF+kT0dAEbrqs7UrLq9yp44i1A1A+jxP/87C9eLmWYFkP+BSiiweQxYUpMaf737e2KU/2X
	Sv1YyNQ1BNnVOVORA/+nCLHr/h9Gwl8GMQv2/LCfMIbJO0Hl7OU0c9XXrVV1q20lhvbmlrJ4QF9
	Su9yKYLHIgCuISyNb0SEh5Cn0kuoG7GEy5FhsdFsiyDDMt/mjnYlDIkXOMmf6ndtx/IDDRtliV4
	IllNEPAdE5BUcUpy8ruE9ekCQJH2qDz1CfR6o7kr26
X-Received: by 2002:a05:600c:3549:b0:485:41c4:e2e4 with SMTP id 5b1f17b1804b1-488997d2ccemr210437665e9.23.1775557605360;
        Tue, 07 Apr 2026 03:26:45 -0700 (PDT)
Received: from mbp.lan ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca760b0518sm16483880eec.0.2026.04.07.03.26.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Apr 2026 03:26:44 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	xni@redhat.com,
	linan122@huawei.com,
	yukuai@fnnas.com,
	heming.zhao@suse.com,
	l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2 2/5] md/md-bitmap: add an extra sysfs argument to md_bitmap_create and destroy
Date: Tue,  7 Apr 2026 18:26:22 +0800
Message-ID: <20260407102625.5686-3-glass.su@suse.com>
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

For further use, no functional change.

Signed-off-by: Su Yue <glass.su@suse.com>
---
 drivers/md/md-bitmap.c |  6 +++---
 drivers/md/md.c        | 36 ++++++++++++++++++------------------
 drivers/md/md.h        |  4 ++--
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 2f24aae05552..ac06c9647bf0 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2618,7 +2618,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			goto out;
 		}
 
-		md_bitmap_destroy(mddev);
+		md_bitmap_destroy(mddev, true);
 		mddev->bitmap_info.offset = 0;
 		if (mddev->bitmap_info.file) {
 			struct file *f = mddev->bitmap_info.file;
@@ -2659,14 +2659,14 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			 */
 			mddev->bitmap_id = ID_BITMAP;
 			mddev->bitmap_info.offset = offset;
-			rv = md_bitmap_create(mddev);
+			rv = md_bitmap_create(mddev, true);
 			if (rv)
 				goto out;
 
 			rv = bitmap_load(mddev);
 			if (rv) {
 				mddev->bitmap_info.offset = 0;
-				md_bitmap_destroy(mddev);
+				md_bitmap_destroy(mddev, true);
 				goto out;
 			}
 		}
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8b1ecc370ad6..d3c8f77b4fe3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -678,7 +678,7 @@ static void active_io_release(struct percpu_ref *ref)
 
 static void no_op(struct percpu_ref *r) {}
 
-static bool mddev_set_bitmap_ops(struct mddev *mddev)
+static bool mddev_set_bitmap_ops(struct mddev *mddev, bool create_sysfs)
 {
 	struct bitmap_operations *old = mddev->bitmap_ops;
 	struct md_submodule_head *head;
@@ -703,7 +703,7 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
 	mddev->bitmap_ops = (void *)head;
 	xa_unlock(&md_submodule);
 
-	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->group) {
+	if (create_sysfs && !mddev_is_dm(mddev) && mddev->bitmap_ops->group) {
 		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
 			pr_warn("md: cannot register extra bitmap attributes for %s\n",
 				mdname(mddev));
@@ -721,9 +721,9 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
 	return false;
 }
 
-static void mddev_clear_bitmap_ops(struct mddev *mddev)
+static void mddev_clear_bitmap_ops(struct mddev *mddev, bool remove_sysfs)
 {
-	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
+	if (remove_sysfs && !mddev_is_dm(mddev) && mddev->bitmap_ops &&
 	    mddev->bitmap_ops->group)
 		sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
 
@@ -6447,24 +6447,24 @@ static void md_safemode_timeout(struct timer_list *t)
 
 static int start_dirty_degraded;
 
-int md_bitmap_create(struct mddev *mddev)
+int md_bitmap_create(struct mddev *mddev, bool create_sysfs)
 {
 	if (mddev->bitmap_id == ID_BITMAP_NONE)
 		return -EINVAL;
 
-	if (!mddev_set_bitmap_ops(mddev))
+	if (!mddev_set_bitmap_ops(mddev, create_sysfs))
 		return -ENOENT;
 
 	return mddev->bitmap_ops->create(mddev);
 }
 
-void md_bitmap_destroy(struct mddev *mddev)
+void md_bitmap_destroy(struct mddev *mddev, bool remove_sysfs)
 {
 	if (!md_bitmap_registered(mddev))
 		return;
 
 	mddev->bitmap_ops->destroy(mddev);
-	mddev_clear_bitmap_ops(mddev);
+	mddev_clear_bitmap_ops(mddev, remove_sysfs);
 }
 
 int md_run(struct mddev *mddev)
@@ -6612,7 +6612,7 @@ int md_run(struct mddev *mddev)
 	}
 	if (err == 0 && pers->sync_request &&
 	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
-		err = md_bitmap_create(mddev);
+		err = md_bitmap_create(mddev, true);
 		if (err)
 			pr_warn("%s: failed to create bitmap (%d)\n",
 				mdname(mddev), err);
@@ -6685,7 +6685,7 @@ int md_run(struct mddev *mddev)
 		pers->free(mddev, mddev->private);
 	mddev->private = NULL;
 	put_pers(pers);
-	md_bitmap_destroy(mddev);
+	md_bitmap_destroy(mddev, true);
 	return err;
 }
 EXPORT_SYMBOL_GPL(md_run);
@@ -6702,7 +6702,7 @@ int do_md_run(struct mddev *mddev)
 	if (md_bitmap_registered(mddev)) {
 		err = mddev->bitmap_ops->load(mddev);
 		if (err) {
-			md_bitmap_destroy(mddev);
+			md_bitmap_destroy(mddev, true);
 			goto out;
 		}
 	}
@@ -6903,7 +6903,7 @@ static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
 
-	md_bitmap_destroy(mddev);
+	md_bitmap_destroy(mddev, true);
 	mddev_detach(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
@@ -7680,16 +7680,16 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 	err = 0;
 	if (mddev->pers) {
 		if (fd >= 0) {
-			err = md_bitmap_create(mddev);
+			err = md_bitmap_create(mddev, true);
 			if (!err)
 				err = mddev->bitmap_ops->load(mddev);
 
 			if (err) {
-				md_bitmap_destroy(mddev);
+				md_bitmap_destroy(mddev, true);
 				fd = -1;
 			}
 		} else if (fd < 0) {
-			md_bitmap_destroy(mddev);
+			md_bitmap_destroy(mddev, true);
 		}
 	}
 
@@ -7996,12 +7996,12 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				mddev->bitmap_info.default_offset;
 			mddev->bitmap_info.space =
 				mddev->bitmap_info.default_space;
-			rv = md_bitmap_create(mddev);
+			rv = md_bitmap_create(mddev, true);
 			if (!rv)
 				rv = mddev->bitmap_ops->load(mddev);
 
 			if (rv)
-				md_bitmap_destroy(mddev);
+				md_bitmap_destroy(mddev, true);
 		} else {
 			struct md_bitmap_stats stats;
 
@@ -8027,7 +8027,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				put_cluster_ops(mddev);
 				mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
 			}
-			md_bitmap_destroy(mddev);
+			md_bitmap_destroy(mddev, true);
 			mddev->bitmap_info.offset = 0;
 		}
 	}
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ed69244af00d..4aaba3d7015c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -895,8 +895,8 @@ static inline void safe_put_page(struct page *p)
 
 int register_md_submodule(struct md_submodule_head *msh);
 void unregister_md_submodule(struct md_submodule_head *msh);
-int md_bitmap_create(struct mddev *mddev);
-void md_bitmap_destroy(struct mddev *mddev);
+int md_bitmap_create(struct mddev *mddev, bool create_sysfs);
+void md_bitmap_destroy(struct mddev *mddev, bool remove_sysfs);
 
 extern struct md_thread *md_register_thread(
 	void (*run)(struct md_thread *thread),
-- 
2.53.0

