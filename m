From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2 2/7] Generic support for --rwh-policy and PPL
Date: Mon,  5 Dec 2016 16:31:59 +0100
Message-ID: <20161205153204.7343-3-artur.paszkiewicz@intel.com>
References: <20161205153204.7343-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153204.7343-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Add a new parameter to mdadm: --rwh-policy=. It can be used to create a
raid5 array using PPL. Add the necessary plumbing to pass this option to
metadata handlers. The write journal functionality is treated as a
different RWH policy, which is implicitly selected when using
--write-journal.

Show the currently enabled RWH policy type in the output from
mdadm --detail. The value is retrieved from the array's sysfs attribute
'rwh_policy'.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 Create.c      |  7 ++++++-
 Detail.c      | 18 ++++++++++++++++--
 Kill.c        |  2 +-
 ReadMe.c      |  1 +
 maps.c        |  7 +++++++
 mdadm.c       | 35 ++++++++++++++++++++++++++++++++---
 mdadm.h       | 15 +++++++++++++--
 super-ddf.c   |  4 ++--
 super-intel.c | 12 ++++++------
 super0.c      |  6 +++---
 super1.c      |  4 ++--
 sysfs.c       | 11 +++++++++++
 12 files changed, 100 insertions(+), 22 deletions(-)

diff --git a/Create.c b/Create.c
index 2721884..ebbdd94 100644
--- a/Create.c
+++ b/Create.c
@@ -594,6 +594,11 @@ int Create(struct supertype *st, char *mddev,
 		return 1;
 	}
 
+	if (s->rwh_policy == RWH_POLICY_PPL && !st->ss->supports_ppl) {
+		pr_err("%s metadata does not support PPL\n", st->ss->name);
+		return 1;
+	}
+
 	/* We need to create the device */
 	map_lock(&map);
 	mdfd = create_mddev(mddev, name, c->autof, LOCAL, chosen_name);
@@ -720,7 +725,7 @@ int Create(struct supertype *st, char *mddev,
 				name += 2;
 		}
 	}
