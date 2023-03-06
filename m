Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A8CC6FD1C
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjCFV3r (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjCFV3M (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99743527C
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rbo53No23YfTeWXuKKbyDPigg7MscXQ8KwGcV+U3+TM=;
        b=JLoP3Y1Sp9enF0JKxCmLTZPq1vDsecKHpo2Nt4ju+7jdCgdr4pjXdTo6e12nIOf+kcNrGL
        Mmv+h80NdhtlCPNyFfe+Jx5Jum0Nu20qLJ9bcNMrTcDf5tUPXM9KnkLeSGvObYQR5fZHyY
        ZrAyiZC9tPQjpayklAvBn63NcLlUmrM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-ZhCMQsEaOICnX4TJJ39a6A-1; Mon, 06 Mar 2023 16:28:14 -0500
X-MC-Unique: ZhCMQsEaOICnX4TJJ39a6A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82D52183B3C0
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:14 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFAF040C83B6;
        Mon,  6 Mar 2023 21:28:13 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 15/34] md: avoid multiple line dereference [WARNING}
Date:   Mon,  6 Mar 2023 22:27:38 +0100
Message-Id: <0a57310b9bd33a0cdec7f7cd45883a69e32130cb.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md-bitmap.c |  3 +--
 drivers/md/md.c        | 30 ++++++++++++------------------
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 2db748c998e1..fcf516d7fcff 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -469,8 +469,7 @@ void md_bitmap_update_sb(struct bitmap *bitmap)
 	sb->sync_size = cpu_to_le64(bitmap->mddev->resync_max_sectors);
 	sb->chunksize = cpu_to_le32(bitmap->mddev->bitmap_info.chunksize);
 	sb->nodes = cpu_to_le32(bitmap->mddev->bitmap_info.nodes);
-	sb->sectors_reserved = cpu_to_le32(bitmap->mddev->
-					   bitmap_info.space);
+	sb->sectors_reserved = cpu_to_le32(bitmap->mddev->bitmap_info.space);
 	kunmap_atomic(sb);
 	write_page(bitmap, bitmap->storage.sb_page, 1);
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2e764ddc55d6..187fe8a25fc1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2833,8 +2833,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 		 * then added disks for geometry changes,
 		 * and should be added immediately.
 		 */
-		super_types[mddev->major_version].
-			validate_super(mddev, rdev);
+		super_types[mddev->major_version].validate_super(mddev, rdev);
 		if (add_journal)
 			mddev_suspend(mddev);
 		err = mddev->pers->hot_add_disk(mddev, rdev);
@@ -3292,8 +3291,7 @@ static ssize_t new_offset_store(struct md_rdev *rdev,
 		return -EINVAL;
 
 	if (mddev->pers && mddev->persistent &&
-	    !super_types[mddev->major_version]
-	    .allow_new_offset(rdev, new_offset))
+	    !super_types[mddev->major_version].allow_new_offset(rdev, new_offset))
 		return -E2BIG;
 	rdev->new_data_offset = new_offset;
 	if (new_offset > rdev->data_offset)
@@ -3377,8 +3375,8 @@ rdev_size_store(struct md_rdev *rdev, const char *buf, size_t len)
 		return -EINVAL; /* too confusing */
 	if (my_mddev->pers && rdev->raid_disk >= 0) {
 		if (my_mddev->persistent) {
-			sectors = super_types[my_mddev->major_version].
-				rdev_size_change(rdev, sectors);
+			sectors = super_types[my_mddev->major_version].rdev_size_change(rdev,
+											sectors);
 			if (!sectors)
 				return -EBUSY;
 		} else if (!sectors)
@@ -3701,8 +3699,7 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 	}
 
 	if (super_format >= 0) {
-		err = super_types[super_format].
-			load_super(rdev, NULL, super_minor);
+		err = super_types[super_format].load_super(rdev, NULL, super_minor);
 		if (err == -EINVAL) {
 			pr_warn("md: %pg does not have a valid v%d.%d superblock, not importing!\n",
 				rdev->bdev,
@@ -3738,8 +3735,8 @@ static int analyze_sbs(struct mddev *mddev)
 
 	freshest = NULL;
 	rdev_for_each_safe(rdev, tmp, mddev)
-		switch (super_types[mddev->major_version].
-			load_super(rdev, freshest, mddev->minor_version)) {
+		switch (super_types[mddev->major_version].load_super(rdev, freshest,
+								     mddev->minor_version)) {
 		case 1:
 			freshest = rdev;
 			break;
@@ -3757,8 +3754,7 @@ static int analyze_sbs(struct mddev *mddev)
 		return -EINVAL;
 	}
 
-	super_types[mddev->major_version].
-		validate_super(mddev, freshest);
+	super_types[mddev->major_version].validate_super(mddev, freshest);
 
 	i = 0;
 	rdev_for_each_safe(rdev, tmp, mddev) {
@@ -3772,8 +3768,7 @@ static int analyze_sbs(struct mddev *mddev)
 			continue;
 		}
 		if (rdev != freshest) {
-			if (super_types[mddev->major_version].
-			    validate_super(mddev, rdev)) {
+			if (super_types[mddev->major_version].validate_super(mddev, rdev)) {
 				pr_warn("md: kicking non-fresh %pg from array!\n",
 					rdev->bdev);
 				md_kick_rdev_from_array(rdev);
@@ -6793,8 +6788,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 				rdev->raid_disk = -1;
 			rdev->saved_raid_disk = rdev->raid_disk;
 		} else
-			super_types[mddev->major_version].
-				validate_super(mddev, rdev);
+			super_types[mddev->major_version].validate_super(mddev, rdev);
 		if ((info->state & (1<<MD_DISK_SYNC)) &&
 		     rdev->raid_disk != info->raid_disk) {
 			/* This was a hot-add request, but events doesn't
@@ -9831,8 +9825,8 @@ static int read_rdev(struct mddev *mddev, struct md_rdev *rdev)
 	if (err == 0) {
 		ClearPageUptodate(rdev->sb_page);
 		rdev->sb_loaded = 0;
-		err = super_types[mddev->major_version].
-			load_super(rdev, NULL, mddev->minor_version);
+		err = super_types[mddev->major_version].load_super(rdev, NULL,
+								   mddev->minor_version);
 	}
 	if (err < 0) {
 		pr_warn("%s: %d Could not reload rdev(%d) err: %d. Restoring old values\n",
-- 
2.39.2

