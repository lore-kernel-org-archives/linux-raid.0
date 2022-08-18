Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C9DC00140
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 14:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343825AbiHRO57 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 10:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343887AbiHRO54 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 10:57:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92720BB015
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 07:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660834674; x=1692370674;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9zmiWqEgV2xNS6uXaFWvo4BQYif6XybJ61DXdOfKkvI=;
  b=fvyTky4W4+Ky+P2kPDZubCbr5Zo8PyXt3nEprRANlCKurBxaJe7W5Oq7
   jjG/0EalT5hx4Dki2rmJzxqNpNU2Ig9DgDf1uNFve3RFcA7N9lTvLj9QJ
   HhlYJW9rWMl5zZimMO8yGFo743y4VjP7bMsJTuWBSj+tSxeM2kdzGSEq1
   YOWPkB6dHM6diDbo7dx4ngCRtyimXfoMFsC5BvAExpl8zYmQJULD6C1lv
   H38mgdr5JFxyoqoZYzea6J+Pi/QtepKLM8jTgQflxdqSbjnSJWDD4E4Tc
   4npHoZx6zajULkQTjsn0DBauudIfP/w4r34KoczY82MU8t9D2czDTUY8X
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="356766216"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="356766216"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:57:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="676084571"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.52])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 07:57:53 -0700
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 05/10] super0: refactor the code for enum
Date:   Thu, 18 Aug 2022 16:56:16 +0200
Message-Id: <20220818145621.21982-6-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220818145621.21982-1-mateusz.kusiak@intel.com>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It prepares update_super0 for change context->update to enum.
Change if else statements to switch.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 super0.c | 102 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 63 insertions(+), 39 deletions(-)

diff --git a/super0.c b/super0.c
index 37f595ed..4e53f41e 100644
--- a/super0.c
+++ b/super0.c
@@ -502,19 +502,39 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
 	int rv = 0;
 	int uuid[4];
 	mdp_super_t *sb = st->sb;
+	enum update_opt update_enum = map_name(update_options, update);
 
-	if (strcmp(update, "homehost") == 0 &&
-	    homehost) {
-		/* note that 'homehost' is special as it is really
+	if (update_enum == UOPT_HOMEHOST && homehost) {
+		/*
+		 * note that 'homehost' is special as it is really
 		 * a "uuid" update.
 		 */
 		uuid_set = 0;
-		update = "uuid";
+		update_enum = UOPT_UUID;
 		info->uuid[0] = sb->set_uuid0;
 		info->uuid[1] = sb->set_uuid1;
 	}
 
-	if (strcmp(update, "sparc2.2")==0 ) {
+	switch (update_enum) {
+	case UOPT_UUID:
+		if (!uuid_set && homehost) {
+			char buf[20];
+			memcpy(info->uuid+2,
+			       sha1_buffer(homehost, strlen(homehost), buf),
+			       8);
+		}
+		sb->set_uuid0 = info->uuid[0];
+		sb->set_uuid1 = info->uuid[1];
+		sb->set_uuid2 = info->uuid[2];
+		sb->set_uuid3 = info->uuid[3];
+		if (sb->state & (1<<MD_SB_BITMAP_PRESENT)) {
+			struct bitmap_super_s *bm;
+			bm = (struct bitmap_super_s *)(sb+1);
+			uuid_from_super0(st, uuid);
+			memcpy(bm->uuid, uuid, 16);
+		}
+		break;
+	case UOPT_SPARC22: {
 		/* 2.2 sparc put the events in the wrong place
 		 * So we copy the tail of the superblock
 		 * up 4 bytes before continuing
@@ -527,12 +547,15 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
 		if (verbose >= 0)
 			pr_err("adjusting superblock of %s for 2.2/sparc compatibility.\n",
 			       devname);
-	} else if (strcmp(update, "super-minor") ==0) {
+		break;
+	}
+	case UOPT_SUPER_MINOR:
 		sb->md_minor = info->array.md_minor;
 		if (verbose > 0)
 			pr_err("updating superblock of %s with minor number %d\n",
 				devname, info->array.md_minor);
-	} else if (strcmp(update, "summaries") == 0) {
+		break;
+	case UOPT_SUMMARIES: {
 		unsigned int i;
 		/* set nr_disks, active_disks, working_disks,
 		 * failed_disks, spare_disks based on disks[]
@@ -559,7 +582,9 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
 					sb->spare_disks++;
 			} else if (i >= sb->raid_disks && sb->disks[i].number == 0)
 				sb->disks[i].state = 0;
-	} else if (strcmp(update, "force-one")==0) {
+		break;
+	}
+	case UOPT_SPEC_FORCE_ONE: {
 		/* Not enough devices for a working array, so
 		 * bring this one up-to-date.
 		 */
@@ -569,7 +594,9 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
 		if (sb->events_hi != ehi ||
 		    sb->events_lo != elo)
 			rv = 1;
-	} else if (strcmp(update, "force-array")==0) {
+		break;
+	}
+	case UOPT_SPEC_FORCE_ARRAY:
 		/* degraded array and 'force' requested, so
 		 * maybe need to mark it 'clean'
 		 */
@@ -579,7 +606,8 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
 			sb->state |= (1 << MD_SB_CLEAN);
 			rv = 1;
 		}
-	} else if (strcmp(update, "assemble")==0) {
+		break;
+	case UOPT_SPEC_ASSEMBLE: {
 		int d = info->disk.number;
 		int wonly = sb->disks[d].state & (1<<MD_DISK_WRITEMOSTLY);
 		int failfast = sb->disks[d].state & (1<<MD_DISK_FAILFAST);
@@ -609,7 +637,9 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
 			sb->reshape_position = info->reshape_progress;
 			rv = 1;
 		}
-	} else if (strcmp(update, "linear-grow-new") == 0) {
+		break;
+	}
+	case UOPT_SPEC_LINEAR_GROW_NEW:
 		memset(&sb->disks[info->disk.number], 0, sizeof(sb->disks[0]));
 		sb->disks[info->disk.number].number = info->disk.number;
 		sb->disks[info->disk.number].major = info->disk.major;
