From: Luca Berra <bluca@comedia.it>
Subject: [PATCH] gcc warnings again
Date: Thu, 16 Jun 2011 09:05:10 +0200
Message-ID: <20110616070510.GA8544@maude.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline

hello.
yesterday i tried rebuilding both mdadm 3.1.5 and 3.2.1 with gcc 4.6,
with the following CXFLAGS

x86:    -O2 -g -frecord-gcc-switches -Wstrict-aliasing=2 -pipe -Wformat
-Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector
--param=ssp-buffer-size=4 -fomit-frame-pointer -mtune=generic
-march=i586 -fasynchronous-unwind-tables

x86_64: -O2 -g -frecord-gcc-switches -Wstrict-aliasing=2 -pipe -Wformat
-Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector
--param=ssp-buffer-size=4 -fPIC

i found a good number of warnings
unused but set variable
strict aliasing
comparison between signed and unsigned values *on 32bit*

for the unused variables i found fedora already had a patch which is
sensible enough, i did not see it reported here, so i will attach it.

I know -Wstrict-aliasing=2 can give false positive but those looked real
to me, so i fixed those.

looking at the gpt code in util.c i found i did not like it at all, a
gpt partition entry is currently 128 bytes, but the spec does not say it
is a fixed value, so the code that reads into a buffer with 512bytes
chunk expecting this to be a multiplier of part_size is imho incorrect.
my fix was to read each partition entry directly into a struct
GPT_part_entry, the advantage is that the code is very simple to read,
the disadvantage it is 128 reads of 128 bytes each, which is
sub-optimal, but i believe readahead will mitigate this a lot.

regards,
L.


-- 
Luca Berra -- bluca@comedia.it

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="mdadm-3.1.5-unused-param.patch"

--- mdadm-3.2.1/sysfs.c.param	2011-03-28 11:28:13.599402233 -0400
+++ mdadm-3.2.1/sysfs.c	2011-03-28 11:48:02.593714836 -0400
@@ -418,7 +418,7 @@ int sysfs_set_num(struct mdinfo *sra, st
 int sysfs_uevent(struct mdinfo *sra, char *event)
 {
 	char fname[50];
-	int n;
+	unsigned int n;
 	int fd;
 
 	sprintf(fname, "/sys/block/%s/uevent",
@@ -428,6 +428,11 @@ int sysfs_uevent(struct mdinfo *sra, cha
 		return -1;
 	n = write(fd, event, strlen(event));
 	close(fd);
+	if (n != strlen(event)) {
+		dprintf(Name ": failed to write '%s' to '%s' (%s)\n",
+			event, fname, strerror(errno));
+		return -1;
+	}
 	return 0;
 }	
 
--- mdadm-3.2.1/mdadm.c.param	2011-03-28 10:38:12.035258787 -0400
+++ mdadm-3.2.1/mdadm.c	2011-03-28 10:39:33.346082070 -0400
@@ -103,7 +103,9 @@ int main(int argc, char *argv[])
 	char *shortopt = short_options;
 	int dosyslog = 0;
 	int rebuild_map = 0;
+#if 0
 	int auto_update_home = 0;
+#endif
 	char *subarray = NULL;
 	char *remove_path = NULL;
 	char *udev_filename = NULL;
@@ -1325,11 +1327,13 @@ int main(int argc, char *argv[])
 							cnt++;
 							acnt++;
 						}
+#if 0
 						if (rv2 == 1)
 							/* found something so even though assembly failed  we
 							 * want to avoid auto-updates
 							 */
 							auto_update_home = 0;
+#endif
 					} while (rv2!=2);
 					/* Incase there are stacked devices, we need to go around again */
 				} while (acnt);
