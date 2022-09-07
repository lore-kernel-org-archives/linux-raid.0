Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6CEC38145
	for <linux-raid@archiver.kernel.org>; Wed,  7 Sep 2022 13:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiIGNPB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Sep 2022 09:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiIGNOn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Sep 2022 09:14:43 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE5C12745
        for <linux-raid@vger.kernel.org>; Wed,  7 Sep 2022 06:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662556470; x=1694092470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q0jtphc85zOexzPM2Hj4KDwB3asV13mPiqefF7KT0XY=;
  b=CP+NDp8UZF7dzZ7vBIkFn/9U/SH2EEOBMmU4Y2L6541vfSTZC28Lzxn3
   KryzApPuesTg7JhfgPFug3SxA9TOuT3uSrQpymOD5KvxWoIHdR+Egtfl3
   cDbYhFoCLASbY1uat1CRLnhypZyWr9jvLhBBpat2nWfJWJ6h7rNMRd8g8
   MnatpQLzi3GQWx7xA8KQ3Gp+aSJ/9mwLyimgfTGkLmoA8dl0H3ZCmufyg
   x0Y/n3VtSG950S8jiFePqJAKKiZBC2TnpfGLm8u0QGzpUIGiWEolbfX7n
   3kzVQrnUguGv7jNBfRtOpbFJKJdSOZCkhgcwfN5j8/Dv42BEj3deyc0S8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="296865382"
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="296865382"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 06:14:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="644608657"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.105.50])
  by orsmga008.jf.intel.com with ESMTP; 07 Sep 2022 06:14:28 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH 6/9] Mdmonitor: Refactor write_autorebuild_pid()
Date:   Wed,  7 Sep 2022 14:56:54 +0200
Message-Id: <20220907125657.12192-7-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220907125657.12192-1-mateusz.grzonka@intel.com>
References: <20220907125657.12192-1-mateusz.grzonka@intel.com>
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
index 80e43ebe..3e09f2a2 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -33,6 +33,7 @@
 #endif
 
 #define EVENT_NAME_MAX 32
+#define AUTOREBUILD_PID_PATH MDMON_DIR "/autorebuild.pid"
 
 struct state {
 	char *devname;
@@ -123,7 +124,7 @@ static int check_udev_activity(void);
 static void link_containers_with_subarrays(struct state *list);
 static int make_daemon(char *pidfile);
 static void try_spare_migration(struct state *statelist);
-static void write_autorebuild_pid(void);
+static int write_autorebuild_pid(void);
 
 int Monitor(struct mddev_dev *devlist,
 	    char *mailaddr, char *alert_cmd,
@@ -224,7 +225,8 @@ int Monitor(struct mddev_dev *devlist,
 	}
 
 	if (share)
-		write_autorebuild_pid();
+		if (write_autorebuild_pid() != 0)
+			return 1;
 
 	if (devlist == NULL) {
 		mdlist = conf_get_ident(NULL);
@@ -428,29 +430,44 @@ static int check_one_sharer(int scan)
 	return 0;
 }
 
-static void write_autorebuild_pid()
+/**
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

