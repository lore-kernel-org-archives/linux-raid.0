Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F56AC433F5
	for <linux-raid@archiver.kernel.org>; Tue,  5 Apr 2022 12:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbiDEMqC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Apr 2022 08:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384311AbiDEM1U (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Apr 2022 08:27:20 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74A9FABDE
        for <linux-raid@vger.kernel.org>; Tue,  5 Apr 2022 04:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649158619; x=1680694619;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pcFYbhpebI7S7ghvtQ7ITGHEFuo1n3zZcPNeOcLqqmQ=;
  b=R7Q450CUYbmZwSypsgDa5dOqmWDpBsvyHCguToUIwxWzMygBgeLK3LxA
   OHNf8nNcAv4ROGFBK4DC80Y6695/cjoHCaGRaOz9BQbNaz6Y0HKFLCIGN
   uPK8R3jsYiVKkJBBn0h8wYzqxMDn7VEKY+zVBfkHseuG+vdHG90E92lBZ
   +MnF5VCshG2QlvMxZq09OZhn4anrhn1sTrFLlrYBm5SoimZQBK8dQBJDo
   SjpdmLNUFSk7/Fi3Wyt2zNKLA+aTPcDqT0GZanvgNS+xxQqZdM3JObc7F
   PlugSkuWcRWVKzvdEKbOzXYz9WtVRtHKQlHwNlFuLHd0w6UM6wla7U7ml
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="241313837"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="241313837"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 04:36:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="569845810"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga008.jf.intel.com with ESMTP; 05 Apr 2022 04:36:58 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, pmenzel@molgen.mpg.de
Subject: [PATCH v2 1/2] Mdmonitor: Fix segfault
Date:   Tue,  5 Apr 2022 13:40:56 +0200
Message-Id: <20220405114057.27080-2-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220405114057.27080-1-kinga.tanska@intel.com>
References: <20220405114057.27080-1-kinga.tanska@intel.com>
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

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
---
 Monitor.c | 11 ++++++++++-
 mdadm.h   |  1 +
 mdopen.c  | 17 +++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

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
-- 
2.26.2