@@ -617,7 +647,8 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
 		sb->disks[info->disk.number].raid_disk = info->disk.raid_disk;
 		sb->disks[info->disk.number].state = info->disk.state;
 		sb->this_disk = sb->disks[info->disk.number];
-	} else if (strcmp(update, "linear-grow-update") == 0) {
+		break;
+	case UOPT_SPEC_LINEAR_GROW_UPDATE:
 		sb->raid_disks = info->array.raid_disks;
 		sb->nr_disks = info->array.nr_disks;
 		sb->active_disks = info->array.active_disks;
@@ -628,29 +659,15 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
 		sb->disks[info->disk.number].minor = info->disk.minor;
 		sb->disks[info->disk.number].raid_disk = info->disk.raid_disk;
 		sb->disks[info->disk.number].state = info->disk.state;
-	} else if (strcmp(update, "resync") == 0) {
-		/* make sure resync happens */
+		break;
+	case UOPT_RESYNC:
+		/**
+		 *make sure resync happens
+		 */
 		sb->state &= ~(1<<MD_SB_CLEAN);
 		sb->recovery_cp = 0;
-	} else if (strcmp(update, "uuid") == 0) {
-		if (!uuid_set && homehost) {
-			char buf[20];
-			char *hash = sha1_buffer(homehost,
-						 strlen(homehost),
-						 buf);
-			memcpy(info->uuid+2, hash, 8);
-		}
-		sb->set_uuid0 = info->uuid[0];
-		sb->set_uuid1 = info->uuid[1];
-		sb->set_uuid2 = info->uuid[2];
-		sb->set_uuid3 = info->uuid[3];
-		if (sb->state & (1<<MD_SB_BITMAP_PRESENT)) {
-			struct bitmap_super_s *bm;
-			bm = (struct bitmap_super_s*)(sb+1);
-			uuid_from_super0(st, uuid);
-			memcpy(bm->uuid, uuid, 16);
-		}
-	} else if (strcmp(update, "metadata") == 0) {
+		break;
+	case UOPT_METADATA:
 		/* Create some v1.0 metadata to match ours but make the
 		 * ctime bigger.  Also update info->array.*_version.
 		 * We need to arrange that store_super writes out
@@ -670,7 +687,8 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
 			uuid_from_super0(st, info->uuid);
 			st->other = super1_make_v0(st, info, st->sb);
 		}
-	} else if (strcmp(update, "revert-reshape") == 0) {
+		break;
+	case UOPT_REVERT_RESHAPE:
 		rv = -2;
 		if (sb->minor_version <= 90)
 			pr_err("No active reshape to revert on %s\n",
@@ -702,16 +720,22 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
 			sb->new_chunk = sb->chunk_size;
 			sb->chunk_size = tmp;
 		}
-	} else if (strcmp(update, "no-bitmap") == 0) {
+		break;
+	case UOPT_NO_BITMAP:
 		sb->state &= ~(1<<MD_SB_BITMAP_PRESENT);
-	} else if (strcmp(update, "_reshape_progress")==0)
+		break;
+	case UOPT_SPEC__RESHAPE_PROGRESS:
 		sb->reshape_position = info->reshape_progress;
-	else if (strcmp(update, "writemostly")==0)
+		break;
+	case UOPT_SPEC_WRITEMOSTLY:
 		sb->state |= (1<<MD_DISK_WRITEMOSTLY);
-	else if (strcmp(update, "readwrite")==0)
+		break;
+	case UOPT_SPEC_READWRITE:
 		sb->state &= ~(1<<MD_DISK_WRITEMOSTLY);
-	else
+		break;
+	default:
 		rv = -1;
+	}
 
 	sb->sb_csum = calc_sb0_csum(sb);
 	return rv;
-- 
2.26.2

