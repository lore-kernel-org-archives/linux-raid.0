From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] imsm: show Subarray and Volume ID in --examine output
Date: Tue, 17 Mar 2020 10:21:03 +0100
Message-ID: <20200317092103.7200-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Show the index of the subarray as 'Subarray' and the value of the
my_vol_raid_dev_num field as 'Volume ID'.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 533becb2..c6198dce 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1579,6 +1579,7 @@ static void print_imsm_dev(struct intel_super *super,
 
 	printf("\n");
 	printf("[%.16s]:\n", dev->volume);
+	printf("       Subarray : %d\n", super->current_vol);
 	printf("           UUID : %s\n", uuid);
 	printf("     RAID Level : %d", get_imsm_raid_level(map));
 	if (map2)
@@ -1683,6 +1684,8 @@ static void print_imsm_dev(struct intel_super *super,
 		printf("Multiple PPLs on journaling drive\n");
 	else
 		printf("<unknown:%d>\n", dev->rwh_policy);
+
+	printf("      Volume ID : %u\n", dev->my_vol_raid_dev_num);
 }
 
 static void print_imsm_disk(struct imsm_disk *disk,
-- 
2.24.0
