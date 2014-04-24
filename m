From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC mdadm PATCH 09/11] imsm: examine cache configurations
Date: Thu, 24 Apr 2014 00:23:07 -0700
Message-ID: <20140424072307.4515.57651.stgit@viggo.jf.intel.com>
References: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, jes.sorensen@redhat.com, artur.paszkiewicz@intel.com, dave.jiang@intel.com
List-Id: linux-raid.ids

Allow -E to show the cache associations of volumes.  The UUIDs are
calculated from the stored "orig_family_num" and "dev_id" in the cache
metadata.

For -Eb a UUID is synthesized from the union of the
<cache>:<cache-target> tuple for the purposes of identifying the
complete volume.

The proposed assembly hierarchy is:

1/ (2) containers (one for the cache "array", one for the cache-target
   "array")

2/ (2) subarrays (one for the cache "volume", one for the cache-target
   "volume")

3/ (1) stacked array with the subarray from 2/ as component members

...where "array" and "volume" are the imsm terminology for a mdadm
container and subarray.

TODO: what to do about the name of the composite volume?  Leave it
dynamically assigned for now, we could have it takeover the cache-target
name, but that name is not available when examinig the cache device...

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 isrt-intel.h  |   12 ++++
 super-intel.c |  184 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 172 insertions(+), 24 deletions(-)

diff --git a/isrt-intel.h b/isrt-intel.h
index 50365de1a620..6d7e92f4da37 100644
--- a/isrt-intel.h
+++ b/isrt-intel.h
@@ -43,6 +43,18 @@ enum {
 	NV_CACHE_MODE_DIS_SAFE     = 11, /* volume or NV cache not associated */
 };
 
+static inline int nvc_enabled(__u8 mode)
+{
+	switch (mode) {
+	case NV_CACHE_MODE_OFF:
+	case NV_CACHE_MODE_DIS_PERF:
+	case NV_CACHE_MODE_DIS_SAFE:
+		return 0;
+	default:
+		return 1;
+	}
+}
+
 struct segment_index_pair {
 	__u32 segment;
 	__u32 index;
diff --git a/super-intel.c b/super-intel.c
index f179d80b8209..7a7a48e9e6d7 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -770,18 +770,40 @@ static struct imsm_dev *__get_imsm_dev(struct imsm_super *mpb, __u8 index)
 	return NULL;
 }
 
-static struct imsm_dev *get_imsm_dev(struct intel_super *super, __u8 index)
+static struct intel_dev *get_intel_dev(struct intel_super *super, __u8 index)
 {
 	struct intel_dev *dv;
 
-	if (index >= super->anchor->num_raid_devs)
-		return NULL;
 	for (dv = super->devlist; dv; dv = dv->next)
 		if (dv->index == index)
-			return dv->dev;
+			return dv;
+	return NULL;
+}
+
+static int is_isrt_leg(struct intel_dev *dv)
+{
+	return dv->nvc || nvc_enabled(dv->dev->nv_cache_mode);
+}
+
+static struct intel_dev *get_isrt_leg(struct intel_super *super, int leg)
+{
+	struct intel_dev *dv;
+
+	for (dv = super->devlist; dv; dv = dv->next)
+		if (!is_isrt_leg(dv))
+			continue;
+		else if (--leg == 0)
+			return dv;
 	return NULL;
 }
 
