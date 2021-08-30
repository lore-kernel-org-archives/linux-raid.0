Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 147C2C4320E
	for <linux-raid@archiver.kernel.org>; Mon, 30 Aug 2021 13:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED5E0603E7
	for <linux-raid@archiver.kernel.org>; Mon, 30 Aug 2021 13:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbhH3NdH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Aug 2021 09:33:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:55184 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhH3NdF (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 30 Aug 2021 09:33:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10091"; a="215145675"
X-IronPort-AV: E=Sophos;i="5.84,363,1620716400"; 
   d="scan'208";a="215145675"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2021 06:32:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,363,1620716400"; 
   d="scan'208";a="530342097"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.52])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Aug 2021 06:32:11 -0700
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH V2] Grow: Close cfd file descriptor
Date:   Mon, 30 Aug 2021 15:32:37 +0200
Message-Id: <20210830133237.7957-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Unclosed file descriptor causes resource leak if error occurs.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Grow.c | 82 +++++++++++++++++++++++++---------------------------------
 1 file changed, 35 insertions(+), 47 deletions(-)

diff --git a/Grow.c b/Grow.c
index 7506ab46..dec6b742 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1796,7 +1796,7 @@ int Grow_reshape(char *devname, int fd,
 	struct supertype *st;
 	char *subarray = NULL;
 
-	int frozen;
+	int frozen = 0;
 	int changed = 0;
 	char *container = NULL;
 	int cfd = -1;
@@ -1805,7 +1805,7 @@ int Grow_reshape(char *devname, int fd,
 	int added_disks;
 
 	struct mdinfo info;
-	struct mdinfo *sra;
+	struct mdinfo *sra = NULL;
 
 	if (md_get_array_info(fd, &array) < 0) {
 		pr_err("%s is not an active md array - aborting\n",
@@ -1851,14 +1851,14 @@ int Grow_reshape(char *devname, int fd,
 	}
 	if (s->raiddisks > st->max_devs) {
 		pr_err("Cannot increase raid-disks on this array beyond %d\n", st->max_devs);
-		return 1;
+		goto error;
 	}
 	if (s->level == 0 && (array.state & (1 << MD_SB_BITMAP_PRESENT)) &&
 		!(array.state & (1 << MD_SB_CLUSTERED)) && !st->ss->external) {
 		array.state &= ~(1 << MD_SB_BITMAP_PRESENT);
 		if (md_set_array_info(fd, &array) != 0) {
 			pr_err("failed to remove internal bitmap.\n");
-			return 1;
+			goto error;
 		}
 	}
 
@@ -1880,16 +1880,14 @@ int Grow_reshape(char *devname, int fd,
 		}
 		if (cfd < 0) {
 			pr_err("Unable to open container for %s\n", devname);
-			free(subarray);
-			return 1;
+			goto error;
 		}
 
 		retval = st->ss->load_container(st, cfd, NULL);
 
 		if (retval) {
 			pr_err("Cannot read superblock for %s\n", devname);
-			free(subarray);
-			return 1;
+			goto error;
 		}
 
 		/* check if operation is supported for metadata handler */
@@ -1900,6 +1898,7 @@ int Grow_reshape(char *devname, int fd,
 			cc = st->ss->container_content(st, subarray);
 			for (content = cc; content ; content = content->next) {
 				int allow_reshape = 1;
+				rv = 1;
 
 				/* check if reshape is allowed based on metadata
 				 * indications stored in content.array.status
@@ -1913,26 +1912,23 @@ int Grow_reshape(char *devname, int fd,
 				if (!allow_reshape) {
 					pr_err("cannot reshape arrays in container with unsupported metadata: %s(%s)\n",
 					       devname, container);
-					sysfs_free(cc);
-					free(subarray);
-					return 1;
+					break;
 				}
 				if (content->consistency_policy ==
 				    CONSISTENCY_POLICY_PPL) {
 					pr_err("Operation not supported when ppl consistency policy is enabled\n");
-					sysfs_free(cc);
-					free(subarray);
-					return 1;
+					break;
 				}
 				if (content->consistency_policy ==
 				    CONSISTENCY_POLICY_BITMAP) {
 					pr_err("Operation not supported when write-intent bitmap is enabled\n");
-					sysfs_free(cc);
-					free(subarray);
-					return 1;
+					break;
 				}
+				rv = 0;
 			}
 			sysfs_free(cc);
+			if (rv == 1)
+				goto release;
 		}
 		if (mdmon_running(container))
 			st->update_tail = &st->updates;
@@ -1950,7 +1946,7 @@ int Grow_reshape(char *devname, int fd,
 		       s->raiddisks - array.raid_disks,
 		       s->raiddisks - array.raid_disks == 1 ? "" : "s",
 		       array.spare_disks + added_disks);
-		return 1;
+		goto error;
 	}
 
 	sra = sysfs_read(fd, NULL, GET_LEVEL | GET_DISKS | GET_DEVS |
@@ -1963,17 +1959,15 @@ int Grow_reshape(char *devname, int fd,
 	} else {
 		pr_err("failed to read sysfs parameters for %s\n",
 			devname);
-		return 1;
+		goto error;
 	}
 	frozen = freeze(st);
 	if (frozen < -1) {
 		/* freeze() already spewed the reason */
-		sysfs_free(sra);
-		return 1;
+		goto error;
 	} else if (frozen < 0) {
 		pr_err("%s is performing resync/recovery and cannot be reshaped\n", devname);
-		sysfs_free(sra);
-		return 1;
+		goto error;
 	}
 
 	/* ========= set size =============== */
@@ -1989,15 +1983,13 @@ int Grow_reshape(char *devname, int fd,
 
 		if (orig_size == 0) {
 			pr_err("Cannot set device size in this type of array.\n");
-			rv = 1;
-			goto release;
+			goto error;
 		}
 
 		if (reshape_super(st, s->size, UnSet, UnSet, 0, 0, UnSet, NULL,
 				  devname, APPLY_METADATA_CHANGES,
 				  c->verbose > 0)) {
-			rv = 1;
-			goto release;
+			goto error;
 		}
 		sync_metadata(st);
 		if (st->ss->external) {
@@ -2126,8 +2118,7 @@ size_change_error:
 			if (err == EBUSY &&
 			    (array.state & (1<<MD_SB_BITMAP_PRESENT)))
 				cont_err("Bitmap must be removed before size can be changed\n");
-			rv = 1;
-			goto release;
+			goto error;
 		}
 		if (s->assume_clean) {
 			/* This will fail on kernels older than 3.0 unless
@@ -2183,10 +2174,7 @@ size_change_error:
 		err = remove_disks_for_takeover(st, sra, array.layout);
 		if (err) {
 			dprintf("Array cannot be reshaped\n");
-			if (cfd > -1)
-				close(cfd);
-			rv = 1;
-			goto release;
+			goto error;
 		}
 		/* Make sure mdmon has seen the device removal
 		 * and updated metadata before we continue with
@@ -2200,8 +2188,7 @@ size_change_error:
 	info.array = array;
 	if (sysfs_init(&info, fd, NULL)) {
 		pr_err("failed to initialize sysfs.\n");
-		rv = 1;
-		goto release;
+		goto error;
 	}
 	strcpy(info.text_version, sra->text_version);
 	info.component_size = s->size*2;
@@ -2222,8 +2209,7 @@ size_change_error:
 			pr_err("%s has a non-standard layout.  If you wish to preserve this\n", devname);
 			cont_err("during the reshape, please specify --layout=preserve\n");
 			cont_err("If you want to change it, specify a layout or use --layout=normalise\n");
-			rv = 1;
-			goto release;
+			goto error;
 		}
 	} else if (strcmp(s->layout_str, "normalise") == 0 ||
 		   strcmp(s->layout_str, "normalize") == 0) {
@@ -2239,8 +2225,7 @@ size_change_error:
 			}
 		} else {
 			pr_err("%s is only meaningful when reshaping a RAID6 array.\n", s->layout_str);
-			rv = 1;
-			goto release;
+			goto error;
 		}
 	} else if (strcmp(s->layout_str, "preserve") == 0) {
 		/* This means that a non-standard RAID6 layout
@@ -2261,8 +2246,7 @@ size_change_error:
 			info.new_layout = map_name(r6layout, l);
 		} else {
 			pr_err("%s in only meaningful when reshaping to RAID6\n", s->layout_str);
-			rv = 1;
-			goto release;
+			goto error;
 		}
 	} else {
 		int l = info.new_level;
@@ -2283,14 +2267,12 @@ size_change_error:
 			break;
 		default:
 			pr_err("layout not meaningful with this level\n");
-			rv = 1;
-			goto release;
+			goto error;
 		}
 		if (info.new_layout == UnSet) {
 			pr_err("layout %s not understood for this level\n",
 				s->layout_str);
-			rv = 1;
-			goto release;
+			goto error;
 		}
 	}
 
@@ -2359,8 +2341,7 @@ size_change_error:
 				  info.array.raid_disks, info.delta_disks,
 				  c->backup_file, devname,
 				  APPLY_METADATA_CHANGES, c->verbose)) {
-			rv = 1;
-			goto release;
+			goto error;
 		}
 		sync_metadata(st);
 		rv = reshape_array(container, fd, devname, st, &info, c->force,
@@ -2369,10 +2350,17 @@ size_change_error:
 		frozen = 0;
 	}
 release:
+	if (cfd > -1)
+		close(cfd);
+	free(subarray);
 	sysfs_free(sra);
 	if (frozen > 0)
 		unfreeze(st);
+	free(st);
 	return rv;
+error:
+	rv = 1;
+	goto release;
 }
 
 /* verify_reshape_position()
-- 
2.26.2

