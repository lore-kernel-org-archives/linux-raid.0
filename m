Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D93C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 23 Mar 2022 09:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243068AbiCWJIR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Mar 2022 05:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243122AbiCWJH5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Mar 2022 05:07:57 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2929074857
        for <linux-raid@vger.kernel.org>; Wed, 23 Mar 2022 02:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648026388; x=1679562388;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UlF3Q/qYhMsT6eVa56fqZvbBJRofwDbO11ciVK6aOD8=;
  b=WTd7ECPPCEJ8CLla0pROhuBRzsdYua6tZXlY5eC7/cMuPRTZ9uQCRsP6
   dPiM9Ww7wPcOrol3027hK+xxXRKXG+1R02YY3b44s6zWmywhRQoysy6Vu
   RSOWYbD78kpg1SpZaOtAgF3ybCgK6HIx0NzhkaLS/X9lDwDNWFgJ2SEX8
   TBXI+a5ZgAg1lke9Hn0FsvvqgAXdcqWi607AT7+ltrEAW1fmU2QvyXFr2
   NIBaWjVseXqcliJNU+DbFNzDWv4vvUaJ5XxyI5Jnao720apF8RIVleBd7
   R1PLZlDuZ6rSEXiwe9DBADUTto+WY46w6HAVVDr0Ui4ZQwsaHzZxf/gQl
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="318770754"
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="318770754"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 02:06:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="560809491"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga008.jf.intel.com with ESMTP; 23 Mar 2022 02:06:26 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 2/2] mdadm: replace container level checking with inline
Date:   Wed, 23 Mar 2022 10:10:01 +0100
Message-Id: <20220323091001.27139-3-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220323091001.27139-1-kinga.tanska@intel.com>
References: <20220323091001.27139-1-kinga.tanska@intel.com>
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
index f31372db..27324939 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1123,7 +1123,7 @@ static int start_array(int mdfd,
 			       i/2, mddev);
 	}
 
