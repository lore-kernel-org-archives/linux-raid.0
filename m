Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDD7C00140
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 14:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343885AbiHRO7M (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 10:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343927AbiHRO6l (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 10:58:41 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47C831DDB
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 07:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660834717; x=1692370717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CConeVxtRmBzp20xaOMTDWJZw9RDDkuWxb12mmArUug=;
  b=ZiJ5N/MOiu2jYP0h+rHOL2F+gkMayQafvmPfu/PfjI32pk3MRSvK7yeH
   KlSBcXuEEcQUDahNVJJUm11eBcko5V8y0FqB/RGpxZALpnGwWUugxkN8O
   IzCRglmq0x6S+aEsW4VUBiZ/MWWm5/gdP7b/Ilwq1sduJtswLpsnOeoS6
   aAl7rwOGLtk3yojwPgF+0bT+72EaxO6oX0wVozkKqBE5otgH5ieMksA3x
   d7EyLF9bet5kGBsW0SPiA07PtSoT4UhbsD5W4rTHHj84927ndjwtXctHx
   Ka9NKKPnq/5HthxEL6UKysu//9a/Rrnyyphq3pGHvFhUesbaTIFm2yA0f
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="318799167"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="318799167"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:58:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="676084895"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.52])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 07:58:35 -0700
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 10/10] Change char* to enum in context->update & refactor code
Date:   Thu, 18 Aug 2022 16:56:21 +0200
Message-Id: <20220818145621.21982-11-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220818145621.21982-1-mateusz.kusiak@intel.com>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Storing update option in string is bad for frequent comparisons and
error prone.
Replace char array with enum so already existing enum is passed around
instead of string.
Adapt code to changes.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Assemble.c | 40 +++++++++++++++++-----------------------
 mdadm.c    | 52 +++++++++++++++++++---------------------------------
 mdadm.h    |  2 +-
 3 files changed, 37 insertions(+), 57 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 8cd3d533..942e352e 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -135,17 +135,17 @@ static int ident_matches(struct mddev_ident *ident,
 			 struct mdinfo *content,
 			 struct supertype *tst,
 			 char *homehost, int require_homehost,
-			 char *update, char *devname)
+			 enum update_opt update, char *devname)
 {
 
-	if (ident->uuid_set && (!update || strcmp(update, "uuid")!= 0) &&
+	if (ident->uuid_set && update != UOPT_UUID &&
 	    same_uuid(content->uuid, ident->uuid, tst->ss->swapuuid)==0 &&
 	    memcmp(content->uuid, uuid_zero, sizeof(int[4])) != 0) {
 		if (devname)
 			pr_err("%s has wrong uuid.\n", devname);
 		return 0;
 	}
-	if (ident->name[0] && (!update || strcmp(update, "name")!= 0) &&
+	if (ident->name[0] && update != UOPT_NAME &&
 	    name_matches(content->name, ident->name, homehost, require_homehost)==0) {
 		if (devname)
 			pr_err("%s has wrong name.\n", devname);
@@ -648,11 +648,10 @@ static int load_devices(struct devs *devices, char *devmap,
 			int err;
 			fstat(mdfd, &stb2);
 
-			if (strcmp(c->update, "uuid") == 0 && !ident->uuid_set)
+			if (c->update == UOPT_UUID && !ident->uuid_set)
 				random_uuid((__u8 *)ident->uuid);
 
-			if (strcmp(c->update, "ppl") == 0 &&
-			    ident->bitmap_fd >= 0) {
+			if (c->update == UOPT_PPL && ident->bitmap_fd >= 0) {
 				pr_err("PPL is not compatible with bitmap\n");
 				close(mdfd);
 				free(devices);
@@ -684,34 +683,30 @@ static int load_devices(struct devs *devices, char *devmap,
 			strcpy(content->name, ident->name);
 			content->array.md_minor = minor(stb2.st_rdev);
 
-			if (strcmp(c->update, "byteorder") == 0)
+			if (c->update == UOPT_BYTEORDER)
 				err = 0;
-			else if (strcmp(c->update, "home-cluster") == 0) {
+			else if (c->update == UOPT_HOME_CLUSTER) {
 				tst->cluster_name = c->homecluster;
 				err = tst->ss->write_bitmap(tst, dfd, NameUpdate);
-			} else if (strcmp(c->update, "nodes") == 0) {
+			} else if (c->update == UOPT_NODES) {
 				tst->nodes = c->nodes;
 				err = tst->ss->write_bitmap(tst, dfd, NodeNumUpdate);
-			} else if (strcmp(c->update, "revert-reshape") == 0 &&
-				   c->invalid_backup)
+			} else if (c->update == UOPT_REVERT_RESHAPE && c->invalid_backup)
 				err = tst->ss->update_super(tst, content,
 							    UOPT_SPEC_REVERT_RESHAPE_NOBACKUP,
 							    devname, c->verbose,
 							    ident->uuid_set,
 							    c->homehost);
 			else
-				/*
-				 * Mapping is temporary, will be removed in this patchset
-				 */
 				err = tst->ss->update_super(tst, content,
-							    map_name(update_options, c->update),
+							    c->update,
 							    devname, c->verbose,
 							    ident->uuid_set,
 							    c->homehost);
 			if (err < 0) {
 				if (err == -1)
 					pr_err("--update=%s not understood for %s metadata\n",
-					       c->update, tst->ss->name);
+					       map_num(update_options, c->update), tst->ss->name);
 				tst->ss->free_super(tst);
 				free(tst);
 				close(mdfd);
@@ -721,7 +716,7 @@ static int load_devices(struct devs *devices, char *devmap,
 				*stp = st;
 				return -1;
 			}
-			if (strcmp(c->update, "uuid")==0 &&
+			if (c->update == UOPT_UUID &&
 			    !ident->uuid_set) {
 				ident->uuid_set = 1;
 				memcpy(ident->uuid, content->uuid, 16);
@@ -730,7 +725,7 @@ static int load_devices(struct devs *devices, char *devmap,
 				pr_err("Could not re-write superblock on %s.\n",
 				       devname);
 
-			if (strcmp(c->update, "uuid")==0 &&
+			if (c->update == UOPT_UUID &&
 			    ident->bitmap_fd >= 0 && !bitmap_done) {
 				if (bitmap_update_uuid(ident->bitmap_fd,
 						       content->uuid,
@@ -1188,8 +1183,7 @@ static int start_array(int mdfd,
 				pr_err("%s: Need a backup file to complete reshape of this array.\n",
 				       mddev);
 				pr_err("Please provided one with \"--backup-file=...\"\n");
-				if (c->update &&
-				    strcmp(c->update, "revert-reshape") == 0)
+				if (c->update == UOPT_REVERT_RESHAPE)
 					pr_err("(Don't specify --update=revert-reshape again, that part succeeded.)\n");
 				return 1;
 			}
@@ -1487,7 +1481,7 @@ try_again:
 	 */
 	if (map_lock(&map))
 		pr_err("failed to get exclusive lock on mapfile - continue anyway...\n");
-	if (c->update && strcmp(c->update,"uuid") == 0)
+	if (c->update == UOPT_UUID)
 		mp = NULL;
 	else
 		mp = map_by_uuid(&map, content->uuid);
@@ -1635,7 +1629,7 @@ try_again:
 		goto out;
 	}
 
-	if (c->update && strcmp(c->update, "byteorder")==0)
+	if (c->update == UOPT_BYTEORDER)
 		st->minor_version = 90;
 
 	st->ss->getinfo_super(st, content, NULL);
@@ -1904,7 +1898,7 @@ try_again:
 	/* First, fill in the map, so that udev can find our name
 	 * as soon as we become active.
 	 */
-	if (c->update && strcmp(c->update, "metadata")==0) {
+	if (c->update == UOPT_METADATA) {
 		content->array.major_version = 1;
 		content->array.minor_version = 0;
 		strcpy(content->text_version, "1.0");
diff --git a/mdadm.c b/mdadm.c
index b55e0d9a..dc6d6a95 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -746,7 +746,7 @@ int main(int argc, char *argv[])
 		case O(MISC,'U'):
 			if (c.update) {
 				pr_err("Can only update one aspect of superblock, both %s and %s given.\n",
-					c.update, optarg);
+					map_num(update_options, c.update), optarg);
 				exit(2);
 			}
 			if (mode == MISC && !c.subarray) {
@@ -754,8 +754,7 @@ int main(int argc, char *argv[])
 				exit(2);
 			}
 
-			c.update = optarg;
-			enum update_opt updateopt = map_name(update_options, c.update);
+			c.update = map_name(update_options, optarg);
 			enum update_opt print_mode = UOPT_HELP;
 			const char *error_addon = "update option";
 
@@ -763,14 +762,14 @@ int main(int argc, char *argv[])
 				print_mode = UOPT_SUBARRAY_ONLY;
 				error_addon = "update-subarray option";
 
-				if (updateopt > UOPT_SUBARRAY_ONLY && updateopt < UOPT_HELP)
-					updateopt = UOPT_UNDEFINED;
+				if (c.update > UOPT_SUBARRAY_ONLY && c.update < UOPT_HELP)
+					c.update = UOPT_UNDEFINED;
 			}
 
-			switch (updateopt) {
+			switch (c.update) {
 			case UOPT_UNDEFINED:
 				pr_err("'--update=%s' is invalid %s. ",
-					c.update, error_addon);
+					optarg, error_addon);
 				outf = stderr;
 			case UOPT_HELP:
 				if (!outf)
@@ -795,14 +794,14 @@ int main(int argc, char *argv[])
 			}
 			if (c.update) {
 				pr_err("Can only update one aspect of superblock, both %s and %s given.\n",
-					c.update, optarg);
+					map_num(update_options, c.update), optarg);
 				exit(2);
 			}
-			c.update = optarg;
-			if (strcmp(c.update, "devicesize") != 0 &&
-			    strcmp(c.update, "bbl") != 0 &&
-			    strcmp(c.update, "force-no-bbl") != 0 &&
-			    strcmp(c.update, "no-bbl") != 0) {
+			c.update = map_name(update_options, optarg);
+			if (c.update != UOPT_DEVICESIZE &&
+			    c.update != UOPT_BBL &&
+			    c.update != UOPT_NO_BBL &&
+			    c.update != UOPT_FORCE_NO_BBL) {
 				pr_err("only 'devicesize', 'bbl', 'no-bbl', and 'force-no-bbl' can be updated with --re-add\n");
 				exit(2);
 			}
@@ -1388,7 +1387,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (c.update && strcmp(c.update, "nodes") == 0 && c.nodes == 0) {
+	if (c.update && c.update == UOPT_NODES && c.nodes == 0) {
 		pr_err("Please specify nodes number with --nodes\n");
 		exit(1);
 	}
@@ -1433,22 +1432,10 @@ int main(int argc, char *argv[])
 		/* readonly, add/remove, readwrite, runstop */
 		if (c.readonly > 0)
 			rv = Manage_ro(devlist->devname, mdfd, c.readonly);
-		if (!rv && devs_found > 1) {
-			/*
-			 * This is temporary and will be removed in next patches
-			 * Null c.update will cause segfault
-			 */
-			if (c.update)
-				rv = Manage_subdevs(devlist->devname, mdfd,
-						devlist->next, c.verbose, c.test,
-						map_name(update_options, c.update),
-						c.force);
-			else
-				rv = Manage_subdevs(devlist->devname, mdfd,
-						devlist->next, c.verbose, c.test,
-						UOPT_UNDEFINED,
-						c.force);
-		}
+		if (!rv && devs_found > 1)
+			rv = Manage_subdevs(devlist->devname, mdfd,
+					    devlist->next, c.verbose,
+					    c.test, c.update, c.force);
 		if (!rv && c.readonly < 0)
 			rv = Manage_ro(devlist->devname, mdfd, c.readonly);
 		if (!rv && c.runstop > 0)
@@ -1970,14 +1957,13 @@ static int misc_list(struct mddev_dev *devlist,
 			rv |= Kill_subarray(dv->devname, c->subarray, c->verbose);
 			continue;
 		case UpdateSubarray:
-			if (c->update == NULL) {
+			if (!c->update) {
 				pr_err("-U/--update must be specified with --update-subarray\n");
 				rv |= 1;
 				continue;
 			}
 			rv |= Update_subarray(dv->devname, c->subarray,
-					      map_name(update_options, c->update),
-					      ident, c->verbose);
+					      c->update, ident, c->verbose);
 			continue;
 		case Dump:
 			rv |= Dump_metadata(dv->devname, dump_directory, c, ss);
diff --git a/mdadm.h b/mdadm.h
index fe09fd46..c732a936 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -616,7 +616,7 @@ struct context {
 	int	export;
 	int	test;
 	char	*subarray;
-	char	*update;
+	enum	update_opt update;
 	int	scan;
 	int	SparcAdjust;
 	int	autof;
-- 
2.26.2

