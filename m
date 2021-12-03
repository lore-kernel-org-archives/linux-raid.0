Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9F7C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  3 Dec 2021 14:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352426AbhLCOet (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Dec 2021 09:34:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:37515 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230456AbhLCOeo (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 3 Dec 2021 09:34:44 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="236791863"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="236791863"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 06:31:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="610417877"
Received: from linux-myjy.igk.intel.com ([10.102.102.116])
  by orsmga004.jf.intel.com with ESMTP; 03 Dec 2021 06:31:19 -0800
From:   Blazej Kucman <blazej.kucman@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] mdadm: block creation with long names
Date:   Fri,  3 Dec 2021 15:31:15 +0100
Message-Id: <20211203143115.4544-1-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This fixes buffer overflows in create_mddev(). It prohibits
creation with not supported names for DDF and native. For IMSM,
mdadm will do silent cut to 16 later.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 mdadm.8.in | 5 +++++
 mdadm.c    | 9 ++++++++-
 mdadm.h    | 5 +++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 28d773c2..68e100cb 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2186,6 +2186,11 @@ is run, but will be created by
 .I udev
 once the array becomes active.
 
+The max length md-device name is limited to 32 characters.
+Different metadata types have more strict limitation
+(like IMSM where only 16 characters are allowed).
+For that reason, long name could be truncated or rejected, it depends on metadata policy.
+
 As devices are added, they are checked to see if they contain RAID
 superblocks or filesystems.  They are also checked to see if the variance in
 device size exceeds 1%.
diff --git a/mdadm.c b/mdadm.c
index 91e67467..26299b2e 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1359,9 +1359,16 @@ int main(int argc, char *argv[])
 			mdfd = open_mddev(devlist->devname, 1);
 			if (mdfd < 0)
 				exit(1);
-		} else
+		} else {
+			char *bname = basename(devlist->devname);
+
+			if (strlen(bname) > MD_NAME_MAX) {
+				pr_err("Name %s is too long.\n", devlist->devname);
+				exit(1);
+			}
 			/* non-existent device is OK */
 			mdfd = open_mddev(devlist->devname, 0);
+		}
 		if (mdfd == -2) {
 			pr_err("device %s exists but is not an md array.\n", devlist->devname);
 			exit(1);
diff --git a/mdadm.h b/mdadm.h
index 54567396..c7268a71 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1880,3 +1880,8 @@ enum r0layout {
 #define INVALID_SECTORS 1
 /* And another special number needed for --data_offset=variable */
 #define VARIABLE_OFFSET 3
+
+/**
+ * This is true for native and DDF, IMSM allows 16.
+ */
+#define MD_NAME_MAX 32
-- 
2.26.2

