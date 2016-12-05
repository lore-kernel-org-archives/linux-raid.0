From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2 4/7] super1: PPL support
Date: Mon,  5 Dec 2016 16:32:01 +0100
Message-ID: <20161205153204.7343-5-artur.paszkiewicz@intel.com>
References: <20161205153204.7343-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153204.7343-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Enable creating and assembling raid5 arrays with PPL for 1.1 and 1.2
metadata.

When creating, reserve enough space for PPL and store its size and
location in the superblock and set MD_FEATURE_PPL bit. PPL is stored in
the metadata region reserved for internal write-intent bitmap, so don't
allow using bitmap and PPL together.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 Create.c      | 19 +++++++++++--
 Grow.c        | 15 +++++++++-
 mdadm.h       |  4 ++-
 super-ddf.c   |  2 +-
 super-gpt.c   |  2 +-
 super-intel.c | 10 +++++--
 super-mbr.c   |  2 +-
 super0.c      |  2 +-
 super1.c      | 88 +++++++++++++++++++++++++++++++++++++++++++++++++----------
 9 files changed, 118 insertions(+), 26 deletions(-)

diff --git a/Create.c b/Create.c
index ebbdd94..0168c3a 100644
--- a/Create.c
+++ b/Create.c
@@ -201,6 +201,15 @@ int Create(struct supertype *st, char *mddev,
 		return 1;
 	}
 
+	if (s->rwh_policy == RWH_POLICY_PPL) {
+		if (s->bitmap_file) {
+			pr_err("PPL is not compatible with bitmap\n");
+			return 1;
+		} else {
+			s->bitmap_file = "none";
+		}
+	}
+
 	/* now set some defaults */
 
 	if (s->layout == UnSet) {
@@ -259,7 +268,8 @@ int Create(struct supertype *st, char *mddev,
 	if (st && ! st->ss->validate_geometry(st, s->level, s->layout, s->raiddisks,
 					      &s->chunk, s->size*2,
 					      data_offset, NULL,
-					      &newsize, c->verbose>=0))
+					      &newsize, s->rwh_policy,
+					      c->verbose>=0))
 		return 1;
 
 	if (s->chunk && s->chunk != UnSet) {
@@ -358,7 +368,8 @@ int Create(struct supertype *st, char *mddev,
 						st, s->level, s->layout, s->raiddisks,
 						&s->chunk, s->size*2,
 						dv->data_offset, dname,
-						&freesize, c->verbose > 0)) {
+						&freesize, s->rwh_policy,
+						c->verbose > 0)) {
 				case -1: /* Not valid, message printed, and not
 					  * worth checking any further */
 					exit(2);
@@ -395,6 +406,7 @@ int Create(struct supertype *st, char *mddev,
 						       &s->chunk, s->size*2,
 						       dv->data_offset,
 						       dname, &freesize,
+						       s->rwh_policy,
 						       c->verbose >= 0)) {
 
 				pr_err("%s is not suitable for this array.\n",
@@ -501,7 +513,8 @@ int Create(struct supertype *st, char *mddev,
 						       s->raiddisks,
 						       &s->chunk, minsize*2,
 						       data_offset,
-						       NULL, NULL, 0)) {
+						       NULL, NULL,
+						       s->rwh_policy, 0)) {
 				pr_err("devices too large for RAID level %d\n", s->level);
 				return 1;
 			}
diff --git a/Grow.c b/Grow.c
index 455c5f9..8bfb09c 100755
--- a/Grow.c
+++ b/Grow.c
@@ -290,6 +290,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 	int major = BITMAP_MAJOR_HI;
 	int vers = md_get_version(fd);
 	unsigned long long bitmapsize, array_size;
+	struct mdinfo *mdi;
 
 	if (vers < 9003) {
 		major = BITMAP_MAJOR_HOSTENDIAN;
@@ -389,12 +390,23 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 		free(st);
 		return 1;
 	}
