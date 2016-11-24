From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 3/7] imsm: PPL support
Date: Thu, 24 Nov 2016 13:29:48 +0100
Message-ID: <20161124122952.16529-4-artur.paszkiewicz@intel.com>
References: <20161124122952.16529-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161124122952.16529-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Enable creating and assembling IMSM raid5 arrays with PPL.

Write the IMSM MPB location for a device to the newly added rdev
sb_start sysfs attribute and 'journal_ppl' to 'state' attribute for
every active member.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 mdadm.h       |  1 +
 super-intel.c | 33 +++++++++++++++++++++++++++++++++
 sysfs.c       |  4 ++++
 3 files changed, 38 insertions(+)

diff --git a/mdadm.h b/mdadm.h
index 4eabf59..5600341 100755
--- a/mdadm.h
+++ b/mdadm.h
@@ -252,6 +252,7 @@ struct mdinfo {
 	unsigned long long	custom_array_size; /* size for non-default sized
 						    * arrays (in sectors)
 						    */
+	unsigned long long	sb_start;
 #define NO_RESHAPE		0
 #define VOLUME_RESHAPE		1
 #define CONTAINER_RESHAPE	2
diff --git a/super-intel.c b/super-intel.c
index df09272..79a3d78 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1261,6 +1261,15 @@ static void print_imsm_dev(struct intel_super *super,
 	}
 	printf("\n");
 	printf("    Dirty State : %s\n", dev->vol.dirty ? "dirty" : "clean");
+	printf("     RWH Policy : ");
+	if (dev->rwh_policy == RWH_OFF)
+		printf("off\n");
+	else if (dev->rwh_policy == RWH_DISTRIBUTED)
+		printf("PPL distributed\n");
+	else if (dev->rwh_policy == RWH_JOURNALING_DRIVE)
+		printf("PPL journaling drive\n");
+	else
+		printf("<unknown:%d>\n", dev->rwh_policy);
 }
 
 static void print_imsm_disk(struct imsm_disk *disk, int index, __u32 reserved)
@@ -3043,6 +3052,15 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 			}
 		}
 	}
+
+	if (info->array.level == 5) {
+		if (dev->rwh_policy == RWH_OFF)
+			info->rwh_policy = RWH_POLICY_OFF;
+		else if (dev->rwh_policy == RWH_DISTRIBUTED)
+			info->rwh_policy = RWH_POLICY_PPL;
+		else
+			info->rwh_policy = RWH_POLICY_UNKNOWN;
+	}
 }
 
 static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev,
@@ -3177,6 +3195,9 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 
 		disk = &super->disks->disk;
 		info->data_offset = total_blocks(&super->disks->disk) - reserved;
+		/* mpb anchor sector - see store_imsm_mpb() */
+		info->sb_start = total_blocks(&super->disks->disk) -
+				 ((2 * super->sector_size) >> 9);
 		info->component_size = reserved;
 		info->disk.state  = is_configured(disk) ? (1 << MD_DISK_ACTIVE) : 0;
 		/* we don't change info->disk.raid_disk here because
@@ -5034,6 +5055,17 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	}
 	mpb->num_raid_devs++;
 
+	if (s->rwh_policy == UnSet || s->rwh_policy == RWH_POLICY_OFF) {
+		dev->rwh_policy = RWH_OFF;
+	} else if (s->rwh_policy == RWH_POLICY_PPL) {
+		dev->rwh_policy = RWH_DISTRIBUTED;
+	} else {
+		free(dev);
+		free(dv);
+		pr_err("imsm supports only PPL RWH Policy\n");
+		return 0;
+	}
+
 	dv->dev = dev;
 	dv->index = super->current_vol;
 	dv->next = super->devlist;
@@ -11061,6 +11093,7 @@ struct superswitch super_imsm = {
 	.container_content = container_content_imsm,
 	.validate_container = validate_container_imsm,
 
+	.supports_ppl	= 1,
 	.external	= 1,
 	.name = "imsm",
 
diff --git a/sysfs.c b/sysfs.c
index 4772d77..b4437a3 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -732,7 +732,11 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
 			rv |= sysfs_set_num(sra, sd, "slot", sd->disk.raid_disk);
 		if (resume)
 			sysfs_set_num(sra, sd, "recovery_start", sd->recovery_start);
+		if (sra->rwh_policy == RWH_POLICY_PPL &&
+		    (sd->recovery_start == MaxSector || !resume))
+			sysfs_set_str(sra, sd, "state", "journal_ppl");
 	}
+	sysfs_set_num(sra, sd, "sb_start", sd->sb_start);
 	return rv;
 }
 
-- 
2.10.1

