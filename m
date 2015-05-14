From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 3/7] Create write-cache superblock in mdadm --create
Date: Wed, 13 May 2015 23:43:52 -0700
Message-ID: <1431585836-4103033-4-git-send-email-songliubraving@fb.com>
References: <1431585836-4103033-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1431585836-4103033-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, dan.j.williams@intel.com, neilb@suse.de, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids


Signed-off-by: Song Liu <songliubraving@fb.com>
---
 md_p.h   |  72 +++++++++++++++++++++++++++++++
 mdadm.h  |   7 ++-
 super1.c | 148 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 221 insertions(+), 6 deletions(-)

diff --git a/md_p.h b/md_p.h
index f45c4e0..8a30f7b 100644
--- a/md_p.h
+++ b/md_p.h
@@ -197,4 +197,76 @@ static inline __u64 md_event(mdp_super_t *sb) {
 	return (ev<<32)| sb->events_lo;
 }
 
+/* all disk position of below struct start from rdev->start_offset */
+struct r5l_meta_header {
+	__u32 magic;
+	__u32 type;
+	__u32 checksum; /* checksum(metadata block + uuid) */
+	__u32 meta_size;
+	__u64 seq;
+	__u64 position; /* block number the meta is written */
+} __attribute__ ((__packed__));
+
+#define R5LOG_VERSION 0x1
+#define R5LOG_MAGIC 0x6433c509
+
+enum {
+	R5LOG_TYPE_META = 0,
+	R5LOG_TYPE_SUPER = 1,
+	R5LOG_TYPE_FLUSH_START = 2,
+	R5LOG_TYPE_FLUSH_END = 3,
+};
+
+struct r5l_super_block {
+	struct r5l_meta_header header;
+	__u32 version;
+	__u32 stripe_cache_size; /* bytes */
+	__u32 block_size; /* bytes */
+	__u32 stripe_data_size; /* bytes */
+	__u32 chunk_size; /* bytes */
+	__u32 stripe_size; /* bytes */
+	__u32 parity_disks;
+	__u32 zero_padding;
+	__u64 total_blocks; /* block */
+	__u64 first_block; /* block */
+	__u64 last_checkpoint; /* block */
+	__u64 update_time_sec;
+	__u64 update_time_nsec;
+	__u8 meta_checksum_type;
+	__u8 data_checksum_type;
+	__u8 uuid[16];
+	/* fill with 0 */
+} __attribute__ ((__packed__));
+
+enum {
+	R5LOG_CHECKSUM_CRC32 = 0,
+	R5LOG_CHECKSUM_NR = 1,
+};
+
+struct r5l_meta_payload {
+	__u16 payload_type;
+	__u16 payload_flags;
+	__u32 blocks; /* block. For parity, should be 1 or 2 pages */
+	__u64 location; /* sector. For data, it's raid sector.
+			    For parity, it's stripe sector */
+	__u32 data_checksum[]; /* checksum(data + uuid) */
+} __attribute__ ((__packed__));
+
+enum {
+	/* type */
+	R5LOG_PAYLOAD_DATA = 0,
+	R5LOG_PAYLOAD_PARITY = 1,
+	/* flags */
+	R5LOG_PAYLOAD_DISCARD = 1,
+};
+
+struct r5l_meta_block {
+	struct r5l_meta_header header;
+	struct r5l_meta_payload payloads[];
+} __attribute__ ((__packed__));
+
+struct r5l_flush_block {
+	struct r5l_meta_header header;
+	__u64 flush_stripes[]; /* stripe sector */
+} __attribute__ ((__packed__));
 #endif
