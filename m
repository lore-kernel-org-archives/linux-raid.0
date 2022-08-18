Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1D5C00140
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 14:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343891AbiHRO6g (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 10:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343900AbiHRO6X (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 10:58:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE2A766D
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 07:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660834699; x=1692370699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=df4bPF8YVZbhNzSJySpwkYpcu7J4EMWIoVDfKKreZKg=;
  b=S/0bYvsVY5DUFn+Ud7jczmKeMp7NS/DMQGyS0L95RVA9BHuTwWqdY2rt
   CF+U0UAo/h7qXMZ2xnhQvVXM2yDdX/ZySTUaJQUzc0mR/0g9MLfF66BF3
   hwVMMxma0haLsvStOO27skoMMtOFbEmnGDPxs+nZy83E2LHH5mzRzM5O+
   zDH1M0LT3qWGqj34VDiOFAGnBPVFa8VGZ4fC4AssXB+1v5BGpe40K8iNu
   uqiLeMUA7MELBobtwNCcVkmJHSl+WQtNh2Jwb4zptBfim0rEIk9HzWGs7
   2vwV6ckf6p4RV9P1llAs5BwD6bDiX/xG0Hy4hSxqSRzVVtLNc/fZlTjZY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="292774663"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="292774663"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:58:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="676084601"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.52])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 07:58:01 -0700
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 06/10] super1: refactor the code for enum
Date:   Thu, 18 Aug 2022 16:56:17 +0200
Message-Id: <20220818145621.21982-7-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220818145621.21982-1-mateusz.kusiak@intel.com>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It prepares update_super1 for change context->update to enum.
Change if else statements into switch.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 super1.c | 149 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 87 insertions(+), 62 deletions(-)

diff --git a/super1.c b/super1.c
index 71af860c..6c81c1b9 100644
--- a/super1.c
+++ b/super1.c
@@ -1212,30 +1212,53 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 	int rv = 0;
 	struct mdp_superblock_1 *sb = st->sb;
 	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + MAX_SB_SIZE);
+	enum update_opt update_enum = map_name(update_options, update);
 
-	if (strcmp(update, "homehost") == 0 &&
-	    homehost) {
-		/* Note that 'homehost' is special as it is really
+	if (update_enum == UOPT_HOMEHOST && homehost) {
+		/*
+		 * Note that 'homehost' is special as it is really
 		 * a "name" update.
 		 */
 		char *c;
-		update = "name";
+		update_enum = UOPT_NAME;
 		c = strchr(sb->set_name, ':');
 		if (c)
-			strncpy(info->name, c+1, 31 - (c-sb->set_name));
+			snprintf(info->name, sizeof(info->name), "%s", c+1);
 		else
-			strncpy(info->name, sb->set_name, 32);
-		info->name[32] = 0;
+			snprintf(info->name, sizeof(info->name), "%s", sb->set_name);
 	}
 
-	if (strcmp(update, "force-one")==0) {
+	switch (update_enum) {
+	case UOPT_NAME:
+		if (!info->name[0])
+			snprintf(info->name, sizeof(info->name), "%d", info->array.md_minor);
+		memset(sb->set_name, 0, sizeof(sb->set_name));
+		int namelen;
+
+		namelen = strnlen(homehost, MD_NAME_MAX) + 1 + strnlen(info->name, MD_NAME_MAX);
+		if (homehost &&
+		    strchr(info->name, ':') == NULL &&
+		    namelen < MD_NAME_MAX) {
+			strcpy(sb->set_name, homehost);
+			strcat(sb->set_name, ":");
+			strcat(sb->set_name, info->name);
+		} else {
+			namelen = min((int)strnlen(info->name, MD_NAME_MAX),
+				      (int)sizeof(sb->set_name) - 1);
+			memcpy(sb->set_name, info->name, namelen);
+			memset(&sb->set_name[namelen], '\0',
+			       sizeof(sb->set_name) - namelen);
+		}
+		break;
+	case UOPT_SPEC_FORCE_ONE:
 		/* Not enough devices for a working array,
 		 * so bring this one up-to-date
 		 */
 		if (sb->events != __cpu_to_le64(info->events))
 			rv = 1;
 		sb->events = __cpu_to_le64(info->events);
-	} else if (strcmp(update, "force-array")==0) {
+		break;
+	case UOPT_SPEC_FORCE_ARRAY:
 		/* Degraded array and 'force' requests to
 		 * maybe need to mark it 'clean'.
 		 */
@@ -1248,7 +1271,8 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 				rv = 1;
 			sb->resync_offset = MaxSector;
 		}
-	} else if (strcmp(update, "assemble")==0) {
+		break;
+	case UOPT_SPEC_ASSEMBLE: {
 		int d = info->disk.number;
 		int want;
 		if (info->disk.state & (1<<MD_DISK_ACTIVE))
@@ -1281,7 +1305,9 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 				__cpu_to_le64(info->reshape_progress);
 			rv = 1;
 		}
-	} else if (strcmp(update, "linear-grow-new") == 0) {
+		break;
+	}
+	case UOPT_SPEC_LINEAR_GROW_NEW: {
 		int i;
 		int fd;
 		int max = __le32_to_cpu(sb->max_dev);
@@ -1324,7 +1350,9 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 					ds - __le64_to_cpu(sb->data_offset));
 			}
 		}
