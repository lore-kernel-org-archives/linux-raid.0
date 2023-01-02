Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F38C3DA7A
	for <linux-raid@archiver.kernel.org>; Mon,  2 Jan 2023 08:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjABIh3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Jan 2023 03:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjABIhG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Jan 2023 03:37:06 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA51C19
        for <linux-raid@vger.kernel.org>; Mon,  2 Jan 2023 00:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672648625; x=1704184625;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cv16y35aQRqqLWVh3YElioGYmYgMzqmccr/Lb2GpEpk=;
  b=NCkMvuykPIroGfC7hEIoVpJRuoPN1O0CVs90AW+eeF+dSrrslcNwVGK3
   JCRKdIXPqIqE1tnOKtBh93cqhhYYuxPydj4MFjBmn6UH1+Yuc8qJvnuBc
   0seyYOVRsHH5xbg8KLFhhVykl+cUaTJmpg9w+QtK4LM52Ll8mGqJZTumy
   f2h8hsdx4FqAsuHyLUgvcx/JSDWHlbKxCorz03lVaon8XmrnMes7xGVhw
   j41LTfSKOAx6WoWXYad7wCKUTwZtRcGeJbEZDfNWt+Gr3rLY8ATaI2c+u
   63VIBmOQnnOSrC3zj5da08RxPm6dTdS6nTV0kKByz+HSCq5ZkQUHOaniw
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="322685304"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="322685304"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2023 00:37:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="647864609"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="647864609"
Received: from unknown (HELO DESKTOP-QODMV9C.igk.intel.com.com) ([10.102.109.29])
  by orsmga007.jf.intel.com with ESMTP; 02 Jan 2023 00:37:03 -0800
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH v2 01/10] mdadm: Add option validation for --update-subarray
Date:   Mon,  2 Jan 2023 09:35:15 +0100
Message-Id: <20230102083524.28893-2-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230102083524.28893-1-mateusz.kusiak@intel.com>
References: <20230102083524.28893-1-mateusz.kusiak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Subset of options available for "--update" is not same as for "--update-subarray".
Define maps and enum for update options and use them instead of direct comparisons.
Add proper error message.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 ReadMe.c |  31 +++++++++++++++++
 maps.c   |  31 +++++++++++++++++
 mdadm.c  | 104 +++++++++++++++++--------------------------------------
 mdadm.h  |  32 ++++++++++++++++-
 4 files changed, 124 insertions(+), 74 deletions(-)

diff --git a/ReadMe.c b/ReadMe.c
index 50a5e36d..bd8d50d2 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -655,3 +655,34 @@ char *mode_help[mode_count] = {
 	[GROW]		= Help_grow,
 	[INCREMENTAL]	= Help_incr,
 };
+
+/**
+ * fprint_update_options() - Print valid update options depending on the mode.
+ * @outf: File (output stream)
+ * @update_mode: Used to distinguish update and update_subarray
+ */
+void fprint_update_options(FILE *outf, enum update_opt update_mode)
+{
+	int counter = UOPT_NAME, breakpoint = UOPT_HELP;
+	mapping_t *map = update_options;
+
+	if (!outf)
+		return;
+	if (update_mode == UOPT_SUBARRAY_ONLY) {
+		breakpoint = UOPT_SUBARRAY_ONLY;
+		fprintf(outf, "Valid --update options for update-subarray are:\n\t");
+	} else
+		fprintf(outf, "Valid --update options are:\n\t");
+	while (map->num) {
+		if (map->num >= breakpoint)
+			break;
+		fprintf(outf, "'%s', ", map->name);
+		if (counter % 5 == 0)
+			fprintf(outf, "\n\t");
+		counter++;
+		map++;
+	}
+	if ((counter - 1) % 5)
+		fprintf(outf, "\n");
+	fprintf(outf, "\r");
+}
diff --git a/maps.c b/maps.c
index 20fcf719..b586679a 100644
--- a/maps.c
+++ b/maps.c
@@ -165,6 +165,37 @@ mapping_t sysfs_array_states[] = {
 	{ "broken", ARRAY_BROKEN },
 	{ NULL, ARRAY_UNKNOWN_STATE }
 };
