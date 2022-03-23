Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0BAC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 23 Mar 2022 14:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244642AbiCWOIO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Mar 2022 10:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244734AbiCWOH7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Mar 2022 10:07:59 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6D67EA1C
        for <linux-raid@vger.kernel.org>; Wed, 23 Mar 2022 07:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648044390; x=1679580390;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=25aiIEKXiu+yT7AKQwWsqVzc8NtV7CULzeTZA38mCsM=;
  b=De/ph5YZB+7GNOn4nvs/RHcrRIgL3ROYNz1OVHNdtcwukHBz2Vdbn+4R
   XIrpi1A4ImIKRyLh76kQSeUY99fPmfXfNmIAUoW/+hKYX82RMg5bmbHKV
   HiMtA/wTOAhxef+rsFZY4dfn9c39hg9RvzgxvN1NCMbAwNINIfSXKzkb8
   hjoci5M0bx8wMz4sk+BXWj1mxS3a299Lsf8Kd27BBQS1KRhUyAG1u3rBo
   FpZR33eIW2IsiyBfh40ae2D1EM5xppBzfv+2RJV539lZId8znIbDagRMa
   w7Qu6Kp0YuXtE6ROieb+boPBiLX1B9Ahu6dXvHm9CKsrZ50vFFb8WI/bO
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="238721784"
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="238721784"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 07:06:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="560915826"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.52])
  by orsmga008.jf.intel.com with ESMTP; 23 Mar 2022 07:06:28 -0700
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] Grow_reshape: Add r0 grow size error message and update man
Date:   Wed, 23 Mar 2022 15:05:19 +0100
Message-Id: <20220323140519.1151-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Grow size on r0 is not supported for imsm and native metadata.
Add proper error message.
Update man for proper use of --size.
Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Grow.c     |  6 ++++++
 mdadm.8.in | 19 ++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/Grow.c b/Grow.c
index 9c6fc95e..efbbf6a9 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1998,6 +1998,12 @@ int Grow_reshape(char *devname, int fd,
 			goto release;
 		}
 
+		if (array.level == 0) {
+			pr_err("Component size change is not supported for RAID0\n");
+			rv = 1;
+			goto release;
+		}
+
 		if (reshape_super(st, s->size, UnSet, UnSet, 0, 0, UnSet, NULL,
 				  devname, APPLY_METADATA_CHANGES,
 				  c->verbose > 0)) {
diff --git a/mdadm.8.in b/mdadm.8.in
index be902dba..e2a42425 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -459,7 +459,8 @@ number of spare devices.
 
 .TP
 .BR \-z ", " \-\-size=
-Amount (in Kilobytes) of space to use from each drive in RAID levels 1/4/5/6.
+Amount (in Kilobytes) of space to use from each drive in RAID levels 1/4/5/6/10
+and for RAID 0 on external metadata.
 This must be a multiple of the chunk size, and must leave about 128Kb
 of space at the end of the drive for the RAID superblock.
 If this is not specified
@@ -478,10 +479,19 @@ To guard against this it can be useful to set the initial size
 slightly smaller than the smaller device with the aim that it will
 still be larger than any replacement.
 
+This option can be used with
+.B \-\-create
+for determining initial size of an array. For external metadata,
+it can be used on a volume, but not on a container itself.
+Setting initial size of
+.B RAID 0
+array is only valid for external metadata.
+
 This value can be set with
 .B \-\-grow
-for RAID level 1/4/5/6 though
+for RAID level 1/4/5/6/10 though
 DDF arrays may not be able to support this.
+RAID 0 array size cannot be changed.
 If the array was created with a size smaller than the currently
 active drives, the extra space can be accessed using
 .BR \-\-grow .
@@ -501,11 +511,6 @@ problems the array can be made bigger again with no loss with another
 .B "\-\-grow \-\-size="
 command.
 
-This value cannot be used when creating a
-.B CONTAINER
-such as with DDF and IMSM metadata, though it perfectly valid when
-creating an array inside a container.
-
 .TP
 .BR \-Z ", " \-\-array\-size=
 This is only meaningful with
-- 
2.26.2

