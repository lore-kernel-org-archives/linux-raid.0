Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7ADC43334
	for <linux-raid@archiver.kernel.org>; Mon, 13 Jun 2022 10:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244210AbiFMKto (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Jun 2022 06:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346824AbiFMKsr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Jun 2022 06:48:47 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D0B2CCB0
        for <linux-raid@vger.kernel.org>; Mon, 13 Jun 2022 03:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655115978; x=1686651978;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ka6n3dD6J4wp8dvsbkha0Oa5bfE4WNgyzsx1QY6ZzeQ=;
  b=DfF+pXfwfy8GVwChySok8uNebxAaCgP8svOpGbbjCL5aB1TvWwB9tEjI
   xExbqTLuPHkPPTdU1mpj1sEESJKgyvM/R7NSNm6KGs8u8Lcp/b6sr3/ug
   A81wmobZDg87QurQwio2/Q0fHmp6c/SfpUXCKId+pXWi+pu1tl97iGbQa
   iS7mPe79coRk/UOicPXIeJY0jX4COUWO/Q630Cxr16yIBquIvUNMrfLyy
   H/GJwXde0MO8Bg7UFKnse6eamX1qqxuuvF7s3wse9tr04tJmhdDF+qgr7
   OYXp7yGoefQaurohAdRkgN/EFC3+m06dYVQGuHPXuIKGL0Oi1KBwLT/Ob
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="261274689"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="261274689"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 03:26:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="685963129"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.57])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jun 2022 03:26:16 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH v2 resend] Incremental: Fix possible memory and resource leaks
Date:   Mon, 13 Jun 2022 12:11:25 +0200
Message-Id: <20220613101125.20593-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

map allocated through map_by_uuid() is not freed if mdfd is invalid.
In addition mdfd is not closed, and mdinfo list is not freed too.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
Change-Id: I25e726f0e2502cf7e8ce80c2bd7944b3b1e2b9dc
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