-	if (content->array.level == LEVEL_CONTAINER) {
+	if (is_container(content->array.level)) {
 		sysfs_rules_apply(mddev, content);
 		if (c->verbose >= 0) {
 			pr_err("Container %s has been assembled with %d drive%s",
@@ -1553,8 +1553,7 @@ try_again:
 			 */
 			trustworthy = LOCAL;
 
-		if (name[0] == 0 &&
-		    content->array.level == LEVEL_CONTAINER) {
+		if (!name[0] && is_container(content->array.level)) {
 			name = content->text_version;
 			trustworthy = METADATA;
 		}
diff --git a/Create.c b/Create.c
index 0ff1922d..6edc4ad3 100644
--- a/Create.c
+++ b/Create.c
@@ -472,7 +472,7 @@ int Create(struct supertype *st, char *mddev,
 			    st->minor_version >= 1)
 				/* metadata at front */
 				warn |= check_partitions(fd, dname, 0, 0);
-			else if (s->level == 1 || s->level == LEVEL_CONTAINER ||
+			else if (s->level == 1 || is_container(s->level) ||
 				 (s->level == 0 && s->raiddisks == 1))
 				/* partitions could be meaningful */
 				warn |= check_partitions(fd, dname, freesize*2, s->size*2);
@@ -982,7 +982,7 @@ int Create(struct supertype *st, char *mddev,
 			 * again returns container info.
 			 */
 			st->ss->getinfo_super(st, &info_new, NULL);
-			if (st->ss->external && s->level != LEVEL_CONTAINER &&
+			if (st->ss->external && !is_container(s->level) &&
 			    !same_uuid(info_new.uuid, info.uuid, 0)) {
 				map_update(&map, fd2devnm(mdfd),
 					   info_new.text_version,
@@ -1025,7 +1025,7 @@ int Create(struct supertype *st, char *mddev,
 	map_unlock(&map);
 	free(infos);
 
-	if (s->level == LEVEL_CONTAINER) {
+	if (is_container(s->level)) {
 		/* No need to start.  But we should signal udev to
 		 * create links */
 		sysfs_uevent(&info, "change");
diff --git a/Grow.c b/Grow.c
index 9c6fc95e..391c4212 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2156,7 +2156,7 @@ size_change_error:
 					devname, s->size);
 		}
 		changed = 1;
-	} else if (array.level != LEVEL_CONTAINER) {
+	} else if (!is_container(array.level)) {
 		s->size = get_component_size(fd)/2;
 		if (s->size == 0)
 			s->size = array.size;
@@ -2212,7 +2212,7 @@ size_change_error:
 	info.component_size = s->size*2;
 	info.new_level = s->level;
 	info.new_chunk = s->chunk * 1024;
-	if (info.array.level == LEVEL_CONTAINER) {
+	if (is_container(info.array.level)) {
 		info.delta_disks = UnSet;
 		info.array.raid_disks = s->raiddisks;
 	} else if (s->raiddisks)
@@ -2325,7 +2325,7 @@ size_change_error:
 				printf("layout for %s set to %d\n",
 				       devname, array.layout);
 		}
-	} else if (array.level == LEVEL_CONTAINER) {
+	} else if (is_container(array.level)) {
 		/* This change is to be applied to every array in the
 		 * container.  This is only needed when the metadata imposes
 		 * restraints of the various arrays in the container.
diff --git a/Incremental.c b/Incremental.c
index a57fc323..077d4eea 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -244,7 +244,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 		c->autof = ci->autof;
 
 	name_to_use = info.name;
-	if (name_to_use[0] == 0 && info.array.level == LEVEL_CONTAINER) {
+	if (name_to_use && is_container(info.array.level)) {
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
index c7268a71..371927ae 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1885,3 +1885,17 @@ enum r0layout {
  * This is true for native and DDF, IMSM allows 16.
  */
 #define MD_NAME_MAX 32
+
+/**
+ * is_container() - check if @level is &LEVEL_CONTAINER
+ * @level: level value
+ *
+ * return:
+ * &true if level is equal to &LEVEL_CONTAINER, &false otherwise.
+ */
+static inline bool is_container(const int level)
+{
+	if (level == LEVEL_CONTAINER)
+		return true;
+	return false;
+}
\ No newline at end of file
diff --git a/super-ddf.c b/super-ddf.c
index 3f304cdc..bd366da2 100644
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
index d5fad102..7376a2e9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6661,7 +6661,7 @@ static int validate_geometry_imsm_container(struct supertype *st, int level,
 	struct intel_super *super = NULL;
 	int rv = 0;
 
-	if (level != LEVEL_CONTAINER)
+	if (!is_container(level))
 		return 0;
 	if (!dev)
 		return 1;
@@ -7580,7 +7580,7 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 	 * if given unused devices create a container
 	 * if given given devices in a container create a member volume
 	 */
-	if (level == LEVEL_CONTAINER)
+	if (is_container(level))
 		/* Must be a fresh device to add to a container */
 		return validate_geometry_imsm_container(st, level, raiddisks,
 							data_offset, dev,
diff --git a/super0.c b/super0.c
index b79b97a9..87a4b374 100644
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
index a12a5bc8..d3a48478 100644
--- a/super1.c
+++ b/super1.c
@@ -2800,7 +2800,7 @@ static int validate_geometry1(struct supertype *st, int level,
 	unsigned long long overhead;
 	int fd;
 
-	if (level == LEVEL_CONTAINER) {
+	if (is_container(level)) {
 		if (verbose)
 			pr_err("1.x metadata does not support containers\n");
 		return 0;
diff --git a/sysfs.c b/sysfs.c
index 2995713d..054842c2 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -762,7 +762,7 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
 
 	rv = sysfs_set_num(sra, sd, "offset", sd->data_offset);
 	rv |= sysfs_set_num(sra, sd, "size", (sd->component_size+1) / 2);
-	if (sra->array.level != LEVEL_CONTAINER) {
+	if (!is_container(sra->array.level)) {
 		if (sra->consistency_policy == CONSISTENCY_POLICY_PPL) {
 			rv |= sysfs_set_num(sra, sd, "ppl_sector", sd->ppl_sector);
 			rv |= sysfs_set_num(sra, sd, "ppl_size", sd->ppl_size);
-- 
2.26.2

