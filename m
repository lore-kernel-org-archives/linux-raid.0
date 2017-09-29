From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 1/2] raid5-ppl: don't resync after rebuild
Date: Fri, 29 Sep 2017 22:54:18 +0200
Message-ID: <20170929205419.16715-2-artur.paszkiewicz@intel.com>
References: <20170929205419.16715-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170929205419.16715-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

The check for degraded array is unnecessary and causes a resync to be
performed after ppl recovery and rebuild when restarting an array during
rebuilding after unclean shutdown.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5-ppl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index a98ef172f8e8..2c6513777f68 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -1296,8 +1296,7 @@ int ppl_init_log(struct r5conf *conf)
 
 	if (ret) {
 		goto err;
-	} else if (!mddev->pers &&
-		   mddev->recovery_cp == 0 && !mddev->degraded &&
+	} else if (!mddev->pers && mddev->recovery_cp == 0 &&
 		   ppl_conf->recovered_entries > 0 &&
 		   ppl_conf->mismatch_count == 0) {
 		/*
-- 
2.14.1

