Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA49DC00140
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 14:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343911AbiHRO6s (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 10:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343937AbiHRO6b (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 10:58:31 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B7B14036
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 07:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660834700; x=1692370700;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wMABWFdKE/OCq7QW76Qa+gsuTeduwsLvTK7oYl81Cfg=;
  b=ILTDMsKwnJGhBBYyyrOeuNYf/gXWdIdg49u72NwZmY3OIortKAtYIfrW
   M0AzK/k5a6NH1zPYts59oLMlYhqXRa+oSp1v9/qnhW3t2jaVWVe169aST
   ihFVnCE2NqiWzwvodZARz4urp9lS2t0xvNJV6jrG5Gsq7CVDZvzZ0WyJl
   JCJSW+kFvn9Tp8WsPmxKJoTXNtt0ECF15HGEi3cKNC7QXkyPf++lcHQFw
   dGhw7CHGtYrq3rPxkfNOCYD/chPlKO20m/2mOjww8V7OndjwZS3C9E6Xk
   iwaqQHl+Ij3rip4Ck1CpjXfWqYw2EdkikeaaVuvSlryDNozZE896ZU6v4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="379069675"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="379069675"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:58:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="676084849"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.52])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 07:58:18 -0700
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 08/10] Change update to enum in update_super and update_subarray
Date:   Thu, 18 Aug 2022 16:56:19 +0200
Message-Id: <20220818145621.21982-9-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220818145621.21982-1-mateusz.kusiak@intel.com>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Use already existing enum, change update_super and update_subarray
update to enum globally.
Refactor function references also.
Remove code specific options from update_options.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Assemble.c    | 14 +++++++++-----
 Examine.c     |  2 +-
 Grow.c        |  9 +++++----
 Manage.c      | 14 ++++++++------
 maps.c        | 21 ---------------------
 mdadm.h       | 12 +++++++++---
 super-intel.c | 16 ++++++++--------
 super0.c      |  9 ++++-----
 super1.c      | 17 ++++++++---------
 9 files changed, 52 insertions(+), 62 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 6df6bfbc..8cd3d533 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -695,12 +695,16 @@ static int load_devices(struct devs *devices, char *devmap,
 			} else if (strcmp(c->update, "revert-reshape") == 0 &&
 				   c->invalid_backup)
 				err = tst->ss->update_super(tst, content,
-							    "revert-reshape-nobackup",
+							    UOPT_SPEC_REVERT_RESHAPE_NOBACKUP,
 							    devname, c->verbose,
 							    ident->uuid_set,
 							    c->homehost);
 			else