diff --git a/mdadm.h b/mdadm.h
index d28caa0..d7a205c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -969,6 +969,8 @@ extern struct superswitch {
 	/* validate container after assemble */
 	int (*validate_container)(struct mdinfo *info);
 
+	/* write super block of raid5-cache*/
+	int (*write_r5l_super)(struct supertype *st, int fd);
 	int swapuuid; /* true if uuid is bigending rather than hostendian */
 	int external;
 	const char *name; /* canonical metadata name */
@@ -1033,7 +1035,7 @@ struct supertype {
 	int retry_soon;
 
 	struct mdinfo *devs;
-
+	struct r5l_super_block *r5l_sb;
 };
 
 extern struct supertype *super_by_fd(int fd, char **subarray);
@@ -1585,3 +1587,6 @@ char *xstrdup(const char *str);
 #define INVALID_SECTORS 1
 /* And another special number needed for --data_offset=variable */
 #define VARIABLE_OFFSET 3
+
+#define LOG_BLOCK_SIZE 4096
+extern int ExamineR5LSuper(struct r5l_super_block *sb_blk);
diff --git a/super1.c b/super1.c
index f8a55c6..f2697a8 100644
--- a/super1.c
+++ b/super1.c
@@ -133,6 +133,20 @@ struct misc_dev_info {
 					|MD_FEATURE_RESHAPE_BACKWARDS	\
 					|MD_FEATURE_NEW_OFFSET		\
 					)
+static int write_r5l_super1(struct supertype *st, int fd);
+
+static int role_from_sb(struct mdp_superblock_1 *sb)
+{
+	unsigned int d;
+	int role;
+
+	d = __le32_to_cpu(sb->dev_number);
+	if (d < __le32_to_cpu(sb->max_dev))
+		role = __le16_to_cpu(sb->dev_roles[d]);
+	else
+		role = 0xFFFF;
+	return role;
+}
 
 static unsigned int calc_sb_1_csum(struct mdp_superblock_1 * sb)
 {
@@ -458,11 +472,7 @@ static void examine_super1(struct supertype *st, char *homehost)
 	printf(")\n");
 #endif
 	printf("   Device Role : ");
-	d = __le32_to_cpu(sb->dev_number);
-	if (d < __le32_to_cpu(sb->max_dev))
-		role = __le16_to_cpu(sb->dev_roles[d]);
-	else
-		role = 0xFFFF;
+	role = role_from_sb(sb);
 	if (role >= 0xFFFE)
 		printf("spare\n");
 	else if (role == 0xFFFD)
@@ -1559,8 +1569,11 @@ static int write_init_super1(struct supertype *st)
 	unsigned long long dsize, array_size;
 	unsigned long long sb_offset;
 	unsigned long long data_offset;
+	struct devinfo *cache_di = NULL;
 
 	for (di = st->info; di; di = di->next) {
+		if (di->disk.state & (1 << MD_DISK_WRITECACHE))
+		    cache_di = di;
 		if (di->disk.state & (1 << MD_DISK_FAULTY))
 			continue;
 		if (di->fd < 0)
@@ -1700,11 +1713,17 @@ static int write_init_super1(struct supertype *st)
 		rv = store_super1(st, di->fd);
 		if (rv == 0 && (__le32_to_cpu(sb->feature_map) & 1))
 			rv = st->ss->write_bitmap(st, di->fd);
+
+		if (cache_di == di) {
+			rv = write_r5l_super1(st, cache_di->fd);
+		}
+
 		close(di->fd);
 		di->fd = -1;
 		if (rv)
 			goto error_out;
 	}
+
 error_out:
 	if (rv)
 		pr_err("Failed to write metadata to %s\n",
@@ -1758,6 +1777,7 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 	unsigned long long dsize;
 	unsigned long long sb_offset;
 	struct mdp_superblock_1 *super;
+	struct r5l_super_block *r5l_super;
 	int uuid[4];
 	struct bitmap_super_s *bsb;
 	struct misc_dev_info *misc;
@@ -1848,11 +1868,18 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 		return 1;
 	}
 
+	if (posix_memalign((void**)&r5l_super, 4096, LOG_BLOCK_SIZE) != 0) {
+		pr_err("could not allocate superblock\n");
+		free(super);
+		return 1;
+	}
+
 	if (aread(&afd, super, MAX_SB_SIZE) != MAX_SB_SIZE) {
 		if (devname)
 			pr_err("Cannot read superblock on %s\n",
 				devname);
 		free(super);
+		free(r5l_super);
 		return 1;
 	}
 
@@ -1861,6 +1888,7 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 			pr_err("No super block found on %s (Expected magic %08x, got %08x)\n",
 				devname, MD_SB_MAGIC, __le32_to_cpu(super->magic));
 		free(super);
+		free(r5l_super);
 		return 2;
 	}
 
@@ -1869,6 +1897,7 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 			pr_err("Cannot interpret superblock on %s - version is %d\n",
 				devname, __le32_to_cpu(super->major_version));
 		free(super);
+		free(r5l_super);
 		return 2;
 	}
 	if (__le64_to_cpu(super->super_offset) != sb_offset) {
@@ -1876,9 +1905,27 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 			pr_err("No superblock found on %s (super_offset is wrong)\n",
 				devname);
 		free(super);
+		free(r5l_super);
 		return 2;
 	}
 	st->sb = super;
+	if (0xFFFD == role_from_sb(super)) {
+		if (lseek64(fd, 512 * (super->data_offset), 0) < 0LL) {
+			if (devname)
+				pr_err("Cannot seek to r5l superblock on %s: %s\n",
+				       devname, strerror(errno));
+			free(r5l_super);
+		} else {
+			if (aread(&afd, r5l_super, LOG_BLOCK_SIZE) != LOG_BLOCK_SIZE) {
+				if (devname)
+					pr_err("Cannot read r5l superblock on %s: %s\n",
+					       devname, strerror(errno));
+				free(r5l_super);
+			} else
+				st->r5l_sb = r5l_super;
+		}
+	} else
+		free(r5l_super);
 
 	bsb = (struct bitmap_super_s *)(((char*)super)+MAX_SB_SIZE);
 
