Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27547C05027
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 11:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjBBLqW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Feb 2023 06:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjBBLqT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Feb 2023 06:46:19 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A1B8C437
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 03:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675338379; x=1706874379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FqU6LNlOYBHHdeYukZxZIHyLDINjk0YHG9xLnXBKHhw=;
  b=kzDIHzjfIiymTwQqZt9uF9KbLeTq7yGQ4IdtTMRQM7WmxdECTTf83/2h
   in3/V7h5YIKTPv8mCxI4d0So0u440SEjyW+kh1hbMwgPOX+sDMrpYM9As
   toU7Y+4Wg+RyThpJGifhwGD2sg0zIgjEqUOzjvVdaWT+yop0Rpt369Ofj
   qrZ9cIt/M5qXokOQHpSMDTWBV8xsl7sfGTgHVnq1MfYm88Ah/JGLc5ekO
   4vSiJ+EkJ4qB8H8BE5MnlwvuOl4E0b3wz3XF7frwYLpgeWMIHgLbGQ0V9
   rzZRYBLcq4ka6UXyvq9pgA/Vrqdf6fN9HBLqg+yaiEiq3758zxyoJUa28
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="327075959"
X-IronPort-AV: E=Sophos;i="5.97,267,1669104000"; 
   d="scan'208";a="327075959"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 03:46:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="697661048"
X-IronPort-AV: E=Sophos;i="5.97,267,1669104000"; 
   d="scan'208";a="697661048"
Received: from unknown (HELO localhost.elements.local) ([10.102.104.85])
  by orsmga001.jf.intel.com with ESMTP; 02 Feb 2023 03:46:17 -0800
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH v3 5/8] Mdmonitor: Refactor write_autorebuild_pid()
Date:   Thu,  2 Feb 2023 12:27:03 +0100
Message-Id: <20230202112706.14228-6-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230202112706.14228-1-mateusz.grzonka@intel.com>
References: <20230202112706.14228-1-mateusz.grzonka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add better error handling and check for symlinks when opening MDMON_DIR.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 Monitor.c | 55 ++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 19 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 39598ba0..14a2dfe5 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -33,6 +33,7 @@
 #endif
 
 #define EVENT_NAME_MAX 32
+#define AUTOREBUILD_PID_PATH MDMON_DIR "/autorebuild.pid"
 
 struct state {
 	char devname[MD_NAME_MAX + sizeof("/dev/md/")];	/* length of "/dev/md/" + device name + terminating byte*/
@@ -126,7 +127,7 @@ static int check_udev_activity(void);
 static void link_containers_with_subarrays(struct state *list);
 static int make_daemon(char *pidfile);
 static void try_spare_migration(struct state *statelist);
-static void write_autorebuild_pid(void);
+static int write_autorebuild_pid(void);
 
 int Monitor(struct mddev_dev *devlist,
 	    char *mailaddr, char *alert_cmd,
@@ -234,7 +235,8 @@ int Monitor(struct mddev_dev *devlist,
 	}
 
 	if (share)
-		write_autorebuild_pid();
+		if (write_autorebuild_pid() != 0)
+			return 1;
 
 	if (devlist == NULL) {
 		mdlist = conf_get_ident(NULL);
@@ -440,29 +442,44 @@ static int check_one_sharer(int scan)
 	return 0;
 }
 
-static void write_autorebuild_pid()
+/*
+ * write_autorebuild_pid() - Writes pid to autorebuild.pid file.
+ *
+ * Return: 0 on success, 1 on error
+ */
+static int write_autorebuild_pid(void)
 {
-	char path[PATH_MAX];
-	int pid;
-	FILE *fp = NULL;
-	sprintf(path, "%s/autorebuild.pid", MDMON_DIR);
+	FILE *fp;
+	int fd;
 
 	if (mkdir(MDMON_DIR, 0700) < 0 && errno != EEXIST) {
-		pr_err("Can't create autorebuild.pid file\n");
-	} else {
-		int fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0700);
+		pr_err("%s: %s\n", strerror(errno), MDMON_DIR);
+		return 1;
+	}
 
-		if (fd >= 0)
-			fp = fdopen(fd, "w");
+	if (!is_directory(MDMON_DIR)) {
+		pr_err("%s is not a regular directory.\n", MDMON_DIR);
+		return 1;
+	}
 
-		if (!fp)
-			pr_err("Can't create autorebuild.pid file\n");
-		else {
-			pid = getpid();
-			fprintf(fp, "%d\n", pid);
-			fclose(fp);
-		}
+	fd = open(AUTOREBUILD_PID_PATH, O_WRONLY | O_CREAT | O_TRUNC, 0700);
+
+	if (fd < 0) {
+		pr_err("Error opening %s file.\n", AUTOREBUILD_PID_PATH);
+		return 1;
 	}
+
+	fp = fdopen(fd, "w");
+
+	if (!fp) {
+		pr_err("Error opening fd for %s file.\n", AUTOREBUILD_PID_PATH);
+		return 1;
+	}
+
+	fprintf(fp, "%d\n", getpid());
+
+	fclose(fp);
+	return 0;
 }
 
 #define BASE_MESSAGE "%s event detected on md device %s"
-- 
2.26.2