-	} else if (strcmp(update, "linear-grow-update") == 0) {
+		break;
+	}
+	case UOPT_SPEC_LINEAR_GROW_UPDATE: {
 		int max = __le32_to_cpu(sb->max_dev);
 		int i = info->disk.number;
 		if (max > MAX_DEVS || i > MAX_DEVS)
@@ -1336,19 +1364,20 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		sb->raid_disks = __cpu_to_le32(info->array.raid_disks);
 		sb->dev_roles[info->disk.number] =
 			__cpu_to_le16(info->disk.raid_disk);
-	} else if (strcmp(update, "resync") == 0) {
-		/* make sure resync happens */
-		sb->resync_offset = 0ULL;
-	} else if (strcmp(update, "uuid") == 0) {
+		break;
+	}
+	case UOPT_UUID:
 		copy_uuid(sb->set_uuid, info->uuid, super1.swapuuid);
 
 		if (__le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET)
 			memcpy(bms->uuid, sb->set_uuid, 16);
-	} else if (strcmp(update, "no-bitmap") == 0) {
+		break;
+	case UOPT_NO_BITMAP:
 		sb->feature_map &= ~__cpu_to_le32(MD_FEATURE_BITMAP_OFFSET);
 		if (bms->version == BITMAP_MAJOR_CLUSTERED && !IsBitmapDirty(devname))
 			sb->resync_offset = MaxSector;
-	} else if (strcmp(update, "bbl") == 0) {
+		break;
+	case UOPT_BBL: {
 		/* only possible if there is room after the bitmap, or if
 		 * there is no bitmap
 		 */
@@ -1377,14 +1406,12 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 				bb_offset = bitmap_offset + bm_sectors;
 			while (bb_offset < (long)sb_offset + 8 + 32*2 &&
 			       bb_offset + 8+8 <= (long)data_offset)
-				/* too close to bitmap, and room to grow */
 				bb_offset += 8;
 			if (bb_offset + 8 <= (long)data_offset) {
 				sb->bblog_size = __cpu_to_le16(8);
 				sb->bblog_offset = __cpu_to_le32(bb_offset);
 			}
 		} else {
-			/* 1.0 - Put bbl just before super block */
 			if (bm_sectors && bitmap_offset < 0)
 				space = -bitmap_offset - bm_sectors;
 			else
@@ -1395,7 +1422,9 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 				sb->bblog_offset = __cpu_to_le32((unsigned)-8);
 			}
 		}
-	} else if (strcmp(update, "no-bbl") == 0) {
+		break;
+	}
+	case UOPT_NO_BBL:
 		if (sb->feature_map & __cpu_to_le32(MD_FEATURE_BAD_BLOCKS))
 			pr_err("Cannot remove active bbl from %s\n",devname);
 		else {
@@ -1403,12 +1432,14 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 			sb->bblog_shift = 0;
 			sb->bblog_offset = 0;
 		}
