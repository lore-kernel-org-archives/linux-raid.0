Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1469AC433EF
	for <linux-raid@archiver.kernel.org>; Tue,  5 Jul 2022 11:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiGELvn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Jul 2022 07:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiGELvk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Jul 2022 07:51:40 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5E7175A8
        for <linux-raid@vger.kernel.org>; Tue,  5 Jul 2022 04:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657021899; x=1688557899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MLFjAgVMSITdirT7gV+aMn6XSsuNDJPgTBjJrYEKc0U=;
  b=CjktxIJPxprWw1EJsehvKET8IFSLUkxRFdRNhoYqbjPNE1vT+uImIcGG
   v3DwRq7kpGAdJmMe5ysPjnlqHAraL1AArKwQuO0/Kk3IhOXLVdEEqCY1F
   xzcZlREiZlP7hBMCXJ0nxsQSoHMS0rgLmj1+Xyd/Sb5keDxVHBG2qR9Qk
   Qt8f8EeAsI9tSA9Z7okGskE9p1dimvqEG22IwY6pFsnIasC7s205LcmRu
   OviMfuHNB1kVCBc/b/c2uKzzsL1G3bdzroJzjrPLvi8izTCvGCRAkwa18
   9O4O+qkTSfLiFKh3SF+4gcgu2KzCEoD2e4eIIQT7sEu3Jn9uA74pSS0bh
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="284065307"
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="284065307"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 04:51:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="619800216"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga008.jf.intel.com with ESMTP; 05 Jul 2022 04:51:38 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH v3 2/2] mdadm: replace container level checking with inline
Date:   Tue,  5 Jul 2022 13:58:12 +0200
Message-Id: <20220705115812.6946-3-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220705115812.6946-1-kinga.tanska@intel.com>
References: <20220705115812.6946-1-kinga.tanska@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

To unify all containers checks in code, is_container() function is
added and propagated.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Assemble.c    |  5 ++---
 Create.c      |  6 +++---
 Grow.c        |  6 +++---
 Incremental.c |  4 ++--
 mdadm.h       | 14 ++++++++++++++
 super-ddf.c   |  6 +++---
 super-intel.c |  4 ++--
 super0.c      |  2 +-
 super1.c      |  2 +-
 sysfs.c       |  2 +-
 10 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 6df6bfbc..2731ad4e 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1120,7 +1120,7 @@ static int start_array(int mdfd,
 			       i/2, mddev);
 	}
 
