Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29330C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 11:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244301AbiEaLOp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 07:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbiEaLOp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 07:14:45 -0400
X-Greylist: delayed 1473 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 May 2022 04:14:43 PDT
Received: from cdw.me.uk (cdw.me.uk [91.203.57.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39A248E190
        for <linux-raid@vger.kernel.org>; Tue, 31 May 2022 04:14:43 -0700 (PDT)
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1nvzRw-0008Ni-NL; Tue, 31 May 2022 11:50:08 +0100
Date:   Tue, 31 May 2022 11:50:08 +0100
From:   Chris Webb <chris@arachsys.com>
To:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH] md: Explicitly create command-line configured devices
Message-ID: <YpXy4CLSwLf7arGp@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Boot-time assembly of arrays with md= command-line arguments breaks when
CONFIG_BLOCK_LEGACY_AUTOLOAD is unset. md_setup_drive() in md-autodetect.c
calls blkdev_get_by_dev(), assuming this implicitly creates the block
device.

Fix this by attempting to md_alloc() the array first. As in the probe path,
ignore any error as failure is caught by blkdev_get_by_dev() anyway.

Signed-off-by: Chris Webb <chris@arachsys.com>
---
 drivers/md/md-autodetect.c | 1 +
 drivers/md/md.c            | 2 +-
 drivers/md/md.h            | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 2cf973722f59..344910ba435c 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -169,6 +169,7 @@ static void __init md_setup_drive(struct md_setup_args *args)
 
 	pr_info("md: Loading %s: %s\n", name, args->device_names);
 
+	md_alloc(mdev, name);
 	bdev = blkdev_get_by_dev(mdev, FMODE_READ, NULL);
 	if (IS_ERR(bdev)) {
 		pr_err("md: open failed - cannot start array %s\n", name);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 707e802d0082..5a4bca886572 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5638,7 +5638,7 @@ int mddev_init_writes_pending(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(mddev_init_writes_pending);
 
-static int md_alloc(dev_t dev, char *name)
+int md_alloc(dev_t dev, char *name)
 {
 	/*
 	 * If dev is zero, name is the name of a device to allocate with
diff --git a/drivers/md/md.h b/drivers/md/md.h
index cf2cbb17acbd..8da7ec314bbf 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -751,6 +751,7 @@ extern int md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale);
 
 extern void mddev_init(struct mddev *mddev);
+extern int md_alloc(dev_t dev, char *name);
 extern int md_run(struct mddev *mddev);
 extern int md_start(struct mddev *mddev);
 extern void md_stop(struct mddev *mddev);
