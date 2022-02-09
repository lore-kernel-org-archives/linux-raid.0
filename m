Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78529C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  9 Feb 2022 09:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242660AbiBIJCd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Feb 2022 04:02:33 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239265AbiBIJCY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Feb 2022 04:02:24 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846CDE01566E
        for <linux-raid@vger.kernel.org>; Wed,  9 Feb 2022 01:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644397324; x=1675933324;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3eQfLGCO1Q8xbuPvmjNEtNgitmsItLFoP6PL5w9wWcA=;
  b=cxM38cdpBQhbgK2V5Mz/cG/axYc5Q//y/Dapfy9Ie1uGNy2/Y5K/eBvI
   R3RM4wAEiYB8yG2iHTJBidb1v7dBYANE5O3ZzeYxyn/wB2ZQsPyT7pRiu
   CcCX0VNaY7yO7X1uxzqyFknUWzcUUPZCCdbLXJLQQlYq7Yamzv3T/yk2+
   ceQViHHa+lwhYVg4JPcOrLiDVklGpFpE6CBj7u4MbRFAuX8JvSHSeYO4f
   CyWNKj2OSUr/xl7n8zXvLsOWfL7+ArBI4+zLxqEGrg+LbssaVC6gKz8ET
   b3zutpcbNbC83vpWyJGtCbVuStCjoboEThxRCsD8O0wB4LHNDO8LYb+Y2
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="232725663"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="232725663"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 00:54:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="622206900"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Feb 2022 00:54:17 -0800
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] Monitor: use devname as char array instead of pointer
Date:   Wed,  9 Feb 2022 09:56:28 +0100
Message-Id: <20220209085628.11418-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Device name wasn't filled properly due to incorrect use of strcpy.
Instead pointer, devname with fixed size is used and safer string
functions are propagated.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Monitor.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 30c031a2..d02344ec 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -34,8 +34,8 @@
 #endif
 
 struct state {
-	char *devname;
-	char devnm[32];	/* to sync with mdstat info */
+	char devname[MD_NAME_MAX + 8];
+	char devnm[MD_NAME_MAX];	/* to sync with mdstat info */
 	unsigned int utime;
 	int err;
 	char *spare_group;
@@ -46,7 +46,7 @@ struct state {
 	int devstate[MAX_DISKS];
 	dev_t devid[MAX_DISKS];
 	int percent;
-	char parent_devnm[32]; /* For subarray, devnm of parent.
+	char parent_devnm[MD_NAME_MAX]; /* For subarray, devnm of parent.
 				* For others, ""
 				*/
 	struct supertype *metadata;
@@ -184,13 +184,7 @@ int Monitor(struct mddev_dev *devlist,
 			if (strcasecmp(mdlist->devname, "<ignore>") == 0)
 				continue;
 			st = xcalloc(1, sizeof *st);
-			if (mdlist->devname[0] == '/')
-				st->devname = xstrdup(mdlist->devname);
-			else {
-				st->devname = xmalloc(8+strlen(mdlist->devname)+1);
-				strcpy(strcpy(st->devname, "/dev/md/"),
-				       mdlist->devname);
-			}
+			snprintf(st->devname, MD_NAME_MAX + 8, "/dev/md/%s", basename(mdlist->devname));
 			st->next = statelist;
 			st->devnm[0] = 0;
 			st->percent = RESYNC_UNKNOWN;
@@ -206,7 +200,7 @@ int Monitor(struct mddev_dev *devlist,
 		for (dv = devlist; dv; dv = dv->next) {
 			struct state *st = xcalloc(1, sizeof *st);
 			mdlist = conf_get_ident(dv->devname);
-			st->devname = xstrdup(dv->devname);
+			snprintf(st->devname, MD_NAME_MAX + 8, "%s", dv->devname);
 			st->next = statelist;
 			st->devnm[0] = 0;
 			st->percent = RESYNC_UNKNOWN;
@@ -289,7 +283,6 @@ int Monitor(struct mddev_dev *devlist,
 		for (stp = &statelist; (st = *stp) != NULL; ) {
 			if (st->from_auto && st->err > 5) {
 				*stp = st->next;
-				free(st->devname);
 				free(st->spare_group);
 				free(st);
 			} else
@@ -540,7 +533,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		goto disappeared;
 
 	if (st->devnm[0] == 0)
-		strcpy(st->devnm, fd2devnm(fd));
+		snprintf(st->devnm, MD_NAME_MAX, "%s", fd2devnm(fd));
 
 	for (mse2 = mdstat; mse2; mse2 = mse2->next)
 		if (strcmp(mse2->devnm, st->devnm) == 0) {
@@ -670,7 +663,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	    strncmp(mse->metadata_version, "external:", 9) == 0 &&
 	    is_subarray(mse->metadata_version+9)) {
 		char *sl;
-		strcpy(st->parent_devnm, mse->metadata_version + 10);
+		snprintf(st->parent_devnm, MD_NAME_MAX, "%s", mse->metadata_version + 10);
 		sl = strchr(st->parent_devnm, '/');
 		if (sl)
 			*sl = 0;
@@ -758,14 +751,13 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 				continue;
 			}
 
-			st->devname = xstrdup(name);
+			snprintf(st->devname, MD_NAME_MAX + 8, "%s", name);
 			if ((fd = open(st->devname, O_RDONLY)) < 0 ||
 			    md_get_array_info(fd, &array) < 0) {
 				/* no such array */
 				if (fd >= 0)
 					close(fd);
 				put_md_name(st->devname);
-				free(st->devname);
 				if (st->metadata) {
 					st->metadata->ss->free_super(st->metadata);
 					free(st->metadata);
@@ -777,7 +769,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 			st->next = *statelist;
 			st->err = 1;
 			st->from_auto = 1;
-			strcpy(st->devnm, mse->devnm);
+			snprintf(st->devnm, MD_NAME_MAX, "%s", mse->devnm);
 			st->percent = RESYNC_UNKNOWN;
 			st->expected_spares = -1;
 			if (mse->metadata_version &&
@@ -785,8 +777,8 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 				    "external:", 9) == 0 &&
 			    is_subarray(mse->metadata_version+9)) {
 				char *sl;
-				strcpy(st->parent_devnm,
-					mse->metadata_version+10);
+				snprintf(st->parent_devnm, MD_NAME_MAX,
+					 "%s", mse->metadata_version + 10);
 				sl = strchr(st->parent_devnm, '/');
 				*sl = 0;
 			} else
-- 
2.26.2

