Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B50CCC00A5A
	for <linux-raid@archiver.kernel.org>; Thu, 19 Jan 2023 13:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjASNzW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Jan 2023 08:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjASNyt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Jan 2023 08:54:49 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CC38A78
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 05:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674136487; x=1705672487;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MTs2TuN8T2Ns0CZEdBLr87cdvQwrK+wISI5nkINIsOQ=;
  b=GhovXVSgGH8a92/tfC0AnAMTyCHrkgbh/mMrNWqYyX3MkbpGL9hMDD4j
   F4MnbgaNXfBGWFBDntetUUmjs+s55KsqQkEzVNXK2aRAxrOpFd9zw09ug
   bEymVxD5vFwf8IR6A8LQjU3h0dC8bPPOcUiBe3YVUmO8UlvhdQEPy8/92
   cZf/Y4tHRZr6XNXEnHYH+TEQod7BCJubsfKKZJV6JzEIwVDg36MWUSWJM
   DjIhJWwzpox0sOqm35vWpX62LtTAzjozbQlRLRFzPjTEBsczpVqpf97/T
   5bRUnVY6CmQGxeqTa3xD9KO10Y0u9DnGxJ1OlJwNVxbud8wNyydo24u8d
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="305657237"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="305657237"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 05:54:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="905520403"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="905520403"
Received: from unknown (HELO localhost.elements.local) ([10.102.104.85])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jan 2023 05:54:46 -0800
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH v2 8/8] udev: Move udev_block() and udev_unblock() into udev.c
Date:   Thu, 19 Jan 2023 14:35:46 +0100
Message-Id: <20230119133546.13334-8-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230119133546.13334-1-mateusz.grzonka@intel.com>
References: <20230119133546.13334-1-mateusz.grzonka@intel.com>
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

