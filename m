Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 871A6C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 24 Nov 2021 12:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243154AbhKXMUJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Nov 2021 07:20:09 -0500
Received: from mga14.intel.com ([192.55.52.115]:9428 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243321AbhKXMSJ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 24 Nov 2021 07:18:09 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="235501506"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="235501506"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 04:09:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="674839436"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.57])
  by orsmga005.jf.intel.com with ESMTP; 24 Nov 2021 04:09:56 -0800
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH v2] Incremental: Fix possible memory and resource leaks
Date:   Wed, 24 Nov 2021 12:58:19 +0100
Message-Id: <20211124115819.7568-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

map allocated through map_by_uuid() is not freed if mdfd is invalid.
In addition mdfd is not closed, and mdinfo list is not freed too.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 Incremental.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index cd9cc0fc..01554efc 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1498,7 +1498,7 @@ static int Incremental_container(struct supertype *st, char *devname,
 		return 0;
 	}
 	for (ra = list ; ra ; ra = ra->next) {
-		int mdfd;
+		int mdfd = -1;
 		char chosen_name[1024];
 		struct map_ent *mp;
 		struct mddev_ident *match = NULL;
@@ -1513,6 +1513,12 @@ static int Incremental_container(struct supertype *st, char *devname,
 
 		if (mp) {
 			mdfd = open_dev(mp->devnm);
+			if (!is_fd_valid(mdfd)) {
+				pr_err("failed to open %s: %s.\n",
+				       mp->devnm, strerror(errno));
+				rv = 2;
+				goto release;
+			}
 			if (mp->path)
 				strcpy(chosen_name, mp->path);
 			else
@@ -1572,21 +1578,25 @@ static int Incremental_container(struct supertype *st, char *devname,
 					    c->autof,
 					    trustworthy,
 					    chosen_name, 0);
+
+			if (!is_fd_valid(mdfd)) {
+				pr_err("create_mddev failed with chosen name %s: %s.\n",
+				       chosen_name, strerror(errno));
+				rv = 2;
+				goto release;
+			}
 		}
-		if (only && (!mp || strcmp(mp->devnm, only) != 0))
-			continue;
 
-		if (mdfd < 0) {
-			pr_err("failed to open %s: %s.\n",
-				chosen_name, strerror(errno));
-			return 2;
+		if (only && (!mp || strcmp(mp->devnm, only) != 0)) {
+			close_fd(&mdfd);
+			continue;
 		}
 
 		assemble_container_content(st, mdfd, ra, c,
 					   chosen_name, &result);
 		map_free(map);
 		map = NULL;
-		close(mdfd);
+		close_fd(&mdfd);
 	}
 	if (c->export && result) {
 		char sep = '=';
@@ -1609,7 +1619,11 @@ static int Incremental_container(struct supertype *st, char *devname,
 		}
 		printf("\n");
 	}
-	return 0;
+
+release:
+	map_free(map);
+	sysfs_free(list);
+	return rv;
 }
 
 static void run_udisks(char *arg1, char *arg2)
-- 
2.26.2

