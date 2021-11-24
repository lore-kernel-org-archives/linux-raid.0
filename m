Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0772FC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 24 Nov 2021 11:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbhKXLD0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Nov 2021 06:03:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:61084 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231610AbhKXLDZ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 24 Nov 2021 06:03:25 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="232750857"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="232750857"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 03:00:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="457439023"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.57])
  by orsmga006.jf.intel.com with ESMTP; 24 Nov 2021 03:00:14 -0800
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] Correct checking if file descriptors are valid
Date:   Wed, 24 Nov 2021 11:48:33 +0100
Message-Id: <20211124104833.27368-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In some cases file descriptors equal to 0 are treated as invalid.
Fix it.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 Assemble.c    | 3 +--
 Grow.c        | 5 +----
 Incremental.c | 4 ++--
 mdadm.c       | 3 +--
 super-ddf.c   | 2 +-
 5 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 20fd97b5..704b8293 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -569,8 +569,7 @@ static int select_devices(struct mddev_dev *devlist,
 				if (dfd < 0 ||
 				    st->ss->load_super(st, dfd, NULL))
 					tmpdev->used = 2;
-				if (dfd > 0)
-					close(dfd);
+				close_fd(&dfd);
 			}
 		}
 
diff --git a/Grow.c b/Grow.c
index 70f26c7e..9c6fc95e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2334,10 +2334,7 @@ size_change_error:
 		 * number of devices (On-Line Capacity Expansion) must be
 		 * performed at the level of the container
 		 */
-		if (fd > 0) {
-			close(fd);
-			fd = -1;
-		}
+		close_fd(&fd);
 		rv = reshape_container(container, devname, -1, st, &info,
 				       c->force, c->backup_file, c->verbose,
 				       0, 0, 0);
diff --git a/Incremental.c b/Incremental.c
index cd9cc0fc..d28925d6 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1701,8 +1701,8 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
 		return 1;
 	}
 	mdfd = open_dev_excl(ent->devnm);
-	if (mdfd > 0) {
-		close(mdfd);
+	if (is_fd_valid(mdfd)) {
+		close_fd(&mdfd);
 		if (sysfs_get_str(&mdi, NULL, "array_state",
 				  buf, sizeof(buf)) > 0) {
 			if (strncmp(buf, "active", 6) == 0 ||
diff --git a/mdadm.c b/mdadm.c
index a31ab99c..91e67467 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1770,8 +1770,7 @@ int main(int argc, char *argv[])
 	}
 	if (locked)
 		cluster_release_dlmlock();
-	if (mdfd > 0)
-		close(mdfd);
+	close_fd(&mdfd);
 	exit(rv);
 }
 
diff --git a/super-ddf.c b/super-ddf.c
index d334a79d..3f304cdc 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4914,7 +4914,7 @@ static int raid10_degraded(struct mdinfo *info)
 			pr_err("BUG: invalid raid disk\n");
 			goto out;
 		}
-		if (d->state_fd > 0)
+		if (is_fd_valid(d->state_fd))
 			found[i]++;
 	}
 	ret = 2;
-- 
2.26.2

