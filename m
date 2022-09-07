Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72EF5C38145
	for <linux-raid@archiver.kernel.org>; Wed,  7 Sep 2022 13:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiIGNPJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Sep 2022 09:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiIGNOr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Sep 2022 09:14:47 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B805317064
        for <linux-raid@vger.kernel.org>; Wed,  7 Sep 2022 06:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662556473; x=1694092473;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PILjyphCFOey/Vm8M2cE31atJR0ggpjtS7Uj4dPrq4Y=;
  b=kTiQDe8pduu0tbAjQkJ1poSgwQAO19o00kJFRCCDyTwtRDucnH9gs3CV
   IIWX7nkzHfF9obuxZkxF4vWbOyclkeZWIszToVtRl30fMSwCUNnRMc70h
   rVSKm/266k4aDEPZvIVoPrqVDr/RFNbzBDKFog0cuKPhhoYhMmMvImWRa
   wLEzbKEVB0RHD/pkRdFYJZE8EpybyexDEQahCvCa/L7oZlZNS1P983nGN
   cjFY2YJw0MpkwVcf9n9zgJi0TlPoxKwrxGH0RokOKRf4hYUrERnU6RPBH
   wL8bv0hQ4qeQhxM0P4RmIeKL6Ncdrwdhtt0m/7u8PtO5NylX37UMQ1Ypm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="296865388"
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="296865388"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 06:14:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="644608669"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.105.50])
  by orsmga008.jf.intel.com with ESMTP; 07 Sep 2022 06:14:30 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH 7/9] Mdmonitor: Refactor check_one_sharer() for better error handling
Date:   Wed,  7 Sep 2022 14:56:55 +0200
Message-Id: <20220907125657.12192-8-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220907125657.12192-1-mateusz.grzonka@intel.com>
References: <20220907125657.12192-1-mateusz.grzonka@intel.com>
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
index 3e09f2a2..aa79cf6c 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -32,6 +32,7 @@
 #include	<libudev.h>
 #endif
 
+#define TASK_COMM_LEN 16
 #define EVENT_NAME_MAX 32
 #define AUTOREBUILD_PID_PATH MDMON_DIR "/autorebuild.pid"
 
@@ -214,7 +215,7 @@ int Monitor(struct mddev_dev *devlist,
 	info.hostname[sizeof(info.hostname) - 1] = '\0';
 
 	if (share){
-		if (check_one_sharer(c->scan))
+		if (check_one_sharer(c->scan) == 2)
 			return 1;
 	}
 
@@ -394,39 +395,73 @@ static int make_daemon(char *pidfile)
 	return -1;
 }
 
+/**
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

