Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3292C43460
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 14:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9189B601FC
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 14:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240268AbhEQOus (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 May 2021 10:50:48 -0400
Received: from mga05.intel.com ([192.55.52.43]:44171 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241487AbhEQOsJ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 17 May 2021 10:48:09 -0400
IronPort-SDR: LPQyW0SZcDHmH3FlvjSM1g9qLTzfuxgap++REDNKvQTwC76ao1o+RZpAq4mhQIpnqKFM7hZ+kY
 SE4mcmamHGqw==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="286009471"
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="286009471"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 07:39:30 -0700
IronPort-SDR: +8WA5ZanaC6tYU3/yoX6Horuk7OnwwLYjmSPMsTDEdrgIplBYz0NCBE8naOTvQhU/3N0bTpBs2
 tTO4OiiZsTFg==
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="472432949"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 07:39:29 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 4/4] Manage: Call validate_geometry when adding drive to external container
Date:   Mon, 17 May 2021 16:39:03 +0200
Message-Id: <20210517143903.10077-5-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210517143903.10077-1-mariusz.tkaczyk@linux.intel.com>
References: <20210517143903.10077-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When adding drive to container call validate_geometry to verify whether
drive is supported and can be addded to container.

Remove unused parameters from validate_geometry_imsm_container().
There is no need to pass them.
Don't calculate freesize if it is not mandatory. Make it configurable.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Manage.c      |  7 +++++++
 super-ddf.c   |  9 +++++----
 super-intel.c | 19 +++++++------------
 3 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/Manage.c b/Manage.c
index 0a5f09b..f789e0c 100644
--- a/Manage.c
+++ b/Manage.c
@@ -992,6 +992,13 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			return -1;
 		}
 
+		/* Check if metadata handler is able to accept the drive */
+		if (!tst->ss->validate_geometry(tst, LEVEL_CONTAINER, 0, 1, NULL,
+		    0, 0, dv->devname, NULL, 0, 1)) {
+			close(container_fd);
+			return -1;
+		}
+
 		Kill(dv->devname, NULL, 0, -1, 0);
 		dfd = dev_open(dv->devname, O_RDWR | O_EXCL|O_DIRECT);
 		if (tst->ss->add_to_super(tst, &disc, dfd,
diff --git a/super-ddf.c b/super-ddf.c
index 2314762..80a40f8 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3475,10 +3475,11 @@ validate_geometry_ddf_container(struct supertype *st,
 		return 0;
 	}
 	close(fd);
-
-	*freesize = avail_size_ddf(st, ldsize >> 9, INVALID_SECTORS);
-	if (*freesize == 0)
-		return 0;
+	if (freesize) {
+		*freesize = avail_size_ddf(st, ldsize >> 9, INVALID_SECTORS);
+		if (*freesize == 0)
+			return 0;
+	}
 
 	return 1;
 }
diff --git a/super-intel.c b/super-intel.c
index fdcefb6..fe45d93 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6652,8 +6652,7 @@ static int store_super_imsm(struct supertype *st, int fd)
 }
 
 static int validate_geometry_imsm_container(struct supertype *st, int level,
-					    int layout, int raiddisks, int chunk,
-					    unsigned long long size,
+					    int raiddisks,
 					    unsigned long long data_offset,
 					    char *dev,
 					    unsigned long long *freesize,
@@ -6725,8 +6724,8 @@ static int validate_geometry_imsm_container(struct supertype *st, int level,
 			}
 		}
 	}
-
-	*freesize = avail_size_imsm(st, ldsize >> 9, data_offset);
+	if (freesize)
+		*freesize = avail_size_imsm(st, ldsize >> 9, data_offset);
 	rv = 1;
 exit:
 	if (super)
@@ -7586,15 +7585,11 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 	 * if given unused devices create a container
 	 * if given given devices in a container create a member volume
 	 */
-	if (level == LEVEL_CONTAINER) {
+	if (level == LEVEL_CONTAINER)
 		/* Must be a fresh device to add to a container */
-		return validate_geometry_imsm_container(st, level, layout,
-							raiddisks,
-							*chunk,
-							size, data_offset,
-							dev, freesize,
-							verbose);
-	}
+		return validate_geometry_imsm_container(st, level, raiddisks,
+							data_offset, dev,
+							freesize, verbose);
 
 	/*
 	 * Size is given in sectors.
-- 
2.26.2

