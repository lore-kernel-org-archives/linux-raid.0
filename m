From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 3/6] simplify calculating array_blocks
Date: Thu, 29 Mar 2012 12:43:13 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B918A205DE@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

no point calling info_to_blocks_per_member when it just returns size*2 for level==1
calc_array_size can be used for all levels

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 super-intel.c |    5 +----
 util.c        |    2 ++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 36e8878..c27badc 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4623,10 +4623,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	}
 
 	strncpy((char *) dev->volume, name, MAX_RAID_SERIAL_LEN);
-	if (info->level == 1)
-		array_blocks = info_to_blocks_per_member(info, size);
-	else
-		array_blocks = calc_array_size(info->level, info->raid_disks,
+	array_blocks = calc_array_size(info->level, info->raid_disks,
 					       info->layout, info->chunk_size,
 					       size * 2);
 	/* round array size down to closest MB */
diff --git a/util.c b/util.c
index 7abbff7..d32e650 100644
--- a/util.c
+++ b/util.c
@@ -711,6 +711,8 @@ void print_r10_layout(int layout)
 unsigned long long calc_array_size(int level, int raid_disks, int layout,
 				   int chunksize, unsigned long long devsize)
 {
+	if (level == 1)
+		return devsize;
 	devsize &= ~(unsigned long long)((chunksize>>9)-1);
 	return get_data_disks(level, layout, raid_disks) * devsize;
 }
-- 
1.6.4.2

