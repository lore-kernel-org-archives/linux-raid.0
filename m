From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 3/6] Enable create array with write journal (--write-journal DEVICE).
Date: Thu, 8 Oct 2015 22:51:43 -0700
Message-ID: <1444369906-1804157-4-git-send-email-songliubraving@fb.com>
References: <1444369906-1804157-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444369906-1804157-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, shli@fb.com, hch@infradead.org, dan.j.williams@intel.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Specify the write journal device with --write-journal DEVICE

./mdadm --create -f /dev/md0 --assume-clean -c 32 --raid-devices=4 --level=5 /dev/sd[c-f] --write-journal /dev/sdb1
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

Only one journal device is allowed. If multiple --write-journal
are given, mdadm will use the first and ignore others

./mdadm --create -f /dev/md0 --assume-clean -c 32 --raid-devices=4 --level=5 /dev/sd[c-f] --write-journal /dev/sdb1 --write-journal /dev/sdx
mdadm: Please specify only one journal device for the array.
mdadm: Ignoring --write-journal /dev/sdx...
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 Create.c | 20 +++++++++++++------
 ReadMe.c |  1 +
 md_p.h   | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 mdadm.c  | 23 +++++++++++++++++++++
 mdadm.h  |  2 ++
 super1.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 167 insertions(+), 7 deletions(-)

