From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 1/7] imsm: metadata changes for PPL
Date: Thu, 24 Nov 2016 13:29:46 +0100
Message-ID: <20161124122952.16529-2-artur.paszkiewicz@intel.com>
References: <20161124122952.16529-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161124122952.16529-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Updates for the IMSM metadata format, including PPL header structures.

Extend imsm_vol dirty field adding a third value, which is required to
enable PPL recovery in Windows and UEFI drivers.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 48 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5740088..69f6201 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -104,8 +104,11 @@ struct imsm_disk {
 	__u32 status;			 /* 0xF0 - 0xF3 */
 	__u32 owner_cfg_num; /* which config 0,1,2... owns this disk */
 	__u32 total_blocks_hi;		 /* 0xF4 - 0xF5 total blocks hi */
-#define	IMSM_DISK_FILLERS	3
-	__u32 filler[IMSM_DISK_FILLERS]; /* 0xF5 - 0x107 MPB_DISK_FILLERS for future expansion */
+	__u8 is_journal_disk;
+	__u8 filler1; /* MPB_DISK_FILLERS - reserved for future expansion */
+	__u16 filler2;
+#define	IMSM_DISK_FILLERS	2
+	__u32 filler[IMSM_DISK_FILLERS];
 };
 
 /* map selector for map managment
@@ -154,6 +157,9 @@ struct imsm_vol {
 #define MIGR_STATE_CHANGE 4
 #define MIGR_REPAIR 5
 	__u8  migr_type;	/* Initializing, Rebuilding, ... */
+#define RAIDVOL_CLEAN          0
+#define RAIDVOL_DIRTY          1
+#define RAIDVOL_DSRECORD_VALID 2
 	__u8  dirty;
 	__u8  fs_state;		/* fast-sync state for CnG (0xff == disabled) */
 	__u16 verify_errors;	/* number of mismatches */
@@ -189,7 +195,30 @@ struct imsm_dev {
 	__u16 cache_policy;
 	__u8  cng_state;
 	__u8  cng_sub_state;
-#define IMSM_DEV_FILLERS 10
+	__u16 my_vol_raid_dev_num; /* Used in Unique volume Id for this RaidDev */
+
+	/* NVM_EN */
+	__u8 nv_cache_mode;
+	union {
+		__u8 nv_cache_flags;
+		struct {
+		    __u8 dirty:1; /* 1 - cache is dirty, 0 - clean */
+		    __u8 nvc_health:2;
+		    __u8 expansion_bytes:5;
+		} nvCache;
+	};
+
+	/* Unique Volume Id of the NvCache Volume associated with this volume */
+	__u32 nvc_vol_orig_family_num;
+	__u16 nvc_vol_raid_dev_num;
+
+#define RWH_OFF 0
+#define RWH_DISTRIBUTED 1
+#define RWH_JOURNALING_DRIVE 2
+	__u8  rwh_policy;              /* Raid Write Hole Policy */
+	__u8  filler1;
+
+#define IMSM_DEV_FILLERS 7
 	__u32 filler[IMSM_DEV_FILLERS];
 	struct imsm_vol vol;
 } __attribute__ ((packed));
@@ -7565,12 +7594,15 @@ mark_checkpoint:
 
 skip_mark_checkpoint:
 	/* mark dirty / clean */
-	if (dev->vol.dirty != !consistent) {
+	if ((dev->vol.dirty & RAIDVOL_DIRTY) != !consistent) {
 		dprintf("imsm: mark '%s'\n", consistent ? "clean" : "dirty");
-		if (consistent)
-			dev->vol.dirty = 0;
-		else
-			dev->vol.dirty = 1;
+		if (consistent) {
+			dev->vol.dirty = RAIDVOL_CLEAN;
+		} else {
+			dev->vol.dirty = RAIDVOL_DIRTY;
+			if (dev->rwh_policy)
+				dev->vol.dirty |= RAIDVOL_DSRECORD_VALID;
+		}
 		super->updates_pending++;
 	}
 
-- 
2.10.1

