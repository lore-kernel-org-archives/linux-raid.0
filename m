Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AABFECAAD1
	for <linux-raid@archiver.kernel.org>; Thu,  1 Sep 2022 09:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbiIAJVP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Sep 2022 05:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbiIAJVO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Sep 2022 05:21:14 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44005124860
        for <linux-raid@vger.kernel.org>; Thu,  1 Sep 2022 02:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662024073; x=1693560073;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LnQkYzQY6oGUoHrCLac8d5mNN4XvfuImU6Q5XQVSi5M=;
  b=iMx0YWTe0p5K2G1rdgv/C/tjaU6h+R6qDIdQmiXSbR8MiJ+h3z0OSFN/
   AqhSCBtr8zkh3d15y9sWJAq5ZtmTJOSRyvGs9Br2xO2pGIpaBh2/Q9JI7
   9TFxvkZqZCkhuMNDkclfwCIn6oxYSvuG1uyCOYjLtWxhbqAXlyxdxa1eS
   EaXUUu3VsyVKmLTP+ic7bD/EtUBoirAqfa1b0QDc0GU7EorX8nPfZnIZM
   GwW2ronIJe2B6sGGRwsVWfS+jcV0XPS5N7o0HOrnwbzgsPQLkqhblFPFk
   9B49Oy1t6VA7gCFf3mFijDNWYiaLEgeZClBlHU9T+i120NTtSZRX/j0Kq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="278683702"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="278683702"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 02:21:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="738427986"
Received: from gklab-154-222.elements.local ([10.102.102.222])
  by orsmga004.jf.intel.com with ESMTP; 01 Sep 2022 02:21:11 -0700
From:   Pawel Baldysiak <pawel.baldysiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 1/1] Monitor: Fix statelist memory leaks
Date:   Thu,  1 Sep 2022 11:20:31 +0200
Message-Id: <20220901092031.3274605-1-pawel.baldysiak@intel.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Free statelist in error path in Monitor initialization.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 Monitor.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 93f36ac0..b4e954c6 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -74,6 +74,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 			  int test, struct alert_info *info);
 static void try_spare_migration(struct state *statelist, struct alert_info *info);
 static void link_containers_with_subarrays(struct state *list);
+static void free_statelist(struct state *statelist);
 #ifndef NO_LIBUDEV
 static int check_udev_activity(void);
 #endif
@@ -128,7 +129,6 @@ int Monitor(struct mddev_dev *devlist,
 	 */
 
 	struct state *statelist = NULL;
-	struct state *st2;
 	int finished = 0;
 	struct mdstat_ent *mdstat = NULL;
 	char *mailfrom;
@@ -185,12 +185,14 @@ int Monitor(struct mddev_dev *devlist,
 				continue;
 			if (strcasecmp(mdlist->devname, "<ignore>") == 0)
 				continue;
+			if (!is_mddev(mdlist->devname)) {
+				free_statelist(statelist);
+				return 1;
+			}
 
 			st = xcalloc(1, sizeof *st);
 			snprintf(st->devname, MD_NAME_MAX + sizeof("/dev/md/"),
 				 "/dev/md/%s", basename(mdlist->devname));
-			if (!is_mddev(mdlist->devname))
-				return 1;
 			st->next = statelist;
 			st->devnm[0] = 0;
 			st->percent = RESYNC_UNKNOWN;
@@ -206,8 +208,10 @@ int Monitor(struct mddev_dev *devlist,
 		for (dv = devlist; dv; dv = dv->next) {
 			struct state *st;
 
-			if (!is_mddev(dv->devname))
+			if (!is_mddev(dv->devname)) {
+				free_statelist(statelist);
 				return 1;
+			}
 
 			st = xcalloc(1, sizeof *st);
 			mdlist = conf_get_ident(dv->devname);
@@ -294,16 +298,16 @@ int Monitor(struct mddev_dev *devlist,
 		for (stp = &statelist; (st = *stp) != NULL; ) {
 			if (st->from_auto && st->err > 5) {
 				*stp = st->next;
-				free(st->spare_group);
+				if (st->spare_group)
+					free(st->spare_group);
+
 				free(st);
 			} else
 				stp = &st->next;
 		}
 	}
-	for (st2 = statelist; st2; st2 = statelist) {
-		statelist = st2->next;
-		free(st2);
-	}
+
+	free_statelist(statelist);
 
 	if (pidfile)
 		unlink(pidfile);
@@ -1056,6 +1060,24 @@ static void link_containers_with_subarrays(struct state *list)
 				}
 }
 
+/**
+ * free_statelist() - Frees statelist.
+ * @statelist: statelist to free
+ */
+static void free_statelist(struct state *statelist)
+{
+	struct state *tmp = NULL;
+
+	while (statelist) {
+		if (statelist->spare_group)
+			free(statelist->spare_group);
+
+		tmp = statelist;
+		statelist = statelist->next;
+		free(tmp);
+	}
+}
+
 #ifndef NO_LIBUDEV
 /* function: check_udev_activity
  * Description: Function waits for udev to finish
-- 
2.25.4

