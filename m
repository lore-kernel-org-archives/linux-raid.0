Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9350DCCA483
	for <linux-raid@archiver.kernel.org>; Sat, 23 Jul 2022 06:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbiGWGYn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 23 Jul 2022 02:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiGWGYl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 23 Jul 2022 02:24:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5312269F2C
        for <linux-raid@vger.kernel.org>; Fri, 22 Jul 2022 23:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=a4+u4CSQEPEG9JK1/eViUn5F2zDUHKmuEmrbXmCzMIU=; b=Np3PXXAv1oCUyaud8l3pDbnjVu
        DAyX8NU693KTL+t+BD7NswmvB6RC+LggR7fJ3SktnghH+xjkE9PbuxJda6VdAABtmYXIUiLI3TxlQ
        Gbp2+bUdRjQeGjTwDAvGc6dhNohJ0DgdBGbiQicJsv1RqXzlGabDydHSodRetFIAA+PtDBUY2xUIM
        Kp1aui77mE5vA0/Aagwh9acDu/u0r/j3uhQtcygY2Nf0fTaXpSSHHWRAyzSK+jGhvHrakkq2QyCLy
        tNWooRBRcDnHSM7ejdWrYdankXM7K7TjvE9mMTCD/W0M/6UIYGnPs9ezW9rxWN764XpLxh+LJ7qEW
        M5ZshJ3Q==;
Received: from [2001:4bb8:199:fe1f:951f:1322:520f:5e75] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oF8Z3-00GKKT-UE; Sat, 23 Jul 2022 06:24:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org
Subject: [PATCH 2/2] md: return the allocated devices from md_alloc
Date:   Sat, 23 Jul 2022 08:24:29 +0200
Message-Id: <20220723062429.2210193-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220723062429.2210193-1-hch@lst.de>
References: <20220723062429.2210193-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Two callers of md_alloc want to use the newly allocated devices, so
return it instead of letting them find it cumbersomely after the
allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md-autodetect.c | 22 +++++-----------
 drivers/md/md.c            | 54 ++++++++++++++++----------------------
 drivers/md/md.h            |  3 ++-
 3 files changed, 30 insertions(+), 49 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 344910ba435c5..91836e6de3260 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -125,7 +125,6 @@ static void __init md_setup_drive(struct md_setup_args *args)
 	char *devname = args->device_names;
 	dev_t devices[MD_SB_DISKS + 1], mdev;
 	struct mdu_array_info_s ainfo = { };
-	struct block_device *bdev;
 	struct mddev *mddev;
 	int err = 0, i;
 	char name[16];
@@ -169,25 +168,16 @@ static void __init md_setup_drive(struct md_setup_args *args)
 
 	pr_info("md: Loading %s: %s\n", name, args->device_names);
 
