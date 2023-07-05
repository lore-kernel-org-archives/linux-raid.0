Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CE9EB64DA
	for <linux-raid@archiver.kernel.org>; Wed,  5 Jul 2023 15:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbjGEPMV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 Jul 2023 11:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbjGEPMU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 5 Jul 2023 11:12:20 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20F0E59
        for <linux-raid@vger.kernel.org>; Wed,  5 Jul 2023 08:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688569939; x=1720105939;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6bV3pZISME/9A+bEctacGcWMD+Q0vsZOqY3ncRPKWp8=;
  b=JgUgbDwu/1b8iMc+QpACRnusd01K3tkbI+6MAZNcx0K+84OibmhBHzOd
   /IZ0EoTRnPZkngoe/gaS0rS9+pxSeVRrWLqSHTmkP6/6u1sFU7k/M+S7t
   TbNf4nY2QoVdri4DDLirOzfyJFguwBY3XNHmEuS00+mTK90rcRfmTjhQM
   lU+Rc02L75ab3386QwZhCbOiAguvMe+G2psdeqDk4qRRIbo6zbfbtDaXj
   KB0ZoSEfnzKkfq1iSwHsjoi/sBB/wNky7SV54ZFRAewp3ewP/CCQX+2jn
   cU10JYLXeohtOjAuBgpFj0t4swEJOytdRkxAg+ecQWY7B4odVjBsXKELO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="363398310"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="363398310"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 08:12:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="784600050"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="784600050"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.104.85])
  by fmsmga008.fm.intel.com with ESMTP; 05 Jul 2023 08:12:17 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH v4 2/2] udev: Move udev_block() and udev_unblock() into udev.c
Date:   Wed,  5 Jul 2023 16:50:41 +0200
Message-Id: <20230705145041.31758-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
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
 udev.h   |  3 +++
 6 files changed, 54 insertions(+), 37 deletions(-)

diff --git a/Create.c b/Create.c
index ea6a4745..19e53cc8 100644
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
index 9c26c627..8c6f8509 100644
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
index bbb2fbf8..7e1a795d 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1755,8 +1755,6 @@ extern char *fd2kname(int fd);
 extern char *stat2devnm(struct stat *st);
 bool stat_is_md_dev(struct stat *st);
 extern char *fd2devnm(int fd);
-extern void udev_block(char *devnm);
-extern void udev_unblock(void);
 
 extern int in_initrd(void);
 
diff --git a/mdopen.c b/mdopen.c
index fbdb0af0..333e07fa 100644
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
 		create_named_array(devnm);
 	}
 
diff --git a/udev.c b/udev.c
index 2bac6921..bc4722b0 100644
--- a/udev.c
+++ b/udev.c
@@ -28,6 +28,8 @@
 #include	<syslog.h>
 #include	<libudev.h>
 
+static char *unblock_path;
+
 /*
  * udev_is_available() - Checks for udev in the system.
  *
@@ -148,3 +150,45 @@ enum udev_status udev_wait_for_events(int seconds)
 	return UDEV_STATUS_TIMEOUT;
 }
 #endif
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
diff --git a/udev.h b/udev.h
index 33884861..ae0a3617 100644
--- a/udev.h
+++ b/udev.h
@@ -34,4 +34,7 @@ bool udev_is_available(void);
 enum udev_status udev_wait_for_events(int seconds);
 #endif
 
+enum udev_status udev_block(char *devnm);
+void udev_unblock(void);
+
 #endif
-- 
2.26.2