-				err = tst->ss->update_super(tst, content, c->update,
+				/*
+				 * Mapping is temporary, will be removed in this patchset
+				 */
+				err = tst->ss->update_super(tst, content,
+							    map_name(update_options, c->update),
 							    devname, c->verbose,
 							    ident->uuid_set,
 							    c->homehost);
@@ -960,7 +964,7 @@ static int force_array(struct mdinfo *content,
 			continue;
 		}
 		content->events = devices[most_recent].i.events;
-		tst->ss->update_super(tst, content, "force-one",
+		tst->ss->update_super(tst, content, UOPT_SPEC_FORCE_ONE,
 				      devices[chosen_drive].devname, c->verbose,
 				      0, NULL);
 
@@ -1789,7 +1793,7 @@ try_again:
 		if (!(devices[j].i.array.state & 1))
 			clean = 0;
 
-		if (st->ss->update_super(st, &devices[j].i, "assemble", NULL,
+		if (st->ss->update_super(st, &devices[j].i, UOPT_SPEC_ASSEMBLE, NULL,
 					 c->verbose, 0, NULL)) {
 			if (c->force) {
 				if (c->verbose >= 0)
@@ -1813,7 +1817,7 @@ try_again:
 	    !enough(content->array.level, content->array.raid_disks,
 		    content->array.layout, clean,
 		    avail)) {
-		change += st->ss->update_super(st, content, "force-array",
+		change += st->ss->update_super(st, content, UOPT_SPEC_FORCE_ARRAY,
 					       devices[chosen_drive].devname, c->verbose,
 					       0, NULL);
 		was_forced = 1;
diff --git a/Examine.c b/Examine.c
index 9574a3cc..c9605a60 100644
--- a/Examine.c
+++ b/Examine.c
@@ -117,7 +117,7 @@ int Examine(struct mddev_dev *devlist,
 		}
 
 		if (c->SparcAdjust)
-			st->ss->update_super(st, NULL, "sparc2.2",
+			st->ss->update_super(st, NULL, UOPT_SPARC22,
 					     devlist->devname, 0, 0, NULL);
 		/* Ok, its good enough to try, though the checksum could be wrong */
 
diff --git a/Grow.c b/Grow.c
index 97f22c75..83b38a71 100644
--- a/Grow.c
+++ b/Grow.c
@@ -196,7 +196,7 @@ int Grow_Add_device(char *devname, int fd, char *newdev)
 	info.disk.minor = minor(rdev);
 	info.disk.raid_disk = d;
 	info.disk.state = (1 << MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE);
-	if (st->ss->update_super(st, &info, "linear-grow-new", newdev,
+	if (st->ss->update_super(st, &info, UOPT_SPEC_LINEAR_GROW_NEW, newdev,
 				 0, 0, NULL) != 0) {
 		pr_err("Preparing new metadata failed on %s\n", newdev);
 		close(nfd);
@@ -254,7 +254,7 @@ int Grow_Add_device(char *devname, int fd, char *newdev)
 		info.array.active_disks = nd+1;
 		info.array.working_disks = nd+1;
 
-		if (st->ss->update_super(st, &info, "linear-grow-update", dv,
+		if (st->ss->update_super(st, &info, UOPT_SPEC_LINEAR_GROW_UPDATE, dv,
 				     0, 0, NULL) != 0) {
 			pr_err("Updating metadata failed on %s\n", dv);
 			close(fd2);
@@ -665,7 +665,7 @@ int Grow_consistency_policy(char *devname, int fd, struct context *c, struct sha
 					goto free_info;
 				}
 
-				ret = st->ss->update_super(st, sra, "ppl",
+				ret = st->ss->update_super(st, sra, UOPT_PPL,
 							   devname,
 							   c->verbose, 0, NULL);
 				if (ret) {
@@ -4941,7 +4941,8 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 				continue;
 			st->ss->getinfo_super(st, &dinfo, NULL);
 			dinfo.reshape_progress = info->reshape_progress;
-			st->ss->update_super(st, &dinfo, "_reshape_progress",
+			st->ss->update_super(st, &dinfo,
+					     UOPT_SPEC__RESHAPE_PROGRESS,
 					     NULL,0, 0, NULL);
 			st->ss->store_super(st, fdlist[j]);
 			st->ss->free_super(st);
diff --git a/Manage.c b/Manage.c
index b9f0b184..c47b6262 100644
--- a/Manage.c
+++ b/Manage.c
@@ -605,6 +605,7 @@ int attempt_re_add(int fd, int tfd, struct mddev_dev *dv,
 	struct mdinfo mdi;
 	int duuid[4];
 	int ouuid[4];
+	enum update_opt update_enum = map_name(update_options, update);
 
 	dev_st->ss->getinfo_super(dev_st, &mdi, NULL);
 	dev_st->ss->uuid_from_super(dev_st, ouuid);
@@ -666,23 +667,23 @@ int attempt_re_add(int fd, int tfd, struct mddev_dev *dv,
 
 			if (dv->writemostly == FlagSet)
 				rv = dev_st->ss->update_super(
-					dev_st, NULL, "writemostly",
+					dev_st, NULL, UOPT_SPEC_WRITEMOSTLY,
 					devname, verbose, 0, NULL);
 			if (dv->writemostly == FlagClear)
 				rv = dev_st->ss->update_super(
-					dev_st, NULL, "readwrite",
+					dev_st, NULL, UOPT_SPEC_READWRITE,
 					devname, verbose, 0, NULL);
 			if (dv->failfast == FlagSet)
 				rv = dev_st->ss->update_super(
-					dev_st, NULL, "failfast",
+					dev_st, NULL, UOPT_SPEC_FAILFAST,
 					devname, verbose, 0, NULL);
 			if (dv->failfast == FlagClear)
 				rv = dev_st->ss->update_super(
-					dev_st, NULL, "nofailfast",
+					dev_st, NULL, UOPT_SPEC_NOFAILFAST,
 					devname, verbose, 0, NULL);
 			if (update)
 				rv = dev_st->ss->update_super(
-					dev_st, NULL, update,
+					dev_st, NULL, update_enum,
 					devname, verbose, 0, NULL);
 			if (rv == 0)
 				rv = dev_st->ss->store_super(dev_st, tfd);
@@ -1680,6 +1681,7 @@ int Update_subarray(char *dev, char *subarray, char *update, struct mddev_ident
 	struct supertype supertype, *st = &supertype;
 	int fd, rv = 2;
 	struct mdinfo *info = NULL;
+	enum update_opt update_enum = map_name(update_options, update);
 
 	memset(st, 0, sizeof(*st));
 
@@ -1711,7 +1713,7 @@ int Update_subarray(char *dev, char *subarray, char *update, struct mddev_ident
 		goto free_super;
 	}
 
-	rv = st->ss->update_subarray(st, subarray, update, ident);
+	rv = st->ss->update_subarray(st, subarray, update_enum, ident);
 
 	if (rv) {
 		if (verbose >= 0)
diff --git a/maps.c b/maps.c
index c59036f1..b586679a 100644
--- a/maps.c
+++ b/maps.c
@@ -194,27 +194,6 @@ mapping_t update_options[] = {
 	{ "byteorder", UOPT_BYTEORDER },
 	{ "help", UOPT_HELP },
 	{ "?", UOPT_HELP },
-	/*
-	 * Those enries are temporary and will be removed in this patchset.
-	 *
-	 * Before update_super:update can be changed to enum,
-	 * all update_super sub-functions must be adapted first.
-	 * Update options will be passed as string (as it is for now),
-	 * and then mapped, so all options must be handled temporarily.
-	 *
-	 * Those options code specific and should not be accessible for user.
-	 */
-	{ "force-one", UOPT_SPEC_FORCE_ONE },
-	{ "force-array", UOPT_SPEC_FORCE_ARRAY },
-	{ "assemble", UOPT_SPEC_ASSEMBLE },
-	{ "linear-grow-new", UOPT_SPEC_LINEAR_GROW_NEW },
-	{ "linear-grow-update", UOPT_SPEC_LINEAR_GROW_UPDATE },
-	{ "_reshape_progress", UOPT_SPEC__RESHAPE_PROGRESS },
-	{ "writemostly", UOPT_SPEC_WRITEMOSTLY },
-	{ "readwrite", UOPT_SPEC_READWRITE },
-	{ "failfast", UOPT_SPEC_FAILFAST },
-	{ "nofailfast", UOPT_SPEC_NOFAILFAST },
-	{ "revert-reshape-nobackup", UOPT_SPEC_REVERT_RESHAPE_NOBACKUP },
 	{ NULL, UOPT_UNDEFINED}
 };
 
diff --git a/mdadm.h b/mdadm.h
index 7bc31b16..afc2e2a8 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1010,7 +1010,7 @@ extern struct superswitch {
 	 *                    it will resume going in the opposite direction.
 	 */
 	int (*update_super)(struct supertype *st, struct mdinfo *info,
-			    char *update,
+			    enum update_opt update,
 			    char *devname, int verbose,
 			    int uuid_set, char *homehost);
 
@@ -1136,9 +1136,15 @@ extern struct superswitch {
 	/* Permit subarray's to be deleted from inactive containers */
 	int (*kill_subarray)(struct supertype *st,
 			     char *subarray_id); /* optional */
-	/* Permit subarray's to be modified */
+	/**
+	 * update_subarray() - Permit subarray to be modified.
+	 * @st: Supertype.
+	 * @subarray: Subarray name.
+	 * @update: Update option.
+	 * @ident: Optional identifiers.
+	 */
 	int (*update_subarray)(struct supertype *st, char *subarray,
-			       char *update, struct mddev_ident *ident); /* optional */
+			       enum update_opt update, struct mddev_ident *ident);
 	/* Check if reshape is supported for this external format.
 	 * st is obtained from super_by_fd() where st->subarray[0] is
 	 * initialized to indicate if reshape is being performed at the
diff --git a/super-intel.c b/super-intel.c
index 3de3873e..ce1db58b 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3893,8 +3893,8 @@ struct mdinfo *getinfo_super_disks_imsm(struct supertype *st)
 }
 
 static int update_super_imsm(struct supertype *st, struct mdinfo *info,
-			     char *update, char *devname, int verbose,
-			     int uuid_set, char *homehost)
+			     enum update_opt update, char *devname,
+			     int verbose, int uuid_set, char *homehost)
 {
 	/* For 'assemble' and 'force' we need to return non-zero if any
 	 * change was made.  For others, the return value is ignored.
@@ -3930,7 +3930,7 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 
 	mpb = super->anchor;
 
-	switch (map_name(update_options, update)) {
+	switch (update) {
 	case UOPT_UUID:
 		/* We take this to mean that the family_num should be updated.
 		 * However that is much smaller than the uuid so we cannot really
@@ -6538,7 +6538,7 @@ static int validate_ppl_imsm(struct supertype *st, struct mdinfo *info,
 		if (mdmon_running(st->container_devnm))
 			st->update_tail = &st->updates;
 
-		if (st->ss->update_subarray(st, subarray, "ppl", NULL)) {
+		if (st->ss->update_subarray(st, subarray, UOPT_PPL, NULL)) {
 			pr_err("Failed to update subarray %s\n",
 			      subarray);
 		} else {
@@ -7915,13 +7915,13 @@ static int get_rwh_policy_from_update(enum update_opt update)
 }
 
 static int update_subarray_imsm(struct supertype *st, char *subarray,
-				char *update, struct mddev_ident *ident)
+				enum update_opt update, struct mddev_ident *ident)
 {
 	/* update the subarray currently referenced by ->current_vol */
 	struct intel_super *super = st->sb;
 	struct imsm_super *mpb = super->anchor;
 
-	if (map_name(update_options, update) == UOPT_NAME) {
+	if (update == UOPT_NAME) {
 		char *name = ident->name;
 		char *ep;
 		int vol;
@@ -7955,7 +7955,7 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 			}
 			super->updates_pending++;
 		}
-	} else if (get_rwh_policy_from_update(map_name(update_options, update)) != UOPT_UNDEFINED) {
+	} else if (get_rwh_policy_from_update(update) != UOPT_UNDEFINED) {
 		int new_policy;
 		char *ep;
 		int vol = strtoul(subarray, &ep, 10);
@@ -7963,7 +7963,7 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 		if (*ep != '\0' || vol >= super->anchor->num_raid_devs)
 			return 2;
 
-		new_policy = get_rwh_policy_from_update(map_name(update_options, update));
+		new_policy = get_rwh_policy_from_update(update);
 
 		if (st->update_tail) {
 			struct imsm_update_rwh_policy *u = xmalloc(sizeof(*u));
diff --git a/super0.c b/super0.c
index 4e53f41e..0804993e 100644
--- a/super0.c
+++ b/super0.c
@@ -491,7 +491,7 @@ static struct mdinfo *container_content0(struct supertype *st, char *subarray)
 }
 
 static int update_super0(struct supertype *st, struct mdinfo *info,
-			 char *update,
+			 enum update_opt update,
 			 char *devname, int verbose,
 			 int uuid_set, char *homehost)
 {
@@ -502,20 +502,19 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
 	int rv = 0;
 	int uuid[4];
 	mdp_super_t *sb = st->sb;
-	enum update_opt update_enum = map_name(update_options, update);
 
-	if (update_enum == UOPT_HOMEHOST && homehost) {
+	if (update == UOPT_HOMEHOST && homehost) {
 		/*
 		 * note that 'homehost' is special as it is really
 		 * a "uuid" update.
 		 */
 		uuid_set = 0;
-		update_enum = UOPT_UUID;
+		update = UOPT_UUID;
 		info->uuid[0] = sb->set_uuid0;
 		info->uuid[1] = sb->set_uuid1;
 	}
 
-	switch (update_enum) {
+	switch (update) {
 	case UOPT_UUID:
 		if (!uuid_set && homehost) {
 			char buf[20];
diff --git a/super1.c b/super1.c
index 6c81c1b9..e6cc9b00 100644
--- a/super1.c
+++ b/super1.c
@@ -1202,7 +1202,7 @@ static struct mdinfo *container_content1(struct supertype *st, char *subarray)
 }
 
 static int update_super1(struct supertype *st, struct mdinfo *info,
-			 char *update, char *devname, int verbose,
+			 enum update_opt update, char *devname, int verbose,
 			 int uuid_set, char *homehost)
 {
 	/* NOTE: for 'assemble' and 'force' we need to return non-zero
@@ -1212,15 +1212,14 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 	int rv = 0;
 	struct mdp_superblock_1 *sb = st->sb;
 	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + MAX_SB_SIZE);
-	enum update_opt update_enum = map_name(update_options, update);
 
-	if (update_enum == UOPT_HOMEHOST && homehost) {
+	if (update == UOPT_HOMEHOST && homehost) {
 		/*
 		 * Note that 'homehost' is special as it is really
 		 * a "name" update.
 		 */
 		char *c;
-		update_enum = UOPT_NAME;
+		update = UOPT_NAME;
 		c = strchr(sb->set_name, ':');
 		if (c)
 			snprintf(info->name, sizeof(info->name), "%s", c+1);
@@ -1228,7 +1227,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 			snprintf(info->name, sizeof(info->name), "%s", sb->set_name);
 	}
 
-	switch (update_enum) {
+	switch (update) {
 	case UOPT_NAME:
 		if (!info->name[0])
 			snprintf(info->name, sizeof(info->name), "%d", info->array.md_minor);
@@ -1526,7 +1525,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 			 * If that couldn't happen, the "-nobackup" version
 			 * will be used.
 			 */
-			if (update_enum == UOPT_SPEC_REVERT_RESHAPE_NOBACKUP &&
+			if (update == UOPT_SPEC_REVERT_RESHAPE_NOBACKUP &&
 			    sb->reshape_position == 0 &&
 			    (__le32_to_cpu(sb->delta_disks) > 0 ||
 			     (__le32_to_cpu(sb->delta_disks) == 0 &&
@@ -1607,14 +1606,14 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 	case UOPT_LAYOUT_UNSPECIFIED:
 		if (__le32_to_cpu(sb->level) != 0) {
 			pr_err("%s: %s only supported for RAID0\n",
-			       devname ?: "", map_num(update_options, update_enum));
+			       devname ?: "", map_num(update_options, update));
 			rv = -1;
-		} else if (update_enum == UOPT_LAYOUT_UNSPECIFIED) {
+		} else if (update == UOPT_LAYOUT_UNSPECIFIED) {
 			sb->feature_map &= ~__cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);
 			sb->layout = 0;
 		} else {
 			sb->feature_map |= __cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);
-			sb->layout = __cpu_to_le32(update_enum == UOPT_LAYOUT_ORIGINAL ? 1 : 2);
+			sb->layout = __cpu_to_le32(update == UOPT_LAYOUT_ORIGINAL ? 1 : 2);
 		}
 		break;
 	default:
-- 
2.26.2

