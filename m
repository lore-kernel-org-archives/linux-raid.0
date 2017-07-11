From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] raid5-ppl: use BIOSET_NEED_BVECS when creating bioset
Date: Tue, 11 Jul 2017 16:16:24 +0200
Message-ID: <20170711141624.27051-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

This bioset is used for allocating bios with nr_iovecs > 0 so this flag
must be set.

Fixes: 011067b05668 ("blk: replace bioset_create_nobvec() with a flags arg to bioset_create()")
Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5-ppl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 77cce3573aa8..44ad5baf3206 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -1150,7 +1150,7 @@ int ppl_init_log(struct r5conf *conf)
 		goto err;
 	}
 
-	ppl_conf->bs = bioset_create(conf->raid_disks, 0, 0);
+	ppl_conf->bs = bioset_create(conf->raid_disks, 0, BIOSET_NEED_BVECS);
 	if (!ppl_conf->bs) {
 		ret = -ENOMEM;
 		goto err;
-- 
2.13.1