@@ -2223,6 +2270,8 @@ static int write_bitmap1(struct supertype *st, int fd)
 
 static void free_super1(struct supertype *st)
 {
+	if (st->r5l_sb)
+		free(st->r5l_sb);
 	if (st->sb)
 		free(st->sb);
 	while (st->info) {
@@ -2233,6 +2282,7 @@ static void free_super1(struct supertype *st)
 		free(di);
 	}
 	st->sb = NULL;
+	st->r5l_sb = NULL;
 }
 
 #ifndef MDASSEMBLE
@@ -2389,6 +2439,93 @@ void *super1_make_v0(struct supertype *st, struct mdinfo *info, mdp_super_t *sb0
 	return ret;
 }
 
+unsigned long crc32(
+	unsigned long crc,
+	const unsigned char *buf,
+	unsigned len);
+
+static int write_r5l_super1(struct supertype *st, int fd)
+{
+	struct r5l_super_block *sb_blk;
+	struct mdp_superblock_1 *sb = st->sb;
+	unsigned long long dsize;
+	int parity_disks;
+	struct align_fd afd;
+	__u32 crc;
+
+	init_afd(&afd, fd);
+	if (sb->level == 5 || sb->level == 4)
+		parity_disks = 1;
+	else if (sb->level == 6)
+		parity_disks = 2;
+	else {
+		pr_err("Write cache is only applicable to RAID 4/5/6.\n");
+		return 1;
+	}
+
+	if (!get_dev_size(fd, NULL, &dsize)) {
+		pr_err("Cannot get size of cache device.\n");
+		return 1;
+	}
+
+	if (st->r5l_sb)
+		free(st->r5l_sb);
+
+	if (posix_memalign((void**)&sb_blk, 4096, LOG_BLOCK_SIZE) != 0) {
+		pr_err("Could not allocate memory for writecache superblock.\n");
+		return 1;
+	}
+
+	memset(sb_blk, 0, LOG_BLOCK_SIZE);
+
+	sb_blk->header.magic = __cpu_to_le32(R5LOG_MAGIC);
+	sb_blk->header.type = __cpu_to_le32(R5LOG_TYPE_SUPER);
+	sb_blk->header.seq = __cpu_to_le64(random32());
+	sb_blk->header.meta_size = __cpu_to_le32(sizeof(*sb_blk));
+	sb_blk->version = __cpu_to_le32(R5LOG_VERSION);
+	sb_blk->stripe_cache_size = __cpu_to_le32(LOG_BLOCK_SIZE);
+	sb_blk->block_size = __cpu_to_le32(LOG_BLOCK_SIZE);
+	sb_blk->total_blocks = __cpu_to_le64(((dsize - (sb->data_offset << 9)) / LOG_BLOCK_SIZE) - 1);
+	sb_blk->stripe_data_size = __cpu_to_le32((sb->chunksize << 9) *
+		(sb->raid_disks - parity_disks));
+	sb_blk->chunk_size = __cpu_to_le32(sb->chunksize << 9);
+
+
+	sb_blk->stripe_size = __cpu_to_le32(sb_blk->chunk_size * sb->raid_disks);
+	sb_blk->parity_disks = __cpu_to_le32(parity_disks);
+
+	sb_blk->first_block = __cpu_to_le64(1);
+	sb_blk->last_checkpoint = __cpu_to_le64(1);
+	sb_blk->update_time_sec = __cpu_to_le64((unsigned long long)time(0));
+	sb_blk->update_time_nsec = 0;
+	sb_blk->meta_checksum_type = R5LOG_CHECKSUM_CRC32;
+	sb_blk->data_checksum_type = R5LOG_CHECKSUM_CRC32;
+	memcpy(sb_blk->uuid, sb->set_uuid, 16);
+
+	crc = __cpu_to_le32(crc32(0xffffffff, (unsigned char *)(sb_blk->uuid), sizeof(sb_blk->uuid)));
+	crc = __cpu_to_le32(crc32(crc, (unsigned char *)sb_blk, LOG_BLOCK_SIZE));
+	sb_blk->header.checksum = crc;
+
+	if (lseek64(fd, (sb->data_offset) * 512, 0) < 0LL) {
+		pr_err("cannot seek to offset of write cache superblock\n");
+		goto fail_to_write;
+	}
+	if (awrite(&afd, sb_blk, sizeof(*sb_blk)) != sizeof(*sb_blk)) {
+		pr_err("failed to store write cache superblock \n");
+		goto fail_to_write;
+	}
+	fsync(fd);
+
+	st->r5l_sb = sb_blk;
+	return 0;
+
+fail_to_write:
+	free(sb_blk);
+	st->r5l_sb = NULL;
+	return 1;
+}
+
+
 struct superswitch super1 = {
 #ifndef MDASSEMBLE
 	.examine_super = examine_super1,
@@ -2418,6 +2555,7 @@ struct superswitch super1 = {
 	.locate_bitmap = locate_bitmap1,
 	.write_bitmap = write_bitmap1,
 	.free_super = free_super1,
+	.write_r5l_super = write_r5l_super1,
 #if __BYTE_ORDER == BIG_ENDIAN
 	.swapuuid = 0,
 #else
-- 
1.8.1

