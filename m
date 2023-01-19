Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC38C6379F
	for <linux-raid@archiver.kernel.org>; Thu, 19 Jan 2023 13:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbjASNzO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Jan 2023 08:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjASNyp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Jan 2023 08:54:45 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2A34FAE3
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 05:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674136484; x=1705672484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FqU6LNlOYBHHdeYukZxZIHyLDINjk0YHG9xLnXBKHhw=;
  b=KAIuQD2M77co66k2qh1FuZgdqurGSr62X9eGleXcCTgbr0hOMr1Hrngb
   Y/B3DrjwyvH1QJCpxRiAylVIAdKmXoJBEF0PZDI/SHSMFOuu1+qoZGNkX
   UTBMiY5p/3m/+WCBZs0C1glkH9zyZe3pxNIca90CKjWGJiYsd+9Rwn6FC
   rDxv4fJhu51fgFvoHFTbaud84IHrxTTRbHA1DrW8CNufmPYK7AopKmaDF
   msfcDUXJMDWIoXEmufg40HfEWAXc75bMLM/4l1X04h5KUyhb6ipwy9Kgi
   0h8bScIohB8hQjvV+wKMMeYGUgD41EXTa4V16ht/hUnRPjvsormHG8O2C
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="305657224"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="305657224"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 05:54:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="905520396"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="905520396"
Received: from unknown (HELO localhost.elements.local) ([10.102.104.85])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jan 2023 05:54:43 -0800
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH v2 5/8] Mdmonitor: Refactor write_autorebuild_pid()
Date:   Thu, 19 Jan 2023 14:35:43 +0100
Message-Id: <20230119133546.13334-5-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230119133546.13334-1-mateusz.grzonka@intel.com>
References: <20230119133546.13334-1-mateusz.grzonka@intel.com>
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

