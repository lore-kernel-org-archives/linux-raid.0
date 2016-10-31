From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 1/8] imsm: parse bad block log in metadata on startup
Date: Mon, 31 Oct 2016 15:50:47 +0100
Message-ID: <1477925454-16809-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Always allocate memory for all log entries to avoid a need for memory
allocation when monitor requests to record a bad block.

Also some extra checks added to make static code analyzer happy.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 158 +++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 112 insertions(+), 46 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index c146bbd..5d6d534 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -217,22 +217,24 @@ struct imsm_super {
 } __attribute__ ((packed));
 
 #define BBM_LOG_MAX_ENTRIES 254
+#define BBM_LOG_MAX_LBA_ENTRY_VAL 256		/* Represents 256 LBAs */
+#define BBM_LOG_SIGNATURE 0xABADB10C
+
+struct bbm_log_block_addr {
+	__u16 w1;
+	__u32 dw1;
+} __attribute__ ((__packed__));
 
 struct bbm_log_entry {
-	__u64 defective_block_start;
-#define UNREADABLE 0xFFFFFFFF
-	__u32 spare_block_offset;
-	__u16 remapped_marked_count;
-	__u16 disk_ordinal;
+	__u8 marked_count;		/* Number of blocks marked - 1 */
+	__u8 disk_ordinal;		/* Disk entry within the imsm_super */
+	struct bbm_log_block_addr defective_block_start;
 } __attribute__ ((__packed__));
 
 struct bbm_log {
 	__u32 signature; /* 0xABADB10C */
 	__u32 entry_count;
-	__u32 reserved_spare_block_count; /* 0 */
-	__u32 reserved; /* 0xFFFF */
-	__u64 first_spare_lba;
-	struct bbm_log_entry mapped_block_entries[BBM_LOG_MAX_ENTRIES];
+	struct bbm_log_entry marked_block_entries[BBM_LOG_MAX_ENTRIES];
 } __attribute__ ((__packed__));
 
 #ifndef MDASSEMBLE
@@ -785,6 +787,92 @@ static struct imsm_dev *get_imsm_dev(struct intel_super *super, __u8 index)
 	return NULL;
 }
 
+#if BYTE_ORDER == LITTLE_ENDIAN
+static inline unsigned long long __le48_to_cpu(const struct bbm_log_block_addr
+					       *addr)
+{
+	return ((((__u64)addr->dw1) << 16) | addr->w1);
+}
+
+static inline struct bbm_log_block_addr __cpu_to_le48(unsigned long long sec)
+{
+	struct bbm_log_block_addr addr;
+
+	addr.w1 =  (__u16)(sec & 0xFFFF);
+	addr.dw1 = (__u32)((sec >> 16) & 0xFFFFFFFF);
+	return addr;
+}
+#elif BYTE_ORDER == BIG_ENDIAN
+static inline unsigned long long __le48_to_cpu(const struct bbm_log_block_addr
+					       *addr)
+{
+	return ((((__u64)__le32_to_cpu(addr->dw1)) << 16) |
+		__le16_to_cpu(addr->w1));
+}
+
+static inline struct bbm_log_block_addr __cpu_to_le48(unsigned long long sec)
+{
+	struct bbm_log_block_addr addr;
+
+	addr.w1 =  __cpu_to_le16((__u16)(sec & 0xFFFF));
+	addr.dw1 = __cpu_to_le32((__u32)(sec >> 16) & 0xFFFFFFFF);
+	return addr;
+}
+#else
+#  error "unknown endianness."
+#endif
+
+#ifndef MDASSEMBLE
+/* get size of the bbm log */
+static __u32 get_imsm_bbm_log_size(struct bbm_log *log)
+{
+	if (!log || log->entry_count == 0)
+		return 0;
+
+	return sizeof(log->signature) +
+		sizeof(log->entry_count) +
+		log->entry_count * sizeof(struct bbm_log_entry);
+}
+#endif /* MDASSEMBLE */
+
+/* allocate and load BBM log from metadata */
+static int load_bbm_log(struct intel_super *super)
+{
+	struct imsm_super *mpb = super->anchor;
+	__u32 bbm_log_size =  __le32_to_cpu(mpb->bbm_log_size);
+
+	super->bbm_log = malloc(sizeof(struct bbm_log));
+	if (!super->bbm_log)
+		return 1;
+
+	if (bbm_log_size) {
+		struct bbm_log *log = (void *)mpb +
+			__le32_to_cpu(mpb->mpb_size) - bbm_log_size;
+		__u32 entry_count;
+
+		if (bbm_log_size < sizeof(log->signature) +
+		    sizeof(log->entry_count))
+			return 2;
+
+		entry_count = __le32_to_cpu(log->entry_count);
+		if ((__le32_to_cpu(log->signature) != BBM_LOG_SIGNATURE) ||
+		    (entry_count > BBM_LOG_MAX_ENTRIES))
+			return 3;
+
+		if (bbm_log_size !=
+		    sizeof(log->signature) + sizeof(log->entry_count) +
+		    entry_count * sizeof(struct bbm_log_entry))
+			return 4;
+
+		memcpy(super->bbm_log, log, bbm_log_size);
+	} else {
+		super->bbm_log->signature = __cpu_to_le32(BBM_LOG_SIGNATURE);
+		super->bbm_log->entry_count = 0;
+	}
+
+	return 0;
+}
+
 /*
  * for second_map:
  *  == MAP_0 get first map
@@ -1433,7 +1521,7 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	printf("          Disks : %d\n", mpb->num_disks);
 	printf("   RAID Devices : %d\n", mpb->num_raid_devs);
 	print_imsm_disk(__get_imsm_disk(mpb, super->disks->index), super->disks->index, reserved);
-	if (super->bbm_log) {
+	if (get_imsm_bbm_log_size(super->bbm_log)) {
 		struct bbm_log *log = super->bbm_log;
 
 		printf("\n");
@@ -1441,9 +1529,6 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 		printf("       Log Size : %d\n", __le32_to_cpu(mpb->bbm_log_size));
 		printf("      Signature : %x\n", __le32_to_cpu(log->signature));
 		printf("    Entry Count : %d\n", __le32_to_cpu(log->entry_count));
-		printf("   Spare Blocks : %d\n",  __le32_to_cpu(log->reserved_spare_block_count));
-		printf("    First Spare : %llx\n",
-		       (unsigned long long) __le64_to_cpu(log->first_spare_lba));
 	}
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct mdinfo info;
@@ -3628,19 +3713,6 @@ static int parse_raid_devices(struct intel_super *super)
 	return 0;
 }
 
-/* retrieve a pointer to the bbm log which starts after all raid devices */
-struct bbm_log *__get_imsm_bbm_log(struct imsm_super *mpb)
-{
-	void *ptr = NULL;
-
-	if (__le32_to_cpu(mpb->bbm_log_size)) {
-		ptr = mpb;
-		ptr += mpb->mpb_size - __le32_to_cpu(mpb->bbm_log_size);
-	}
-
-	return ptr;
-}
-
 /*******************************************************************************
  * Function:	check_mpb_migr_compatibility
  * Description:	Function checks for unsupported migration features:
@@ -3790,12 +3862,6 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 		return 3;
 	}
 
-	/* FIXME the BBM log is disk specific so we cannot use this global
-	 * buffer for all disks.  Ok for now since we only look at the global
-	 * bbm_log_size parameter to gate assembly
-	 */
-	super->bbm_log = __get_imsm_bbm_log(super->anchor);
-
 	return 0;
 }
 
