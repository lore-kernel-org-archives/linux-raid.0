Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B22C7C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 23 Mar 2022 09:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbiCWJFm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Mar 2022 05:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiCWJFk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Mar 2022 05:05:40 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FA565CC
        for <linux-raid@vger.kernel.org>; Wed, 23 Mar 2022 02:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648026251; x=1679562251;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x3/ZjOyCJckv5yg0SXcJS7vV3hTMD9//G2Q578Rh56Q=;
  b=SAbzVoubTVrVazBPTlDiXldHXFx4HVUSmCMjhmtK4xze2Ih5GcSO1g2X
   d0wGTLgHonwNS7b/EFWLcJ/UliY5jPv2//isWlCV6JkFxFrZkX44Nm96Q
   YE/BF10+Cz9UXcXywYu8ZlYzUIXMfZrQ4mlLCan8uLyNrC7t9D8fvtsKW
   m9wqI442Xhyzfj9GLi+RjAD/75bWQZaxR1aUoHWBLErhHAHh2EW0WwmMx
   xx5bIkrazLK5TnhDq9djpbiqLQh0kvssBrXtMWrQzLftmMXHF8E/40FIu
   it5OFbeU/uCdqVXGQAH3Lubwcjo1w/V1IGwaAv04+Ms/oNi6k7Ib6sigd
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="240221871"
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="240221871"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 02:04:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="560808790"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga008.jf.intel.com with ESMTP; 23 Mar 2022 02:04:10 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     pmenzel@molgen.mpg.de, jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 1/2] Mdmonitor: Fix segfault
Date:   Wed, 23 Mar 2022 10:07:43 +0100
Message-Id: <20220323090744.26716-2-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220323090744.26716-1-kinga.tanska@intel.com>
References: <20220323090744.26716-1-kinga.tanska@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Check that devices passed to mdmonitor are md arrays.

Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Monitor.c | 11 ++++++++++-
 mdadm.h   |  1 +
 mdopen.c  | 17 +++++++++++++++++
 util.c    |  2 +-
 4 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index f5412299..0b24b656 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -183,6 +183,10 @@ int Monitor(struct mddev_dev *devlist,
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
@@ -204,7 +208,12 @@ int Monitor(struct mddev_dev *devlist,
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

