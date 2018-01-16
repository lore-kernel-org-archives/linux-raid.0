From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] imsm: update name in --detail-platform
Date: Tue, 16 Jan 2018 12:23:09 +0100
Message-ID: <20180116112309.22450-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

For IMSM enterprise firmware starting with major version 6, present the
platform name as Intel VROC.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index c55802f1..c4a5a1be 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2369,6 +2369,8 @@ static void print_imsm_capability(const struct imsm_orom *orom)
 	printf("       Platform : Intel(R) ");
 	if (orom->capabilities == 0 && orom->driver_features == 0)
 		printf("Matrix Storage Manager\n");
+	else if (imsm_orom_is_enterprise(orom) && orom->major_ver >= 6)
+		printf("Virtual RAID on CPU\n");
 	else
 		printf("Rapid Storage Technology%s\n",
 			imsm_orom_is_enterprise(orom) ? " enterprise" : "");
-- 
2.15.1