+/**
+ * mapping_t update_options - stores supported update options.
+ */
+mapping_t update_options[] = {
+	{ "name", UOPT_NAME },
+	{ "ppl", UOPT_PPL },
+	{ "no-ppl", UOPT_NO_PPL },
+	{ "bitmap", UOPT_BITMAP },
+	{ "no-bitmap", UOPT_NO_BITMAP },
+	{ "sparc2.2", UOPT_SPARC22 },
+	{ "super-minor", UOPT_SUPER_MINOR },
+	{ "summaries", UOPT_SUMMARIES },
+	{ "resync", UOPT_RESYNC },
+	{ "uuid", UOPT_UUID },
+	{ "homehost", UOPT_HOMEHOST },
+	{ "home-cluster", UOPT_HOME_CLUSTER },
+	{ "nodes", UOPT_NODES },
+	{ "devicesize", UOPT_DEVICESIZE },
+	{ "bbl", UOPT_BBL },
+	{ "no-bbl", UOPT_NO_BBL },
+	{ "force-no-bbl", UOPT_FORCE_NO_BBL },
+	{ "metadata", UOPT_METADATA },
+	{ "revert-reshape", UOPT_REVERT_RESHAPE },
+	{ "layout-original", UOPT_LAYOUT_ORIGINAL },
+	{ "layout-alternate", UOPT_LAYOUT_ALTERNATE },
+	{ "layout-unspecified", UOPT_LAYOUT_UNSPECIFIED },
+	{ "byteorder", UOPT_BYTEORDER },
+	{ "help", UOPT_HELP },
+	{ "?", UOPT_HELP },
+	{ NULL, UOPT_UNDEFINED}
+};
 
 /**
  * map_num_s() - Safer alternative of map_num() function.
diff --git a/mdadm.c b/mdadm.c
index 74fdec31..f5f505fe 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -100,7 +100,7 @@ int main(int argc, char *argv[])
 	char *dump_directory = NULL;
 
 	int print_help = 0;
-	FILE *outf;
+	FILE *outf = NULL;
 
 	int mdfd = -1;
 	int locked = 0;
@@ -723,7 +723,11 @@ int main(int argc, char *argv[])
 			continue;
 
 		case O(ASSEMBLE,'U'): /* update the superblock */
