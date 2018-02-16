From: Michal Zylowski <michal.zylowski@intel.com>
Subject: [PATCH] imsm: update product name in error message
Date: Fri, 16 Feb 2018 15:51:33 +0100
Message-ID: <1518792693-13610-1-git-send-email-michal.zylowski@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Michal Zylowski <michal.zylowski@intel.com>
List-Id: linux-raid.ids

This commit extends ab0c6bb ("imsm: update name in --detail-platform").
Refer user to RSTe/VROC manual when needed.

Signed-off-by: Michal Zylowski <michal.zylowski@intel.com>
---
 super-intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/super-intel.c b/super-intel.c
index c4a5a1b..a429940 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5771,7 +5771,7 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 		} else if (super->hba->type == SYS_DEV_VMD && super->orom &&
 		    !imsm_orom_has_tpv_support(super->orom)) {
 			pr_err("\tPlatform configuration does not support non-Intel NVMe drives.\n"
-			       "\tPlease refer to Intel(R) RSTe user guide.\n");
+			       "\tPlease refer to Intel(R) RSTe/VROC user guide.\n");
 			free(dd->devname);
 			free(dd);
 			return 1;
-- 
2.7.4

