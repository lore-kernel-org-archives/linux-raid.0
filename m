Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D40C4C4320A
	for <linux-raid@archiver.kernel.org>; Tue, 27 Jul 2021 08:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC54B60FC1
	for <linux-raid@archiver.kernel.org>; Tue, 27 Jul 2021 08:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbhG0IfT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 27 Jul 2021 04:35:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:23282 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235913AbhG0IfS (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 27 Jul 2021 04:35:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10057"; a="212386408"
X-IronPort-AV: E=Sophos;i="5.84,272,1620716400"; 
   d="scan'208";a="212386408"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2021 01:35:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,272,1620716400"; 
   d="scan'208";a="662538559"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.57])
  by fmsmga006.fm.intel.com with ESMTP; 27 Jul 2021 01:35:17 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] Fix memory leak after "mdadm --detail"
Date:   Tue, 27 Jul 2021 10:25:18 +0200
Message-Id: <20210727082518.10737-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 Detail.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/Detail.c b/Detail.c
index ad56344f..d3af0ab5 100644
--- a/Detail.c
+++ b/Detail.c
@@ -66,11 +66,11 @@ int Detail(char *dev, struct context *c)
 	int spares = 0;
 	struct stat stb;
 	int failed = 0;
-	struct supertype *st;
+	struct supertype *st = NULL;
 	char *subarray = NULL;
 	int max_disks = MD_SB_DISKS; /* just a default */
 	struct mdinfo *info = NULL;
-	struct mdinfo *sra;
+	struct mdinfo *sra = NULL;
 	struct mdinfo *subdev;
 	char *member = NULL;
 	char *container = NULL;
@@ -93,8 +93,7 @@ int Detail(char *dev, struct context *c)
 	if (!sra) {
 		if (md_get_array_info(fd, &array)) {
 			pr_err("%s does not appear to be an md device\n", dev);
-			close(fd);
-			return rv;
+			goto out;
 		}
 	}
 	external = (sra != NULL && sra->array.major_version == -1 &&
@@ -108,16 +107,13 @@ int Detail(char *dev, struct context *c)
 			    sra->devs == NULL) {
 				pr_err("Array associated with md device %s does not exist.\n",
 				       dev);
-				close(fd);
-				sysfs_free(sra);
-				return rv;
+				goto out;
 			}
 			array = sra->array;
 		} else {
 			pr_err("cannot get array detail for %s: %s\n",
 			       dev, strerror(errno));
-			close(fd);
-			return rv;
+			goto out;
 		}
 	}
 
@@ -827,10 +823,12 @@ out:
 	close(fd);
 	free(subarray);
 	free(avail);
-	for (d = 0; d < n_devices; d++)
-		free(devices[d]);
+	if (devices)
+		for (d = 0; d < n_devices; d++)
+			free(devices[d]);
 	free(devices);
 	sysfs_free(sra);
+	free(st);
 	return rv;
 }
 
-- 
2.26.2

