Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A18C61DA4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjCFVaI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjCFV3W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1405B3B66E
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Y0mBr2wOqGkKPVfhHu65dUuY3Vbl0jekTTK6LWay/s=;
        b=AuMrCJs9jS3mdQ2lPg06nD99kt2w7dptpX3929oBXaL758aWdlujxmm1K4YRte+qWsJFx9
        KCCjp+6QPcsoJ2oCqf0aaigcY8U1kj0EprML4Tw7NdhrOM4uRpBlE1IdqryjHvq4vpkBz1
        aRhQ1j1965z5uyiNbjcHmVA7Hhuw2tU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-7gedkF9fOaul_ZO9aIkD9Q-1; Mon, 06 Mar 2023 16:28:23 -0500
X-MC-Unique: 7gedkF9fOaul_ZO9aIkD9Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76987885624
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:23 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B11B640CF8F0;
        Mon,  6 Mar 2023 21:28:22 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 24/34] md: prefer octal permissions [WARNING]
Date:   Mon,  6 Mar 2023 22:27:47 +0100
Message-Id: <bb5f95dfb11e0603635566795dd3ad4705095b22.1678136717.git.heinzm@redhat.com>
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
 drivers/md/md-bitmap.c |  28 +++----
 drivers/md/md.c        | 176 ++++++++++++++++++++---------------------
 drivers/md/raid5-ppl.c |   4 +-
 drivers/md/raid5.c     |  29 +++----
 4 files changed, 106 insertions(+), 131 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b78b3647c4e7..25895ec7d89a 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2387,8 +2387,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 	return len;
 }
 
