Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858B6C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 24 Nov 2021 10:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240713AbhKXLAS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Nov 2021 06:00:18 -0500
Received: from mga03.intel.com ([134.134.136.65]:43017 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231886AbhKXLAS (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 24 Nov 2021 06:00:18 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="235202695"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="235202695"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 02:57:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="457438329"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.57])
  by orsmga006.jf.intel.com with ESMTP; 24 Nov 2021 02:57:07 -0800
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] Incremental: Close unclosed mdfd in IncrementalScan()
Date:   Wed, 24 Nov 2021 11:45:30 +0100
Message-Id: <20211124104530.26592-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In addition to closing mdfd, propagate helpers to manage file
descriptors across IncrementalScan().

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 Incremental.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index cd9cc0fc..9cdd31f0 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1346,7 +1346,7 @@ restart:
 		}
 		mdfd = open_dev(me->devnm);
 
-		if (mdfd < 0)
+		if (!is_fd_valid(mdfd))
 			continue;
 		if (!isdigit(me->metadata[0])) {
 			/* must be a container */
@@ -1356,7 +1356,7 @@ restart:
 
 			if (st && st->ss->load_container)
 				ret = st->ss->load_container(st, mdfd, NULL);
-			close(mdfd);
+			close_fd(&mdfd);
 			if (!ret && st && st->ss->container_content) {
 				if (map_lock(&map))
 					pr_err("failed to get exclusive lock on mapfile\n");
@@ -1368,7 +1368,7 @@ restart:
 			continue;
 		}
 		if (md_array_active(mdfd)) {
-			close(mdfd);
+			close_fd(&mdfd);
 			continue;
 		}
 		/* Ok, we can try this one.   Maybe it needs a bitmap */
@@ -1385,9 +1385,9 @@ restart:
 			int bmfd;
 
 			bmfd = open(mddev->bitmap_file, O_RDWR);
-			if (bmfd >= 0) {
+			if (is_fd_valid(bmfd)) {
 				added = ioctl(mdfd, SET_BITMAP_FILE, bmfd);
-				close(bmfd);
+				close_fd(&bmfd);
 			}
 			if (c->verbose >= 0) {
 				if (added == 0)
@@ -1416,6 +1416,7 @@ restart:
 			}
 			sysfs_free(sra);
 		}
+		close_fd(&mdfd);
 	}
 	map_free(mapl);
 	return rv;
-- 
2.26.2

