From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2 3/7] imsm: PPL support
Date: Mon,  5 Dec 2016 16:32:00 +0100
Message-ID: <20161205153204.7343-4-artur.paszkiewicz@intel.com>
References: <20161205153204.7343-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153204.7343-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Enable creating and assembling IMSM raid5 arrays with PPL.

Write the IMSM MPB location for a device to the newly added rdev
sb_start sysfs attribute and 'journal_ppl' to 'state' attribute for
every active member.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 mdadm.h       |  1 +
 super-intel.c | 48 ++++++++++++++++++++++++++++++++++++++++++++----
 sysfs.c       |  4 ++++
 3 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index fee07ef..03de402 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -263,6 +263,7 @@ struct mdinfo {
 	unsigned long long	custom_array_size; /* size for non-default sized
 						    * arrays (in sectors)
 						    */
+	unsigned long long	sb_start;
 #define NO_RESHAPE		0
 #define VOLUME_RESHAPE		1
 #define CONTAINER_RESHAPE	2
diff --git a/super-intel.c b/super-intel.c
index e3ada74..0c4726a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1309,6 +1309,11 @@ static int is_failed(struct imsm_disk *disk)
 	return (disk->status & FAILED_DISK) == FAILED_DISK;
 }
 
+static int is_journal(struct imsm_disk *disk)
+{
+	return (disk->status & JOURNAL_DISK) == JOURNAL_DISK;
+}
+
 /* try to determine how much space is reserved for metadata from
  * the last get_extents() entry on the smallest active disk,
  * otherwise fallback to the default
@@ -1499,6 +1504,15 @@ static void print_imsm_dev(struct intel_super *super,
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
@@ -1515,9 +1529,10 @@ static void print_imsm_disk(struct imsm_disk *disk, int index, __u32 reserved)
 		printf("  Disk%02d Serial : %s\n", index, str);
 	else
 		printf("    Disk Serial : %s\n", str);
-	printf("          State :%s%s%s\n", is_spare(disk) ? " spare" : "",
-					    is_configured(disk) ? " active" : "",
-					    is_failed(disk) ? " failed" : "");
+	printf("          State :%s%s%s%s\n", is_spare(disk) ? " spare" : "",
+					      is_configured(disk) ? " active" : "",
+					      is_failed(disk) ? " failed" : "",
+					      is_journal(disk) ? " journal" : "");
 	printf("             Id : %08x\n", __le32_to_cpu(disk->scsi_id));
 	sz = total_blocks(disk) - reserved;
 	printf("    Usable Size : %llu%s\n", (unsigned long long)sz,
@@ -3323,6 +3338,15 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
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
@@ -3458,6 +3482,9 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 
 		disk = &super->disks->disk;
 		info->data_offset = total_blocks(&super->disks->disk) - reserved;
+		/* mpb anchor sector - see store_imsm_mpb() */
+		info->sb_start = total_blocks(&super->disks->disk) -
+				 ((2 * super->sector_size) >> 9);
 		info->component_size = reserved;
 		info->disk.state  = is_configured(disk) ? (1 << MD_DISK_ACTIVE) : 0;
 		/* we don't change info->disk.raid_disk here because
@@ -3465,7 +3492,8 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 		 * found the 'most fresh' version of the metadata
 		 */
 		info->disk.state |= is_failed(disk) ? (1 << MD_DISK_FAULTY) : 0;
-		info->disk.state |= is_spare(disk) ? 0 : (1 << MD_DISK_SYNC);
+		info->disk.state |= (is_spare(disk) || is_journal(disk)) ?
+				    0 : (1 << MD_DISK_SYNC);
 	}
 
 	/* only call uuid_from_super_imsm when this disk is part of a populated container,
@@ -5317,6 +5345,17 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
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
@@ -11579,6 +11618,7 @@ struct superswitch super_imsm = {
 	.container_content = container_content_imsm,
 	.validate_container = validate_container_imsm,
 
+	.supports_ppl	= 1,
 	.external	= 1,
 	.name = "imsm",
 
diff --git a/sysfs.c b/sysfs.c
index f88461c..677c1b9 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -735,6 +735,9 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
 			rv |= sysfs_set_num(sra, sd, "slot", sd->disk.raid_disk);
 		if (resume)
 			sysfs_set_num(sra, sd, "recovery_start", sd->recovery_start);
+		if (sra->rwh_policy == RWH_POLICY_PPL &&
+		    (sd->recovery_start == MaxSector || !resume))
+			sysfs_set_str(sra, sd, "state", "journal_ppl");
 	}
 	if (sd->bb.supported) {
 		if (sysfs_set_str(sra, sd, "state", "external_bbl")) {
@@ -758,6 +761,7 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
 			rv |= sysfs_set_str(sra, sd, "bad_blocks", s);
 		}
 	}
+	sysfs_set_num(sra, sd, "sb_start", sd->sb_start);
 	return rv;
 }
 
-- 
2.10.1

