Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E830D36CDE3
	for <linux-raid@vger.kernel.org>; Sat, 18 Jul 2026 10:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784372179; cv=none; b=GCpvkY8FR0Ltnbk35dTzUBZXpKtTRpHVDc6/27HMy8WVDluDKmm5g0CaxDLmQSGs71W8K+qOie4Uy1srnHXi+1oii7OpZrpUmWfZPRSgirScXATLTllVuIGyqe7bP5/YHRjvASNdplpukyPNJvsRwZ4BTMDotp/r8Qcb1HuPwFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784372179; c=relaxed/simple;
	bh=UDhROFw0gnRn5iZUWXiAuT6ATAYBJBDbmSgSLNiNzeY=;
	h=To:Cc:Message-Id:Mime-Version:From:Content-Type:Subject:Date; b=CiuIiLm/ejgwCbNVdc6TATmS/Wr8uR4v/7IXoU2n0mD6KN/mRLwo9MN8IoRrgIFeTf9ik5tulpSAQG3qJPRKqFyok5NEfHhfHVQ3jIB1Nc1JAzhr0mJmhmOH3Uw7AjSYNEAevb3OkVe6zyelj2VKPMNmz7DYrDoh0vm1rwWtOys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=zPhdkGlZ; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="zPhdkGlZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1784372164;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=llYGPliUlsafPkxBoJcNHTZUlVrqfw6/0St3IdiJCNk=;
 b=zPhdkGlZwpWi5l7oBCj5R1c3FH17GCcJ2A9tOvTC2w/BaUf0ktniqL+BgF0Dmmyc7vqwEN
 atQQpsdVyxRhfKLeOUC27VK5OZwGAijKVENqdVu+9JPme5BB0/JQD6jfFDOm+M89dUgwL8
 pwr2zIuZbdC83FKeAgzMC3UXKAmPGoW2JIX5hmEj0+2w+s52+EbqYogK8AklZO8MfgS+0X
 ggqm0HMSGjjwHGsmyJNDfx/xa6IHMDe3mNjmbg7AAdKfalEqhKmw1Nmg/chY1cyjMJYX4d
 R5YrI5tO/CeL0T3zHjqwOG06CHT53KIuM+6WC/6AER/gUW7+QjJ+fXDm2WSsNQ==
Content-Transfer-Encoding: 7bit
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
Cc: <chencheng@fnnas.com>, <chencheng@fygo.io>, 
	<linux-kernel@vger.kernel.org>
Message-Id: <20260718105551.608500-1-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Chen Cheng" <chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a5b5bc2+e9d24e+vger.kernel.org+chencheng@fnnas.com>
Received: from fedora ([183.34.161.69]) by smtp.feishu.cn with ESMTPS; Sat, 18 Jul 2026 18:56:01 +0800
X-Mailer: git-send-email 2.54.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH] md: handle serial pool allocation failures
Date: Sat, 18 Jul 2026 18:55:51 +0800
X-Original-From: chencheng@fnnas.com

From: Chen Cheng <chencheng@fnnas.com>

sashiko-bot report a issue:
mddev_create_serial_pool() silently ignored allocation failures, allowing
callers to continue with incomplete serialization state.

validation:

fail_page_alloc with a stacktrace filter for rdev_init_serial() to force
the serial allocation and its kvmalloc fallback to fail.

A/B result:
- Without this patch, serialize_policy accepts the write despite the
	injected allocation failure, leaving serialization state
	incomplete.
- With this patch, the write returns -ENOMEM and serialize_policy remains
	unchanged.

Fixes: 3938f5fb82ae ("md: add serialize_policy sysfs node for raid1")
Link: https://github.com/chencheng-fnnas/reproducer/blob/main/test-serial-pool-oom.sh

sashiko-bot report:
=====================
[Severity: Critical]
This is a pre-existing issue, but further down in backlog_store(), is it
possible for mddev_create_serial_pool() to fail silently?

drivers/md/md-bitmap.c:backlog_store() {
    ...
    } else if (backlog && !mddev->serial_info_pool) {
        /* serial_info_pool is needed since backlog is not zero */
        rdev_for_each(rdev, mddev)
            mddev_create_serial_pool(mddev, rdev);
    }
    ...
}

