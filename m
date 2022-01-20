Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067CBC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 20 Jan 2022 12:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242382AbiATMa3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Jan 2022 07:30:29 -0500
Received: from mga07.intel.com ([134.134.136.100]:62801 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232606AbiATMa3 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Jan 2022 07:30:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642681829; x=1674217829;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n6OcYj1V8RD9Ie+lh2zLjrW3Sv1/WvMJhf4uHfVR10Q=;
  b=hTB/QJoWA79M4QiLR50M+CKEssBdNqLRDnpbe1aHYvYUQ3JwlPsgH7aG
   fA+kCpNcdwwjs553oo+jZIxIi0B1aTD9Xyn/gSsvBkFugPfWD2bsBkWNM
   ZF6kCMgWxU9BuJyfjIFlJIpiVBDbyuykWs0VtYgkXes2CDBrIKMCyv2mF
   sqMD0WC0Cljyj1UF1QXmxRuhDqABtYly5QOFrK79xcJAQ8OQ1Lk3D+183
   IeJU9LCz1r9eAyimFD4VV+5D3jUe2BOjKfKEpuljkPjj4MfhK4ieHXzP8
   66cAQ4+PXoJgbYdkHzvd7rmCI/x7wnilLsUwewabt7fzACBlXf9wA9xa3
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10232"; a="308680233"
X-IronPort-AV: E=Sophos;i="5.88,302,1635231600"; 
   d="scan'208";a="308680233"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 04:30:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,302,1635231600"; 
   d="scan'208";a="518595265"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga007.jf.intel.com with ESMTP; 20 Jan 2022 04:30:27 -0800
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] Mdmonitor: Fix segfault and improve logging
Date:   Thu, 20 Jan 2022 13:32:13 +0100
Message-Id: <20220120123213.17891-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>

Check that devices passed to mdmonitor are md arrays.
Also, change logging, so mdmonitor in verbose mode will report its
configuration.

Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Monitor.c | 36 ++++++++++++++++++++++++------------
 mdadm.h   |  1 +
 mdopen.c  | 17 +++++++++++++++++
 util.c    |  2 +-
 4 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index f5412299..bd417d04 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -137,24 +137,27 @@ int Monitor(struct mddev_dev *devlist,
 	struct mddev_ident *mdlist;
 	int delay_for_event = c->delay;
 
-	if (!mailaddr) {
+	if (!mailaddr)
 		mailaddr = conf_get_mailaddr();
-		if (mailaddr && ! c->scan)
-			pr_err("Monitor using email address \"%s\" from config file\n",
-			       mailaddr);
-	}
-	mailfrom = conf_get_mailfrom();
 
-	if (!alert_cmd) {
+	if (!alert_cmd)
 		alert_cmd = conf_get_program();
-		if (alert_cmd && !c->scan)
-			pr_err("Monitor using program \"%s\" from config file\n",
-			       alert_cmd);
-	}
+
+	mailfrom = conf_get_mailfrom();
+
 	if (c->scan && !mailaddr && !alert_cmd && !dosyslog) {
 		pr_err("No mail address or alert command - not monitoring.\n");
 		return 1;
 	}
+
+	if (c->verbose) {
+		pr_err("Monitor is started with delay %ds\n", c->delay);
+		if (mailaddr)
+			pr_err("Monitor using email address %s\n", mailaddr);
+		if (alert_cmd)
+			pr_err("Monitor using program %s\n", alert_cmd);
+	}
+
 	info.alert_cmd = alert_cmd;
 	info.mailaddr = mailaddr;
 	info.mailfrom = mailfrom;
@@ -183,6 +186,10 @@ int Monitor(struct mddev_dev *devlist,
 				continue;
 			if (strcasecmp(mdlist->devname, "<ignore>") == 0)
 				continue;
+
+			if (!is_mddev(mdlist->devname))
+				return 1;
+
 			st = xcalloc(1, sizeof *st);
 			if (mdlist->devname[0] == '/')
 				st->devname = xstrdup(mdlist->devname);
@@ -204,7 +211,12 @@ int Monitor(struct mddev_dev *devlist,
 		struct mddev_dev *dv;
 
 		for (dv = devlist; dv; dv = dv->next) {
-			struct state *st = xcalloc(1, sizeof *st);
+			struct state *st;
+
+			if (!is_mddev(dv->devname))
+				return 1;
+
+			st = xcalloc(1, sizeof *st);
 			mdlist = conf_get_ident(dv->devname);
 			st->devname = xstrdup(dv->devname);
 			st->next = statelist;
diff --git a/mdadm.h b/mdadm.h
index 8f8841d8..03151c34 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1607,6 +1607,7 @@ extern int create_mddev(char *dev, char *name, int autof, int trustworthy,
 #define	FOREIGN	2
 #define	METADATA 3
 extern int open_mddev(char *dev, int report_errors);
+extern int is_mddev(char *dev);
 extern int open_container(int fd);
 extern int metadata_container_matches(char *metadata, char *devnm);
 extern int metadata_subdev_matches(char *metadata, char *devnm);
diff --git a/mdopen.c b/mdopen.c
index 245be537..d18c9319 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -475,6 +475,23 @@ int open_mddev(char *dev, int report_errors)
 	return mdfd;
 }
 
+/**
+ * is_mddev() - check that file name passed is an md device.
+ * @dev: file name that has to be checked.
+ * Return: 1 if file passed is an md device, 0 if not.
+ */
+int is_mddev(char *dev)
+{
+	int fd = open_mddev(dev, 1);
+
+	if (fd >= 0) {
+		close(fd);
+		return 1;
+	}
+
+	return 0;
+}
+
 char *find_free_devnm(int use_partitions)
 {
 	static char devnm[32];
diff --git a/util.c b/util.c
index cdf1da24..003b2f86 100644
--- a/util.c
+++ b/util.c
@@ -268,7 +268,7 @@ int md_array_active(int fd)
 		 * GET_ARRAY_INFO doesn't provide access to the proper state
 		 * information, so fallback to a basic check for raid_disks != 0
 		 */
-		ret = ioctl(fd, GET_ARRAY_INFO, &array);
+		ret = md_get_array_info(fd, &array);
 	}
 
 	return !ret;
-- 
2.26.2

