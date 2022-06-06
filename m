Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F31C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  6 Jun 2022 10:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbiFFKOe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Jun 2022 06:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbiFFKOS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Jun 2022 06:14:18 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B96D133258
        for <linux-raid@vger.kernel.org>; Mon,  6 Jun 2022 03:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654510290; x=1686046290;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kM1cwh3kbV0HqDlgH5s7Pnc2onmq1byYL2sLWfBSlTM=;
  b=mtxIjMONppl024qNAa9b0hPFq6BBYVqerAj3yQBz9a8KTJyT32e0WIPa
   kgFnWiOytE24clFdc32pPlsKyFp74aA/9h37JvnXe9wBSzicZTBXRVgT8
   wC+9NuB7Ac4bw15/4I1bFNDVjp5eyseIiXu1Etca4zcwfnlf+6KNZy2EG
   YU3/zC6MdfVkwal/MicY66IVYTjAvB/Zg2QsTSi6co3F1mq0K1+VcVvq/
   Xe6Emmmw02MHBMfHb80hfIA2Iyc3OX5egCcan1ThfxxxdyvXKW69v2C8/
   BaX3N7i2reYv3i3MrSPt2clPGdYvtplKGu5GnwIFihSrI1IqSq0omyhXT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="274180200"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="274180200"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 03:11:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="682189052"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jun 2022 03:11:28 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, pmenzel@molgen.mpg.de
Subject: [PATCH v3 1/2] Mdmonitor: Fix segfault
Date:   Mon,  6 Jun 2022 12:17:14 +0200
Message-Id: <20220606101715.11433-2-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220606101715.11433-1-kinga.tanska@intel.com>
References: <20220606101715.11433-1-kinga.tanska@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Mdadm with "--monitor" parameter requires md device
as an argument to be monitored. If given argument is
not a md device, error shall be returned. Previously
it was not checked and invalid argument caused
segmentation fault. This commit adds checking
that devices passed to mdmonitor are md devices.

Change-Id: I6726aeeaa7b46fe8f46cbc6108f0406e0c756ad0
Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Monitor.c | 10 +++++++++-
 mdadm.h   |  1 +
 mdopen.c  | 17 +++++++++++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/Monitor.c b/Monitor.c
index f5412299..3d0c147a 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -183,6 +183,7 @@ int Monitor(struct mddev_dev *devlist,
 				continue;
 			if (strcasecmp(mdlist->devname, "<ignore>") == 0)
 				continue;
+
 			st = xcalloc(1, sizeof *st);
 			if (mdlist->devname[0] == '/')
 				st->devname = xstrdup(mdlist->devname);
@@ -191,6 +192,8 @@ int Monitor(struct mddev_dev *devlist,
 				strcpy(strcpy(st->devname, "/dev/md/"),
 				       mdlist->devname);
 			}
+			if (!is_mddev(mdlist->devname))
+				return 1;
 			st->next = statelist;
 			st->devnm[0] = 0;
 			st->percent = RESYNC_UNKNOWN;
@@ -204,7 +207,12 @@ int Monitor(struct mddev_dev *devlist,
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
-- 
2.26.2

