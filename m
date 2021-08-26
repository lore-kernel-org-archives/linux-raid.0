Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB040C432BE
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 09:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9C5460F45
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 09:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237918AbhHZJwe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Aug 2021 05:52:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:45719 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234666AbhHZJwd (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 26 Aug 2021 05:52:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="214582422"
X-IronPort-AV: E=Sophos;i="5.84,353,1620716400"; 
   d="scan'208";a="214582422"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 02:51:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,353,1620716400"; 
   d="scan'208";a="527813644"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.57])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Aug 2021 02:51:33 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] Incremental: Fix possible memory and resource leaks
Date:   Thu, 26 Aug 2021 11:40:40 +0200
Message-Id: <20210826094040.30118-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

map allocated through map_by_uuid() is not freed if mdfd is invalid.
It is also not freed at the end of Incremental_container().
In addition mdfd is not closed, and mdinfo list is not
freed too.
Fix it.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 Incremental.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index cd9cc0fc..6678739b 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1416,6 +1416,7 @@ restart:
 			}
 			sysfs_free(sra);
 		}
+		close(mdfd);
 	}
 	map_free(mapl);
 	return rv;
@@ -1499,6 +1500,7 @@ static int Incremental_container(struct supertype *st, char *devname,
 	}
 	for (ra = list ; ra ; ra = ra->next) {
 		int mdfd;
+		int doclose = 0;
 		char chosen_name[1024];
 		struct map_ent *mp;
 		struct mddev_ident *match = NULL;
@@ -1513,6 +1515,7 @@ static int Incremental_container(struct supertype *st, char *devname,
 
 		if (mp) {
 			mdfd = open_dev(mp->devnm);
+			doclose = 1;
 			if (mp->path)
 				strcpy(chosen_name, mp->path);
 			else
@@ -1572,22 +1575,30 @@ static int Incremental_container(struct supertype *st, char *devname,
 					    c->autof,
 					    trustworthy,
 					    chosen_name, 0);
+			doclose = 1;
 		}
-		if (only && (!mp || strcmp(mp->devnm, only) != 0))
-			continue;
 
 		if (mdfd < 0) {
 			pr_err("failed to open %s: %s.\n",
 				chosen_name, strerror(errno));
-			return 2;
+			rv = 2;
+			goto release;
+		}
+
+		if (only && (!mp || strcmp(mp->devnm, only) != 0)) {
+			if (doclose)
+				close(mdfd);
+			continue;
 		}
 
 		assemble_container_content(st, mdfd, ra, c,
 					   chosen_name, &result);
 		map_free(map);
 		map = NULL;
-		close(mdfd);
+		if (doclose)
+			close(mdfd);
 	}
+
 	if (c->export && result) {
 		char sep = '=';
 		printf("MD_STARTED");
@@ -1609,7 +1620,11 @@ static int Incremental_container(struct supertype *st, char *devname,
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
@@ -1701,7 +1716,7 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
 		return 1;
 	}
 	mdfd = open_dev_excl(ent->devnm);
-	if (mdfd > 0) {
+	if (mdfd >= 0) {
 		close(mdfd);
 		if (sysfs_get_str(&mdi, NULL, "array_state",
 				  buf, sizeof(buf)) > 0) {
-- 
2.26.2