+static struct imsm_dev *get_imsm_dev(struct intel_super *super, __u8 index)
+{
+	struct intel_dev *dv = get_intel_dev(super, index);
+
+	return dv ? dv->dev : NULL;
+}
+
 /*
  * for second_map:
  *  == MAP_0 get first map
@@ -1122,20 +1144,112 @@ static int is_gen_migration(struct imsm_dev *dev);
 static __u64 blocks_per_migr_unit(struct intel_super *super,
 				  struct imsm_dev *dev);
 
-static void print_imsm_dev(struct intel_super *super,
-			   struct imsm_dev *dev,
-			   char *uuid,
-			   int disk_idx)
+/* generate the <cache> + <cache_target> (in that order) UUID */
+static int cache_volume_uuid(struct intel_super *super, struct intel_dev *dv, int uuid[4])
+{
+	char buf[20];
+	struct sha1_ctx ctx;
+	struct imsm_dev *dev = dv->dev;
+
+	if (!is_isrt_leg(dv))
+		return 1;
+
+	sha1_init_ctx(&ctx);
+	sha1_process_bytes(super->anchor->sig, MPB_SIG_LEN, &ctx);
+	if (dv->nvc) {
+		struct nv_cache_vol_config_md *cfg = &dv->nvc->hdr.vol_config_md[0];
+
+		/* self id + cache target id */
+		sha1_process_bytes(&super->anchor->orig_family_num, sizeof(__u32), &ctx);
+		sha1_process_bytes(&dev->dev_id, sizeof(dv->dev->dev_id), &ctx);
+		sha1_process_bytes(&cfg->acc_vol_orig_family_num, sizeof(__u32), &ctx);
+		sha1_process_bytes(&cfg->acc_vol_dev_id, sizeof(cfg->acc_vol_dev_id), &ctx);
+	} else if (nvc_enabled(dev->nv_cache_mode)) {
+		/* cache id + self id */
+		sha1_process_bytes(&dev->nvc_orig_family_num, sizeof(__u32), &ctx);
+		sha1_process_bytes(&dev->nvc_dev_id, sizeof(dev->nvc_dev_id), &ctx);
+		sha1_process_bytes(&super->anchor->orig_family_num, sizeof(__u32), &ctx);
+		sha1_process_bytes(&dev->dev_id, sizeof(dev->dev_id), &ctx);
+	}
+	sha1_finish_ctx(&ctx, buf);
+	memcpy(uuid, buf, 4*4);
+	return 0;
+}
+
+static void cache_target_uuid(struct intel_super *super, struct intel_dev *dv, int uuid[4])
+{
+	char buf[20];
+	struct sha1_ctx ctx;
+	struct nv_cache_vol_config_md *cfg = &dv->nvc->hdr.vol_config_md[0];
+
+	sha1_init_ctx(&ctx);
+	sha1_process_bytes(super->anchor->sig, MPB_SIG_LEN, &ctx);
+	sha1_process_bytes(&cfg->acc_vol_orig_family_num, sizeof(__u32), &ctx);
+	sha1_process_bytes(&cfg->acc_vol_dev_id, sizeof(cfg->acc_vol_dev_id), &ctx);
+	sha1_finish_ctx(&ctx, buf);
+	memcpy(uuid, buf, 4*4);
+}
+
+static void cache_uuid(struct intel_super *super, struct imsm_dev *dev, int uuid[4])
+{
+	char buf[20];
+	struct sha1_ctx ctx;
+
+	sha1_init_ctx(&ctx);
+	sha1_process_bytes(super->anchor->sig, MPB_SIG_LEN, &ctx);
+	sha1_process_bytes(&dev->nvc_orig_family_num, sizeof(__u32), &ctx);
+	sha1_process_bytes(&dev->nvc_dev_id, sizeof(dev->nvc_dev_id), &ctx);
+	sha1_finish_ctx(&ctx, buf);
+	memcpy(uuid, buf, 4*4);
+}
+
+static void examine_cache(struct intel_super *super, struct intel_dev *dv)
+{
+	int uuid[4];
+	char uuid_str[64];
+	char *cache_role = NULL;
+	struct imsm_dev *dev = dv->dev;
+
+	if (dv->nvc) {
+		cache_role = "cache";
+		cache_target_uuid(super, dv, uuid);
+	}
+	if (nvc_enabled(dev->nv_cache_mode)) {
+		if (cache_role)
+			cache_role = NULL; /* can't have it both ways */
+		else {
+			cache_role = "cache-target";
+			cache_uuid(super, dev, uuid);
+		}
+	}
+	__fname_from_uuid(uuid, 0, uuid_str, ':');
+
+	if (!cache_role)
+		return;
+
+	printf("          Magic : Intel (R) Smart Response Technology\n");
+	printf("     Cache role : %s\n", cache_role);
+	printf("     Cache peer : %s\n", uuid_str + 5);
+	cache_volume_uuid(super, dv, uuid);
+	__fname_from_uuid(uuid, 0, uuid_str, ':');
+	printf("   Cache volume : %s\n", uuid_str + 5);
+}
+
+static void print_imsm_dev(struct intel_super *super, struct intel_dev *dv,
+			   struct mdinfo *info, int disk_idx)
 {
 	__u64 sz;
+	__u32 ord;
 	int slot, i;
+	char uuid_str[64];
+	struct imsm_dev *dev = dv->dev;
 	struct imsm_map *map = get_imsm_map(dev, MAP_0);
 	struct imsm_map *map2 = get_imsm_map(dev, MAP_1);
-	__u32 ord;
 
 	printf("\n");
 	printf("[%.16s]:\n", dev->volume);
-	printf("           UUID : %s\n", uuid);
+	__fname_from_uuid(info->uuid, 0, uuid_str, ':');
+	printf("           UUID : %s\n", uuid_str + 5);
 	printf("     RAID Level : %d", get_imsm_raid_level(map));
 	if (map2)
 		printf(" <-- %d", get_imsm_raid_level(map2));
@@ -1224,6 +1338,11 @@ static void print_imsm_dev(struct intel_super *super,
 	}
 	printf("\n");
 	printf("    Dirty State : %s\n", dev->vol.dirty ? "dirty" : "clean");
+
+	if (is_isrt_leg(dv)) {
+		printf("\n");
+		examine_cache(super, dv);
+	}
 }
 
 static void print_imsm_disk(struct imsm_disk *disk, int index, __u32 reserved)