@@ -3839,6 +3905,9 @@ load_and_parse_mpb(int fd, struct intel_super *super, char *devname, int keep_fd
 	if (err)
 		return err;
 	err = parse_raid_devices(super);
+	if (err)
+		return err;
+	err = load_bbm_log(super);
 	clear_hi(super);
 	return err;
 }
@@ -3903,6 +3972,8 @@ static void __free_imsm(struct intel_super *super, int free_disks)
 		free(elem);
 		elem = next;
 	}
+	if (super->bbm_log)
+		free(super->bbm_log);
 	super->hba = NULL;
 }
 
@@ -4508,7 +4579,7 @@ static int get_super_block(struct intel_super **super_list, char *devnm, char *d
 		*super_list = s;
 	} else {
 		if (s)
-			free(s);
+			free_imsm(s);
 		if (dfd >= 0)
 			close(dfd);
 	}
@@ -4570,6 +4641,8 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 	free_super_imsm(st);
 
 	super = alloc_super();
+	if (!super)
+		return 1;
 	/* Load hba and capabilities if they exist.
 	 * But do not preclude loading metadata in case capabilities or hba are
 	 * non-compliant and ignore_hw_compat is set.
@@ -4912,7 +4985,7 @@ static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
 
 	super = alloc_super();
 	if (super && posix_memalign(&super->buf, 512, mpb_size) != 0) {
-		free(super);
+		free_imsm(super);
 		super = NULL;
 	}
 	if (!super) {
@@ -4922,7 +4995,7 @@ static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
 	if (posix_memalign(&super->migr_rec_buf, 512, MIGR_REC_BUF_SIZE) != 0) {
 		pr_err("could not allocate migr_rec buffer\n");
 		free(super->buf);
-		free(super);
+		free_imsm(super);
 		return 0;
 	}
 	memset(super->buf, 0, mpb_size);
@@ -5489,11 +5562,6 @@ static int store_super_imsm(struct supertype *st, int fd)
 #endif
 }
 
-static int imsm_bbm_log_size(struct imsm_super *mpb)
-{
-	return __le32_to_cpu(mpb->bbm_log_size);
-}
-
 #ifndef MDASSEMBLE
 static int validate_geometry_imsm_container(struct supertype *st, int level,
 					    int layout, int raiddisks, int chunk,
@@ -5529,6 +5597,10 @@ static int validate_geometry_imsm_container(struct supertype *st, int level,
 	 * note that there is no fd for the disks in array.
 	 */
 	super = alloc_super();
+	if (!super) {
+		close(fd);
+		return 0;
+	}
 	rv = find_intel_hba_capability(fd, super, verbose > 0 ? dev : NULL);
 	if (rv != 0) {
 #if DEBUG
@@ -6760,12 +6832,6 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 		pr_err("Unsupported attributes in IMSM metadata.Arrays activation is blocked.\n");
 	}
 
-	/* check for bad blocks */
-	if (imsm_bbm_log_size(super->anchor)) {
-		pr_err("BBM log found in IMSM metadata.Arrays activation is blocked.\n");
-		sb_errors = 1;
-	}
-
 	/* count spare devices, not used in maps
 	 */
 	for (d = super->disks; d; d = d->next)
-- 
1.8.3.1

