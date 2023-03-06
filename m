Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50BBCC6FD1A
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjCFVaF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjCFV3U (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F3D6C185
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FpEbCnY02Tktf1RuN8EWmBR3DZbLTfkJHxOE1VSEPNg=;
        b=TcHxqudZWEEjYuo5KHTGcvgNK9Y2zFFoan5GIvKQXVCEPc65TJsagQpMJ9yTGTiYN03FeV
        yj0xnFAvpoDormMx03Dy/l3cLKrY7un3CuetPtZEL5k5Ic1pXzoS8vH6I1cXOTL3INIppr
        436xjtq423SS0zo9Qx5bEmIHhAQt+7I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-kbRh7OG1M76s8k4lhH6kPQ-1; Mon, 06 Mar 2023 16:28:20 -0500
X-MC-Unique: kbRh7OG1M76s8k4lhH6kPQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77779802D2E
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:20 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B469240CF8F0;
        Mon,  6 Mar 2023 21:28:19 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 21/34] md: avoid useless else after break or return [WARNING]
Date:   Mon,  6 Mar 2023 22:27:44 +0100
Message-Id: <7735a0a5cc4a92519c8c457c3ffe40b40e0c4021.1678136717.git.heinzm@redhat.com>
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
 drivers/md/md-bitmap.c  |  5 +++--
 drivers/md/md-cluster.c |  5 +++--
 drivers/md/md.c         | 31 ++++++++++++++++---------------
 drivers/md/raid10.c     | 18 +++++++++---------
 4 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 65e77a7e3656..e739efe2249d 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2188,8 +2188,9 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 				blocks = old_counts.chunks << old_counts.chunkshift;
 				pr_warn("Could not pre-allocate in-memory bitmap for cluster raid\n");
 				break;
-			} else
-				bitmap->counts.bp[page].count += 1;
+			}
+
+			bitmap->counts.bp[page].count += 1;
 		}
 	}
 
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 762160e81ce8..e115603ff0d9 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -174,8 +174,9 @@ static int dlm_lock_sync_interruptible(struct dlm_lock_resource *res, int mode,
 			pr_info("failed to cancel previous lock request "
 				 "%s return %d\n", res->name, ret);
 		return -EPERM;
-	} else
-		res->sync_locking_done = false;
+	}
+
+	res->sync_locking_done = false;
 	if (res->lksb.sb_status == 0)
 		res->mode = mode;
 	return res->lksb.sb_status;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index e19edfe62516..37f1323306aa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2180,7 +2180,6 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 			sb_start &= ~(sector_t)(4*2 - 1);
 
 			bm_space = super_1_choose_bm_space(dev_size);
-
 			/* Space that can be used to store date needs to decrease
 			 * superblock bitmap space and bad block space(4K)
 			 */
@@ -3200,8 +3199,9 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		if (err) {
 			rdev->raid_disk = -1;
 			return err;
-		} else
-			sysfs_notify_dirent_safe(rdev->sysfs_state);
+		}
+
+		sysfs_notify_dirent_safe(rdev->sysfs_state);
 		/* failure here is OK */;
 		sysfs_link_rdev(rdev->mddev, rdev);
 		/* don't wakeup anyone, leave that to userspace. */
@@ -7359,13 +7359,12 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 		 */
 		if (mddev->pers->check_reshape == NULL)
 			return -EINVAL;
-		else {
-			mddev->new_layout = info->layout;
-			rv = mddev->pers->check_reshape(mddev);
-			if (rv)
-				mddev->new_layout = mddev->layout;
-			return rv;
-		}
+
+		mddev->new_layout = info->layout;
+		rv = mddev->pers->check_reshape(mddev);
+		if (rv)
+			mddev->new_layout = mddev->layout;
+		return rv;
 	}
 	if (info->size >= 0 && mddev->dev_sectors / 2 != info->size)
 		rv = update_size(mddev, (sector_t)info->size * 2);
@@ -7689,16 +7688,18 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 		if (mddev->pers) {
 			mdu_disk_info_t info;
 
-			if (copy_from_user(&info, argp, sizeof(info)))
+			if (copy_from_user(&info, argp, sizeof(info))) {
 				err = -EFAULT;
-			else if (!(info.state & (1<<MD_DISK_SYNC)))
+				goto unlock;
+			}
+
+			if (!(info.state & (1<<MD_DISK_SYNC)))
 				/* Need to clear read-only for this */
 				break;
-			else
-				err = md_add_new_disk(mddev, &info);
+
+			err = md_add_new_disk(mddev, &info);
 			goto unlock;
 		}
-		break;
 	}
 
 	/*
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dbad26fcca12..7ab011cdb995 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2325,6 +2325,7 @@ static void end_reshape_read(struct bio *bio)
 static void end_sync_request(struct r10bio *r10_bio)
 {
 	struct mddev *mddev = r10_bio->mddev;
+	struct r10bio *r10_bio2;
 
 	while (atomic_dec_and_test(&r10_bio->remaining)) {
 		if (r10_bio->master_bio == NULL) {
@@ -2338,16 +2339,15 @@ static void end_sync_request(struct r10bio *r10_bio)
 				put_buf(r10_bio);
 			md_done_sync(mddev, s, 1);
 			break;
-		} else {
-			struct r10bio *r10_bio2 = (struct r10bio *)r10_bio->master_bio;
-
-			if (test_bit(R10BIO_MadeGood, &r10_bio->state) ||
-			    test_bit(R10BIO_WriteError, &r10_bio->state))
-				reschedule_retry(r10_bio);
-			else
-				put_buf(r10_bio);
-			r10_bio = r10_bio2;
 		}
+
+		r10_bio2 = (struct r10bio *)r10_bio->master_bio;
+		if (test_bit(R10BIO_MadeGood, &r10_bio->state) ||
+		    test_bit(R10BIO_WriteError, &r10_bio->state))
+			reschedule_retry(r10_bio);
+		else
+			put_buf(r10_bio);
+		r10_bio = r10_bio2;
 	}
 }
 
-- 
2.39.2

