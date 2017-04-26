From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 1/1] IMSM: Initialize my_vol_raid_dev_num during vol creation
Date: Wed, 26 Apr 2017 11:08:07 +0200
Message-ID: <20170426090807.10328-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.serensen@gmail.com, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

This field was not initialized so far. This ID needs to be unique
for every newly created array in container.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super-intel.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0aed57c..d5c77c0 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -232,8 +232,13 @@ struct imsm_super {
 	__u32 orig_family_num;		/* 0x40 - 0x43 original family num */
 	__u32 pwr_cycle_count;		/* 0x44 - 0x47 simulated power cycle count for array */
 	__u32 bbm_log_size;		/* 0x48 - 0x4B - size of bad Block Mgmt Log in bytes */
-#define IMSM_FILLERS 35
-	__u32 filler[IMSM_FILLERS];	/* 0x4C - 0xD7 RAID_MPB_FILLERS */
+	__u16 num_raid_devs_created;	/* 0x4C - 0x4D Used for generating unique
+					 * volume IDs for raid_dev created in this array
+					 * (starts at 1)
+					 */
+	__u16 filler1;			/* 0x4E - 0x4F */
+#define IMSM_FILLERS 34
+	__u32 filler[IMSM_FILLERS];	/* 0x50 - 0xD7 RAID_MPB_FILLERS */
 	struct imsm_disk disk[1];	/* 0xD8 diskTbl[numDisks] */
 	/* here comes imsm_dev[num_raid_devs] */
 	/* here comes BBM logs */
@@ -5368,6 +5373,8 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 		set_imsm_ord_tbl_ent(map, i, IMSM_ORD_REBUILD);
 	}
 	mpb->num_raid_devs++;
+	mpb->num_raid_devs_created++;
+	dev->my_vol_raid_dev_num = mpb->num_raid_devs_created;
 
 	if (s->consistency_policy == UnSet ||
 	    s->consistency_policy == CONSISTENCY_POLICY_RESYNC ||
-- 
2.9.3