-static struct md_sysfs_entry bitmap_location =
-__ATTR(location, S_IRUGO|S_IWUSR, location_show, location_store);
+static struct md_sysfs_entry bitmap_location = __ATTR(location, 0644, location_show, location_store);
 
 /* 'bitmap/space' is the space available at 'location' for the
  * bitmap.  This allows the kernel to know when it is safe to
@@ -2424,8 +2423,7 @@ space_store(struct mddev *mddev, const char *buf, size_t len)
 	return len;
 }
 
-static struct md_sysfs_entry bitmap_space =
-__ATTR(space, S_IRUGO|S_IWUSR, space_show, space_store);
+static struct md_sysfs_entry bitmap_space = __ATTR(space, 0644, space_show, space_store);
 
 static ssize_t
 timeout_show(struct mddev *mddev, char *page)
@@ -2475,8 +2473,7 @@ timeout_store(struct mddev *mddev, const char *buf, size_t len)
 	return len;
 }
 
-static struct md_sysfs_entry bitmap_timeout =
-__ATTR(time_base, S_IRUGO|S_IWUSR, timeout_show, timeout_store);
+static struct md_sysfs_entry bitmap_timeout = __ATTR(time_base, 0644, timeout_show, timeout_store);
 
 static ssize_t
 backlog_show(struct mddev *mddev, char *page)
@@ -2531,8 +2528,7 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 	return len;
 }
 
-static struct md_sysfs_entry bitmap_backlog =
-__ATTR(backlog, S_IRUGO|S_IWUSR, backlog_show, backlog_store);
+static struct md_sysfs_entry bitmap_backlog = __ATTR(backlog, 0644, backlog_show, backlog_store);
 
 static ssize_t
 chunksize_show(struct mddev *mddev, char *page)
@@ -2562,8 +2558,8 @@ chunksize_store(struct mddev *mddev, const char *buf, size_t len)
 	return len;
 }
 
-static struct md_sysfs_entry bitmap_chunksize =
-__ATTR(chunksize, S_IRUGO|S_IWUSR, chunksize_show, chunksize_store);
+static struct md_sysfs_entry bitmap_chunksize = __ATTR(chunksize, 0644,
+						       chunksize_show, chunksize_store);
 
 static ssize_t metadata_show(struct mddev *mddev, char *page)
 {
@@ -2589,8 +2585,7 @@ static ssize_t metadata_store(struct mddev *mddev, const char *buf, size_t len)
 	return len;
 }
 
-static struct md_sysfs_entry bitmap_metadata =
-__ATTR(metadata, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
+static struct md_sysfs_entry bitmap_metadata = __ATTR(metadata, 0644, metadata_show, metadata_store);
 
 static ssize_t can_clear_show(struct mddev *mddev, char *page)
 {
@@ -2621,8 +2616,8 @@ static ssize_t can_clear_store(struct mddev *mddev, const char *buf, size_t len)
 	return len;
 }
 
-static struct md_sysfs_entry bitmap_can_clear =
-__ATTR(can_clear, S_IRUGO|S_IWUSR, can_clear_show, can_clear_store);
+static struct md_sysfs_entry bitmap_can_clear = __ATTR(can_clear, 0644,
+						       can_clear_show, can_clear_store);
 
 static ssize_t
 behind_writes_used_show(struct mddev *mddev, char *page)
@@ -2647,8 +2642,9 @@ behind_writes_used_reset(struct mddev *mddev, const char *buf, size_t len)
 	return len;
 }
 
-static struct md_sysfs_entry max_backlog_used =
-__ATTR(max_backlog_used, S_IRUGO | S_IWUSR, behind_writes_used_show, behind_writes_used_reset);
+static struct md_sysfs_entry max_backlog_used = __ATTR(max_backlog_used, 0644,
+						       behind_writes_used_show,
+						       behind_writes_used_reset);
 
 static struct attribute *md_bitmap_attrs[] = {
 	&bitmap_location.attr,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 858cbb5252df..a495fad762ae 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -307,14 +307,14 @@ static struct ctl_table raid_table[] = {
 		.procname	= "speed_limit_min",
 		.data		= &sysctl_speed_limit_min,
 		.maxlen		= sizeof(int),
-		.mode		= S_IRUGO|S_IWUSR,
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "speed_limit_max",
 		.data		= &sysctl_speed_limit_max,
 		.maxlen		= sizeof(int),
-		.mode		= S_IRUGO|S_IWUSR,
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
 	{ }
@@ -324,7 +324,7 @@ static struct ctl_table raid_dir_table[] = {
 	{
 		.procname	= "raid",
 		.maxlen		= 0,
-		.mode		= S_IRUGO|S_IXUGO,
+		.mode		= 0555,
 		.child		= raid_table,
 	},
 	{ }
@@ -3100,8 +3100,8 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
 	return err ? err : len;
 }
-static struct rdev_sysfs_entry rdev_state =
-__ATTR_PREALLOC(state, S_IRUGO|S_IWUSR, state_show, state_store);
+
+static struct rdev_sysfs_entry rdev_state = __ATTR_PREALLOC(state, 0644, state_show, state_store);
 
 static ssize_t
 errors_show(struct md_rdev *rdev, char *page)
@@ -3121,8 +3121,8 @@ errors_store(struct md_rdev *rdev, const char *buf, size_t len)
 	atomic_set(&rdev->corrected_errors, n);
 	return len;
 }
-static struct rdev_sysfs_entry rdev_errors =
-__ATTR(errors, S_IRUGO|S_IWUSR, errors_show, errors_store);
+
+static struct rdev_sysfs_entry rdev_errors = __ATTR(errors, 0644, errors_show, errors_store);
 
 static ssize_t
 slot_show(struct md_rdev *rdev, char *page)
@@ -3219,8 +3219,7 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 	return len;
 }
 
-static struct rdev_sysfs_entry rdev_slot =
-__ATTR(slot, S_IRUGO|S_IWUSR, slot_show, slot_store);
+static struct rdev_sysfs_entry rdev_slot = __ATTR(slot, 0644, slot_show, slot_store);
 
 static ssize_t
 offset_show(struct md_rdev *rdev, char *page)
@@ -3245,8 +3244,7 @@ offset_store(struct md_rdev *rdev, const char *buf, size_t len)
 	return len;
 }
 
-static struct rdev_sysfs_entry rdev_offset =
-__ATTR(offset, S_IRUGO|S_IWUSR, offset_show, offset_store);
+static struct rdev_sysfs_entry rdev_offset = __ATTR(offset, 0644, offset_show, offset_store);
 
 static ssize_t new_offset_show(struct md_rdev *rdev, char *page)
 {
@@ -3301,8 +3299,9 @@ static ssize_t new_offset_store(struct md_rdev *rdev,
 
 	return len;
 }
-static struct rdev_sysfs_entry rdev_new_offset =
-__ATTR(new_offset, S_IRUGO|S_IWUSR, new_offset_show, new_offset_store);
+
+static struct rdev_sysfs_entry rdev_new_offset = __ATTR(new_offset, 0644,
+							new_offset_show, new_offset_store);
 
 static ssize_t
 rdev_size_show(struct md_rdev *rdev, char *page)
@@ -3409,8 +3408,7 @@ rdev_size_store(struct md_rdev *rdev, const char *buf, size_t len)
 	return len;
 }
 
-static struct rdev_sysfs_entry rdev_size =
-__ATTR(size, S_IRUGO|S_IWUSR, rdev_size_show, rdev_size_store);
+static struct rdev_sysfs_entry rdev_size = __ATTR(size, 0644, rdev_size_show, rdev_size_store);
 
 static ssize_t recovery_start_show(struct md_rdev *rdev, char *page)
 {
@@ -3444,8 +3442,9 @@ static ssize_t recovery_start_store(struct md_rdev *rdev, const char *buf, size_
 	return len;
 }
 
-static struct rdev_sysfs_entry rdev_recovery_start =
-__ATTR(recovery_start, S_IRUGO|S_IWUSR, recovery_start_show, recovery_start_store);
+static struct rdev_sysfs_entry rdev_recovery_start = __ATTR(recovery_start, 0644,
+							    recovery_start_show,
+							    recovery_start_store);
 
 /* sysfs access to bad-blocks list.
  * We present two files.
@@ -3470,8 +3469,7 @@ static ssize_t bb_store(struct md_rdev *rdev, const char *page, size_t len)
 		wake_up(&rdev->blocked_wait);
 	return rv;
 }
-static struct rdev_sysfs_entry rdev_bad_blocks =
-__ATTR(bad_blocks, S_IRUGO|S_IWUSR, bb_show, bb_store);
+static struct rdev_sysfs_entry rdev_bad_blocks = __ATTR(bad_blocks, 0644, bb_show, bb_store);
 
 static ssize_t ubb_show(struct md_rdev *rdev, char *page)
 {
@@ -3481,8 +3479,8 @@ static ssize_t ubb_store(struct md_rdev *rdev, const char *page, size_t len)
 {
 	return badblocks_store(&rdev->badblocks, page, len, 1);
 }
-static struct rdev_sysfs_entry rdev_unack_bad_blocks =
-__ATTR(unacknowledged_bad_blocks, S_IRUGO|S_IWUSR, ubb_show, ubb_store);
+static struct rdev_sysfs_entry rdev_unack_bad_blocks = __ATTR(unacknowledged_bad_blocks, 0644,
+							      ubb_show, ubb_store);
 
 static ssize_t
 ppl_sector_show(struct md_rdev *rdev, char *page)
@@ -3520,8 +3518,8 @@ ppl_sector_store(struct md_rdev *rdev, const char *buf, size_t len)
 	return len;
 }
 
-static struct rdev_sysfs_entry rdev_ppl_sector =
-__ATTR(ppl_sector, S_IRUGO|S_IWUSR, ppl_sector_show, ppl_sector_store);
+static struct rdev_sysfs_entry rdev_ppl_sector = __ATTR(ppl_sector, 0644,
+							ppl_sector_show, ppl_sector_store);
 
 static ssize_t
 ppl_size_show(struct md_rdev *rdev, char *page)
@@ -3553,8 +3551,7 @@ ppl_size_store(struct md_rdev *rdev, const char *buf, size_t len)
 	return len;
 }
 
-static struct rdev_sysfs_entry rdev_ppl_size =
-__ATTR(ppl_size, S_IRUGO|S_IWUSR, ppl_size_show, ppl_size_store);
+static struct rdev_sysfs_entry rdev_ppl_size = __ATTR(ppl_size, 0644, ppl_size_show, ppl_size_store);
 
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
@@ -3861,8 +3858,9 @@ safe_delay_store(struct mddev *mddev, const char *cbuf, size_t len)
 	}
 	return len;
 }
-static struct md_sysfs_entry md_safe_delay =
-__ATTR(safe_mode_delay, S_IRUGO|S_IWUSR, safe_delay_show, safe_delay_store);
+
+static struct md_sysfs_entry md_safe_delay = __ATTR(safe_mode_delay, 0644,
+						    safe_delay_show, safe_delay_store);
 
 static ssize_t
 level_show(struct mddev *mddev, char *page)
@@ -4088,8 +4086,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	return rv;
 }
 
-static struct md_sysfs_entry md_level =
-__ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
+static struct md_sysfs_entry md_level = __ATTR(level, 0644, level_show, level_store);
 
 static ssize_t
 layout_show(struct mddev *mddev, char *page)
@@ -4134,8 +4131,7 @@ layout_store(struct mddev *mddev, const char *buf, size_t len)
 	mddev_unlock(mddev);
 	return err ?: len;
 }
-static struct md_sysfs_entry md_layout =
-__ATTR(layout, S_IRUGO|S_IWUSR, layout_show, layout_store);
+static struct md_sysfs_entry md_layout = __ATTR(layout, 0644, layout_show, layout_store);
 
 static ssize_t
 raid_disks_show(struct mddev *mddev, char *page)
@@ -4189,16 +4185,17 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	mddev_unlock(mddev);
 	return err ? err : len;
 }
-static struct md_sysfs_entry md_raid_disks =
-__ATTR(raid_disks, S_IRUGO|S_IWUSR, raid_disks_show, raid_disks_store);
+
+static struct md_sysfs_entry md_raid_disks = __ATTR(raid_disks, 0644,
+						    raid_disks_show, raid_disks_store);
 
 static ssize_t
 uuid_show(struct mddev *mddev, char *page)
 {
 	return sprintf(page, "%pU\n", mddev->uuid);
 }
-static struct md_sysfs_entry md_uuid =
-__ATTR(uuid, S_IRUGO, uuid_show, NULL);
+
+static struct md_sysfs_entry md_uuid = __ATTR(uuid, 0444, uuid_show, NULL);
 
 static ssize_t
 chunk_size_show(struct mddev *mddev, char *page)
@@ -4243,8 +4240,8 @@ chunk_size_store(struct mddev *mddev, const char *buf, size_t len)
 	mddev_unlock(mddev);
 	return err ?: len;
 }
-static struct md_sysfs_entry md_chunk_size =
-__ATTR(chunk_size, S_IRUGO|S_IWUSR, chunk_size_show, chunk_size_store);
+static struct md_sysfs_entry md_chunk_size = __ATTR(chunk_size, 0644,
+						    chunk_size_show, chunk_size_store);
 
 static ssize_t
 resync_start_show(struct mddev *mddev, char *page)
@@ -4285,7 +4282,7 @@ resync_start_store(struct mddev *mddev, const char *buf, size_t len)
 	return err ?: len;
 }
 static struct md_sysfs_entry md_resync_start =
-__ATTR_PREALLOC(resync_start, S_IRUGO|S_IWUSR,
+__ATTR_PREALLOC(resync_start, 0644,
 		resync_start_show, resync_start_store);
 
 /*
@@ -4500,7 +4497,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	return err ?: len;
 }
 static struct md_sysfs_entry md_array_state =
-__ATTR_PREALLOC(array_state, S_IRUGO|S_IWUSR, array_state_show, array_state_store);
+__ATTR_PREALLOC(array_state, 0644, array_state_show, array_state_store);
 
 static ssize_t max_corrected_read_errors_show(struct mddev *mddev, char *page)
 {
@@ -4520,9 +4517,9 @@ max_corrected_read_errors_store(struct mddev *mddev, const char *buf, size_t len
 	return len;
 }
 
-static struct md_sysfs_entry max_corr_read_errors =
-__ATTR(max_read_errors, S_IRUGO|S_IWUSR, max_corrected_read_errors_show,
-	max_corrected_read_errors_store);
+static struct md_sysfs_entry max_corr_read_errors = __ATTR(max_read_errors, 0644,
+							   max_corrected_read_errors_show,
+							   max_corrected_read_errors_store);
 
 static ssize_t
 null_show(struct mddev *mddev, char *page)
@@ -4606,8 +4603,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	return err ? err : len;
 }
 
-static struct md_sysfs_entry md_new_device =
-__ATTR(new_dev, S_IWUSR, null_show, new_dev_store);
+static struct md_sysfs_entry md_new_device = __ATTR(new_dev, 0200, null_show, new_dev_store);
 
 static ssize_t
 bitmap_store(struct mddev *mddev, const char *buf, size_t len)
@@ -4643,8 +4639,7 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
 	return len;
 }
 
-static struct md_sysfs_entry md_bitmap =
-__ATTR(bitmap_set_bits, S_IWUSR, null_show, bitmap_store);
+static struct md_sysfs_entry md_bitmap = __ATTR(bitmap_set_bits, 0200, null_show, bitmap_store);
 
 static ssize_t
 size_show(struct mddev *mddev, char *page)
@@ -4685,8 +4680,7 @@ size_store(struct mddev *mddev, const char *buf, size_t len)
 	return err ? err : len;
 }
 
-static struct md_sysfs_entry md_size =
-__ATTR(component_size, S_IRUGO|S_IWUSR, size_show, size_store);
+static struct md_sysfs_entry md_size = __ATTR(component_size, 0644, size_show, size_store);
 
 /* Metadata version.
  * This is one of
@@ -4770,8 +4764,8 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 	return err ?: len;
 }
 
-static struct md_sysfs_entry md_metadata =
-__ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
+static struct md_sysfs_entry md_metadata = __ATTR_PREALLOC(metadata_version, 0644,
+							   metadata_show, metadata_store);
 
 static ssize_t
 action_show(struct mddev *mddev, char *page)
@@ -4882,8 +4876,8 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 	return len;
 }
 
-static struct md_sysfs_entry md_scan_mode =
-__ATTR_PREALLOC(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
+static struct md_sysfs_entry md_scan_mode = __ATTR_PREALLOC(sync_action, 0644,
+							    action_show, action_store);
 
 static ssize_t
 last_sync_action_show(struct mddev *mddev, char *page)
@@ -4929,8 +4923,8 @@ sync_min_store(struct mddev *mddev, const char *buf, size_t len)
 	return len;
 }
 
-static struct md_sysfs_entry md_sync_min =
-__ATTR(sync_speed_min, S_IRUGO|S_IWUSR, sync_min_show, sync_min_store);
+static struct md_sysfs_entry md_sync_min = __ATTR(sync_speed_min, 0644,
+						  sync_min_show, sync_min_store);
 
 static ssize_t
 sync_max_show(struct mddev *mddev, char *page)
@@ -4958,8 +4952,8 @@ sync_max_store(struct mddev *mddev, const char *buf, size_t len)
 	return len;
 }
 
-static struct md_sysfs_entry md_sync_max =
-__ATTR(sync_speed_max, S_IRUGO|S_IWUSR, sync_max_show, sync_max_store);
+static struct md_sysfs_entry md_sync_max = __ATTR(sync_speed_max, 0644,
+						  sync_max_show, sync_max_store);
 
 static ssize_t
 degraded_show(struct mddev *mddev, char *page)
@@ -4994,9 +4988,9 @@ sync_force_parallel_store(struct mddev *mddev, const char *buf, size_t len)
 }
 
 /* force parallel resync, even with shared block devices */
