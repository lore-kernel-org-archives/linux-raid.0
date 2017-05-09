From: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Subject: [PATCH] IMSM: Correct --examine output for 4k disks
Date: Tue,  9 May 2017 14:03:27 +0200
Message-ID: <1494331407-2049-1-git-send-email-mariusz.dabrowski@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Maksymilian Kunt <maksymilian.kunt@intel.com>, Mariusz Dabrowski <mariusz.dabrowski@intel.com>
List-Id: linux-raid.ids

From: Maksymilian Kunt <maksymilian.kunt@intel.com>

"Array Size" and "Per Dev Size" are incorrect for disks with sector size
different than 512B.

Calculate "Array Size" and "Per Dev Size" based on sector size. Additionally
print "Sector Size".

Signed-off-by: Maksymilian Kunt <maksymilian.kunt@intel.com>
Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
---
 super-intel.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e13c940..147a70c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1473,13 +1473,16 @@ static void print_imsm_dev(struct intel_super *super,
 		       ord & IMSM_ORD_REBUILD ? " (out-of-sync)" : "");
 	} else
 		printf("      This Slot : ?\n");
+	printf("    Sector Size : %u\n", super->sector_size);
 	sz = __le32_to_cpu(dev->size_high);
 	sz <<= 32;
 	sz += __le32_to_cpu(dev->size_low);
-	printf("     Array Size : %llu%s\n", (unsigned long long)sz,
+	printf("     Array Size : %llu%s\n",
+		   (unsigned long long)sz * 512 / super->sector_size,
 	       human_size(sz * 512));
 	sz = blocks_per_member(map);
-	printf("   Per Dev Size : %llu%s\n", (unsigned long long)sz,
+	printf("   Per Dev Size : %llu%s\n",
+		   (unsigned long long)sz * 512 / super->sector_size,
 	       human_size(sz * 512));
 	printf("  Sector Offset : %llu\n",
 		pba_of_lba0(map));
-- 
1.8.3.1