diff --git a/Create.c b/Create.c
index b200d97..21d1374 100644
--- a/Create.c
+++ b/Create.c
@@ -87,7 +87,7 @@ int Create(struct supertype *st, char *mddev,
 	unsigned long long minsize=0, maxsize=0;
 	char *mindisc = NULL;
 	char *maxdisc = NULL;
-	int dnum;
+	int dnum, raid_disk_num;
 	struct mddev_dev *dv;
 	int fail=0, warn=0;
 	struct stat stb;
@@ -182,11 +182,11 @@ int Create(struct supertype *st, char *mddev,
 		pr_err("This metadata type does not support spare disks at create time\n");
 		return 1;
 	}
-	if (subdevs > s->raiddisks+s->sparedisks) {
+	if (subdevs > s->raiddisks+s->sparedisks+s->journaldisks) {
 		pr_err("You have listed more devices (%d) than are in the array(%d)!\n", subdevs, s->raiddisks+s->sparedisks);
 		return 1;
 	}
-	if (!have_container && subdevs < s->raiddisks+s->sparedisks) {
+	if (!have_container && subdevs < s->raiddisks+s->sparedisks+s->journaldisks) {
 		pr_err("You haven't given enough devices (real or missing) to create this array\n");
 		return 1;
 	}
@@ -399,6 +399,9 @@ int Create(struct supertype *st, char *mddev,
 			}
 		}
 
+		if (dv->disposition == 'j')
+			continue;  /* skip write journal for size check */
+
 		freesize /= 2; /* convert to K */
 		if (s->chunk && s->chunk != UnSet) {
 			/* round to chunk size */
@@ -839,7 +842,7 @@ int Create(struct supertype *st, char *mddev,
 	for (pass=1; pass <=2 ; pass++) {
 		struct mddev_dev *moved_disk = NULL; /* the disk that was moved out of the insert point */
 
-		for (dnum=0, dv = devlist ; dv ;
+		for (dnum=0, raid_disk_num=0, dv = devlist ; dv ;
 		     dv=(dv->next)?(dv->next):moved_disk, dnum++) {
 			int fd;
 			struct stat stb;
@@ -864,8 +867,13 @@ int Create(struct supertype *st, char *mddev,
 				*inf = info;
 
 				inf->disk.number = dnum;
-				inf->disk.raid_disk = dnum;
-				if (inf->disk.raid_disk < s->raiddisks)
+				inf->disk.raid_disk = raid_disk_num++;
+
+				if (dv->disposition == 'j') {
+					inf->disk.raid_disk = MD_DISK_ROLE_JOURNAL;
+					inf->disk.state = (1<<MD_DISK_JOURNAL);
+					raid_disk_num--;
+				} else if (inf->disk.raid_disk < s->raiddisks)
 					inf->disk.state = (1<<MD_DISK_ACTIVE) |
 						(1<<MD_DISK_SYNC);
 				else
diff --git a/ReadMe.c b/ReadMe.c
index c242319..10921e3 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -142,6 +142,7 @@ struct option long_options[] = {
     {"data-offset",1, 0, DataOffset},
     {"nodes",1, 0, Nodes}, /* also for --assemble */
     {"home-cluster",1, 0, ClusterName},
+    {"write-journal",1, 0, WriteJournal},
 
     /* For assemble */
     {"uuid",      1, 0, 'u'},
diff --git a/md_p.h b/md_p.h
index fae73ba..0d691fb 100644
--- a/md_p.h
+++ b/md_p.h
@@ -208,4 +208,62 @@ static inline __u64 md_event(mdp_super_t *sb) {
 	return (ev<<32)| sb->events_lo;
 }
 
+struct r5l_payload_header {
+	__u16 type;
+	__u16 flags;
+} __attribute__ ((__packed__));
+
+enum r5l_payload_type {
+	R5LOG_PAYLOAD_DATA = 0,
+	R5LOG_PAYLOAD_PARITY = 1,
+	R5LOG_PAYLOAD_FLUSH = 2,
+};
+
+struct r5l_payload_data_parity {
+	struct r5l_payload_header header;
+	__u32 size; /* sector. data/parity size. each 4k has a checksum */
+	__u64 location; /* sector. For data, it's raid sector. For
+				parity, it's stripe sector */
+	__u32 checksum[];
+} __attribute__ ((__packed__));
+
+enum r5l_payload_data_parity_flag {
+	R5LOG_PAYLOAD_FLAG_DISCARD = 1, /* payload is discard */
+	/*
+	 * RESHAPED/RESHAPING is only set when there is reshape activity. Note,
+	 * both data/parity of a stripe should have the same flag set
+	 *
+	 * RESHAPED: reshape is running, and this stripe finished reshape
+	 * RESHAPING: reshape is running, and this stripe isn't reshaped
+	 * */
+	R5LOG_PAYLOAD_FLAG_RESHAPED = 2,
+	R5LOG_PAYLOAD_FLAG_RESHAPING = 3,
+};
+
+struct r5l_payload_flush {
+	struct r5l_payload_header header;
+	__u32 size; /* flush_stripes size, bytes */
+	__u64 flush_stripes[];
+} __attribute__ ((__packed__));
+
+enum r5l_payload_flush_flag {
+	R5LOG_PAYLOAD_FLAG_FLUSH_STRIPE = 1, /* data represents whole stripe */
+};
+
+struct r5l_meta_block {
+	__u32 magic;
+	__u32 checksum;
+	__u8 version;
+	__u8 __zero_pading_1;
+	__u16 __zero_pading_2;
+	__u32 meta_size; /* whole size of the block */
+
+	__u64 seq;
+	__u64 position; /* sector, start from rdev->data_offset, current position */
+	struct r5l_payload_header payloads[];
+} __attribute__ ((__packed__));
+
+#define R5LOG_VERSION 0x1
+#define R5LOG_MAGIC 0x6433c509
+
 #endif
diff --git a/mdadm.c b/mdadm.c
index 183f6c8..f32a3d4 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -74,6 +74,7 @@ int main(int argc, char *argv[])
 		.require_homehost = 1,
 	};
 	struct shape s = {
+		.journaldisks	= 0,
 		.level		= UnSet,
 		.layout		= UnSet,
 		.bitmap_chunk	= UnSet,
@@ -1170,6 +1171,23 @@ int main(int argc, char *argv[])
 		case O(INCREMENTAL, IncrementalPath):
 			remove_path = optarg;
 			continue;
+		case O(CREATE, WriteJournal):
+			if (s.journaldisks) {
+				pr_err("Please specify only one journal device for the array.\n");
+				pr_err("Ignoring --write-journal %s...\n", optarg);
+				continue;
+			}
+			dv = xmalloc(sizeof(*dv));
+			dv->devname = optarg;
+			dv->disposition = 'j';  /* WriteJournal */
+			dv->used = 0;
+			dv->next = NULL;
+			*devlistend = dv;
+			devlistend = &dv->next;
+			devs_found++;
+
+			s.journaldisks = 1;
+			continue;
 		}
 		/* We have now processed all the valid options. Anything else is
 		 * an error
@@ -1197,6 +1215,11 @@ int main(int argc, char *argv[])
 		exit(0);
 	}
 
+	if (s.journaldisks && (s.level < 4 || s.level > 6)) {
+		pr_err("--write-journal is only supported for RAID level 4/5/6.\n");
+		exit(2);
+	}
+
 	if (!mode && devs_found) {
 		mode = MISC;
 		devmode = 'Q';
diff --git a/mdadm.h b/mdadm.h
index 5633663..0b27b43 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -347,6 +347,7 @@ enum special_options {
 	Nodes,
 	ClusterName,
 	ClusterConfirm,
+	WriteJournal,
 };
 
 enum prefix_standard {
@@ -434,6 +435,7 @@ struct context {
 struct shape {
 	int	raiddisks;
 	int	sparedisks;
+	int	journaldisks;
 	int	level;
 	int	layout;
 	char	*layout_str;
diff --git a/super1.c b/super1.c
index 6905b6d..85e3b28 100644
--- a/super1.c
+++ b/super1.c
@@ -68,7 +68,10 @@ struct mdp_superblock_1 {
 	__u64	data_offset;	/* sector start of data, often 0 */
 	__u64	data_size;	/* sectors in this device that can be used for data */
 	__u64	super_offset;	/* sector start of this superblock */
-	__u64	recovery_offset;/* sectors before this offset (from data_offset) have been recovered */
+	union {
+		__u64	recovery_offset;/* sectors before this offset (from data_offset) have been recovered */
+		__u64	journal_tail;/* journal tail of journal device (from data_offset) */
+	};
 	__u32	dev_number;	/* permanent identifier of this  device - not role in raid */
 	__u32	cnt_corrected_read; /* number of read errors that were corrected by re-writing */
 	__u8	device_uuid[16]; /* user-space setable, ignored by kernel */
@@ -1447,6 +1450,8 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 
 	if ((dk->state & 6) == 6) /* active, sync */
 		*rp = __cpu_to_le16(dk->raid_disk);
+	else if (dk->state & (1<<MD_DISK_JOURNAL))
+                *rp = MD_DISK_ROLE_JOURNAL;
 	else if ((dk->state & ~2) == 0) /* active or idle -> spare */
 		*rp = MD_DISK_ROLE_SPARE;
 	else
@@ -1566,6 +1571,57 @@ static unsigned long choose_bm_space(unsigned long devsize)
 
 static void free_super1(struct supertype *st);
 
+#define META_BLOCK_SIZE 4096
+unsigned long crc32(
+	unsigned long crc,
+	const unsigned char *buf,
+	unsigned len);
+
+static int write_empty_r5l_meta_block(struct supertype *st, int fd)
+{
+	struct r5l_meta_block *mb;
+	struct mdp_superblock_1 *sb = st->sb;
+	struct align_fd afd;
+	__u32 crc;
+
+	init_afd(&afd, fd);
+
+	if (posix_memalign((void**)&mb, 4096, META_BLOCK_SIZE) != 0) {
+		pr_err("Could not allocate memory for the meta block.\n");
+		return 1;
+	}
+
+	memset(mb, 0, META_BLOCK_SIZE);
+
+	mb->magic = __cpu_to_le32(R5LOG_MAGIC);
+	mb->version = R5LOG_VERSION;
+	mb->meta_size = __cpu_to_le32(sizeof(struct r5l_meta_block));
+	mb->seq = __cpu_to_le64(random32());
+	mb->position = __cpu_to_le64(0);
+
+	crc = crc32(0xffffffff, sb->set_uuid, sizeof(sb->set_uuid));
+	crc = crc32(crc, (void *)mb, META_BLOCK_SIZE);
+	mb->checksum = __cpu_to_le32(crc);
+
+	if (lseek64(fd, (sb->data_offset) * 512, 0) < 0LL) {
+		pr_err("cannot seek to offset of the meta block\n");
+		goto fail_to_write;
+	}
+
+	if (awrite(&afd, mb, META_BLOCK_SIZE) != META_BLOCK_SIZE) {
+		pr_err("failed to store write the meta block \n");
+		goto fail_to_write;
+	}
+	fsync(fd);
+
+	free(mb);
+	return 0;
+
+fail_to_write:
+	free(mb);
+	return 1;
+}
+
 #ifndef MDASSEMBLE
 static int write_init_super1(struct supertype *st)
 {
@@ -1580,6 +1636,11 @@ static int write_init_super1(struct supertype *st)
 	unsigned long long data_offset;
 
 	for (di = st->info; di; di = di->next) {
+		if (di->disk.state & (1 << MD_DISK_JOURNAL))
+			sb->feature_map |= MD_FEATURE_JOURNAL;
+	}
+
+	for (di = st->info; di; di = di->next) {
 		if (di->disk.state & (1 << MD_DISK_FAULTY))
 			continue;
 		if (di->fd < 0)
@@ -1718,6 +1779,13 @@ static int write_init_super1(struct supertype *st)
 
 		sb->sb_csum = calc_sb_1_csum(sb);
 		rv = store_super1(st, di->fd);
+
+		if (rv == 0 && (di->disk.state & (1 << MD_DISK_JOURNAL))) {
+			rv = write_empty_r5l_meta_block(st, di->fd);
+			if (rv)
+				goto error_out;
+		}
+
 		if (rv == 0 && (__le32_to_cpu(sb->feature_map) & 1))
 			rv = st->ss->write_bitmap(st, di->fd, NoUpdate);
 		close(di->fd);
-- 
2.4.6