@@ -1443,13 +1562,12 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 		       (unsigned long long) __le64_to_cpu(log->first_spare_lba));
 	}
 	for (i = 0; i < mpb->num_raid_devs; i++) {
+		struct intel_dev *dv = get_intel_dev(super, i);
 		struct mdinfo info;
-		struct imsm_dev *dev = __get_imsm_dev(mpb, i);
 
 		super->current_vol = i;
 		getinfo_super_imsm(st, &info, NULL);
-		fname_from_uuid(st, &info, nbuf, ':');
-		print_imsm_dev(super, dev, nbuf + 5, super->disks->index);
+		print_imsm_dev(super, dv, &info, super->disks->index);
 	}
 	for (i = 0; i < mpb->num_disks; i++) {
 		if (i == super->disks->index)
@@ -1466,7 +1584,6 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 
 static void brief_examine_super_imsm(struct supertype *st, int verbose)
 {
-	/* We just write a generic IMSM ARRAY entry */
 	struct mdinfo info;
 	char nbuf[64];
 	struct intel_super *super = st->sb;
@@ -1481,14 +1598,28 @@ static void brief_examine_super_imsm(struct supertype *st, int verbose)
 	printf("ARRAY metadata=imsm UUID=%s\n", nbuf + 5);
 }
 
+static void brief_examine_cache_imsm(struct supertype *st, int cache_leg)
+{
+	int uuid[4];
+	char nbuf[64];
+	struct intel_super *super = st->sb;
+	struct intel_dev *dv = get_isrt_leg(super, cache_leg);
+
+	if (!dv)
+		return;
+
+	cache_volume_uuid(super, dv, uuid);
+	__fname_from_uuid(uuid, 0, nbuf, ':');
+	printf("ARRAY UUID=%s\n", nbuf + 5);
+}
+
 static void brief_examine_subarrays_imsm(struct supertype *st, int verbose)
 {
-	/* We just write a generic IMSM ARRAY entry */
-	struct mdinfo info;
+	int i;
 	char nbuf[64];
 	char nbuf1[64];
+	struct mdinfo info;
 	struct intel_super *super = st->sb;
-	int i;
 
 	if (!super->anchor->num_raid_devs)
 		return;
@@ -1496,13 +1627,13 @@ static void brief_examine_subarrays_imsm(struct supertype *st, int verbose)
 	getinfo_super_imsm(st, &info, NULL);
 	fname_from_uuid(st, &info, nbuf, ':');
 	for (i = 0; i < super->anchor->num_raid_devs; i++) {
-		struct imsm_dev *dev = get_imsm_dev(super, i);
+		struct intel_dev *dv = get_intel_dev(super, i);
 
 		super->current_vol = i;
 		getinfo_super_imsm(st, &info, NULL);
 		fname_from_uuid(st, &info, nbuf1, ':');
 		printf("ARRAY /dev/md/%.16s container=%s member=%d UUID=%s\n",
-		       dev->volume, nbuf + 5, i, nbuf1 + 5);
+		       dv->dev->volume, nbuf + 5, i, nbuf1 + 5);
 	}
 }
 
@@ -2827,12 +2958,12 @@ static struct imsm_disk *get_imsm_missing(struct intel_super *super, __u8 index)
 
 static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *map)
 {
-	struct intel_super *super = st->sb;
-	struct imsm_disk *disk;
-	int map_disks = info->array.raid_disks;
-	int max_enough = -1;
 	int i;
+	struct imsm_disk *disk;
 	struct imsm_super *mpb;
+	struct intel_super *super = st->sb;
+	int max_enough = -1, cache_legs = 0;
+	int map_disks = info->array.raid_disks;
 
 	if (super->current_vol >= 0) {
 		getinfo_super_imsm_volume(st, info, map);
@@ -2869,7 +3000,8 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 	mpb = super->anchor;
 
 	for (i = 0; i < mpb->num_raid_devs; i++) {
-		struct imsm_dev *dev = get_imsm_dev(super, i);
+		struct intel_dev *dv = get_intel_dev(super, i);
+		struct imsm_dev *dev = dv->dev;
 		int failed, enough, j, missing = 0;
 		struct imsm_map *map;
 		__u8 state;
@@ -2877,6 +3009,8 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 		failed = imsm_count_failed(super, dev, MAP_0);
 		state = imsm_check_degraded(super, dev, failed, MAP_0);
 		map = get_imsm_map(dev, MAP_0);
+		if (is_isrt_leg(dv))
+			cache_legs++;
 
 		/* any newly missing disks?
 		 * (catches single-degraded vs double-degraded)
@@ -2917,6 +3051,7 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 	}
 	dprintf("%s: enough: %d\n", __func__, max_enough);
 	info->container_enough = max_enough;
+	info->cache_legs = cache_legs;
 
 	if (super->disks) {
 		__u32 reserved = imsm_reserved_sectors(super, super->disks);
@@ -10578,6 +10713,7 @@ struct superswitch super_imsm = {
 	.examine_super	= examine_super_imsm,
 	.brief_examine_super = brief_examine_super_imsm,
 	.brief_examine_subarrays = brief_examine_subarrays_imsm,
+	.brief_examine_cache = brief_examine_cache_imsm,
 	.export_examine_super = export_examine_super_imsm,
 	.detail_super	= detail_super_imsm,
 	.brief_detail_super = brief_detail_super_imsm,

