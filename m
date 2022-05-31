Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D752BC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 10:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245688AbiEaK14 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 06:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245136AbiEaK1x (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 06:27:53 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE37996B2
        for <linux-raid@vger.kernel.org>; Tue, 31 May 2022 03:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653992873; x=1685528873;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dcFwSKmNJ0xBnls2ckIdBTgcAIfsD3oq+Dkz0gLyD94=;
  b=kfy2p/ogcxhs50Dn3u87q3y+D9vkxxuQQQAt/D9dopDWypjHsVi6ojQo
   A7PLWPCfnf4TulamkJ4urSMszdr5imLkPhgfm6kg1uwTnFI32phaEVwrR
   cbzyl9gYekXrRNQl/qYKpkk6b1k/5t9n7is+Xa3NtpWc3huCzD+IniFvn
   fVLWkr+99O20CZ+wG/7+wcsTazwoZbe/ZMhsBr5ADYq0qb6KHmV01Nu8I
   33c3htoR7YQlGV4VFidc+eMbKVK9XEgpAGA0ztGhoG/7xN2NZn/DMmtbd
   +Q7HFC5YQwSW0o8Q48DM0a9NiUiSJq10dyau8upMTjN1IanOvuNcM4iN6
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="300562499"
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="300562499"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 03:27:53 -0700
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="576342809"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 03:27:51 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 3/3 v2] imsm: block changing slots during creation
Date:   Tue, 31 May 2022 12:27:27 +0200
Message-Id: <20220531102727.9315-4-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220531102727.9315-1-mariusz.tkaczyk@linux.intel.com>
References: <20220531102727.9315-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If user specifies drives for array creation, then slot order across
volumes is not preserved.
Ideally, it should be checked in validate_geometry() but it is not
possible in current implementation (order is determined later).
Add verification in add_to_super_imsm_volume() and throw error if
mismatch is detected.
IMSM allows to use only same members within container.
This is not hardware dependency but metadata limitation.
Therefore, 09-imsm-overlap test is removed. Testing it is pointless.
After this patch, creation in this scenario is blocked. Offset
verification is covered in other tests.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c        | 33 ++++++++++++++++++++++-----------
 tests/09imsm-overlap | 28 ----------------------------
 2 files changed, 22 insertions(+), 39 deletions(-)
 delete mode 100644 tests/09imsm-overlap

diff --git a/super-intel.c b/super-intel.c
index 3c02d2f6..053f7e7e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5760,6 +5760,10 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 	struct imsm_map *map;
 	struct dl *dl, *df;
 	int slot;
+	int autolayout = 0;
+
+	if (!is_fd_valid(fd))
+		autolayout = 1;
 
 	dev = get_imsm_dev(super, super->current_vol);
 	map = get_imsm_map(dev, MAP_0);
@@ -5770,25 +5774,32 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 		return 1;
 	}
 
-	if (!is_fd_valid(fd)) {
-		/* we're doing autolayout so grab the pre-marked (in
-		 * validate_geometry) raid_disk
-		 */
-		for (dl = super->disks; dl; dl = dl->next)
+	for (dl = super->disks; dl ; dl = dl->next) {
+		if (autolayout) {
 			if (dl->raiddisk == dk->raid_disk)
 				break;
-	} else {
-		for (dl = super->disks; dl ; dl = dl->next)
-			if (dl->major == dk->major &&
-			    dl->minor == dk->minor)
-				break;
+		} else if (dl->major == dk->major && dl->minor == dk->minor)
+			break;
 	}
 
 	if (!dl) {
-		pr_err("%s is not a member of the same container\n", devname);
+		if (!autolayout)
+			pr_err("%s is not a member of the same container.\n",
+			       devname);
 		return 1;
 	}
 
+	if (!autolayout && super->current_vol > 0) {
+		int _slot = get_disk_slot_in_dev(super, 0, dl->index);
+
+		if (_slot != dk->raid_disk) {
+			pr_err("Member %s is in %d slot for the first volume, but is in %d slot for a new volume.\n",
+			       dl->devname, _slot, dk->raid_disk);
+			pr_err("Raid members are in different order than for the first volume, aborting.\n");
+			return 1;
+		}
+	}
+
 	if (mpb->num_disks == 0)
 		if (!get_dev_sector_size(dl->fd, dl->devname,
 					 &super->sector_size))
diff --git a/tests/09imsm-overlap b/tests/09imsm-overlap
deleted file mode 100644
index ff5d2093..00000000
--- a/tests/09imsm-overlap
+++ /dev/null
@@ -1,28 +0,0 @@
-
-. tests/env-imsm-template
-
-# create raid arrays with varying degress of overlap
-mdadm -CR $container -e imsm -n 6 $dev0 $dev1 $dev2 $dev3 $dev4 $dev5
-imsm_check container 6
-
-size=1024
-level=1
-num_disks=2
-mdadm -CR $member0 $dev0 $dev1 -n $num_disks -l $level -z $size
-mdadm -CR $member1 $dev1 $dev2 -n $num_disks -l $level -z $size
-mdadm -CR $member2 $dev2 $dev3 -n $num_disks -l $level -z $size
-mdadm -CR $member3 $dev3 $dev4 -n $num_disks -l $level -z $size
-mdadm -CR $member4 $dev4 $dev5 -n $num_disks -l $level -z $size
-
-udevadm settle
-
-offset=0
-imsm_check member $member0 $num_disks $level $size 1024 $offset
-offset=$((offset+size+4096))
-imsm_check member $member1 $num_disks $level $size 1024 $offset
-offset=$((offset+size+4096))
-imsm_check member $member2 $num_disks $level $size 1024 $offset
-offset=$((offset+size+4096))
-imsm_check member $member3 $num_disks $level $size 1024 $offset
-offset=$((offset+size+4096))
-imsm_check member $member4 $num_disks $level $size 1024 $offset
-- 
2.26.2

