Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD040ECAAD8
	for <linux-raid@archiver.kernel.org>; Wed, 21 Sep 2022 13:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiIUNHw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Sep 2022 09:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiIUNHu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Sep 2022 09:07:50 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6213C883D1
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 06:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663765668; x=1695301668;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0FBsJq7GCK4+dDy1ukHXamsNU+AAcd6ONQezUD+CBvM=;
  b=n8hqQYj+WpkpOcECetZdI9dJ6A+HuK89UNPODc11w/G7WvgnOt//yWhW
   3JVhPrHhN6ixKpr5re9Miy0zBimIlyM+lK12x6DaPsAxRK4lbsG0gnWqv
   4QMRSpfO1m5CdEH8+mmsagGmxxYSXDk7jHNyekmXZ82YLvyEcS9biXdhc
   SkPXI/XKdkbic0QK7JZNAvnb+jKEoto0aYiADQVZvh7C5lJpKc02jFs5g
   z2fhRmI4AtoKMwaBJ1BVXUNNCVPxo1Cej1eaacshDzpv3FwQI8Dr0UEfU
   dhNyTz3tc1pXLdfN/Ql+ngq5VKb/zQcYTebPm1XZ5696YMIbE2KeLMhf7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="361754966"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="361754966"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 06:07:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="570527599"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.105.50])
  by orsmga003.jf.intel.com with ESMTP; 21 Sep 2022 06:07:47 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH 9/9 v2] udev: Move udev_block() and udev_unblock() into udev.c
Date:   Wed, 21 Sep 2022 14:50:51 +0200
Message-Id: <20220921125051.21325-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Because a file dedicated for udev-related stuff was created, move udev_block() and udev_unblock() into udev.c
Also add kernel style comments and better error handling.

---
 Create.c |  1 +
 lib.c    | 29 -----------------------------
 mdadm.h  |  2 --
 mdopen.c | 12 ++++++------
 udev.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 udev.h   |  2 ++
 6 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/Create.c b/Create.c
index c84c1ac8..e68894ed 100644
--- a/Create.c
+++ b/Create.c
@@ -23,6 +23,7 @@
  */
 
 #include	"mdadm.h"
+#include	"udev.h"
 #include	"md_u.h"
 #include	"md_p.h"
 #include	<ctype.h>
diff --git a/lib.c b/lib.c
index 10a6ae40..5a1afd49 100644
--- a/lib.c
+++ b/lib.c
@@ -174,35 +174,6 @@ char *fd2devnm(int fd)
 	return NULL;
 }
 
-/* When we create a new array, we don't want the content to
- * be immediately examined by udev - it is probably meaningless.
- * So create /run/mdadm/creating-mdXXX and expect that a udev
- * rule will noticed this and act accordingly.
- */
-static char block_path[] = "/run/mdadm/creating-%s";
-static char *unblock_path = NULL;
-void udev_block(char *devnm)
-{
-	int fd;
-	char *path = NULL;
-
-	xasprintf(&path, block_path, devnm);
-	fd = open(path, O_CREAT|O_RDWR, 0600);
-	if (fd >= 0) {
-		close(fd);
-		unblock_path = path;
-	} else
-		free(path);
-}
-
-void udev_unblock(void)
-{
-	if (unblock_path)
-		unlink(unblock_path);
-	free(unblock_path);
-	unblock_path = NULL;
-}
-
 /*
  * convert a major/minor pair for a block device into a name in /dev, if possible.
  * On the first call, walk /dev collecting name.
diff --git a/mdadm.h b/mdadm.h
index 3c08f826..3f81cce6 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1662,8 +1662,6 @@ extern char *stat2kname(struct stat *st);
 extern char *fd2kname(int fd);
 extern char *stat2devnm(struct stat *st);
 extern char *fd2devnm(int fd);
-extern void udev_block(char *devnm);
-extern void udev_unblock(void);
 
 extern int in_initrd(void);
 
diff --git a/mdopen.c b/mdopen.c
index 53da4d96..93193739 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -336,8 +336,8 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 	devnm[0] = 0;
 	if (num < 0 && cname && ci->names) {
 		sprintf(devnm, "md_%s", cname);
-		if (block_udev)
-			udev_block(devnm);
+		if (block_udev && udev_block(devnm) != UDEV_STATUS_SUCCESS)
+			return -1;
 		if (!create_named_array(devnm)) {
 			devnm[0] = 0;
 			udev_unblock();
@@ -345,8 +345,8 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 	}
 	if (num >= 0) {
 		sprintf(devnm, "md%d", num);
-		if (block_udev)
-			udev_block(devnm);
+		if (block_udev && udev_block(devnm) != UDEV_STATUS_SUCCESS)
+			return -1;
 		if (!create_named_array(devnm)) {
 			devnm[0] = 0;
 			udev_unblock();
@@ -369,8 +369,8 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 				return -1;
 			}
 		}
-		if (block_udev)
-			udev_block(devnm);
+		if (block_udev && udev_block(devnm) != UDEV_STATUS_SUCCESS)
+			return -1;
 	}
 
 	sprintf(devname, "/dev/%s", devnm);
diff --git a/udev.c b/udev.c
index 18055bfc..d6e3d7b5 100644
--- a/udev.c
+++ b/udev.c
@@ -30,6 +30,7 @@
 
 static struct udev *udev;
 static struct udev_monitor *udev_monitor;
+static char *unblock_path;
 
 /**
  * udev_is_available() - Checks for udev in the system.
@@ -145,3 +146,46 @@ void udev_release(void)
 	udev_monitor_unref(udev_monitor);
 	udev_unref(udev);
 }
+
+/**
+ * udev_block() - Block udev from examining newly created arrays.
+ *
+ * When array is created, we don't want udev to examine it immediately.
+ * Function creates /run/mdadm/creating-mdXXX and expects that udev rule
+ * will notice it and act accordingly.
+ *
+ * Return:
+ * UDEV_STATUS_SUCCESS when successfully blocked udev
+ * UDEV_STATUS_ERROR on error
+ */
+enum udev_status udev_block(char *devnm)
+{
+	int fd;
+	char *path = xcalloc(1, BUFSIZ);
+
+	snprintf(path, BUFSIZ, "/run/mdadm/creating-%s", devnm);
+
+	fd = open(path, O_CREAT | O_RDWR, 0600);
+	if (!is_fd_valid(fd)) {
+		pr_err("Cannot block udev, error creating blocking file.\n");
+		pr_err("%s: %s\n", strerror(errno), path);
+		free(path);
+		return UDEV_STATUS_ERROR;
+	}
+
+	close(fd);
+	unblock_path = path;
+	return UDEV_STATUS_SUCCESS;
+}
+
+/**
+ * udev_unblock() - Unblock udev.
+ */
+void udev_unblock(void)
+{
+	if (unblock_path)
+		unlink(unblock_path);
+	free(unblock_path);
+	unblock_path = NULL;
+}
+
diff --git a/udev.h b/udev.h
index 515366e7..e4da29cc 100644
--- a/udev.h
+++ b/udev.h
@@ -32,5 +32,7 @@ bool udev_is_available(void);
 enum udev_status udev_initialize(void);
 enum udev_status udev_wait_for_events(int seconds);
 void udev_release(void);
+enum udev_status udev_block(char *devnm);
+void udev_unblock(void);
 
 #endif
-- 
2.26.2

