Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB695C61DA4
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 11:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjBBLqb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Feb 2023 06:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjBBLqa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Feb 2023 06:46:30 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB966D07F
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 03:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675338389; x=1706874389;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MTs2TuN8T2Ns0CZEdBLr87cdvQwrK+wISI5nkINIsOQ=;
  b=TQTTcc+qajn7wM0QyiUVJW8E/CJIs7WNSJOOSgkrJ0yupmM8lprNAWXB
   gwnT+eqXRj/XKHQRgWp4zJjTQF4RvklU+mRBKDC6DRKbLId9LOljiGiAP
   iAk2DwmYseWfMcqym4OpwSMQfibdcuJC3jgs7W+Maz8nZwGZkwBz34lT+
   zs62ZOJsWWDu0qNZ6QP+/yXEja/8Xr5VKp9hAOscJ14S4xt1Rs4R7BkKA
   BabiRP+6WhdfvH8frcXk5HXvJYmAHU8CE5Sl2Ki9w7KIncvoQzY8st36H
   s4SNIDGSVN/0hSMOzgTyIDRe04s1EERAnjcQaVNVR2WBQC5DctD3r5Xpx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="327075992"
X-IronPort-AV: E=Sophos;i="5.97,267,1669104000"; 
   d="scan'208";a="327075992"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 03:46:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="697661193"
X-IronPort-AV: E=Sophos;i="5.97,267,1669104000"; 
   d="scan'208";a="697661193"
Received: from unknown (HELO localhost.elements.local) ([10.102.104.85])
  by orsmga001.jf.intel.com with ESMTP; 02 Feb 2023 03:46:28 -0800
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH v3 8/8] udev: Move udev_block() and udev_unblock() into udev.c
Date:   Thu,  2 Feb 2023 12:27:06 +0100
Message-Id: <20230202112706.14228-9-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230202112706.14228-1-mateusz.grzonka@intel.com>
References: <20230202112706.14228-1-mateusz.grzonka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add kernel style comments and better error handling.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 Create.c |  1 +
 lib.c    | 29 -----------------------------
 mdadm.h  |  2 --
 mdopen.c | 12 ++++++------
 udev.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 udev.h   |  2 ++
 6 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/Create.c b/Create.c
index 953e7372..666a8c92 100644
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
index 96ba6e8d..24cd10e3 100644
--- a/lib.c
+++ b/lib.c
@@ -186,35 +186,6 @@ char *fd2devnm(int fd)
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
index 23c10a52..5607c599 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1729,8 +1729,6 @@ extern char *fd2kname(int fd);
 extern char *stat2devnm(struct stat *st);
 bool stat_is_md_dev(struct stat *st);
 extern char *fd2devnm(int fd);
-extern void udev_block(char *devnm);
-extern void udev_unblock(void);
 
 extern int in_initrd(void);
 
diff --git a/mdopen.c b/mdopen.c
index afec34a4..ef34613a 100644
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
index 72a38f47..5389e5df 100644
--- a/udev.c
+++ b/udev.c
@@ -30,6 +30,7 @@
 
 static struct udev *udev;
 static struct udev_monitor *udev_monitor;
+static char *unblock_path;
 
 /*
  * udev_is_available() - Checks for udev in the system.
@@ -145,3 +146,46 @@ void udev_release(void)
 	udev_monitor_unref(udev_monitor);
 	udev_unref(udev);
 }
+
+/*
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
+/*
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