Since mddev_create_serial_pool() returns void, it hides memory allocation
failures. If it fails for a disk in this loop, that device is left without
initialization. Does this silently bypass write-behind serialization for
that disk, leading to overlapping writes and silent data corruption?

Similarly, if MD_SERIALIZE_POLICY is active, check_and_add_serial() in
drivers/md/raid1.c will unconditionally dereference rdev->serial:

    int idx = sector_to_idx(r1_bio->sector);
    struct serial_in_rdev *serial = &rdev->serial[idx];
    struct serial_info *head_si;

    spin_lock_irqsave(&serial->serial_lock, flags);

Can this cause a NULL pointer dereference for devices that failed
initialization?

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/md-bitmap.c | 20 +++++++++++++++-----
 drivers/md/md.c        | 33 ++++++++++++++++++++++-----------
 drivers/md/md.h        |  2 +-
 drivers/md/raid1.c     |  9 +++++++--
 4 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 6d495cdf3fb2..e0510e3cae3e 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2211,12 +2211,15 @@ static int bitmap_load(struct mddev *mddev)
 	struct md_rdev *rdev;
 
 	if (!bitmap)
 		goto out;
 
-	rdev_for_each(rdev, mddev)
-		mddev_create_serial_pool(mddev, rdev);
+	rdev_for_each(rdev, mddev) {
+		err = mddev_create_serial_pool(mddev, rdev);
+		if (err)
+			goto out;
+	}
 
 	if (mddev_is_clustered(mddev))
 		mddev->cluster_ops->load_bitmaps(mddev, mddev->bitmap_info.nodes);
 
 	/* Clear out old bitmap info first:  Either there is none, or we
@@ -2868,18 +2871,25 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 		/* serial_info_pool is not needed if backlog is zero */
 		if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 			mddev_destroy_serial_pool(mddev, NULL);
 	} else if (backlog && !mddev->serial_info_pool) {
 		/* serial_info_pool is needed since backlog is not zero */
-		rdev_for_each(rdev, mddev)
-			mddev_create_serial_pool(mddev, rdev);
+		rdev_for_each(rdev, mddev) {
+			rv = mddev_create_serial_pool(mddev, rdev);
+			if (rv) {
+				mddev->bitmap_info.max_write_behind = old_mwb;
+				mddev_destroy_serial_pool(mddev, NULL);
+				goto out;
+			}
+		}
 	}
 	if (old_mwb != backlog)
 		bitmap_update_sb(mddev->bitmap);
 
+out:
 	mddev_unlock_and_resume(mddev);
-	return len;
+	return rv ?: len;
 }
 
 static struct md_sysfs_entry bitmap_backlog =
 __ATTR(backlog, S_IRUGO|S_IWUSR, backlog_show, backlog_store);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 25e06f088dc1..048ffd28869b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -228,18 +228,19 @@ static int rdev_need_serial(struct md_rdev *rdev)
 /*
  * Init resource for rdev(s), then create serial_info_pool if:
  * 1. rdev is the first device which return true from rdev_enable_serial.
  * 2. rdev is NULL, means we want to enable serialization for all rdevs.
  */
-void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
+int mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 {
 	int ret = 0;
 	unsigned int noio_flags;
 
 	if (rdev && !rdev_need_serial(rdev) &&
-	    !test_bit(CollisionCheck, &rdev->flags))
-		return;
+	    !test_bit(CollisionCheck, &rdev->flags) &&
+	    !test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
+		return 0;
 
 	noio_flags = memalloc_noio_save();
 	if (!rdev)
 		ret = rdevs_init_serial(mddev);
 	else
@@ -248,18 +249,22 @@ void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 		goto out;
 
 	if (mddev->serial_info_pool == NULL) {
 		mddev->serial_info_pool =
 			mempool_create_kmalloc_pool(NR_SERIAL_INFOS,
-						sizeof(struct serial_info));
+						    sizeof(struct serial_info));
 		if (!mddev->serial_info_pool) {
+			if (rdev)
+				rdev_uninit_serial(rdev);
 			rdevs_uninit_serial(mddev);
 			pr_err("can't alloc memory pool for serialization\n");
+			ret = -ENOMEM;
 		}
 	}
 out:
 	memalloc_noio_restore(noio_flags);