-	} else if (strcmp(update, "force-no-bbl") == 0) {
+		break;
+	case UOPT_FORCE_NO_BBL:
 		sb->feature_map &= ~ __cpu_to_le32(MD_FEATURE_BAD_BLOCKS);
 		sb->bblog_size = 0;
 		sb->bblog_shift = 0;
 		sb->bblog_offset = 0;
-	} else if (strcmp(update, "ppl") == 0) {
+		break;
+	case UOPT_PPL: {
 		unsigned long long sb_offset = __le64_to_cpu(sb->super_offset);
 		unsigned long long data_offset = __le64_to_cpu(sb->data_offset);
 		unsigned long long data_size = __le64_to_cpu(sb->data_size);
@@ -1458,37 +1489,26 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		sb->ppl.offset = __cpu_to_le16(offset);
 		sb->ppl.size = __cpu_to_le16(space);
 		sb->feature_map |= __cpu_to_le32(MD_FEATURE_PPL);
-	} else if (strcmp(update, "no-ppl") == 0) {
+		break;
+	}
+	case UOPT_NO_PPL:
 		sb->feature_map &= ~__cpu_to_le32(MD_FEATURE_PPL |
 						   MD_FEATURE_MUTLIPLE_PPLS);
-	} else if (strcmp(update, "name") == 0) {
-		if (info->name[0] == 0)
-			sprintf(info->name, "%d", info->array.md_minor);
-		memset(sb->set_name, 0, sizeof(sb->set_name));
-		if (homehost &&
-		    strchr(info->name, ':') == NULL &&
-		    strlen(homehost)+1+strlen(info->name) < 32) {
-			strcpy(sb->set_name, homehost);
-			strcat(sb->set_name, ":");
-			strcat(sb->set_name, info->name);
-		} else {
-			int namelen;
-
-			namelen = min((int)strlen(info->name),
-				      (int)sizeof(sb->set_name) - 1);
-			memcpy(sb->set_name, info->name, namelen);
-			memset(&sb->set_name[namelen], '\0',
-			       sizeof(sb->set_name) - namelen);
-		}
-	} else if (strcmp(update, "devicesize") == 0 &&
-		   __le64_to_cpu(sb->super_offset) <
-		   __le64_to_cpu(sb->data_offset)) {
-		/* set data_size to device size less data_offset */
+		break;
+	case UOPT_DEVICESIZE:
+		if (__le64_to_cpu(sb->super_offset) >=
+		    __le64_to_cpu(sb->data_offset))
+			break;
+		/*
+		 * set data_size to device size less data_offset
+		 */
 		struct misc_dev_info *misc = (struct misc_dev_info*)
 			(st->sb + MAX_SB_SIZE + BM_SUPER_SIZE);
 		sb->data_size = __cpu_to_le64(
 			misc->device_size - __le64_to_cpu(sb->data_offset));
-	} else if (strncmp(update, "revert-reshape", 14) == 0) {
+		break;
+	case UOPT_SPEC_REVERT_RESHAPE_NOBACKUP:
+	case UOPT_REVERT_RESHAPE:
 		rv = -2;
 		if (!(sb->feature_map &
 		      __cpu_to_le32(MD_FEATURE_RESHAPE_ACTIVE)))
@@ -1506,7 +1526,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 			 * If that couldn't happen, the "-nobackup" version
 			 * will be used.
 			 */
-			if (strcmp(update, "revert-reshape-nobackup") == 0 &&
+			if (update_enum == UOPT_SPEC_REVERT_RESHAPE_NOBACKUP &&
 			    sb->reshape_position == 0 &&
 			    (__le32_to_cpu(sb->delta_disks) > 0 ||
 			     (__le32_to_cpu(sb->delta_disks) == 0 &&
@@ -1569,32 +1589,37 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 			}
 		done:;
 		}
-	} else if (strcmp(update, "_reshape_progress") == 0)
+		break;
+	case UOPT_SPEC__RESHAPE_PROGRESS:
 		sb->reshape_position = __cpu_to_le64(info->reshape_progress);
-	else if (strcmp(update, "writemostly") == 0)
-		sb->devflags |= WriteMostly1;
-	else if (strcmp(update, "readwrite") == 0)
+		break;
+	case UOPT_SPEC_READWRITE:
 		sb->devflags &= ~WriteMostly1;
-	else if (strcmp(update, "failfast") == 0)
+		break;
+	case UOPT_SPEC_FAILFAST:
 		sb->devflags |= FailFast1;
-	else if (strcmp(update, "nofailfast") == 0)
+		break;
+	case UOPT_SPEC_NOFAILFAST:
 		sb->devflags &= ~FailFast1;
-	else if (strcmp(update, "layout-original") == 0 ||
-		 strcmp(update, "layout-alternate") == 0 ||
-		 strcmp(update, "layout-unspecified") == 0) {
+		break;
+	case UOPT_LAYOUT_ORIGINAL:
+	case UOPT_LAYOUT_ALTERNATE:
+	case UOPT_LAYOUT_UNSPECIFIED:
 		if (__le32_to_cpu(sb->level) != 0) {
 			pr_err("%s: %s only supported for RAID0\n",
-			       devname?:"", update);
+			       devname ?: "", map_num(update_options, update_enum));
 			rv = -1;
-		} else if (strcmp(update, "layout-unspecified") == 0) {
+		} else if (update_enum == UOPT_LAYOUT_UNSPECIFIED) {
 			sb->feature_map &= ~__cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);
 			sb->layout = 0;
 		} else {
 			sb->feature_map |= __cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);
-			sb->layout = __cpu_to_le32(update[7] == 'o' ? 1 : 2);
+			sb->layout = __cpu_to_le32(update_enum == UOPT_LAYOUT_ORIGINAL ? 1 : 2);
 		}
-	} else
+		break;
+	default:
 		rv = -1;
+	}
 
 	sb->sb_csum = calc_sb_1_csum(sb);
 
-- 
2.26.2

