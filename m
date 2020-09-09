Return-Path: <SRS0=aYZJ=CS=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDBB3C43461
	for <linux-raid@archiver.kernel.org>; Wed,  9 Sep 2020 08:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C1CD21532
	for <linux-raid@archiver.kernel.org>; Wed,  9 Sep 2020 08:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgIIIb5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Sep 2020 04:31:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:56811 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgIIIbx (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 9 Sep 2020 04:31:53 -0400
IronPort-SDR: IXjaqj+OM11VBz9RNu5Y/8Fh0wbjYq0/MiyfXs3qXxrdWsRTuOQ+Jvob0jxo31Ct6N6lQiwI8O
 fPFpO78a4wEw==
X-IronPort-AV: E=McAfee;i="6000,8403,9738"; a="155692161"
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="155692161"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 01:31:51 -0700
IronPort-SDR: Yd5uyrPGWgYHyr43rkIHdsFy38KyU3ka94mW62VQCY9CkmLwOSv5zzgwqHN2rjiqbbwcvBxYPX
 m6ca2TFMJoAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="449119056"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga004.jf.intel.com with ESMTP; 09 Sep 2020 01:31:50 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 4/4] Check if other Monitor instance running before fork.
Date:   Wed,  9 Sep 2020 10:31:20 +0200
Message-Id: <20200909083120.10396-5-mariusz.tkaczyk@intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200909083120.10396-1-mariusz.tkaczyk@intel.com>
References: <20200909083120.10396-1-mariusz.tkaczyk@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Blazej Kucman <blazej.kucman@intel.com>

Make error message visible to the user.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 Monitor.c | 44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 0fb4f77d..7fd48084 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -63,6 +63,7 @@ struct alert_info {
 };
 static int make_daemon(char *pidfile);
 static int check_one_sharer(int scan);
+static void write_autorebuild_pid(void);
 static void alert(char *event, char *dev, char *disc, struct alert_info *info);
 static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		       int test, struct alert_info *info,
@@ -153,6 +154,11 @@ int Monitor(struct mddev_dev *devlist,
 	info.mailfrom = mailfrom;
 	info.dosyslog = dosyslog;
 
+	if (share){
+		if (check_one_sharer(c->scan))
+			return 1;
+	}
+
 	if (daemonise) {
 		int rv = make_daemon(pidfile);
 		if (rv >= 0)
@@ -160,8 +166,7 @@ int Monitor(struct mddev_dev *devlist,
 	}
 
 	if (share)
-		if (check_one_sharer(c->scan))
-			return 1;
+		write_autorebuild_pid();
 
 	if (devlist == NULL) {
 		mdlist = conf_get_ident(NULL);
@@ -328,8 +333,8 @@ static int check_one_sharer(int scan)
 	int pid;
 	FILE *comm_fp;
 	FILE *fp;
-	char comm_path[100];
-	char path[100];
+	char comm_path[PATH_MAX];
+	char path[PATH_MAX];
 	char comm[20];
 
 	sprintf(path, "%s/autorebuild.pid", MDMON_DIR);
@@ -356,21 +361,28 @@ static int check_one_sharer(int scan)
 		}
 		fclose(fp);
 	}
-	if (scan) {
-		if (mkdir(MDMON_DIR, S_IRWXU) < 0 && errno != EEXIST) {
+	return 0;
+}
+
+static void write_autorebuild_pid()
+{
+	char path[PATH_MAX];
+	int pid;
+	FILE *fp;
+	sprintf(path, "%s/autorebuild.pid", MDMON_DIR);
+
+	if (mkdir(MDMON_DIR, S_IRWXU) < 0 && errno != EEXIST) {
+		pr_err("Can't create autorebuild.pid file\n");
+	} else {
+		fp = fopen(path, "w");
+		if (!fp)
 			pr_err("Can't create autorebuild.pid file\n");
-		} else {
-			fp = fopen(path, "w");
-			if (!fp)
-				pr_err("Cannot create autorebuild.pidfile\n");
-			else {
-				pid = getpid();
-				fprintf(fp, "%d\n", pid);
-				fclose(fp);
-			}
+		else {
+			pid = getpid();
+			fprintf(fp, "%d\n", pid);
+			fclose(fp);
 		}
 	}
-	return 0;
 }
 
 static void alert(char *event, char *dev, char *disc, struct alert_info *info)
-- 
2.25.0