-	if (!st->ss->init_super(st, &info.array, s->size, name, c->homehost, uuid,
+	if (!st->ss->init_super(st, &info.array, s, name, c->homehost, uuid,
 				data_offset))
 		goto abort_locked;
 
diff --git a/Detail.c b/Detail.c
index 509b0d4..0c88e77 100644
--- a/Detail.c
+++ b/Detail.c
@@ -504,15 +504,29 @@ int Detail(char *dev, struct context *c)
 		case 10:
 		case 6:
 			if (array.chunk_size)
-				printf("     Chunk Size : %dK\n\n",
+				printf("     Chunk Size : %dK\n",
 				       array.chunk_size/1024);
 			break;
 		case -1:
-			printf("       Rounding : %dK\n\n", array.chunk_size/1024);
+			printf("       Rounding : %dK\n", array.chunk_size/1024);
 			break;
 		default: break;
 		}
 
+		if (array.level == 4 || array.level == 5 || array.level == 6) {
+			struct mdinfo *mdi = sysfs_read(fd, NULL,
+							GET_RWH_POLICY);
+			if (mdi) {
+				char *rwh_policy = map_num(rwh_policies,
+							   mdi->rwh_policy);
+				sysfs_free(mdi);
+				if (rwh_policy)
+					printf("     RWH Policy : %s\n",
+					       rwh_policy);
+			}
+		}
+		printf("\n");
+
 		if (e && e->percent >= 0) {
 			static char *sync_action[] = {
 				"Rebuild", "Resync",
diff --git a/Kill.c b/Kill.c
index f2fdb85..ff52561 100644
--- a/Kill.c
+++ b/Kill.c
@@ -63,7 +63,7 @@ int Kill(char *dev, struct supertype *st, int force, int verbose, int noexcl)
 	rv = st->ss->load_super(st, fd, dev);
 	if (rv == 0 || (force && rv >= 2)) {
 		st->ss->free_super(st);
-		st->ss->init_super(st, NULL, 0, "", NULL, NULL,
+		st->ss->init_super(st, NULL, NULL, "", NULL, NULL,
 				   INVALID_SECTORS);
 		if (st->ss->store_super(st, fd)) {
 			if (verbose >= 0)
diff --git a/ReadMe.c b/ReadMe.c
index 8da49ef..5eb28a3 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -145,6 +145,7 @@ struct option long_options[] = {
     {"nodes",1, 0, Nodes}, /* also for --assemble */
     {"home-cluster",1, 0, ClusterName},
     {"write-journal",1, 0, WriteJournal},
+    {"rwh-policy",1, 0, RwhPolicy},
 
     /* For assemble */
     {"uuid",      1, 0, 'u'},
diff --git a/maps.c b/maps.c
index 64f1df2..2e8dd9e 100644
--- a/maps.c
+++ b/maps.c
@@ -129,6 +129,13 @@ mapping_t faultylayout[] = {
 	{ NULL, 0}
 };
 
+mapping_t rwh_policies[] = {
+	{ "off", RWH_POLICY_OFF},
+	{ "journal", RWH_POLICY_JOURNAL},
+	{ "ppl", RWH_POLICY_PPL},
+	{ NULL, 0}
+};
+
 char *map_num(mapping_t *map, int num)
 {
 	while (map->name) {
diff --git a/mdadm.c b/mdadm.c
index c3a265b..2b6d3a2 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -78,6 +78,7 @@ int main(int argc, char *argv[])
 		.level		= UnSet,
 		.layout		= UnSet,
 		.bitmap_chunk	= UnSet,
+		.rwh_policy	= UnSet,
 	};
 
 	char sys_hostname[256];
@@ -1209,6 +1210,13 @@ int main(int argc, char *argv[])
 
 			s.journaldisks = 1;
 			continue;
+		case O(CREATE, RwhPolicy):
+			s.rwh_policy = map_name(rwh_policies, optarg);
+			if (s.rwh_policy == UnSet) {
+				pr_err("Invalid RWH policy: %s\n", optarg);
+				exit(2);
+			}
+			continue;
 		}
 		/* We have now processed all the valid options. Anything else is
 		 * an error
@@ -1236,9 +1244,30 @@ int main(int argc, char *argv[])
 		exit(0);
 	}
 
-	if (s.journaldisks && (s.level < 4 || s.level > 6)) {
-		pr_err("--write-journal is only supported for RAID level 4/5/6.\n");
-		exit(2);
+	if (s.journaldisks) {
+		if (s.level < 4 || s.level > 6) {
+			pr_err("--write-journal is only supported for RAID level 4/5/6.\n");
+			exit(2);
+		}
+		if (s.rwh_policy == UnSet) {
+			s.rwh_policy = RWH_POLICY_JOURNAL;
+		} else if (s.rwh_policy != RWH_POLICY_JOURNAL) {
+			pr_err("--write-journal is not supported with RWH policy: %s\n",
+			       map_num(rwh_policies, s.rwh_policy));
+			exit(2);
+		}
+	}
+
+	if (mode == CREATE && s.rwh_policy != UnSet) {
+		if (s.level < 4 || s.level > 6) {
+			pr_err("--rwh-policy is only supported for RAID level 4/5/6.\n");
+			exit(2);
+		}
+		if (s.rwh_policy == RWH_POLICY_JOURNAL && !s.journaldisks) {
+			pr_err("--write-journal is required for RWH policy: %s\n",
+			       map_num(rwh_policies, s.rwh_policy));
+			exit(2);
+		}
 	}
 
 	if (!mode && devs_found) {
diff --git a/mdadm.h b/mdadm.h
index 71b8afb..fee07ef 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -279,6 +279,13 @@ struct mdinfo {
 	int journal_device_required;
 	int journal_clean;
 
+	enum {
+		RWH_POLICY_UNKNOWN,
+		RWH_POLICY_OFF,
+		RWH_POLICY_JOURNAL,
+		RWH_POLICY_PPL,
+	} rwh_policy;
+
 	/* During reshape we can sometimes change the data_offset to avoid
 	 * over-writing still-valid data.  We need to know if there is space.
 	 * So getinfo_super will fill in space_before and space_after in sectors.
@@ -426,6 +433,7 @@ enum special_options {
 	ClusterName,
 	ClusterConfirm,
 	WriteJournal,
+	RwhPolicy,
 };
 
 enum prefix_standard {
@@ -527,6 +535,7 @@ struct shape {
 	int	assume_clean;
 	int	write_behind;
 	unsigned long long size;
+	int	rwh_policy;
 };
 
 /* List of device names - wildcards expanded */
@@ -618,6 +627,7 @@ enum sysfs_read_flags {
 	GET_STATE	= (1 << 23),
 	GET_ERROR	= (1 << 24),
 	GET_ARRAY_STATE = (1 << 25),
+	GET_RWH_POLICY	= (1 << 26),
 };
 
 /* If fd >= 0, get the array it is open on,
@@ -701,7 +711,7 @@ extern int restore_stripes(int *dest, unsigned long long *offsets,
 
 extern char *map_num(mapping_t *map, int num);
 extern int map_name(mapping_t *map, char *name);
-extern mapping_t r5layout[], r6layout[], pers[], modes[], faultylayout[];
+extern mapping_t r5layout[], r6layout[], pers[], modes[], faultylayout[], rwh_policies[];
 
 extern char *map_dev_preferred(int major, int minor, int create,
 			       char *prefer);
@@ -863,7 +873,7 @@ extern struct superswitch {
 	 * metadata.
 	 */
 	int (*init_super)(struct supertype *st, mdu_array_info_t *info,
-			  unsigned long long size, char *name,
+			  struct shape *s, char *name,
 			  char *homehost, int *uuid,
 			  unsigned long long data_offset);
 
@@ -1070,6 +1080,7 @@ extern struct superswitch {
 	/* get list of bad blocks from metadata */
 	struct md_bb *(*get_bad_blocks)(struct active_array *a, int n);
 
+	int supports_ppl;
 	int swapuuid; /* true if uuid is bigending rather than hostendian */
 	int external;
 	const char *name; /* canonical metadata name */
diff --git a/super-ddf.c b/super-ddf.c
index 1707ad1..18e1e77 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2290,7 +2290,7 @@ static unsigned int find_vde_by_guid(const struct ddf_super *ddf,
 
 static int init_super_ddf(struct supertype *st,
 			  mdu_array_info_t *info,
-			  unsigned long long size, char *name, char *homehost,
+			  struct shape *s, char *name, char *homehost,
 			  int *uuid, unsigned long long data_offset)
 {
 	/* This is primarily called by Create when creating a new array.
@@ -2328,7 +2328,7 @@ static int init_super_ddf(struct supertype *st,
 	struct virtual_disk *vd;
 
 	if (st->sb)
-		return init_super_ddf_bvd(st, info, size, name, homehost, uuid,
+		return init_super_ddf_bvd(st, info, s->size, name, homehost, uuid,
 					  data_offset);
 
 	if (posix_memalign((void**)&ddf, 512, sizeof(*ddf)) != 0) {
diff --git a/super-intel.c b/super-intel.c
index af769a1..e3ada74 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5169,7 +5169,7 @@ static int check_name(struct intel_super *super, char *name, int quiet)
 }
 
 static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
-				  unsigned long long size, char *name,
+				  struct shape *s, char *name,
 				  char *homehost, int *uuid,
 				  long long data_offset)
 {
@@ -5264,7 +5264,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	strncpy((char *) dev->volume, name, MAX_RAID_SERIAL_LEN);
 	array_blocks = calc_array_size(info->level, info->raid_disks,
 					       info->layout, info->chunk_size,
-					       size * 2);
+					       s->size * 2);
 	/* round array size down to closest MB */
 	array_blocks = (array_blocks >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
 
@@ -5278,7 +5278,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	vol->curr_migr_unit = 0;
 	map = get_imsm_map(dev, MAP_0);
 	set_pba_of_lba0(map, super->create_offset);
-	set_blocks_per_member(map, info_to_blocks_per_member(info, size));
+	set_blocks_per_member(map, info_to_blocks_per_member(info, s->size));
 	map->blocks_per_strip = __cpu_to_le16(info_to_blocks_per_strip(info));
 	map->failed_disk_num = ~0;
 	if (info->level > 0)
@@ -5306,7 +5306,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 		map->num_domains = 1;
 
 	/* info->size is only int so use the 'size' parameter instead */
-	num_data_stripes = (size * 2) / info_to_blocks_per_strip(info);
+	num_data_stripes = (s->size * 2) / info_to_blocks_per_strip(info);
 	num_data_stripes /= map->num_domains;
 	set_num_data_stripes(map, num_data_stripes);
 
@@ -5328,7 +5328,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 }
 
 static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
-			   unsigned long long size, char *name,
+		           struct shape *s, char *name,
 			   char *homehost, int *uuid,
 			   unsigned long long data_offset)
 {
@@ -5351,7 +5351,7 @@ static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
 	}
 
 	if (st->sb)
-		return init_super_imsm_volume(st, info, size, name, homehost, uuid,
+		return init_super_imsm_volume(st, info, s, name, homehost, uuid,
 					      data_offset);
 
 	if (info)
diff --git a/super0.c b/super0.c
index 938cfd9..e252c88 100644
--- a/super0.c
+++ b/super0.c
@@ -725,7 +725,7 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
  * We use the first 8 bytes (64bits) of the sha1 of the host name
  */
 static int init_super0(struct supertype *st, mdu_array_info_t *info,
-		       unsigned long long size, char *ignored_name,
+		       struct shape *s, char *ignored_name,
 		       char *homehost, int *uuid,
 		       unsigned long long data_offset)
 {
@@ -764,8 +764,8 @@ static int init_super0(struct supertype *st, mdu_array_info_t *info,
 	sb->gvalid_words = 0; /* ignored */
 	sb->ctime = time(0);
 	sb->level = info->level;
-	sb->size = size;
-	if (size != (unsigned long long)sb->size)
+	sb->size = s->size;
+	if (s->size != (unsigned long long)sb->size)
 		return 0;
 	sb->nr_disks = info->nr_disks;
 	sb->raid_disks = info->raid_disks;
diff --git a/super1.c b/super1.c
index 87a74cb..edd4a1d 100644
--- a/super1.c
+++ b/super1.c
@@ -1397,7 +1397,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 }
 
 static int init_super1(struct supertype *st, mdu_array_info_t *info,
-		       unsigned long long size, char *name, char *homehost,
+		       struct shape *s, char *name, char *homehost,
 		       int *uuid, unsigned long long data_offset)
 {
 	struct mdp_superblock_1 *sb;
@@ -1450,7 +1450,7 @@ static int init_super1(struct supertype *st, mdu_array_info_t *info,
 	sb->ctime = __cpu_to_le64((unsigned long long)time(0));
 	sb->level = __cpu_to_le32(info->level);
 	sb->layout = __cpu_to_le32(info->layout);
-	sb->size = __cpu_to_le64(size*2ULL);
+	sb->size = __cpu_to_le64(s->size*2ULL);
 	sb->chunksize = __cpu_to_le32(info->chunk_size>>9);
 	sb->raid_disks = __cpu_to_le32(info->raid_disks);
 
diff --git a/sysfs.c b/sysfs.c
index 84c7348..f88461c 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -242,6 +242,17 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 	} else
 		sra->sysfs_array_state[0] = 0;
 
+	if (options & GET_RWH_POLICY) {
+		strcpy(base, "rwh_policy");
+		if (load_sys(fname, buf, sizeof(buf))) {
+			sra->rwh_policy = RWH_POLICY_UNKNOWN;
+		} else {
+			sra->rwh_policy = map_name(rwh_policies, buf);
+			if (sra->rwh_policy == UnSet)
+				sra->rwh_policy = RWH_POLICY_UNKNOWN;
+		}
+	}
+
 	if (! (options & GET_DEVS))
 		return sra;
 
-- 
2.10.1

