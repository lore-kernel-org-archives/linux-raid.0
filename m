From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 2/3] mdadm: IMSM metadata compatibility issues
Date: Fri, 29 Jan 2010 14:54:59 +0000
Message-ID: <F2A46F4A087B8547923AD59C289DC90E01D1622B@irsmsx002.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids


Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 super-intel.c |  152 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 148 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 1bb721e..07bef6b 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3345,14 +3345,133 @@ static int write_super_imsm_spares(struct intel_super *super, int doclose)
 	return 0;
 }
 
-static int write_super_imsm(struct intel_super *super, int doclose)
+static int make_mpb_imsm_compatible(struct supertype *st, struct imsm_super *mpb)
 {
+	struct intel_super *super = st->sb;
+	struct imsm_map *map;
+	struct active_array *a;
+ 	__u8 *src, *dst;
+ 	__u32 orig_mpb_size = mpb->mpb_size;
+	__u32 mpb_size = sizeof(struct imsm_super) - sizeof(struct imsm_disk);
+	__u32 sum;
+	int i, bytes_to_copy, spares = 0;
+	struct dl *d;
+
+	/* Make sure that there is missing disk */
+	if (super->missing == NULL)
+	  return -1;
+
+	/* Decrease the number of disks - 
+	   missing disk will not be exposed to the user*/
+	mpb->num_disks--;
+	
+	/* Create MBP disk table */
+	mpb_size += sizeof(struct imsm_disk) * mpb->num_disks;
+	for (d = super->disks; d; d = d->next) {
+		if (d->index == -1)
+			spares++;
+		else
+			mpb->disk[d->index] = d->disk;
+	}
+	
+	/* Iterate through the imsm devices */
+	for (i = 0; i < mpb->num_raid_devs; i++) {
+
+		struct imsm_dev *dev = __get_imsm_dev(mpb, i);
+		imsm_copy_dev(dev, get_imsm_dev(super, i));
+
+		/* Find layout of the current aray */
+		for (a = st->arrays; a; a = a->next)
+			if (a->info.container_member == i)
+				break;
+
+		/* Process the first map */
+		map = get_imsm_map(dev, 0);
+		if ((map->raid_level == 5) && (a->info.array.layout == ALGORITHM_PARITY_N)) {
+
+			/* get the pointer to the rest of the metadata */
+			src = (__u8*)map + sizeof_imsm_map(map);
+
+			/* change the level and disk number to be compatible with IMSM */
+			map->raid_level = 0;
+			map->num_members--;
+
+			/* get the updated pointer to the rest of the metadata */
+			dst = (__u8*)map + sizeof_imsm_map(map);
+			/* Now move the rest of the metadata to be properly aligned */
+			bytes_to_copy = orig_mpb_size - (src - (__u8*)mpb);
+			if (bytes_to_copy > 0)
+				memmove(dst, src, bytes_to_copy);
+		}
+
+		/* Process the second map if needed */
+		if (dev->vol.migr_state != IMSM_T_STATE_NORMAL) {
+
+			map = get_imsm_map(dev, 1);
+			if ((map->raid_level == 5) && (a->info.array.layout == ALGORITHM_PARITY_N)) {
+
+				/* change the level and disk number to be compatible with IMSM */
+				map->raid_level = 0;
+				map->num_members--;
+			}
+		}
+		mpb_size += sizeof_imsm_dev(dev, 0);
+	}
+	mpb_size += __le32_to_cpu(mpb->bbm_log_size);
+	mpb->mpb_size = __cpu_to_le32(mpb_size);
+
+	/* recalculate checksum */
+	sum = __gen_imsm_checksum(mpb);
+	mpb->check_sum = __cpu_to_le32(sum);
+
+	return 0;
+}
+
+static int is_mpb_imsm_compatible(struct supertype *st, struct imsm_super *mpb)
+{
+    int i;
+
+	/* Iterate through the imsm devices */
+    for (i = 0; i < mpb->num_raid_devs; i++) {
+		struct imsm_dev *dev;
+		struct imsm_map *map;
+		struct active_array *a;
+		dev = __get_imsm_dev(mpb, i);
+
+		/* Find layout of the current aray */
+		for (a = st->arrays; a; a = a->next)
+		{
+			if (a->info.container_member == i)
+				break;
+		}
+		/* Get first map */
+		map = get_imsm_map(dev, 0);
+		if ((map->raid_level == 5) && (a->info.array.layout == ALGORITHM_PARITY_N))	{
+			/* This leve/layout is not compatible with IMSM */
+			return 0;
+		}
+		if (dev->vol.migr_state != IMSM_T_STATE_NORMAL) {
+			/* Get second map */
+			map = get_imsm_map(dev, 1);
+			if ((map->raid_level == 5) && (a->info.array.layout == ALGORITHM_PARITY_N))	{
+				/* This leve/layout is not compatible with IMSM */
+				return 0;
+			}
+		}
+	}
+	return 1;
+}
+
+static int write_super_imsm(struct supertype *st, int doclose)
+{
+	struct intel_super *super = st->sb;
 	struct imsm_super *mpb = super->anchor;
+	struct imsm_super *tmp_mpb = NULL;
 	struct dl *d;
 	__u32 generation;
 	__u32 sum;
 	int spares = 0;
-	int i;
+	int i, buflen;
 	__u32 mpb_size = sizeof(struct imsm_super) - sizeof(struct imsm_disk);
 
 	/* 'generation' is incremented everytime the metadata is written */
@@ -3389,6 +3508,27 @@ static int write_super_imsm(struct intel_super *super, int doclose)
 	sum = __gen_imsm_checksum(mpb);
 	mpb->check_sum = __cpu_to_le32(sum);
 
+	/* The mpb is generated and ready to be flushed to disks.
+	 * Check configuration for compatibility with IMSM
+	 * The following configurations should be handled here:
+	 * N-drive Raid 4 => will be written as N-1 Raid0
+	 */
+	if (!is_mpb_imsm_compatible(st, mpb)) {
+		buflen = ROUND_UP(super->anchor->mpb_size, 512);
+		if (posix_memalign((void**)&tmp_mpb, 512, buflen) != 0) {
+			fprintf(stderr,
+					Name ": unable to allocate %zu byte mpb buffer\n",
+					super->len);
+			return 1;
+		}
+		/* Copy the current mpb */
+		memcpy(tmp_mpb, mpb, buflen);
+		/* Translate mpb to be IMSM compatible */
+		make_mpb_imsm_compatible(st, tmp_mpb);
+		/* From now mpb will point to the new meta */
+		mpb = tmp_mpb;
+	}
+
 	/* write the mpb for disks that compose raid devices */
 	for (d = super->disks; d ; d = d->next) {
 		if (d->index < 0)
@@ -3402,6 +3542,10 @@ static int write_super_imsm(struct intel_super *super, int doclose)
 		}
 	}
 
+	/* Free temporary mpb */
+	if (tmp_mpb)
+		free(tmp_mpb);
+
 	if (spares)
 		return write_super_imsm_spares(super, doclose);
 
@@ -3497,7 +3641,7 @@ static int write_init_super_imsm(struct supertype *st)
 
 		return rv;
 	} else
-		return write_super_imsm(st->sb, 1);
+		return write_super_imsm(st, 1);
 }
 #endif
 
@@ -4570,7 +4714,7 @@ static void imsm_sync_metadata(struct supertype *container)
 	if (!super->updates_pending)
 		return;
 
-	write_super_imsm(super, 0);
+	write_super_imsm(container, 0);
 
 	super->updates_pending = 0;
 }
-- 
1.6.3.3