-	if (content->array.level == LEVEL_CONTAINER) {
+	if (is_container(content->array.level)) {
 		sysfs_rules_apply(mddev, content);
 		if (c->verbose >= 0) {
 			pr_err("Container %s has been assembled with %d drive%s",
@@ -1549,8 +1549,7 @@ try_again:
 			 */
 			trustworthy = LOCAL;
 
-		if (name[0] == 0 &&
-		    content->array.level == LEVEL_CONTAINER) {
+		if (!name[0] && is_container(content->array.level)) {
 			name = content->text_version;
 			trustworthy = METADATA;
 		}
diff --git a/Create.c b/Create.c
index c84c1ac8..a6d2483d 100644
--- a/Create.c
+++ b/Create.c
@@ -487,7 +487,7 @@ int Create(struct supertype *st, char *mddev,
 			    st->minor_version >= 1)
 				/* metadata at front */
 				warn |= check_partitions(fd, dname, 0, 0);
-			else if (s->level == 1 || s->level == LEVEL_CONTAINER ||
+			else if (s->level == 1 || is_container(s->level) ||
 				 (s->level == 0 && s->raiddisks == 1))
 				/* partitions could be meaningful */
 				warn |= check_partitions(fd, dname, freesize*2, s->size*2);
@@ -997,7 +997,7 @@ int Create(struct supertype *st, char *mddev,
 			 * again returns container info.
 			 */
 			st->ss->getinfo_super(st, &info_new, NULL);
-			if (st->ss->external && s->level != LEVEL_CONTAINER &&
+			if (st->ss->external && !is_container(s->level) &&
 			    !same_uuid(info_new.uuid, info.uuid, 0)) {
 				map_update(&map, fd2devnm(mdfd),
 					   info_new.text_version,
@@ -1040,7 +1040,7 @@ int Create(struct supertype *st, char *mddev,
 	map_unlock(&map);
 	free(infos);
 
-	if (s->level == LEVEL_CONTAINER) {
+	if (is_container(s->level)) {
 		/* No need to start.  But we should signal udev to
 		 * create links */
 		sysfs_uevent(&info, "change");
diff --git a/Grow.c b/Grow.c
index 8c520d42..6136aa3e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2169,7 +2169,7 @@ size_change_error:
 					devname, s->size);
 		}
 		changed = 1;
-	} else if (array.level != LEVEL_CONTAINER) {
+	} else if (!is_container(array.level)) {
 		s->size = get_component_size(fd)/2;
 		if (s->size == 0)
 			s->size = array.size;
@@ -2225,7 +2225,7 @@ size_change_error:
 	info.component_size = s->size*2;
 	info.new_level = s->level;
 	info.new_chunk = s->chunk * 1024;
-	if (info.array.level == LEVEL_CONTAINER) {
+	if (is_container(info.array.level)) {
 		info.delta_disks = UnSet;
 		info.array.raid_disks = s->raiddisks;
 	} else if (s->raiddisks)
@@ -2338,7 +2338,7 @@ size_change_error:
 				printf("layout for %s set to %d\n",
 				       devname, array.layout);
 		}
-	} else if (array.level == LEVEL_CONTAINER) {
+	} else if (is_container(array.level)) {
 		/* This change is to be applied to every array in the
 		 * container.  This is only needed when the metadata imposes
 		 * restraints of the various arrays in the container.
diff --git a/Incremental.c b/Incremental.c
index 4d0cd9d6..5a5f4c4c 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -244,7 +244,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 		c->autof = ci->autof;
 
 	name_to_use = info.name;
-	if (name_to_use[0] == 0 && info.array.level == LEVEL_CONTAINER) {
+	if (name_to_use[0] == 0 && is_container(info.array.level)) {
 		name_to_use = info.text_version;
 		trustworthy = METADATA;
 	}
@@ -472,7 +472,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 
 	/* 7/ Is there enough devices to possibly start the array? */
 	/* 7a/ if not, finish with success. */
-	if (info.array.level == LEVEL_CONTAINER) {
+	if (is_container(info.array.level)) {
 		char devnm[32];
 		/* Try to assemble within the container */
 		sysfs_uevent(sra, "change");
diff --git a/mdadm.h b/mdadm.h
index 974415b9..12450860 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1920,3 +1920,17 @@ enum r0layout {
  * This is true for native and DDF, IMSM allows 16.
  */
 #define MD_NAME_MAX 32
+
+/**
+ * is_container() - check if @level is &LEVEL_CONTAINER
+ * @level: level value
+ *
+ * return:
+ * 1 if level is equal to &LEVEL_CONTAINER, 0 otherwise.
+ */
+static inline int is_container(const int level)
+{
+	if (level == LEVEL_CONTAINER)
+		return 1;
+	return 0;
+}
\ No newline at end of file
diff --git a/super-ddf.c b/super-ddf.c
index abbc8b09..cce241d7 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3345,7 +3345,7 @@ static int validate_geometry_ddf(struct supertype *st,
 
 	if (level == LEVEL_NONE)
 		level = LEVEL_CONTAINER;
-	if (level == LEVEL_CONTAINER) {
+	if (is_container(level)) {
 		/* Must be a fresh device to add to a container */
 		return validate_geometry_ddf_container(st, level, layout,
 						       raiddisks, *chunk,
@@ -3460,7 +3460,7 @@ validate_geometry_ddf_container(struct supertype *st,
 	int fd;
 	unsigned long long ldsize;
 
-	if (level != LEVEL_CONTAINER)
+	if (!is_container(level))
 		return 0;
 	if (!dev)
 		return 1;
@@ -3498,7 +3498,7 @@ static int validate_geometry_ddf_bvd(struct supertype *st,
 	struct dl *dl;
 	unsigned long long maxsize;
 	/* ddf/bvd supports lots of things, but not containers */
-	if (level == LEVEL_CONTAINER) {
+	if (is_container(level)) {
 		if (verbose)
 			pr_err("DDF cannot create a container within an container\n");
 		return 0;
diff --git a/super-intel.c b/super-intel.c
index 8ffe485c..2b50925c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6727,7 +6727,7 @@ static int validate_geometry_imsm_container(struct supertype *st, int level,
 	struct intel_super *super = NULL;
 	int rv = 0;
 
-	if (level != LEVEL_CONTAINER)
+	if (!is_container(level))
 		return 0;
 	if (!dev)
 		return 1;
@@ -7692,7 +7692,7 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 	 * if given unused devices create a container
 	 * if given given devices in a container create a member volume
 	 */
-	if (level == LEVEL_CONTAINER)
+	if (is_container(level))
 		/* Must be a fresh device to add to a container */
 		return validate_geometry_imsm_container(st, level, raiddisks,
 							data_offset, dev,
diff --git a/super0.c b/super0.c
index 37f595ed..93876e2e 100644
--- a/super0.c
+++ b/super0.c
@@ -1273,7 +1273,7 @@ static int validate_geometry0(struct supertype *st, int level,
 	if (get_linux_version() < 3001000)
 		tbmax = 2;
 
-	if (level == LEVEL_CONTAINER) {
+	if (is_container(level)) {
 		if (verbose)
 			pr_err("0.90 metadata does not support containers\n");
 		return 0;
diff --git a/super1.c b/super1.c
index 71af860c..0d0f606e 100644
--- a/super1.c
+++ b/super1.c
@@ -2809,7 +2809,7 @@ static int validate_geometry1(struct supertype *st, int level,
 	unsigned long long overhead;
 	int fd;
 
-	if (level == LEVEL_CONTAINER) {
+	if (is_container(level)) {
 		if (verbose)
 			pr_err("1.x metadata does not support containers\n");
 		return 0;
diff --git a/sysfs.c b/sysfs.c
index 0d98a65f..ca1d888f 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -763,7 +763,7 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
 
 	rv = sysfs_set_num(sra, sd, "offset", sd->data_offset);
 	rv |= sysfs_set_num(sra, sd, "size", (sd->component_size+1) / 2);
-	if (sra->array.level != LEVEL_CONTAINER) {
+	if (!is_container(sra->array.level)) {
 		if (sra->consistency_policy == CONSISTENCY_POLICY_PPL) {
 			rv |= sysfs_set_num(sra, sd, "ppl_sector", sd->ppl_sector);
 			rv |= sysfs_set_num(sra, sd, "ppl_size", sd->ppl_size);
-- 
2.26.2

