From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC mdadm PATCH 10/11] imsm: assemble cache volumes
Date: Thu, 24 Apr 2014 00:23:12 -0700
Message-ID: <20140424072312.4515.57828.stgit@viggo.jf.intel.com>
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

Teach load_super to examine the passed in fd and determine if it is a
cache or cache-target md device.

Generate info to allow the two halves of the cache to be assembled.

XXX: what are the rules we need for compare_super to determine stale
cache associations?

Create a LEVEL_ISRT md device.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 isrt-intel.h  |    2 +
 maps.c        |    1 
 mdadm.h       |    1 
 super-intel.c |  191 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 sysfs.c       |    8 ++
 util.c        |    1 
 6 files changed, 198 insertions(+), 6 deletions(-)

diff --git a/isrt-intel.h b/isrt-intel.h
index 6d7e92f4da37..ea106c5ac02c 100644
--- a/isrt-intel.h
+++ b/isrt-intel.h
@@ -28,6 +28,8 @@ enum {
 	NVC_SIG_LEN = 32,
 	ISRT_DEV_IDX = 0,
 	ISRT_TARGET_DEV_IDX = 1,
+	ISRT_ROLE_CACHE = 0,
+	ISRT_ROLE_TARGET = 1,
 
 	NV_CACHE_MODE_OFF          = 0,
 	NV_CACHE_MODE_OFF_TO_SAFE  = 1, /* powerfail recovery state */
diff --git a/maps.c b/maps.c
index 64f1df2c42c3..28c010fdf9bf 100644
--- a/maps.c
+++ b/maps.c
@@ -93,6 +93,7 @@ mapping_t pers[] = {
 	{ "10", 10},
 	{ "faulty", LEVEL_FAULTY},
 	{ "container", LEVEL_CONTAINER},
+	{ "isrt", LEVEL_ISRT },
 	{ NULL, 0}
 };
 
diff --git a/mdadm.h b/mdadm.h
index 111f90f599af..e613d3866d8b 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1457,6 +1457,7 @@ char *xstrdup(const char *str);
 #define	LEVEL_MULTIPATH		(-4)
 #define	LEVEL_LINEAR		(-1)
 #define	LEVEL_FAULTY		(-5)
+#define	LEVEL_ISRT		(-12)
 
 /* kernel module doesn't know about these */
 #define LEVEL_CONTAINER		(-100)
diff --git a/super-intel.c b/super-intel.c
index 7a7a48e9e6d7..e69d2a044e92 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -379,6 +379,8 @@ struct intel_super {
 	int updates_pending; /* count of pending updates for mdmon */
 	int current_vol; /* index of raid device undergoing creation */
 	unsigned long long create_offset; /* common start for 'current_vol' */
+	int load_cache; /* flag to indicate we are operating on the cache metadata */
+	int cache_dev; /* subarray/volume index of the cache volume */
 	__u32 random; /* random data for seeding new family numbers */
 	struct intel_dev *devlist;
 	struct dl {
@@ -1246,6 +1248,9 @@ static void print_imsm_dev(struct intel_super *super, struct intel_dev *dv,
 	struct imsm_map *map = get_imsm_map(dev, MAP_0);
 	struct imsm_map *map2 = get_imsm_map(dev, MAP_1);
 
+	if (super->load_cache)
+		examine_cache(super, dv);
+
 	printf("\n");
 	printf("[%.16s]:\n", dev->volume);
 	__fname_from_uuid(info->uuid, 0, uuid_str, ':');
@@ -1339,7 +1344,7 @@ static void print_imsm_dev(struct intel_super *super, struct intel_dev *dv,
 	printf("\n");
 	printf("    Dirty State : %s\n", dev->vol.dirty ? "dirty" : "clean");
 
-	if (is_isrt_leg(dv)) {
+	if (!super->load_cache) {
 		printf("\n");
 		examine_cache(super, dv);
 	}
@@ -1514,6 +1519,8 @@ static int imsm_check_attributes(__u32 attributes)
 
 #ifndef MDASSEMBLE
 static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *map);
+static void getinfo_super_imsm_cache(struct intel_super *super, struct intel_dev *dv,
+				     struct mdinfo *info, char *map);
 
 static void examine_super_imsm(struct supertype *st, char *homehost)
 {
@@ -1527,6 +1534,18 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	__u32 reserved = imsm_reserved_sectors(super, super->disks);
 	struct dl *dl;
 
+	if (super->load_cache) {
+		struct intel_dev *dv = get_intel_dev(super, super->cache_dev);
+		struct mdinfo info;
+
+		super->load_cache = 0;
+		super->current_vol = super->cache_dev;
+		getinfo_super_imsm(st, &info, NULL);
+		super->load_cache = 1;
+		print_imsm_dev(super, dv, &info, super->disks->index);
+		return;
+	}
+
 	snprintf(str, MPB_SIG_LEN, "%s", mpb->sig);
 	printf("          Magic : %s\n", str);
 	snprintf(str, strlen(MPB_VERSION_RAID0), "%s", get_imsm_version(mpb));
@@ -1595,21 +1614,24 @@ static void brief_examine_super_imsm(struct supertype *st, int verbose)
 
 	getinfo_super_imsm(st, &info, NULL);
 	fname_from_uuid(st, &info, nbuf, ':');
-	printf("ARRAY metadata=imsm UUID=%s\n", nbuf + 5);
+	if (super->load_cache)
+		printf("ARRAY UUID=%s\n", nbuf + 5);
+	else
+		printf("ARRAY metadata=imsm UUID=%s\n", nbuf + 5);
 }
 
 static void brief_examine_cache_imsm(struct supertype *st, int cache_leg)
 {
-	int uuid[4];
 	char nbuf[64];
+	struct mdinfo info;
 	struct intel_super *super = st->sb;
 	struct intel_dev *dv = get_isrt_leg(super, cache_leg);
 
 	if (!dv)
 		return;
 
-	cache_volume_uuid(super, dv, uuid);
-	__fname_from_uuid(uuid, 0, nbuf, ':');
+	getinfo_super_imsm_cache(super, dv, &info, NULL);
+	fname_from_uuid(st, &info, nbuf, ':');
 	printf("ARRAY UUID=%s\n", nbuf + 5);
 }
 
@@ -1621,6 +1643,10 @@ static void brief_examine_subarrays_imsm(struct supertype *st, int verbose)
 	struct mdinfo info;
 	struct intel_super *super = st->sb;
 
+	/* don't re-report container metadata info */
+	if (super->load_cache)
+		return;
+
 	if (!super->anchor->num_raid_devs)
 		return;
 
@@ -2956,6 +2982,71 @@ static struct imsm_disk *get_imsm_missing(struct intel_super *super, __u8 index)
 	return NULL;
 }
 
+static void getinfo_super_imsm_cache(struct intel_super *super, struct intel_dev *dv,
+				     struct mdinfo *info, char *dmap)
+{
+	__u16 nv_cache_mode;
+	int role_failed = 0, role;
+	struct imsm_dev *dev = dv->dev;
+	struct imsm_map *map = get_imsm_map(dev, MAP_X);
+
+	memset(info, 0, sizeof(*info));
+
+	role = dv->nvc ? ISRT_ROLE_CACHE : ISRT_ROLE_TARGET;
+	if (role == ISRT_ROLE_CACHE) {
+		struct nv_cache_vol_config_md *cfg = &dv->nvc->hdr.vol_config_md[0];
+
+		nv_cache_mode = cfg->nv_cache_mode;
+		info->events = 0;
+	} else {
+		nv_cache_mode = dev->nv_cache_mode;
+		info->events = 1; /* make Assemble choose the cache target */
+	}
+
+	if (map->map_state == IMSM_T_STATE_FAILED ||
+	    nv_cache_mode == NV_CACHE_MODE_IS_FAILING ||
+	    nv_cache_mode == NV_CACHE_MODE_HAS_FAILED)
+		role_failed = 1;
+
+	info->array.raid_disks    = 2;
+	info->array.level         = LEVEL_ISRT;
+	info->array.layout        = 0;
+	info->array.md_minor      = -1;
+	info->array.ctime         = 0;
+	info->array.utime         = 0;
+	info->array.chunk_size    = 0;
+
+	info->disk.major = 0;
+	info->disk.minor = 0;
+	info->disk.raid_disk = role;
+	info->reshape_active = 0;
+	info->array.major_version = -1;
+	info->array.minor_version = -2;
+	strcpy(info->text_version, "isrt");
+	info->safe_mode_delay = 0;
+	info->disk.number = role;
+	info->name[0] = 0;
+	info->recovery_start = MaxSector;
+	info->data_offset = 0;
+	info->custom_array_size = __le32_to_cpu(dev->size_high);
+	info->custom_array_size <<= 32;
+	info->custom_array_size |= __le32_to_cpu(dev->size_low);
+	info->component_size = info->custom_array_size;
+
+	if (role_failed)
+		info->disk.state = (1 << MD_DISK_FAULTY);
+	else
+		info->disk.state = (1 << MD_DISK_ACTIVE) | (1 << MD_DISK_SYNC);
+	cache_volume_uuid(super, dv, info->uuid);
+
+	if (dmap) {
+		/* we can only report self-state */
+		dmap[!role] = 1;
+		dmap[role] = !role_failed;
+	}
+}
+
+
 static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *map)
 {
 	int i;
@@ -2965,6 +3056,20 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 	int max_enough = -1, cache_legs = 0;
 	int map_disks = info->array.raid_disks;
 
+	if (super->load_cache || st->cache_leg) {
+		struct intel_dev *dv;
+
+		if (st->cache_leg) {
+			dv = get_isrt_leg(super, st->cache_leg);
+			if (!dv)
+				return;
+		} else
+			dv = get_intel_dev(super, super->cache_dev);
+
+		getinfo_super_imsm_cache(super, dv, info, map);
+		return;
+	}
+
 	if (super->current_vol >= 0) {
 		getinfo_super_imsm_volume(st, info, map);
 		return;
@@ -3266,6 +3371,27 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst)
 		}
 	}
 
+	/* cache configuration metadata lives on member arrays, as long
+	 * as they mutually agree on the volume-uuid then consider them a match
+	 * XXX: sufficient? we do have the failure checks in
+	 * getinfo_super_cache() to mitigate
+	 */
+	if (first->load_cache != sec->load_cache)
+		return 3;
+	else if (first->load_cache) {
+		struct intel_dev *first_dv, *sec_dv;
+		int first_uuid[4], sec_uuid[4];
+
+		first_dv = get_intel_dev(first, first->cache_dev);
+		sec_dv = get_intel_dev(sec, sec->cache_dev);
+		cache_volume_uuid(first, first_dv, first_uuid);
+		cache_volume_uuid(sec, sec_dv, sec_uuid);
+		if (memcmp(first_uuid, sec_uuid, sizeof(first_uuid)))
+			return 3;
+		else
+			return 0;
+	}
+
 	/* if an anchor does not have num_raid_devs set then it is a free
 	 * floating spare
 	 */
@@ -4621,6 +4747,52 @@ static int load_container_imsm(struct supertype *st, int fd, char *devname)
 {
 	return load_super_imsm_all(st, fd, &st->sb, devname, NULL, 1);
 }
+
+static int load_super_cache(struct supertype *st, int fd, char *devname)
+{
+	struct mdinfo *sra = sysfs_read(fd, 0, GET_VERSION);
+	char *subarray, *devnm, *ep;
+	int cfd, cache_dev, err = 1;
+	struct intel_super *super;
+	struct intel_dev *dv;
+
+	if (sra && sra->array.major_version == -1 &&
+	    is_subarray(sra->text_version))
+		/* pass */;
+	else
+		goto out;
+
+	/* modify sra->text_version in place */
+	ep = strchr(sra->text_version+1, '/');
+	*ep = '\0';
+	devnm = sra->text_version+1;
+	subarray = ep+1;
+
+	cfd = open_dev(devnm);
+	if (cfd < 0)
+		goto out;
+
+	err = load_container_imsm(st, cfd, devname);
+	close(cfd);
+	if (err)
+		goto out;
+
+	super = st->sb;
+	cache_dev = strtoul(subarray, &ep, 10);
+	/* validate this volume is a cache or cache-target */
+	if (*ep != '\0' || !(dv = get_intel_dev(super, cache_dev))
+	    || !is_isrt_leg(dv)) {
+		free_super_imsm(st);
+		err = 2;
+		goto out;
+	}
+
+	super->load_cache = 1;
+	super->cache_dev = cache_dev;
+ out:
+	sysfs_free(sra);
+	return err;
+}
 #endif
 
 static int load_super_imsm(struct supertype *st, int fd, char *devname)
@@ -4634,6 +4806,15 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 
 	free_super_imsm(st);
 
+#ifndef MDASSEMBLE
+	/* check if this is a component leg of a cache array and load
+	 * the cache metadata from the parent container
+	 */
+	rv = load_super_cache(st, fd, devname);
+	if (rv == 0)
+		return rv;
+#endif
+
 	super = alloc_super();
 	/* Load hba and capabilities if they exist.
 	 * But do not preclude loading metadata in case capabilities or hba are
diff --git a/sysfs.c b/sysfs.c
index 4cbd4e5d051b..898edde49392 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -638,7 +638,13 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 	rv |= sysfs_set_num(info, NULL, "raid_disks", raid_disks);
 	rv |= sysfs_set_num(info, NULL, "chunk_size", info->array.chunk_size);
 	rv |= sysfs_set_num(info, NULL, "layout", info->array.layout);
-	rv |= sysfs_set_num(info, NULL, "component_size", info->component_size/2);
+	if (info->array.level == LEVEL_ISRT) {
+		/* FIXME: how do we support asymmetric component sizes for
+		 * external metadata?
+		 */
+		rv |= sysfs_set_num(info, NULL, "component_size", 0);
+	} else
+		rv |= sysfs_set_num(info, NULL, "component_size", info->component_size/2);
 	if (info->custom_array_size) {
 		int rc;
 
diff --git a/util.c b/util.c
index 93f9200fa4c7..c9c4dec0fac1 100644
--- a/util.c
+++ b/util.c
@@ -362,6 +362,7 @@ int enough(int level, int raid_disks, int layout, int clean, char *avail)
 
 	case LEVEL_MULTIPATH:
 		return avail_disks>= 1;
+	case LEVEL_ISRT:
 	case LEVEL_LINEAR:
 	case 0:
 		return avail_disks == raid_disks;

