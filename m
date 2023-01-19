Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C677C00A5A
	for <linux-raid@archiver.kernel.org>; Thu, 19 Jan 2023 13:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjASNtz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Jan 2023 08:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbjASNtQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Jan 2023 08:49:16 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE7A1EFE6
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 05:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674136152; x=1705672152;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2RLaTpTu1FQtw3TjSGUzfM6mBktqqKt/DwRnxuxOBjg=;
  b=Oyid4pPgRU7U9Yuh1pXj9ZyiiDA4dtu1kdEvjv0aKt8u2ZqczQ+EY32L
   qHneceT5rlMCpx2YaVAp+Iu1xeBQLOXlY2VDjcpBr7j1iPRi7Fnlg0wYM
   WYcRy3YPhoozOrhGtNbVWTJ6mCTPc6s8LGpylKit1ZKdGJUHfIuNBeLjH
   2NmQxaRaS+Wi7Y3XuT0bnH5Iksqjx4FvTw8OuYLGIDCCj8eEkkR8nvgyF
   seH0c+MXeFYL/j7GFH/0LqPhfXH1FQfGqNXeEQTfvldXdE8zh/8hgTs6n
   2EGCg2X9s2DSbYy5JipK0hdYdplVu/9vWpl3QnPCp27UX+d6K4pc4SGVH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="323973402"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="323973402"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 05:49:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="768221959"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="768221959"
Received: from unknown (HELO localhost.elements.local) ([10.102.104.85])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jan 2023 05:49:11 -0800
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH 6/8] Mdmonitor: Refactor check_one_sharer() for better error handling
Date:   Thu, 19 Jan 2023 14:30:07 +0100
Message-Id: <20230119133009.12696-7-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230119133009.12696-1-mateusz.grzonka@intel.com>
References: <20230119133009.12696-1-mateusz.grzonka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Also check if autorebuild.pid is a symlink, which we shouldn't accept.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 Monitor.c | 89 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 62 insertions(+), 27 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 14a2dfe5..44918184 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -32,6 +32,7 @@
 #include	<libudev.h>
 #endif
 
+#define TASK_COMM_LEN 16
 #define EVENT_NAME_MAX 32
 #define AUTOREBUILD_PID_PATH MDMON_DIR "/autorebuild.pid"
 
@@ -224,7 +225,7 @@ int Monitor(struct mddev_dev *devlist,
 	info.hostname[sizeof(info.hostname) - 1] = '\0';
 
 	if (share){
-		if (check_one_sharer(c->scan))
+		if (check_one_sharer(c->scan) == 2)
 			return 1;
 	}
 
@@ -406,39 +407,73 @@ static int make_daemon(char *pidfile)
 	return -1;
 }
 
+/*
+ * check_one_sharer() - Checks for other mdmon processes running.
+ *
+ * Return:
+ * 0 - no other processes running,
+ * 1 - warning,
+ * 2 - error, or when scan mode is enabled, and one mdmon process already exists
+ */
 static int check_one_sharer(int scan)
 {
 	int pid;
-	FILE *comm_fp;
-	FILE *fp;
+	FILE *fp, *comm_fp;
 	char comm_path[PATH_MAX];
-	char path[PATH_MAX];
-	char comm[20];
-
-	sprintf(path, "%s/autorebuild.pid", MDMON_DIR);
-	fp = fopen(path, "r");
-	if (fp) {
-		if (fscanf(fp, "%d", &pid) != 1)
-			pid = -1;
-		snprintf(comm_path, sizeof(comm_path),
-			 "/proc/%d/comm", pid);
-		comm_fp = fopen(comm_path, "r");
-		if (comm_fp) {
-			if (fscanf(comm_fp, "%19s", comm) &&
-			    strncmp(basename(comm), Name, strlen(Name)) == 0) {
-				if (scan) {
-					pr_err("Only one autorebuild process allowed in scan mode, aborting\n");
-					fclose(comm_fp);
-					fclose(fp);
-					return 1;
-				} else {
-					pr_err("Warning: One autorebuild process already running.\n");
-				}
-			}
+	char comm[TASK_COMM_LEN];
+
+	if (!is_directory(MDMON_DIR)) {
+		pr_err("%s is not a regular directory.\n", MDMON_DIR);
+		return 2;
+	}
+
+	if (access(AUTOREBUILD_PID_PATH, F_OK) != 0)
+		return 0;
+
+	if (!is_file(AUTOREBUILD_PID_PATH)) {
+		pr_err("%s is not a regular file.\n", AUTOREBUILD_PID_PATH);
+		return 2;
+	}
+
+	fp = fopen(AUTOREBUILD_PID_PATH, "r");
+	if (!fp) {
+		pr_err("Cannot open %s file.\n", AUTOREBUILD_PID_PATH);
+		return 2;
+	}
+
+	if (fscanf(fp, "%d", &pid) != 1) {
+		pr_err("Cannot read pid from %s file.\n", AUTOREBUILD_PID_PATH);
+		fclose(fp);
+		return 2;
+	}
+
+	snprintf(comm_path, sizeof(comm_path), "/proc/%d/comm", pid);
+
+	comm_fp = fopen(comm_path, "r");
+	if (!comm_fp) {
+		dprintf("Warning: Cannot open %s, continuing\n", comm_path);
+		fclose(fp);
+		return 1;
+	}
+
+	if (fscanf(comm_fp, "%15s", comm) == 0) {
+		dprintf("Warning: Cannot read comm from %s, continuing\n", comm_path);
+		fclose(comm_fp);
+		fclose(fp);
+		return 1;
+	}
+
+	if (strncmp(basename(comm), Name, strlen(Name)) == 0) {
+		if (scan) {
+			pr_err("Only one autorebuild process allowed in scan mode, aborting\n");
 			fclose(comm_fp);
+			fclose(fp);
+			return 2;
 		}
-		fclose(fp);
+		pr_err("Warning: One autorebuild process already running.\n");
 	}
+	fclose(comm_fp);
+	fclose(fp);
 	return 0;
 }
 
-- 
2.26.2

