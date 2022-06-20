Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C042DC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 16:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241956AbiFTQLr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 12:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241968AbiFTQLl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 12:11:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FECA205F2
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 09:11:40 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id AB5CD1F74D;
        Mon, 20 Jun 2022 16:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655741499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WFtEDapG0AkCBx4OlxPk4zLhiYqZwOvrTi9zcfD2x0E=;
        b=vOWC8+uSz3Ia7hxH4bS1lRgFbi2wv5Gll+WKFcMtWdJFWxVBHHAIdXL6ZBlJOsISNeqZ3Y
        UX36XLiqwftIrxVbSGg9BV/3es3aUlZLF7SR1AyyFJ1ZmHECvCxHehyYQyxh+a06OdJ9Hs
        JZuOXw1l6t34AgHDeJOVLGeiScEhoo4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655741499;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WFtEDapG0AkCBx4OlxPk4zLhiYqZwOvrTi9zcfD2x0E=;
        b=5Um7XrhqPtWHaCoOMZmwJ+17d/sKl2xUZ0XT8dT/gciDwLy0pSlBPd2Tdm4i7nQG+dLjHX
        4O2Zw0tjlqFX5OAg==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id D0B192C141;
        Mon, 20 Jun 2022 16:11:36 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 6/6] imsm: block changing slots during creation
Date:   Tue, 21 Jun 2022 00:10:43 +0800
Message-Id: <20220620161043.3661-7-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220620161043.3661-1-colyli@suse.de>
References: <20220620161043.3661-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

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
Acked-by: Coly Li <colyli@suse.de>
---
 super-intel.c        | 33 ++++++++++++++++++++++-----------
 tests/09imsm-overlap | 28 ----------------------------
 2 files changed, 22 insertions(+), 39 deletions(-)
 delete mode 100644 tests/09imsm-overlap

diff --git a/super-intel.c b/super-intel.c
index deef7c87..8ffe485c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5789,6 +5789,10 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 	struct imsm_map *map;
 	struct dl *dl, *df;
 	int slot;
+	int autolayout = 0;
+
+	if (!is_fd_valid(fd))
+		autolayout = 1;
 
 	dev = get_imsm_dev(super, super->current_vol);
 	map = get_imsm_map(dev, MAP_0);
@@ -5799,25 +5803,32 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
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
2.35.3