+
+	mdi = sysfs_read(fd, NULL, GET_RWH_POLICY);
+	if (mdi) {
+		if (mdi->rwh_policy == RWH_POLICY_PPL) {
+			pr_err("Cannot add bitmap to array with PPL\n");
+			free(mdi);
+			free(st);
+			return 1;
+		}
+		free(mdi);
+	}
+
 	if (strcmp(s->bitmap_file, "internal") == 0 ||
 	    strcmp(s->bitmap_file, "clustered") == 0) {
 		int rv;
 		int d;
 		int offset_setable = 0;
-		struct mdinfo *mdi;
 		if (st->ss->add_internal_bitmap == NULL) {
 			pr_err("Internal bitmaps not supported with %s metadata\n", st->ss->name);
 			return 1;
@@ -446,6 +458,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 			sysfs_init(mdi, fd, NULL);
 			rv = sysfs_set_num_signed(mdi, NULL, "bitmap/location",
 						  mdi->bitmap_offset);
+			free(mdi);
 		} else {
 			if (strcmp(s->bitmap_file, "clustered") == 0)
 				array.state |= (1 << MD_SB_CLUSTERED);
diff --git a/mdadm.h b/mdadm.h
index 03de402..6d52bdf 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -299,6 +299,8 @@ struct mdinfo {
 		#define MaxSector  (~0ULL) /* resync/recovery complete position */
 	};
 	long			bitmap_offset;	/* 0 == none, 1 == a file */
+	unsigned int		ppl_offset;
+	unsigned int		ppl_sectors;
 	unsigned long		safe_mode_delay; /* ms delay to mark clean */
 	int			new_level, delta_disks, new_layout, new_chunk;
 	int			errors;
@@ -972,7 +974,7 @@ extern struct superswitch {
 				 int *chunk, unsigned long long size,
 				 unsigned long long data_offset,
 				 char *subdev, unsigned long long *freesize,
-				 int verbose);
+				 int rwh_policy, int verbose);
 
 	/* Return a linked list of 'mdinfo' structures for all arrays
 	 * in the container.  For non-containers, it is like
diff --git a/super-ddf.c b/super-ddf.c
index 18e1e77..6184a73 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3347,7 +3347,7 @@ static int validate_geometry_ddf(struct supertype *st,
 				 int *chunk, unsigned long long size,
 				 unsigned long long data_offset,
 				 char *dev, unsigned long long *freesize,
-				 int verbose)
+				 int rwh_policy, int verbose)
 {
 	int fd;
 	struct mdinfo *sra;
diff --git a/super-gpt.c b/super-gpt.c
index 1a2adce..efb0c00 100644
--- a/super-gpt.c
+++ b/super-gpt.c
@@ -195,7 +195,7 @@ static int validate_geometry(struct supertype *st, int level,
 			     int *chunk, unsigned long long size,
 			     unsigned long long data_offset,
 			     char *subdev, unsigned long long *freesize,
-			     int verbose)
+			     int rwh_policy, int verbose)
 {
 	pr_err("gpt metadata cannot be used this way\n");
 	return 0;
diff --git a/super-intel.c b/super-intel.c
index 0c4726a..eb6b543 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3482,9 +3482,13 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 
 		disk = &super->disks->disk;
 		info->data_offset = total_blocks(&super->disks->disk) - reserved;
-		/* mpb anchor sector - see store_imsm_mpb() */
+		/* mpb anchor is located in the second _logical_ sector from
+		 * the end of the drive, here we convert it to 512 byte sectors
+		 * because this value will be passed to the kernel
+		 */
 		info->sb_start = total_blocks(&super->disks->disk) -
 				 ((2 * super->sector_size) >> 9);
+
 		info->component_size = reserved;
 		info->disk.state  = is_configured(disk) ? (1 << MD_DISK_ACTIVE) : 0;
 		/* we don't change info->disk.raid_disk here because
@@ -6935,7 +6939,7 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 				  int raiddisks, int *chunk, unsigned long long size,
 				  unsigned long long data_offset,
 				  char *dev, unsigned long long *freesize,
-				  int verbose)
+				  int rwh_policy, int verbose)
 {
 	int fd, cfd;
 	struct mdinfo *sra;
@@ -10971,7 +10975,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 				    geo->raid_disks + devNumChange,
 				    &chunk,
 				    geo->size, INVALID_SECTORS,
-				    0, 0, 1))
+				    0, 0, info.rwh_policy, 1))
 		change = -1;
 
 	if (check_devs) {
diff --git a/super-mbr.c b/super-mbr.c
index f5e4cea..66d984c 100644
--- a/super-mbr.c
+++ b/super-mbr.c
@@ -193,7 +193,7 @@ static int validate_geometry(struct supertype *st, int level,
 			     int *chunk, unsigned long long size,
 			     unsigned long long data_offset,
 			     char *subdev, unsigned long long *freesize,
-			     int verbose)
+			     int rwh_policy, int verbose)
 {
 	pr_err("mbr metadata cannot be used this way\n");
 	return 0;
diff --git a/super0.c b/super0.c
index e252c88..cc50fb4 100644
--- a/super0.c
+++ b/super0.c
@@ -1267,7 +1267,7 @@ static int validate_geometry0(struct supertype *st, int level,
 			      int *chunk, unsigned long long size,
 			      unsigned long long data_offset,
 			      char *subdev, unsigned long long *freesize,
-			      int verbose)
+			      int rwh_policy, int verbose)
 {
 	unsigned long long ldsize;
 	int fd;
diff --git a/super1.c b/super1.c
index edd4a1d..7cf46a8 100644
--- a/super1.c
+++ b/super1.c
@@ -48,10 +48,18 @@ struct mdp_superblock_1 {
 
 	__u32	chunksize;	/* in 512byte sectors */
 	__u32	raid_disks;
-	__u32	bitmap_offset;	/* sectors after start of superblock that bitmap starts
-				 * NOTE: signed, so bitmap can be before superblock
-				 * only meaningful of feature_map[0] is set.
-				 */
+	union {
+		__u32	bitmap_offset;	/* sectors after start of superblock that bitmap starts
+					 * NOTE: signed, so bitmap can be before superblock
+					 * only meaningful of feature_map[0] is set.
+					 */
+
+		/* only meaningful when feature_map[MD_FEATURE_PPL] is set */
+		struct {
+			__u16 offset; /* sectors after start of superblock that ppl starts */
+			__u16 size; /* PPL size (including header) in sectors */
+		} ppl;
+	};
 
 	/* These are only valid with feature bit '4' */
 	__u32	new_level;	/* new level we are reshaping to		*/
@@ -131,6 +139,7 @@ struct misc_dev_info {
 #define	MD_FEATURE_NEW_OFFSET		64 /* new_offset must be honoured */
 #define	MD_FEATURE_BITMAP_VERSIONED	256 /* bitmap version number checked properly */
 #define	MD_FEATURE_JOURNAL		512 /* support write journal */
+#define	MD_FEATURE_PPL			1024 /* support PPL */
 #define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET	\
 					|MD_FEATURE_RECOVERY_OFFSET	\
 					|MD_FEATURE_RESHAPE_ACTIVE	\
@@ -140,6 +149,7 @@ struct misc_dev_info {
 					|MD_FEATURE_NEW_OFFSET		\
 					|MD_FEATURE_BITMAP_VERSIONED	\
 					|MD_FEATURE_JOURNAL		\
+					|MD_FEATURE_PPL			\
 					)
 
 #ifndef MDASSEMBLE
@@ -289,6 +299,11 @@ static int awrite(struct align_fd *afd, void *buf, int len)
 	return len;
 }
 
+static inline unsigned int choose_ppl_space(int chunk)
+{
+	return 8 + (chunk > 128*2 ? chunk : 128*2);
+}
+
 #ifndef MDASSEMBLE
 static void examine_super1(struct supertype *st, char *homehost)
 {
@@ -392,6 +407,10 @@ static void examine_super1(struct supertype *st, char *homehost)
 	if (sb->feature_map & __cpu_to_le32(MD_FEATURE_BITMAP_OFFSET)) {
 		printf("Internal Bitmap : %ld sectors from superblock\n",
 		       (long)(int32_t)__le32_to_cpu(sb->bitmap_offset));
+	} else if (sb->feature_map & __cpu_to_le32(MD_FEATURE_PPL)) {
+		printf("            PPL : %u sectors at offset %u sectors from superblock\n",
+		       __le16_to_cpu(sb->ppl.size),
+		       __le16_to_cpu(sb->ppl.offset));
 	}
 	if (sb->feature_map & __cpu_to_le32(MD_FEATURE_RESHAPE_ACTIVE)) {
 		printf("  Reshape pos'n : %llu%s\n", (unsigned long long)__le64_to_cpu(sb->reshape_position)/2,
@@ -935,8 +954,12 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 
 	info->data_offset = __le64_to_cpu(sb->data_offset);
 	info->component_size = __le64_to_cpu(sb->size);
-	if (sb->feature_map & __le32_to_cpu(MD_FEATURE_BITMAP_OFFSET))
+	if (sb->feature_map & __le32_to_cpu(MD_FEATURE_BITMAP_OFFSET)) {
 		info->bitmap_offset = (int32_t)__le32_to_cpu(sb->bitmap_offset);
+	} else if (sb->feature_map & __le32_to_cpu(MD_FEATURE_PPL)) {
+		info->ppl_offset = __le16_to_cpu(sb->ppl.offset);
+		info->ppl_sectors = __le16_to_cpu(sb->ppl.size);
+	}
 
 	info->disk.major = 0;
 	info->disk.minor = 0;
@@ -981,6 +1004,11 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 			bmend += size;
 			if (bmend > earliest)
 				earliest = bmend;
+		} else if (info->ppl_offset > 0) {
+			unsigned long long pplend = info->ppl_offset +
+						    info->ppl_sectors;
+			if (pplend > earliest)
+				earliest = pplend;
 		}
 		if (sb->bblog_offset && sb->bblog_size) {
 			unsigned long long bbend = super_offset;
@@ -1074,9 +1102,16 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 	}
 
 	info->array.working_disks = working;
-	if (sb->feature_map & __le32_to_cpu(MD_FEATURE_JOURNAL))
+
+	if (sb->feature_map & __le32_to_cpu(MD_FEATURE_JOURNAL)) {
 		info->journal_device_required = 1;
-	info->journal_clean = 0;
+		info->rwh_policy = RWH_POLICY_JOURNAL;
+	} else if (sb->feature_map & __le32_to_cpu(MD_FEATURE_PPL)) {
+		info->rwh_policy = RWH_POLICY_PPL;
+		info->journal_clean = 1;
+	} else {
+		info->rwh_policy = RWH_POLICY_UNKNOWN;
+	}
 }
 
 static struct mdinfo *container_content1(struct supertype *st, char *subarray)
@@ -1238,6 +1273,9 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		if (sb->feature_map & __cpu_to_le32(MD_FEATURE_BITMAP_OFFSET)) {
 			bitmap_offset = (long)__le32_to_cpu(sb->bitmap_offset);
 			bm_sectors = calc_bitmap_size(bms, 4096) >> 9;
+		} else if (sb->feature_map & __cpu_to_le32(MD_FEATURE_PPL)) {
+			bitmap_offset = (long)__le16_to_cpu(sb->ppl.offset);
+			bm_sectors = (long)__le16_to_cpu(sb->ppl.size);
 		}
 #endif
 		if (sb_offset < data_offset) {
@@ -1471,6 +1509,9 @@ static int init_super1(struct supertype *st, mdu_array_info_t *info,
 
 	memset(sb->dev_roles, 0xff, MAX_SB_SIZE - sizeof(struct mdp_superblock_1));
 
+	if (s->rwh_policy == RWH_POLICY_PPL)
+		sb->feature_map |= __cpu_to_le32(MD_FEATURE_PPL);
+
 	return 1;
 }
 
@@ -1672,7 +1713,7 @@ static int write_empty_r5l_meta_block(struct supertype *st, int fd)
 	crc = crc32c_le(crc, (void *)mb, META_BLOCK_SIZE);
 	mb->checksum = crc;
 
-	if (lseek64(fd, (sb->data_offset) * 512, 0) < 0LL) {
+	if (lseek64(fd, __le64_to_cpu(sb->data_offset) * 512, 0) < 0LL) {
 		pr_err("cannot seek to offset of the meta block\n");
 		goto fail_to_write;
 	}
@@ -1705,7 +1746,7 @@ static int write_init_super1(struct supertype *st)
 
 	for (di = st->info; di; di = di->next) {
 		if (di->disk.state & (1 << MD_DISK_JOURNAL))
-			sb->feature_map |= MD_FEATURE_JOURNAL;
+			sb->feature_map |= __cpu_to_le32(MD_FEATURE_JOURNAL);
 	}
 
 	for (di = st->info; di; di = di->next) {
@@ -1780,6 +1821,11 @@ static int write_init_super1(struct supertype *st)
 					(((char *)sb) + MAX_SB_SIZE);
 			bm_space = calc_bitmap_size(bms, 4096) >> 9;
 			bm_offset = (long)__le32_to_cpu(sb->bitmap_offset);
+		} else if (sb->feature_map & __cpu_to_le32(MD_FEATURE_PPL)) {
+			bm_space = choose_ppl_space(__le32_to_cpu(sb->chunksize));
+			bm_offset = 8;
+			sb->ppl.offset = __cpu_to_le16(bm_offset);
+			sb->ppl.size = __cpu_to_le16(bm_space);
 		} else {
 			bm_space = choose_bm_space(array_size);
 			bm_offset = 8;
@@ -1851,8 +1897,10 @@ static int write_init_super1(struct supertype *st)
 				goto error_out;
 		}
 
-		if (rv == 0 && (__le32_to_cpu(sb->feature_map) & 1))
+		if (rv == 0 &&
+		    (__le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET))
 			rv = st->ss->write_bitmap(st, di->fd, NodeNumUpdate);
+
 		close(di->fd);
 		di->fd = -1;
 		if (rv)
@@ -2120,11 +2168,13 @@ static __u64 avail_size1(struct supertype *st, __u64 devsize,
 		return 0;
 
 #ifndef MDASSEMBLE
-	if (__le32_to_cpu(super->feature_map)&MD_FEATURE_BITMAP_OFFSET) {
+	if (__le32_to_cpu(super->feature_map) & MD_FEATURE_BITMAP_OFFSET) {
 		/* hot-add. allow for actual size of bitmap */
 		struct bitmap_super_s *bsb;
 		bsb = (struct bitmap_super_s *)(((char*)super)+MAX_SB_SIZE);
 		bmspace = calc_bitmap_size(bsb, 4096) >> 9;
+	} else if (__le32_to_cpu(super->feature_map) & MD_FEATURE_PPL) {
+		bmspace = __le16_to_cpu(super->ppl.size);
 	}
 #endif
 	/* Allow space for bad block log */
@@ -2492,7 +2542,7 @@ static int validate_geometry1(struct supertype *st, int level,
 			      int *chunk, unsigned long long size,
 			      unsigned long long data_offset,
 			      char *subdev, unsigned long long *freesize,
-			      int verbose)
+			      int rwh_policy, int verbose)
 {
 	unsigned long long ldsize, devsize;
 	int bmspace;
@@ -2514,6 +2564,14 @@ static int validate_geometry1(struct supertype *st, int level,
 		/* not specified, so time to set default */
 		st->minor_version = 2;
 
+	if (st->minor_version != 2 && st->minor_version != 1 &&
+	    rwh_policy == RWH_POLICY_PPL) {
+		if (verbose)
+			pr_err("1.%d metadata does not support PPL\n",
+			       st->minor_version);
+		return 0;
+	}
+
 	fd = open(subdev, O_RDONLY|O_EXCL, 0);
 	if (fd < 0) {
 		if (verbose)
@@ -2534,8 +2592,9 @@ static int validate_geometry1(struct supertype *st, int level,
 		return 0;
 	}
 
-	/* creating:  allow suitable space for bitmap */
-	bmspace = choose_bm_space(devsize);
+	/* creating:  allow suitable space for bitmap or PPL */
+	bmspace = rwh_policy == RWH_POLICY_PPL ?
+		  choose_ppl_space((*chunk)*2) : choose_bm_space(devsize);
 
 	if (data_offset == INVALID_SECTORS)
 		data_offset = st->data_offset;
@@ -2667,5 +2726,6 @@ struct superswitch super1 = {
 #else
 	.swapuuid = 1,
 #endif
+	.supports_ppl = 1,
 	.name = "1.x",
 };
-- 
2.10.1

