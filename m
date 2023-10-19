Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC756CDB465
	for <linux-raid@archiver.kernel.org>; Thu, 19 Oct 2023 14:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346145AbjJSOfr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Oct 2023 10:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346184AbjJSOfo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Oct 2023 10:35:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165E1182
        for <linux-raid@vger.kernel.org>; Thu, 19 Oct 2023 07:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697726140; x=1729262140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FAHdY3clc0dmWd+yLz1Z7eUyiraSQYdP251ABnvVS6Q=;
  b=S25CoLvQ/BpfEjFAAZ9LXKzisTTk9dPP4ougGBiC3zKxTcNG3qZP04/W
   Lt3SXMB5H2uC0LH8lQKKcNBR5gjRUG0G5iC24+tsITxfXXnMemNxniGNa
   HZczWk+Ej+6xVZkzUG7X+yCcsXAGhG+ocsQCp/l3YN9FSUHOFsGhWNEkB
   VKToh0ug4Wb1mV/Jsq/UkchQY7RNumXE1e5a9eIslLUvS8VgXvDkQfsp0
   nbxM/SieCPmhvMcTIb5U+SGVlhPBsRCIPi3cL8Psuyd+QjcCTP9rbFbHY
   M0kuqOPGdOwcN3+xzDjtN4KMa/TBdkoGzxn7IVNF57m+TeG6WHmt6rk0N
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="385139971"
X-IronPort-AV: E=Sophos;i="6.03,237,1694761200"; 
   d="scan'208";a="385139971"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 07:35:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="880675468"
X-IronPort-AV: E=Sophos;i="6.03,237,1694761200"; 
   d="scan'208";a="880675468"
Received: from dev-ppiatko.ger.corp.intel.com ([10.102.95.202])
  by orsmga004.jf.intel.com with ESMTP; 19 Oct 2023 07:35:38 -0700
From:   Pawel Piatkowski <pawel.piatkowski@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 1/2] mdadm: remove container_enough logic
Date:   Thu, 19 Oct 2023 16:35:24 +0200
Message-Id: <20231019143525.2086-2-pawel.piatkowski@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20231019143525.2086-1-pawel.piatkowski@intel.com>
References: <20231019143525.2086-1-pawel.piatkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Arrays without enough disk count will be assembled but not
started.
Now RAIDs will be assembled always (even if they are failed).
RAID devices in all states will be assembled and exposed
to mdstat.
This change affects only IMSM (for ddf it wasn't used,
container_enough was set to true always).
Removed this logic from incremental_container as well with
runstop checking because runstop condition is being verified
in assemble_container_content function.

Signed-off-by: Pawel Piatkowski <pawel.piatkowski@intel.com>
---
 Incremental.c | 11 -----------
 mdadm.h       |  3 ---
 super-ddf.c   |  1 -
 super-intel.c | 32 +-------------------------------
 4 files changed, 1 insertion(+), 46 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index f13ce027..332fb846 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1467,17 +1467,6 @@ static int Incremental_container(struct supertype *st, char *devname,
 
 	st->ss->getinfo_super(st, &info, NULL);
 
-	if ((c->runstop > 0 && info.container_enough >= 0) ||
-	    info.container_enough > 0)
-		/* pass */;
-	else {
-		if (c->export) {
-			printf("MD_STARTED=no\n");
-		} else if (c->verbose)
-			pr_err("not enough devices to start the container\n");
-		return 0;
-	}
-
 	match = conf_match(st, &info, devname, c->verbose, &rv);
 	if (match == NULL && rv == 2)
 		return rv;
diff --git a/mdadm.h b/mdadm.h
index 83f2cf7f..fb4c6fa1 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -372,9 +372,6 @@ struct mdinfo {
 	int container_member; /* for assembling external-metatdata arrays
 			       * This is to be used internally by metadata
 			       * handler only */
-	int container_enough; /* flag external handlers can set to
-			       * indicate that subarrays have not enough (-1),
-			       * enough to start (0), or all expected disks (1) */
 	char		sys_name[32];
 	struct mdinfo *devs;
 	struct mdinfo *next;
diff --git a/super-ddf.c b/super-ddf.c
index 7213284e..d06bd781 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1975,7 +1975,6 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
 	info->array.ctime	  = DECADE + __be32_to_cpu(*cptr);
 
 	info->array.chunk_size	  = 0;
-	info->container_enough	  = 1;
 
 	info->disk.major	  = 0;
 	info->disk.minor	  = 0;
diff --git a/super-intel.c b/super-intel.c
index ae0f4a8c..56dda5a6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3778,7 +3778,6 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 	struct intel_super *super = st->sb;
 	struct imsm_disk *disk;
 	int map_disks = info->array.raid_disks;
-	int max_enough = -1;
 	int i;
 	struct imsm_super *mpb;
 
@@ -3820,12 +3819,9 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
-		int failed, enough, j, missing = 0;
+		int j = 0;
 		struct imsm_map *map;
-		__u8 state;
 
-		failed = imsm_count_failed(super, dev, MAP_0);
-		state = imsm_check_degraded(super, dev, failed, MAP_0);
 		map = get_imsm_map(dev, MAP_0);
 
 		/* any newly missing disks?
@@ -3840,36 +3836,10 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 
 			if (!(ord & IMSM_ORD_REBUILD) &&
 			    get_imsm_missing(super, idx)) {
-				missing = 1;
 				break;
 			}
 		}
-
-		if (state == IMSM_T_STATE_FAILED)
-			enough = -1;
-		else if (state == IMSM_T_STATE_DEGRADED &&
-			 (state != map->map_state || missing))
-			enough = 0;
-		else /* we're normal, or already degraded */
-			enough = 1;
-		if (is_gen_migration(dev) && missing) {
-			/* during general migration we need all disks
-			 * that process is running on.
-			 * No new missing disk is allowed.
-			 */
-			max_enough = -1;
-			enough = -1;
-			/* no more checks necessary
-			 */
-			break;
-		}
-		/* in the missing/failed disk case check to see
-		 * if at least one array is runnable
-		 */
-		max_enough = max(max_enough, enough);
 	}
-	dprintf("enough: %d\n", max_enough);
-	info->container_enough = max_enough;
 
 	if (super->disks) {
 		__u32 reserved = imsm_reserved_sectors(super, super->disks);
-- 
2.39.1

