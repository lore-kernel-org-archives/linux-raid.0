From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 14/21] imsm: FIX: Move reshape_progress forward
Date: Wed, 08 Jun 2011 18:11:26 +0200
Message-ID: <20110608161126.24327.82930.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When array under reshape is assembled, reshape position used in sysfs_set_array()
should be set to position after recovered from backup area.
This avoids data corruption due to reshape the same array area again.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index c19ffac..55829cf 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2194,6 +2194,13 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 			unsigned long long array_blocks;
 			int used_disks;
 
+			if (__le32_to_cpu(migr_rec->ascending_migr) &&
+			    (units <
+				(__le32_to_cpu(migr_rec->num_migr_units)-1)) &&
+			    (super->migr_rec->rec_status ==
+					__cpu_to_le32(UNIT_SRC_IN_CP_AREA)))
+				units++;
+
 			info->reshape_progress = blocks_per_unit * units;
 
 			dprintf("IMSM: General Migration checkpoint : %llu "
@@ -7824,7 +7831,6 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 	int retval = 1;
 	unsigned long curr_migr_unit = __le32_to_cpu(migr_rec->curr_migr_unit);
 	unsigned long num_migr_units = __le32_to_cpu(migr_rec->num_migr_units);
-	int ascending = __le32_to_cpu(migr_rec->ascending_migr);
 	char buffer[20];
 	int skipped_disks = 0;
 	int max_degradation;
@@ -7907,16 +7913,13 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 		goto abort;
 	}
 
-	if (ascending && curr_migr_unit < (num_migr_units-1))
-		curr_migr_unit++;
-
-	migr_rec->curr_migr_unit = __le32_to_cpu(curr_migr_unit);
-	super->migr_rec->rec_status = __cpu_to_le32(UNIT_SRC_NORMAL);
-	if (write_imsm_migr_rec(st) == 0) {
-		__u64 blocks_per_unit = blocks_per_migr_unit(super, id->dev);
-		info->reshape_progress = curr_migr_unit * blocks_per_unit;
+	if (save_checkpoint_imsm(st, info, UNIT_SRC_NORMAL)) {
+		/* ignore error == 2, this can mean end of reshape here
+		 */
+		dprintf("imsm: Cannot write checkpoint to "
+			"migration record (UNIT_SRC_NORMAL) during restart\n");
+	} else
 		retval = 0;
-	}
 
 abort:
 	if (targets) {