-static struct md_sysfs_entry md_sync_force_parallel =
-__ATTR(sync_force_parallel, S_IRUGO|S_IWUSR,
-       sync_force_parallel_show, sync_force_parallel_store);
+static struct md_sysfs_entry md_sync_force_parallel = __ATTR(sync_force_parallel, 0644,
+							     sync_force_parallel_show,
+							     sync_force_parallel_store);
 
 static ssize_t
 sync_speed_show(struct mddev *mddev, char *page)
@@ -5037,8 +5031,8 @@ sync_completed_show(struct mddev *mddev, char *page)
 	return sprintf(page, "%llu / %llu\n", resync, max_sectors);
 }
 
-static struct md_sysfs_entry md_sync_completed =
-	__ATTR_PREALLOC(sync_completed, S_IRUGO, sync_completed_show, NULL);
+static struct md_sysfs_entry md_sync_completed = __ATTR_PREALLOC(sync_completed, 0444,
+								 sync_completed_show, NULL);
 
 static ssize_t
 min_sync_show(struct mddev *mddev, char *page)
@@ -5073,8 +5067,7 @@ min_sync_store(struct mddev *mddev, const char *buf, size_t len)
 	return err ?: len;
 }
 
-static struct md_sysfs_entry md_min_sync =
-__ATTR(sync_min, S_IRUGO|S_IWUSR, min_sync_show, min_sync_store);
+static struct md_sysfs_entry md_min_sync = __ATTR(sync_min, 0644, min_sync_show, min_sync_store);
 
 static ssize_t
 max_sync_show(struct mddev *mddev, char *page)