-	md_alloc(mdev, name);
-	bdev = blkdev_get_by_dev(mdev, FMODE_READ, NULL);
-	if (IS_ERR(bdev)) {
-		pr_err("md: open failed - cannot start array %s\n", name);
+	mddev = md_alloc(mdev, name);
+	if (IS_ERR(mddev)) {
+		pr_err("md: md_alloc failed - cannot start array %s\n", name);
 		return;
 	}
 
-	err = -EIO;
-	if (WARN(bdev->bd_disk->fops != &md_fops,
-			"Opening block device %x resulted in non-md device\n",
-			mdev))
-		goto out_blkdev_put;
-
-	mddev = bdev->bd_disk->private_data;
-
 	err = mddev_lock(mddev);
 	if (err) {
 		pr_err("md: failed to lock array %s\n", name);
-		goto out_blkdev_put;
+		goto out_mddev_put;
 	}
 
 	if (!list_empty(&mddev->disks) || mddev->raid_disks) {
@@ -231,8 +221,8 @@ static void __init md_setup_drive(struct md_setup_args *args)
 		pr_warn("md: starting %s failed\n", name);
 out_unlock:
 	mddev_unlock(mddev);
-out_blkdev_put:
-	blkdev_put(bdev, FMODE_READ);
+out_mddev_put:
+	mddev_put(mddev);
 }
 
 static int __init raid_setup(char *str)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5671160ad3982..6e82df21623d3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -635,7 +635,7 @@ static inline struct mddev *mddev_get(struct mddev *mddev)
 
 static void mddev_delayed_delete(struct work_struct *ws);
 
-static void mddev_put(struct mddev *mddev)
+void mddev_put(struct mddev *mddev)
 {
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
@@ -714,24 +714,6 @@ static dev_t mddev_alloc_unit(void)
 	return dev;
 }
 
-#ifndef MODULE
-static struct mddev *mddev_find(dev_t unit)
-{
-	struct mddev *mddev;
-
-	if (MAJOR(unit) != MD_MAJOR)
-		unit &= ~((1 << MdpMinorShift) - 1);
-
-	spin_lock(&all_mddevs_lock);
-	mddev = mddev_find_locked(unit);
-	if (mddev && !mddev_get(mddev))
-		mddev = NULL;
-	spin_unlock(&all_mddevs_lock);
-
-	return mddev;
-}
-#endif
-
 static struct mddev *mddev_alloc(dev_t unit)
 {
 	struct mddev *new;
@@ -5614,7 +5596,7 @@ int mddev_init_writes_pending(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(mddev_init_writes_pending);
 
-int md_alloc(dev_t dev, char *name)
+struct mddev *md_alloc(dev_t dev, char *name)
 {
 	/*
 	 * If dev is zero, name is the name of a device to allocate with
@@ -5706,17 +5688,16 @@ int md_alloc(dev_t dev, char *name)
 		 * different from a normal close on last release now.
 		 */
 		mddev->hold_active = 0;
-		goto done;
+		mutex_unlock(&disks_mutex);
+		mddev_put(mddev);
+		return ERR_PTR(error);
 	}
 
 	kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
-
-done:
 	mutex_unlock(&disks_mutex);
-	mddev_put(mddev);
-	return error;
+	return mddev;
 
 out_put_disk:
 	put_disk(disk);
@@ -5724,7 +5705,17 @@ int md_alloc(dev_t dev, char *name)
 	mddev_free(mddev);
 out_unlock:
 	mutex_unlock(&disks_mutex);
-	return error;
+	return ERR_PTR(error);
+}
+
+static int md_alloc_and_put(dev_t dev, char *name)
+{
+	struct mddev *mddev = md_alloc(dev, name);
+
+	if (IS_ERR(mddev))
+		return PTR_ERR(mddev);
+	mddev_put(mddev);
+	return 0;
 }
 
 static void md_probe(dev_t dev)
@@ -5732,7 +5723,7 @@ static void md_probe(dev_t dev)
 	if (MAJOR(dev) == MD_MAJOR && MINOR(dev) >= 512)
 		return;
 	if (create_on_open)
-		md_alloc(dev, NULL);
+		md_alloc_and_put(dev, NULL);
 }
 
 static int add_named_array(const char *val, const struct kernel_param *kp)
@@ -5754,12 +5745,12 @@ static int add_named_array(const char *val, const struct kernel_param *kp)
 		return -E2BIG;
 	strscpy(buf, val, len+1);
 	if (strncmp(buf, "md_", 3) == 0)
-		return md_alloc(0, buf);
+		return md_alloc_and_put(0, buf);
 	if (strncmp(buf, "md", 2) == 0 &&
 	    isdigit(buf[2]) &&
 	    kstrtoul(buf+2, 10, &devnum) == 0 &&
 	    devnum <= MINORMASK)
-		return md_alloc(MKDEV(MD_MAJOR, devnum), NULL);
+		return md_alloc_and_put(MKDEV(MD_MAJOR, devnum), NULL);
 
 	return -EINVAL;
 }
@@ -6500,9 +6491,8 @@ static void autorun_devices(int part)
 			break;
 		}
 
-		md_alloc(dev, NULL);
-		mddev = mddev_find(dev);
-		if (!mddev)
+		mddev = md_alloc(dev, NULL);
+		if (IS_ERR(mddev))
 			break;
 
 		if (mddev_lock(mddev))
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f6ab73c90b7d2..b4e2d8b87b611 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -767,7 +767,8 @@ extern int md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale);
 
 extern void mddev_init(struct mddev *mddev);
-int md_alloc(dev_t dev, char *name);
+struct mddev *md_alloc(dev_t dev, char *name);
+void mddev_put(struct mddev *mddev);
 extern int md_run(struct mddev *mddev);
 extern int md_start(struct mddev *mddev);
 extern void md_stop(struct mddev *mddev);
-- 
2.30.2

