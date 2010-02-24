From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [mdadm PATCH 1/11] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:44:46 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65C2@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 6ab365a524182234a377a365290fe90d581b8c42 Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:04:49 +0100
Subject: [PATCH] OLCE: Add show_meta()

Changes to be committed:
	modified:   super-intel.c

Add show_meta() debug function.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 super-intel.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 07bef6b..be7fac9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3461,6 +3461,74 @@ static int is_mpb_imsm_compatible(struct supertype *st, struct imsm_super *mpb)
 	}
 	return 1;
 }
+ 
+
+static void show_meta(struct imsm_super *mpb)
+{
+
+#ifdef DEBUG
+    struct imsm_dev *raidDev;
+    struct imsm_vol *raidVol;
+    struct imsm_disk *raidDisk;
+    struct imsm_map *map;
+    int i;
+
+    fprintf(stderr,"#MPB: sig: XXX,mpbSize: %d, familyNum: %x, generationNum: %d,\n \
+                errorLogByteSize: %d, attributes: %x, numDisks: %d, numRaidDevs: %d, \n", \
+			   /*mpb->sig.text,*/ mpb->mpb_size, mpb->family_num, mpb->generation_num, \
+                mpb->error_log_size, mpb->attributes, mpb->num_disks, mpb->num_raid_devs);
+
+    fprintf(stderr,"                errorLogPosLayout: %d, cacheSizeInMB: %u, origFamilyNum: %d, pwrCycleCount: %d \n", \
+                mpb->error_log_pos, mpb->cache_size, mpb->orig_family_num, mpb->pwr_cycle_count);
+
+
+    for (i = 0; i<mpb->num_disks; i++) {
+        raidDisk = &(mpb->disk[i]);
+        if (raidDisk) {
+            fprintf(stderr, "#MPB Disk %d: serial: %s\n", i, raidDisk->serial);
+
+            fprintf(stderr, "#MPB Disk %d: total_blocks: %d, scsi_id: %d, status %x, owner_cfg_num: %u \n",\
+            i, raidDisk->total_blocks, raidDisk->scsi_id, raidDisk->status, raidDisk->owner_cfg_num);
+        }
+    }
+
+    raidDev = (struct imsm_dev*)(mpb->disk + mpb->num_disks);
+
+    for (i = 0; i<mpb->num_raid_devs; i++) {
+        fprintf(stderr, "#RAID Dev nr: %d, serial: %s\n", i, raidDev->volume);
+
+        fprintf(stderr, "#RAID Dev nr: %d, NUM_DB_LO: %x, NUM_DB_HI: %x, status: %x, reserved_blocks: %u,\n\
+               migr_priority: %d, num_sub_vols: %d, tid: %d, cng_master: %d, cache_policy: %d, cng_state: %d, cng_sub_state: %d \n",\
+                    i, raidDev->size_low, raidDev->size_high, raidDev->status, raidDev->reserved_blocks, \
+                    raidDev->migr_priority, raidDev->num_sub_vols, raidDev->tid, raidDev->cng_master_disk, raidDev->cache_policy, \
+                    raidDev->cng_state, raidDev->cng_sub_state);
+
+        raidVol = &(raidDev->vol);
+
+        fprintf(stderr, "#RAID Vol: curr_migr_unit: %u, checkpoint_id: %u, migr_state: %d, migr_type: %d, dirty: %d, fs_state: %d,\n \
+               verify_errors: %d, verify_BBs: %d \n", raidVol->curr_migr_unit, raidVol->checkpoint_id, raidVol->migr_state, 
+                raidVol->migr_type, raidVol->dirty, raidVol->fs_state, raidVol->verify_errors, raidVol->bad_blocks);
+
+        map = (struct imsm_map*) &(raidVol->map);
+
+        fprintf(stderr, "LO MAP: pba_of_lba0: %u, blocks_per_member: %u, num_data_stripes: %u, blocks_per_strip: %u,\n\
+                    map_state: %x, raid_level: %d, num_members: %d, num_domains: %d, failed_disk_num: %d\n",\
+                    map->pba_of_lba0, map->blocks_per_member, map->num_data_stripes, map->blocks_per_strip, map->map_state, map->raid_level, \
+                    map->num_members, map->num_domains, map->failed_disk_num);
+ 
+ 
+        if (raidVol->migr_state != IMSM_T_STATE_NORMAL) {
+            map = (struct imsm_map*)(((char*)map) + sizeof(struct imsm_map) + sizeof(map->disk_ord_tbl)*(map->num_members-1));
+            fprintf(stderr, "HI MAP: pba_of_lba0: %u, blocks_per_member: %u, num_data_stripes: %u, blocks_per_strip: %u,\n\
+                    map_state: %x, raid_level: %d, num_members: %d, num_domains: %d, failed_disk_num: %d\n", \
+                    map->pba_of_lba0, map->blocks_per_member, map->num_data_stripes, map->blocks_per_strip, map->map_state, map->raid_level, \
+                    map->num_members, map->num_domains, map->failed_disk_num);
+        }
+        raidDev++;
+
+    }
+#endif
+}
 
 static int write_super_imsm(struct supertype *st, int doclose)
 {
@@ -3529,6 +3597,7 @@ static int write_super_imsm(struct supertype *st, int doclose)
 		mpb = tmp_mpb;
 	}
 
+	show_meta(mpb);
 	/* write the mpb for disks that compose raid devices */
 	for (d = super->disks; d ; d = d->next) {
 		if (d->index < 0)
-- 
1.6.0.2