@@ -5126,8 +5119,7 @@ max_sync_store(struct mddev *mddev, const char *buf, size_t len)
 	return err ?: len;
 }
 
-static struct md_sysfs_entry md_max_sync =
-__ATTR(sync_max, S_IRUGO|S_IWUSR, max_sync_show, max_sync_store);
+static struct md_sysfs_entry md_max_sync = __ATTR(sync_max, 0644, max_sync_show, max_sync_store);
 
 static ssize_t
 suspend_lo_show(struct mddev *mddev, char *page)
@@ -5163,8 +5155,9 @@ suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
 	mddev_unlock(mddev);
 	return err ?: len;
 }
-static struct md_sysfs_entry md_suspend_lo =
-__ATTR(suspend_lo, S_IRUGO|S_IWUSR, suspend_lo_show, suspend_lo_store);
+
+static struct md_sysfs_entry md_suspend_lo = __ATTR(suspend_lo, 0644,
+						    suspend_lo_show, suspend_lo_store);
 
 static ssize_t
 suspend_hi_show(struct mddev *mddev, char *page)
@@ -5200,8 +5193,9 @@ suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
 	mddev_unlock(mddev);
 	return err ?: len;
 }
-static struct md_sysfs_entry md_suspend_hi =
-__ATTR(suspend_hi, S_IRUGO|S_IWUSR, suspend_hi_show, suspend_hi_store);
+
+static struct md_sysfs_entry md_suspend_hi = __ATTR(suspend_hi, 0644,
+						    suspend_hi_show, suspend_hi_store);
 
 static ssize_t
 reshape_position_show(struct mddev *mddev, char *page)
