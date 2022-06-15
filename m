Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41F1C43334
	for <linux-raid@archiver.kernel.org>; Wed, 15 Jun 2022 12:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243190AbiFOM3T (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Jun 2022 08:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242459AbiFOM3S (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Jun 2022 08:29:18 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD073F8BD
        for <linux-raid@vger.kernel.org>; Wed, 15 Jun 2022 05:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655296157; x=1686832157;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bFK8VNaQ7nhUz5WYVJudvi1oWAZFEXrdu7tw+HopkB4=;
  b=IFJfPusu3k8biZ3Ir4CCU8RQZIFQTHBaa0eCX412F34BsBDA9fiGV7CP
   RAXAgMzN5m2uAbcjF4xgariI9Ajo2KfSEqwkwMNuaEP4F/RX/vXlU2qrX
   md3+CoXIlEBm0uPrqkaCVW/JcRGU/YZ1BSl6bZDvKofaPIdEUkLDnN402
   gKssVk2xwuOk+Rv/I/PuWe1jGucOk/YU9QzR4zxZIQ6yjxetiNA4kxgxG
   dhTlhoBhfLaQ49yQt6Eh4LF5UHsAuiqYqVqIjsvAm0kg2RXe4a+j3BE59
   3Bzv3xEi3QxDj/GT6mVhizr2RYktE7oQ+1HAXYLcoNC1fuC794HUTR/mN
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="277736297"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="277736297"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 05:29:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="911631974"
Received: from unknown (HELO gklab-localhost.igk.intel.com) ([10.102.108.128])
  by fmsmga005.fm.intel.com with ESMTP; 15 Jun 2022 05:29:09 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] mdadm: block update=ppl for non raid456 levels
Date:   Wed, 15 Jun 2022 14:28:39 +0200
Message-Id: <20220615122839.458384-1-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Option ppl should be used only for raid levels 4, 5 and 6. Cancel update
for other levels.

Applied globally for imsm and ddf format.

Additionally introduce is_level456() helper function.

Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
---
 Assemble.c | 11 +++++------
 Grow.c     |  2 +-
 Manage.c   | 14 ++++++++++++--
 mdadm.h    | 11 +++++++++++
 super0.c   |  2 +-
 super1.c   |  3 +--
 6 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 4b213560..6df6bfbc 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -906,8 +906,7 @@ static int force_array(struct mdinfo *content,
 				 * devices in RAID4 or last devices in RAID4/5/6.
 				 */
 				delta = devices[j].i.delta_disks;
-				if (devices[j].i.array.level >= 4 &&
-				    devices[j].i.array.level <= 6 &&
+				if (is_level456(devices[j].i.array.level) &&
 				    i/2 >= content->array.raid_disks - delta)
 					/* OK */;
 				else if (devices[j].i.array.level == 4 &&
@@ -1226,8 +1225,7 @@ static int start_array(int mdfd,
 				fprintf(stderr, ".\n");
 			}
 			if (content->reshape_active &&
-			    content->array.level >= 4 &&
-			    content->array.level <= 6) {
+			    is_level456(content->array.level)) {
 				/* might need to increase the size
 				 * of the stripe cache - default is 256
 				 */
@@ -1974,7 +1972,8 @@ int assemble_container_content(struct supertype *st, int mdfd,
 	int start_reshape;
 	char *avail;
 	int err;
-	int is_raid456, is_clean, all_disks;
+	int is_clean, all_disks;
+	bool is_raid456;
 
 	if (sysfs_init(content, mdfd, NULL)) {
 		pr_err("Unable to initialize sysfs\n");
@@ -2107,7 +2106,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		content->array.state |= 1;
 	}
 
-	is_raid456 = (content->array.level >= 4 && content->array.level <= 6);
+	is_raid456 = is_level456(content->array.level);
 	is_clean = content->array.state & 1;
 
 	if (enough(content->array.level, content->array.raid_disks,
diff --git a/Grow.c b/Grow.c
index f6efbc48..8c520d42 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2944,7 +2944,7 @@ static int impose_level(int fd, int level, char *devname, int verbose)
 	}
 
 	md_get_array_info(fd, &array);
-	if (level == 0 && (array.level >= 4 && array.level <= 6)) {
+	if (level == 0 && is_level456(array.level)) {
 		/* To convert to RAID0 we need to fail and
 		 * remove any non-data devices. */
 		int found = 0;
diff --git a/Manage.c b/Manage.c
index f789e0c1..e5e6abe4 100644
--- a/Manage.c
+++ b/Manage.c
@@ -307,7 +307,7 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 	 *  - unfreeze reshape
 	 *  - wait on 'sync_completed' for that point to be reached.
 	 */
-	if (mdi && (mdi->array.level >= 4 && mdi->array.level <= 6) &&
+	if (mdi && is_level456(mdi->array.level) &&
 	    sysfs_attribute_available(mdi, NULL, "sync_action") &&
 	    sysfs_attribute_available(mdi, NULL, "reshape_direction") &&
 	    sysfs_get_str(mdi, NULL, "sync_action", buf, 20) > 0 &&
@@ -1679,6 +1679,7 @@ int Update_subarray(char *dev, char *subarray, char *update, struct mddev_ident
 {
 	struct supertype supertype, *st = &supertype;
 	int fd, rv = 2;
+	struct mdinfo *info = NULL;
 
 	memset(st, 0, sizeof(*st));
 
@@ -1696,6 +1697,13 @@ int Update_subarray(char *dev, char *subarray, char *update, struct mddev_ident
 	if (mdmon_running(st->devnm))
 		st->update_tail = &st->updates;
 
+	info = st->ss->container_content(st, subarray);
+
+	if (strncmp(update, "ppl", 3) == 0 && !is_level456(info->array.level)) {
+		pr_err("RWH policy ppl is supported only for raid4, raid5 and raid6.\n");
+		goto free_super;
+	}
+
 	rv = st->ss->update_subarray(st, subarray, update, ident);
 
 	if (rv) {
@@ -1711,7 +1719,9 @@ int Update_subarray(char *dev, char *subarray, char *update, struct mddev_ident
 		pr_err("Updated subarray-%s name from %s, UUIDs may have changed\n",
 		       subarray, dev);
 
- free_super:
+free_super:
+	if (info)
+		free(info);
 	st->ss->free_super(st);
 	close(fd);
 
diff --git a/mdadm.h b/mdadm.h
index d53df169..974415b9 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -796,6 +796,17 @@ static inline int is_fd_valid(int fd)
 	return (fd > -1);
 }
 
+/**
+ * is_level456() - check whether given level is between inclusive 4 and 6.
+ * @level: level to check.
+ *
+ * Return: true if condition is met, false otherwise
+ */
+static inline bool is_level456(int level)
+{
+	return (level >= 4 && level <= 6);
+}
+
 /**
  * close_fd() - verify, close and unset file descriptor.
  * @fd: pointer to file descriptor.
diff --git a/super0.c b/super0.c
index 61c9ec1d..37f595ed 100644
--- a/super0.c
+++ b/super0.c
@@ -683,7 +683,7 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
 			int parity = sb->level == 6 ? 2 : 1;
 			rv = 0;
 
-			if (sb->level >= 4 && sb->level <= 6 &&
+			if (is_level456(sb->level) &&
 			    sb->reshape_position % (
 				    sb->new_chunk/512 *
 				    (sb->raid_disks - sb->delta_disks - parity))) {
diff --git a/super1.c b/super1.c
index e3e2f954..d4bdca77 100644
--- a/super1.c
+++ b/super1.c
@@ -1530,8 +1530,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 			 * So we reject a revert-reshape unless the
 			 * alignment is good.
 			 */
-			if (__le32_to_cpu(sb->level) >= 4 &&
-			    __le32_to_cpu(sb->level) <= 6) {
+			if (is_level456(__le32_to_cpu(sb->level))) {
 				reshape_sectors =
 					__le64_to_cpu(sb->reshape_position);
 				reshape_chunk = __le32_to_cpu(sb->new_chunk);
-- 
2.27.0

