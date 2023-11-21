Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JD9zcdo6"
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CB6C1
	for <linux-raid@vger.kernel.org>; Mon, 20 Nov 2023 23:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700553439; x=1732089439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ngAN7lM5/fnBDTal1ugDMAb9Zk1SlyRFmPL0l6OqJUM=;
  b=JD9zcdo6jPqW8/fOKFjGGLE4/akzVi9gY9xJk1zb0D0WHyg1Zo/vy8+4
   u3lwDUXFVVtBEgvzCPOn6SFEAvMqSoChVdiXa8qmpXAyGSYOHrhSpciiQ
   qmivUZ0qTiL2uhhk08RsO6AB6riHW/PUCmfgdLmXYaUqCJYpHZcHizvP5
   FJaGy5l524eTeTAMHD3QNpmeBhwnTZ2c+X7WGMDkitOsIFjRB5v8VkWFX
   XN093JAFfwaxBETxEbLkpqghR3vAOhsDVwRNjrV+bgLipsCfozXHuAJyr
   cDGvGy0vjodGV5CJ+W5Zs3OFkL5vaGf2q1DTmKdgvxsZuInVniGUNxQQB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="477991904"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="477991904"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 23:57:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="890174517"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="890174517"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orsmga004.jf.intel.com with ESMTP; 20 Nov 2023 23:57:17 -0800
From: Kinga Tanska <kinga.tanska@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	colyli@suse.de
Subject: [PATCH v5 2/2] udev: Move udev_block() and udev_unblock() into udev.c
Date: Tue, 21 Nov 2023 01:58:24 +0100
Message-Id: <20231121005824.3951-3-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20231121005824.3951-1-kinga.tanska@intel.com>
References: <20231121005824.3951-1-kinga.tanska@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mateusz Grzonka <mateusz.grzonka@intel.com>

Add kernel style comments and better error handling.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Create.c |  1 +
 lib.c    | 29 -----------------------------
 mdadm.h  |  2 --
 mdopen.c | 12 ++++++------
 udev.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 udev.h   |  3 +++
 6 files changed, 54 insertions(+), 37 deletions(-)

diff --git a/Create.c b/Create.c
index a280c7bc..ddd1a79b 100644
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
index cf2701cd..2b09293c 100644
--- a/lib.c
+++ b/lib.c
@@ -204,35 +204,6 @@ char *fd2devnm(int fd)
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
index 9514cbe5..8dcd8b86 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1765,8 +1765,6 @@ extern char *fd2kname(int fd);
 extern char *stat2devnm(struct stat *st);
 bool stat_is_md_dev(struct stat *st);
 extern char *fd2devnm(int fd);
-extern void udev_block(char *devnm);
-extern void udev_unblock(void);
 
 extern int in_initrd(void);
 
diff --git a/mdopen.c b/mdopen.c
index f9b04e1c..eaa59b59 100644
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