@@ -5245,9 +5239,9 @@ reshape_position_store(struct mddev *mddev, const char *buf, size_t len)
 	return err ?: len;
 }
 
-static struct md_sysfs_entry md_reshape_position =
-__ATTR(reshape_position, S_IRUGO|S_IWUSR, reshape_position_show,
-       reshape_position_store);
+static struct md_sysfs_entry md_reshape_position = __ATTR(reshape_position, 0644,
+							  reshape_position_show,
+							  reshape_position_store);
 
 static ssize_t
 reshape_direction_show(struct mddev *mddev, char *page)
@@ -5286,9 +5280,9 @@ reshape_direction_store(struct mddev *mddev, const char *buf, size_t len)
 	return err ?: len;
 }
 
-static struct md_sysfs_entry md_reshape_direction =
-__ATTR(reshape_direction, S_IRUGO|S_IWUSR, reshape_direction_show,
-       reshape_direction_store);
+static struct md_sysfs_entry md_reshape_direction = __ATTR(reshape_direction, 0644,
+							   reshape_direction_show,
+							   reshape_direction_store);
 
 static ssize_t
 array_size_show(struct mddev *mddev, char *page)
@@ -5342,9 +5336,8 @@ array_size_store(struct mddev *mddev, const char *buf, size_t len)
 	return err ?: len;
 }
 