-		case O(MISC,'U'):
+		case O(MISC,'U'): {
+			enum update_opt updateopt = map_name(update_options, c.update);
+			enum update_opt print_mode = UOPT_HELP;
+			const char *error_addon = "update option";
+
 			if (c.update) {
 				pr_err("Can only update one aspect of superblock, both %s and %s given.\n",
 					c.update, optarg);
@@ -733,83 +737,37 @@ int main(int argc, char *argv[])
 				pr_err("Only subarrays can be updated in misc mode\n");
 				exit(2);
 			}
+
 			c.update = optarg;
-			if (strcmp(c.update, "sparc2.2") == 0)
-				continue;
-			if (strcmp(c.update, "super-minor") == 0)
-				continue;
-			if (strcmp(c.update, "summaries") == 0)
-				continue;
-			if (strcmp(c.update, "resync") == 0)
-				continue;
-			if (strcmp(c.update, "uuid") == 0)
-				continue;
-			if (strcmp(c.update, "name") == 0)
-				continue;
-			if (strcmp(c.update, "homehost") == 0)
-				continue;
-			if (strcmp(c.update, "home-cluster") == 0)
-				continue;
-			if (strcmp(c.update, "nodes") == 0)
-				continue;
-			if (strcmp(c.update, "devicesize") == 0)
-				continue;
-			if (strcmp(c.update, "bitmap") == 0)
-				continue;
-			if (strcmp(c.update, "no-bitmap") == 0)
-				continue;
-			if (strcmp(c.update, "bbl") == 0)
-				continue;
-			if (strcmp(c.update, "no-bbl") == 0)
-				continue;
-			if (strcmp(c.update, "force-no-bbl") == 0)
-				continue;
-			if (strcmp(c.update, "ppl") == 0)
-				continue;
-			if (strcmp(c.update, "no-ppl") == 0)
-				continue;
-			if (strcmp(c.update, "metadata") == 0)
-				continue;
-			if (strcmp(c.update, "revert-reshape") == 0)
-				continue;
-			if (strcmp(c.update, "layout-original") == 0 ||
-			    strcmp(c.update, "layout-alternate") == 0 ||
-			    strcmp(c.update, "layout-unspecified") == 0)
-				continue;
-			if (strcmp(c.update, "byteorder") == 0) {
+
+			if (devmode == UpdateSubarray) {
+				print_mode = UOPT_SUBARRAY_ONLY;
+				error_addon = "update-subarray option";
+
+				if (updateopt > UOPT_SUBARRAY_ONLY && updateopt < UOPT_HELP)
+					updateopt = UOPT_UNDEFINED;
+			}
+
+			switch (updateopt) {
+			case UOPT_UNDEFINED:
+				pr_err("'--update=%s' is invalid %s. ",
+					c.update, error_addon);
+				outf = stderr;
+			case UOPT_HELP:
+				if (!outf)
+					outf = stdout;
+				fprint_update_options(outf, print_mode);
+				exit(outf == stdout ? 0 : 2);
+			case UOPT_BYTEORDER:
 				if (ss) {
 					pr_err("must not set metadata type with --update=byteorder.\n");
 					exit(2);
 				}
-				for(i = 0; !ss && superlist[i]; i++)
-					ss = superlist[i]->match_metadata_desc(
-						"0.swap");
-				if (!ss) {
-					pr_err("INTERNAL ERROR cannot find 0.swap\n");
-					exit(2);
-				}
-
-				continue;
+			default:
+				break;
 			}
-			if (strcmp(c.update,"?") == 0 ||
-			    strcmp(c.update, "help") == 0) {
-				outf = stdout;
-				fprintf(outf, "%s: ", Name);
-			} else {
-				outf = stderr;
-				fprintf(outf,
-					"%s: '--update=%s' is invalid.  ",
-					Name, c.update);
-			}
-			fprintf(outf, "Valid --update options are:\n"
-		"     'sparc2.2', 'super-minor', 'uuid', 'name', 'nodes', 'resync',\n"
-		"     'summaries', 'homehost', 'home-cluster', 'byteorder', 'devicesize',\n"
-		"     'bitmap', 'no-bitmap', 'metadata', 'revert-reshape'\n"
-		"     'bbl', 'no-bbl', 'force-no-bbl', 'ppl', 'no-ppl'\n"
-		"     'layout-original', 'layout-alternate', 'layout-unspecified'\n"
-				);
-			exit(outf == stdout ? 0 : 2);
-
+			continue;
+		}
 		case O(MANAGE,'U'):
 			/* update=devicesize is allowed with --re-add */
 			if (devmode != 'A') {
diff --git a/mdadm.h b/mdadm.h
index 23ffe977..51f1db2d 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -497,6 +497,36 @@ enum special_options {
 	ConsistencyPolicy,
 };
 
+enum update_opt {
+	UOPT_NAME = 1,
+	UOPT_PPL,
+	UOPT_NO_PPL,
+	UOPT_BITMAP,
+	UOPT_NO_BITMAP,
+	UOPT_SUBARRAY_ONLY,
+	UOPT_SPARC22,
+	UOPT_SUPER_MINOR,
+	UOPT_SUMMARIES,
+	UOPT_RESYNC,
+	UOPT_UUID,
+	UOPT_HOMEHOST,
+	UOPT_HOME_CLUSTER,
+	UOPT_NODES,
+	UOPT_DEVICESIZE,
+	UOPT_BBL,
+	UOPT_NO_BBL,
+	UOPT_FORCE_NO_BBL,
+	UOPT_METADATA,
+	UOPT_REVERT_RESHAPE,
+	UOPT_LAYOUT_ORIGINAL,
+	UOPT_LAYOUT_ALTERNATE,
+	UOPT_LAYOUT_UNSPECIFIED,
+	UOPT_BYTEORDER,
+	UOPT_HELP,
+	UOPT_UNDEFINED
+};
+extern void fprint_update_options(FILE *outf, enum update_opt update_mode);
+
 enum prefix_standard {
 	JEDEC,
 	IEC
@@ -777,7 +807,7 @@ extern char *map_num(mapping_t *map, int num);
 extern int map_name(mapping_t *map, char *name);
 extern mapping_t r0layout[], r5layout[], r6layout[],
 	pers[], modes[], faultylayout[];
-extern mapping_t consistency_policies[], sysfs_array_states[];
+extern mapping_t consistency_policies[], sysfs_array_states[], update_options[];
 
 extern char *map_dev_preferred(int major, int minor, int create,
 			       char *prefer);
-- 
2.26.2