+	return ret;
 }
 
 /*
  * Free resource from rdev(s), and destroy serial_info_pool under conditions:
  * 1. rdev is the last device flaged with CollisionCheck.
@@ -2605,12 +2610,15 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 	strreplace(b, '/', '!');
 
 	rdev->mddev = mddev;
 	pr_debug("md: bind<%s>\n", b);
 
-	if (mddev->raid_disks)
-		mddev_create_serial_pool(mddev, rdev);
+	if (mddev->raid_disks) {
+		err = mddev_create_serial_pool(mddev, rdev);
+		if (err)
+			return err;
+	}
 
 	if ((err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
 		goto fail;
 
 	/* failure here is OK */
@@ -3118,13 +3126,15 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 				md_new_event();
 			}
 		}
 	} else if (cmd_match(buf, "writemostly")) {
 		set_bit(WriteMostly, &rdev->flags);
-		mddev_create_serial_pool(rdev->mddev, rdev);
-		need_update_sb = true;
-		err = 0;
+		err = mddev_create_serial_pool(rdev->mddev, rdev);
+		if (err)
+			clear_bit(WriteMostly, &rdev->flags);
+		else
+			need_update_sb = true;
 	} else if (cmd_match(buf, "-writemostly")) {
 		mddev_destroy_serial_pool(rdev->mddev, rdev);
 		clear_bit(WriteMostly, &rdev->flags);
 		need_update_sb = true;
 		err = 0;
@@ -5943,12 +5953,13 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
 		err = -EINVAL;
 		goto unlock;
 	}
 
 	if (value) {
-		mddev_create_serial_pool(mddev, NULL);
-		set_bit(MD_SERIALIZE_POLICY, &mddev->flags);
+		err = mddev_create_serial_pool(mddev, NULL);
+		if (!err)
+			set_bit(MD_SERIALIZE_POLICY, &mddev->flags);
 	} else {
 		mddev_destroy_serial_pool(mddev, NULL);
 		clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
 	}
 unlock:
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 76488cd9e81e..e6ea0cc3669a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -959,11 +959,11 @@ extern void mddev_resume(struct mddev *mddev);
 extern void md_idle_sync_thread(struct mddev *mddev);
 extern void md_frozen_sync_thread(struct mddev *mddev);
 extern void md_unfrozen_sync_thread(struct mddev *mddev);
 
 extern void md_update_sb(struct mddev *mddev, int force);
-extern void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev);
+extern int mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev);
 extern void mddev_destroy_serial_pool(struct mddev *mddev,
 				      struct md_rdev *rdev);
 struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
 struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev);
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5b9368bd9e70..ef3812806f30 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -90,11 +90,11 @@ static int check_and_add_serial(struct md_rdev *rdev, struct r1bio *r1_bio,
 static void wait_for_serialization(struct md_rdev *rdev, struct r1bio *r1_bio)
 {
 	struct mddev *mddev = rdev->mddev;
 	struct serial_info *si;
 
-	if (WARN_ON(!mddev->serial_info_pool))
+	if (WARN_ON(!mddev->serial_info_pool || !rdev->serial))
 		return;
 	si = mempool_alloc(mddev->serial_info_pool, GFP_NOIO);
 	INIT_LIST_HEAD(&si->waiters);
 	INIT_LIST_HEAD(&si->list_node);
 	init_completion(&si->ready);
@@ -109,11 +109,16 @@ static void remove_serial(struct md_rdev *rdev, sector_t lo, sector_t hi)
 	struct serial_info *si, *iter_si;
 	unsigned long flags;
 	int found = 0;
 	struct mddev *mddev = rdev->mddev;
 	int idx = sector_to_idx(lo);
-	struct serial_in_rdev *serial = &rdev->serial[idx];
+	struct serial_in_rdev *serial;
+
+	if (WARN_ON(!mddev->serial_info_pool || !rdev->serial))
+		return;
+
+	serial = &rdev->serial[idx];
 
 	spin_lock_irqsave(&serial->serial_lock, flags);
 	for (si = raid1_rb_iter_first(&serial->serial_rb, lo, hi);
 	     si; si = raid1_rb_iter_next(si, lo, hi)) {
 		if (si->start == lo && si->last == hi) {
-- 
2.54.0