-static struct md_sysfs_entry md_array_size =
-__ATTR(array_size, S_IRUGO|S_IWUSR, array_size_show,
-       array_size_store);
+static struct md_sysfs_entry md_array_size = __ATTR(array_size, 0644,
+						    array_size_show, array_size_store);
 
 static ssize_t
 consistency_policy_show(struct mddev *mddev, char *page)
@@ -5388,9 +5381,9 @@ consistency_policy_store(struct mddev *mddev, const char *buf, size_t len)
 	return err ? err : len;
 }
 
-static struct md_sysfs_entry md_consistency_policy =
-__ATTR(consistency_policy, S_IRUGO | S_IWUSR, consistency_policy_show,
-       consistency_policy_store);
+static struct md_sysfs_entry md_consistency_policy = __ATTR(consistency_policy, 0644,
+							    consistency_policy_show,
+							    consistency_policy_store);
 
 static ssize_t fail_last_dev_show(struct mddev *mddev, char *page)
 {
@@ -5416,9 +5409,8 @@ fail_last_dev_store(struct mddev *mddev, const char *buf, size_t len)
 
 	return len;
 }
-static struct md_sysfs_entry md_fail_last_dev =
-__ATTR(fail_last_dev, S_IRUGO | S_IWUSR, fail_last_dev_show,
-       fail_last_dev_store);
+static struct md_sysfs_entry md_fail_last_dev = __ATTR(fail_last_dev, 0644,
+						       fail_last_dev_show, fail_last_dev_store);
 
 static ssize_t serialize_policy_show(struct mddev *mddev, char *page)
 {
@@ -5466,9 +5458,9 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
 	return err ?: len;
 }
 