--- mdadm-3.2.1/mdmon.c.param	2011-03-28 11:29:41.128681560 -0400
+++ mdadm-3.2.1/mdmon.c	2011-03-28 11:30:54.514946394 -0400
@@ -513,6 +513,9 @@ static int mdmon(char *devname, int devn
 	ignore = dup(0);
 #endif
 
+	if (ignore)
+		ignore++;
+
 	do_manager(container);
 
 	exit(0);
--- mdadm-3.2.1/Grow.c.param	2011-03-28 10:38:12.038259001 -0400
+++ mdadm-3.2.1/Grow.c	2011-03-28 10:45:28.174500010 -0400
@@ -1312,7 +1312,6 @@ int Grow_reshape(char *devname, int fd, 
 	char *subarray = NULL;
 
 	int frozen;
-	int changed = 0;
 	char *container = NULL;
 	char container_buf[20];
 	int cfd = -1;
@@ -1479,7 +1478,6 @@ int Grow_reshape(char *devname, int fd, 
 		if (!quiet)
 			fprintf(stderr, Name ": component size of %s has been set to %lluK\n",
 				devname, size);
-		changed = 1;
 	} else if (array.level != LEVEL_CONTAINER) {
 		size = get_component_size(fd)/2;
 		if (size == 0)
--- mdadm-3.2.1/Query.c.param	2011-03-28 10:38:12.040259145 -0400
+++ mdadm-3.2.1/Query.c	2011-03-28 10:41:19.272668999 -0400
@@ -35,7 +35,7 @@ int Query(char *dev)
 	int fd = open(dev, O_RDONLY);
 	int vers;
 	int ioctlerr;
-	int superror, superrno;
+	int superror;
 	struct mdinfo info;
 	mdu_array_info_t array;
 	struct supertype *st = NULL;
@@ -84,7 +84,6 @@ int Query(char *dev)
 	st = guess_super(fd);
 	if (st) {
 		superror = st->ss->load_super(st, fd, dev);
-		superrno = errno;
 	} else
 		superror = -1;
 	close(fd);
--- mdadm-3.2.1/super1.c.param	2011-03-28 10:38:12.043259360 -0400
+++ mdadm-3.2.1/super1.c	2011-03-28 10:53:14.423905054 -0400
@@ -111,7 +111,6 @@ static unsigned int calc_sb_1_csum(struc
 	unsigned long long newcsum;
 	int size = sizeof(*sb) + __le32_to_cpu(sb->max_dev)*2;
 	unsigned int *isuper = (unsigned int*)sb;
-	int i;
 
 /* make sure I can count... */
 	if (offsetof(struct mdp_superblock_1,data_offset) != 128 ||
@@ -123,7 +122,7 @@ static unsigned int calc_sb_1_csum(struc
 	disk_csum = sb->sb_csum;
 	sb->sb_csum = 0;
 	newcsum = 0;
-	for (i=0; size>=4; size -= 4 ) {
+	for (; size>=4; size -= 4 ) {
 		newcsum += __le32_to_cpu(*isuper);
 		isuper++;
 	}
@@ -387,15 +386,11 @@ static void examine_super1(struct supert
 	printf("   Array State : ");
 	for (d=0; d<__le32_to_cpu(sb->raid_disks) + delta_extra; d++) {
 		int cnt = 0;
-		int me = 0;
 		unsigned int i;
 		for (i=0; i< __le32_to_cpu(sb->max_dev); i++) {
 			unsigned int role = __le16_to_cpu(sb->dev_roles[i]);
-			if (role == d) {
-				if (i == __le32_to_cpu(sb->dev_number))
-					me = 1;
+			if (role == d)
 				cnt++;
-			}
 		}
 		if (cnt > 1) printf("?");
 		else if (cnt == 1) printf("A");
--- mdadm-3.2.1/Incremental.c.param	2011-03-28 10:38:12.045259502 -0400
+++ mdadm-3.2.1/Incremental.c	2011-03-28 11:31:41.924347665 -0400
@@ -707,7 +707,7 @@ static int count_active(struct supertype
 	int cnt = 0;
 	__u64 max_events = 0;
 	char *avail = NULL;
-	int *best;
+	int *best = NULL;
 	char *devmap = NULL;
 	int numdevs = 0;
 	int devnum;
--- mdadm-3.2.1/super-intel.c.param	2011-03-28 10:38:12.048259718 -0400
+++ mdadm-3.2.1/super-intel.c	2011-03-28 11:33:53.898816208 -0400
@@ -6164,7 +6164,7 @@ static int apply_takeover_update(struct 
 {
 	struct imsm_dev *dev = NULL;
 	struct intel_dev *dv;
-	struct imsm_dev *dev_new;
+	struct imsm_dev *dev_new = NULL;
 	struct imsm_map *map;
 	struct dl *dm, *du;
 	int i;
@@ -7008,7 +7008,7 @@ static int imsm_create_metadata_update_f
 	int update_memory_size = 0;
 	struct imsm_update_reshape *u = NULL;
 	struct mdinfo *spares = NULL;
-	int i;
+	int i = -1;
 	int delta_disks = 0;
 	struct mdinfo *dev;
 

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="mdadm-3.2.1-strictalias.patch"

Workaround for strict-aliasing warning

Signed-off-by: Luca Berra <bluca@vodka.it>
---

--- mdadm-3.2.1/Grow.c.strictalias	2011-06-15 14:46:48.281409916 +0000
+++ mdadm-3.2.1/Grow.c	2011-06-15 14:46:48.321410099 +0000
@@ -2914,6 +2914,7 @@ int child_monitor(int afd, struct mdinfo
 	int chunk = sra->array.chunk_size;
 	struct mdinfo *sd;
 	unsigned long stripes;
+	int uuid[4];
 
 	/* set up the backup-super-block.  This requires the
 	 * uuid from the array.
@@ -2941,7 +2942,8 @@ int child_monitor(int afd, struct mdinfo
 
 	memset(&bsb, 0, 512);
 	memcpy(bsb.magic, "md_backup_data-1", 16);
-	st->ss->uuid_from_super(st, (int*)&bsb.set_uuid);
+	st->ss->uuid_from_super(st, uuid);
+	memcpy(bsb.set_uuid, uuid, 16);
 	bsb.mtime = __cpu_to_le64(time(0));
 	bsb.devstart2 = blocks;
 
--- mdadm-3.2.1/super0.c.strictalias	2011-03-28 02:31:20.000000000 +0000
+++ mdadm-3.2.1/super0.c	2011-06-15 14:46:48.321410099 +0000
@@ -423,6 +423,7 @@ static int update_super0(struct supertyp
 	 * ignored.
 	 */
 	int rv = 0;
+	int uuid[4];
 	mdp_super_t *sb = st->sb;
 	if (strcmp(update, "sparc2.2")==0 ) {
 		/* 2.2 sparc put the events in the wrong place
@@ -561,7 +562,8 @@ static int update_super0(struct supertyp
 		if (sb->state & (1<<MD_SB_BITMAP_PRESENT)) {
 			struct bitmap_super_s *bm;
 			bm = (struct bitmap_super_s*)(sb+1);
-			uuid_from_super0(st, (int*)bm->uuid);
+			uuid_from_super0(st, uuid);
+			memcpy(bm->uuid, uuid, 16);
 		}
 	} else if (strcmp(update, "no-bitmap") == 0) {
 		sb->state &= ~(1<<MD_SB_BITMAP_PRESENT);
@@ -987,6 +989,7 @@ static int add_internal_bitmap0(struct s
 	int chunk = *chunkp;
 	mdp_super_t *sb = st->sb;
 	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + MD_SB_BYTES);
+	int uuid[4];
 
 
 	min_chunk = 4096; /* sub-page chunks don't work yet.. */
@@ -1010,7 +1013,8 @@ static int add_internal_bitmap0(struct s
 	memset(bms, 0, sizeof(*bms));
 	bms->magic = __cpu_to_le32(BITMAP_MAGIC);
 	bms->version = __cpu_to_le32(major);
-	uuid_from_super0(st, (int*)bms->uuid);
+	uuid_from_super0(st, uuid);
+	memcpy(bms->uuid, uuid, 16);
 	bms->chunksize = __cpu_to_le32(chunk);
 	bms->daemon_sleep = __cpu_to_le32(delay);
 	bms->sync_size = __cpu_to_le64(size);
--- mdadm-3.2.1/super1.c.strictalias	2011-06-15 14:46:48.281409916 +0000
+++ mdadm-3.2.1/super1.c	2011-06-15 14:46:48.321410099 +0000
@@ -1492,6 +1492,7 @@ add_internal_bitmap1(struct supertype *s
 	int room = 0;
 	struct mdp_superblock_1 *sb = st->sb;
 	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + 1024);
+	int uuid[4];
 
 	switch(st->minor_version) {
 	case 0:
@@ -1579,7 +1580,8 @@ add_internal_bitmap1(struct supertype *s
 	memset(bms, 0, sizeof(*bms));
 	bms->magic = __cpu_to_le32(BITMAP_MAGIC);
 	bms->version = __cpu_to_le32(major);
-	uuid_from_super1(st, (int*)bms->uuid);
+	uuid_from_super1(st, uuid);
+	memcpy(bms->uuid, uuid, 16);
 	bms->chunksize = __cpu_to_le32(chunk);
 	bms->daemon_sleep = __cpu_to_le32(delay);
 	bms->sync_size = __cpu_to_le64(size);

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="mdadm-3.2.1-gpt.patch"

Workaround for strict-aliasing warning
read() returns a ssize_t, not an unsigned
Rework code to not depend on assumptions about part_entry size

Signed-off-by: Luca Berra <bluca@vodka.it>

--- mdadm-3.2.1/util.c.gpt	2011-03-28 02:31:20.000000000 +0000
+++ mdadm-3.2.1/util.c	2011-06-15 21:14:07.039082716 +0000
@@ -1280,9 +1280,8 @@ int must_be_container(int fd)
 static int get_gpt_last_partition_end(int fd, unsigned long long *endofpart)
 {
 	struct GPT gpt;
-	unsigned char buf[512];
 	unsigned char empty_gpt_entry[16]= {0};
-	struct GPT_part_entry *part;
+	struct GPT_part_entry part;
 	unsigned long long curr_part_end;
 	unsigned all_partitions, entry_size;
 	unsigned part_nr;
@@ -1290,8 +1289,9 @@ static int get_gpt_last_partition_end(in
 	*endofpart = 0;
 
 	BUILD_BUG_ON(sizeof(gpt) != 512);
-	/* read GPT header */
+	/* skip protective MBR */
 	lseek(fd, 512, SEEK_SET);
+	/* read GPT header */
 	if (read(fd, &gpt, 512) != 512)
 		return 0;
 
@@ -1308,28 +1308,19 @@ static int get_gpt_last_partition_end(in
 	    entry_size > 512)
 		return -1;
 
-	/* read first GPT partition entries */
-	if (read(fd, buf, 512) != 512)
-		return 0;
-
-	part = (struct GPT_part_entry*)buf;
-
 	for (part_nr=0; part_nr < all_partitions; part_nr++) {
+		/* read partition entry */
+		if (read(fd, &part, entry_size) != (ssize_t)entry_size)
+			return 0;
+
 		/* is this valid partition? */
-		if (memcmp(part->type_guid, empty_gpt_entry, 16) != 0) {
+		if (memcmp(part.type_guid, empty_gpt_entry, 16) != 0) {
 			/* check the last lba for the current partition */
-			curr_part_end = __le64_to_cpu(part->ending_lba);
+			curr_part_end = __le64_to_cpu(part.ending_lba);
 			if (curr_part_end > *endofpart)
 				*endofpart = curr_part_end;
 		}
 
-		part = (struct GPT_part_entry*)((unsigned char*)part + entry_size);
-
-		if ((unsigned char *)part >= buf + 512) {
-			if (read(fd, buf, 512) != 512)
-				return 0;
-			part = (struct GPT_part_entry*)buf;
-		}
 	}
 	return 1;
 }

--UlVJffcvxoiEqYs2--