-static struct md_sysfs_entry md_serialize_policy =
-__ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
-       serialize_policy_store);
+static struct md_sysfs_entry md_serialize_policy = __ATTR(serialize_policy, 0644,
+							  serialize_policy_show,
+							  serialize_policy_store);
 
 
 static struct attribute *md_default_attrs[] = {
@@ -9671,7 +9663,7 @@ static void md_geninit(void)
 {
 	pr_debug("md: sizeof(mdp_super_t) = %d\n", (int)sizeof(mdp_super_t));
 
-	proc_create("mdstat", S_IRUGO, NULL, &mdstat_proc_ops);
+	proc_create("mdstat", 0444, NULL, &mdstat_proc_ops);
 }
 
 static int __init md_init(void)
@@ -10022,10 +10014,10 @@ static int set_ro(const char *val, const struct kernel_param *kp)
 	return kstrtouint(val, 10, (unsigned int *)&start_readonly);
 }
 
-module_param_call(start_ro, set_ro, get_ro, NULL, S_IRUSR|S_IWUSR);
-module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
-module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
-module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
+module_param_call(start_ro, set_ro, get_ro, NULL, 0600);
+module_param(start_dirty_degraded, int, 0644);
+module_param_call(new_array, add_named_array, NULL, NULL, 0200);
+module_param(create_on_open, bool, 0600);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MD RAID framework");
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index cfff345951db..8e19cbfc32ca 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -1528,6 +1528,4 @@ ppl_write_hint_store(struct mddev *mddev, const char *page, size_t len)
 }
 
 struct md_sysfs_entry
-ppl_write_hint = __ATTR(ppl_write_hint, S_IRUGO | S_IWUSR,
-			ppl_write_hint_show,
-			ppl_write_hint_store);
+ppl_write_hint = __ATTR(ppl_write_hint, 0644, ppl_write_hint_show, ppl_write_hint_store);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f418035da889..b41d0918b914 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6938,9 +6938,8 @@ raid5_store_stripe_cache_size(struct mddev *mddev, const char *page, size_t len)
 }
 
 static struct md_sysfs_entry
-raid5_stripecache_size = __ATTR(stripe_cache_size, S_IRUGO | S_IWUSR,
-				raid5_show_stripe_cache_size,
-				raid5_store_stripe_cache_size);
+raid5_stripecache_size = __ATTR(stripe_cache_size, 0644,
+				raid5_show_stripe_cache_size, raid5_store_stripe_cache_size);
 
 static ssize_t
 raid5_show_rmw_level(struct mddev  *mddev, char *page)
@@ -6981,9 +6980,7 @@ raid5_store_rmw_level(struct mddev  *mddev, const char *page, size_t len)
 }
 
 static struct md_sysfs_entry
-raid5_rmw_level = __ATTR(rmw_level, S_IRUGO | S_IWUSR,
-			 raid5_show_rmw_level,
-			 raid5_store_rmw_level);
+raid5_rmw_level = __ATTR(rmw_level, 0644, raid5_show_rmw_level, raid5_store_rmw_level);
 
 static ssize_t
 raid5_show_stripe_size(struct mddev  *mddev, char *page)
@@ -7070,14 +7067,10 @@ raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
 }
 
 static struct md_sysfs_entry
-raid5_stripe_size = __ATTR(stripe_size, 0644,
-			 raid5_show_stripe_size,
-			 raid5_store_stripe_size);
+raid5_stripe_size = __ATTR(stripe_size, 0644, raid5_show_stripe_size, raid5_store_stripe_size);
 #else
 static struct md_sysfs_entry
-raid5_stripe_size = __ATTR(stripe_size, 0444,
-			 raid5_show_stripe_size,
-			 NULL);
+raid5_stripe_size = __ATTR(stripe_size, 0444, raid5_show_stripe_size, NULL);
 #endif
 
 static ssize_t
@@ -7121,8 +7114,7 @@ raid5_store_preread_threshold(struct mddev *mddev, const char *page, size_t len)
 }
 
 static struct md_sysfs_entry
-raid5_preread_bypass_threshold = __ATTR(preread_bypass_threshold,
-					S_IRUGO | S_IWUSR,
+raid5_preread_bypass_threshold = __ATTR(preread_bypass_threshold, 0644,
 					raid5_show_preread_threshold,
 					raid5_store_preread_threshold);
 
@@ -7175,9 +7167,7 @@ raid5_store_skip_copy(struct mddev *mddev, const char *page, size_t len)
 }
 
 static struct md_sysfs_entry
-raid5_skip_copy = __ATTR(skip_copy, S_IRUGO | S_IWUSR,
-					raid5_show_skip_copy,
-					raid5_store_skip_copy);
+raid5_skip_copy = __ATTR(skip_copy, 0644, raid5_show_skip_copy, raid5_store_skip_copy);
 
 static ssize_t
 stripe_cache_active_show(struct mddev *mddev, char *page)
@@ -7260,9 +7250,8 @@ raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
 }
 
 static struct md_sysfs_entry
-raid5_group_thread_cnt = __ATTR(group_thread_cnt, S_IRUGO | S_IWUSR,
-				raid5_show_group_thread_cnt,
-				raid5_store_group_thread_cnt);
+raid5_group_thread_cnt = __ATTR(group_thread_cnt, 0644,
+				raid5_show_group_thread_cnt, raid5_store_group_thread_cnt);
 
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
-- 
2.39.2

