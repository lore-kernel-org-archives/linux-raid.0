From: Michal Soltys <soltys@ziu.info>
Subject: [PATCH] compile cleanly with -Wstrict-aliasing=1
Date: Sun, 22 Jan 2012 01:49:20 +0100
Message-ID: <1327193360-4446-2-git-send-email-soltys@ziu.info>
References: <20120112104320.471910db@notabene.brown>
 <1327193360-4446-1-git-send-email-soltys@ziu.info>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1327193360-4446-1-git-send-email-soltys@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

Signed-off-by: Michal Soltys <soltys@ziu.info>
---
 Grow.c        |   14 ++++++------
 Makefile      |    2 +-
 bitmap.h      |    2 +-
 managemon.c   |   13 ++++++-----
 md5.h         |    1 +
 mdadm.h       |   13 +++++++++-
 part.h        |    4 +-
 restripe.c    |   11 ++++++---
 sha1.c        |    8 ++----
 super-ddf.c   |   64 +++++++++++++++++++++++++-------------------------------
 super-gpt.c   |    2 +-
 super-intel.c |   37 +++++++++++++++++----------------
 super-mbr.c   |    4 +-
 super0.c      |   14 +++++++-----
 super1.c      |   17 +++++++++------
 util.c        |    7 +++--
 16 files changed, 113 insertions(+), 100 deletions(-)

diff --git a/Grow.c b/Grow.c
index b2c1360..e10e020 100644
--- a/Grow.c
+++ b/Grow.c
@@ -766,11 +766,11 @@ int remove_disks_for_takeover(struct supertype *st,
 	sra->devs = NULL;
 	/* for each 'copy', select one device and remove from the list. */
 	for (slot = 0; slot < sra->array.raid_disks; slot += nr_of_copies) {
-		struct mdinfo **diskp;
+		mdinfo_pa *diskp;
 		int found = 0;
 
 		/* Find a working device to keep */
-		for (diskp =  &remaining; *diskp ; diskp = &(*diskp)->next) {
+		for (diskp = &remaining; *diskp ; diskp = (mdinfo_pa *)&(*diskp)->next) {
 			struct mdinfo *disk = *diskp;
 
 			if (disk->disk.raid_disk < slot)
@@ -797,10 +797,10 @@ int remove_disks_for_takeover(struct supertype *st,
 
 	if (slot < sra->array.raid_disks) {
 		/* didn't find all slots */
-		struct mdinfo **e;
+		mdinfo_pa *e;
 		e = &remaining;
 		while (*e)
-			e = &(*e)->next;
+			e = (mdinfo_pa *)&(*e)->next;
 		*e = sra->devs;
 		sra->devs = remaining;
 		return 1;
@@ -3177,8 +3177,8 @@ static void validate(int afd, int bfd, unsigned long long offset)
 			free(abuf);
 			free(bbuf);
 			abuflen = len;
-			if (posix_memalign((void**)&abuf, 4096, abuflen) ||
-			    posix_memalign((void**)&bbuf, 4096, abuflen)) {
+			if (posix_memalign((void_pa *)&abuf, 4096, abuflen) ||
+			    posix_memalign((void_pa *)&bbuf, 4096, abuflen)) {
 				abuflen = 0;
 				/* just stop validating on mem-alloc failure */
 				return;
@@ -3291,7 +3291,7 @@ int child_monitor(int afd, struct mdinfo *sra, struct reshape *reshape,
 	stripes = blocks / (sra->array.chunk_size/512) /
 		reshape->before.data_disks;
 
-	if (posix_memalign((void**)&buf, 4096, disks * chunk))
+	if (posix_memalign((void_pa *)&buf, 4096, disks * chunk))
 		/* Don't start the 'reshape' */
 		return 0;
 	if (reshape->before.data_disks == reshape->after.data_disks) {
diff --git a/Makefile b/Makefile
index b8d363f..0cdf9d3 100644
--- a/Makefile
+++ b/Makefile
@@ -42,7 +42,7 @@ KLIBC_GCC = gcc -nostdinc -iwithprefix include -I$(KLIBC)/klibc/include -I$(KLIB
 
 CC = $(CROSS_COMPILE)gcc
 CXFLAGS = -ggdb
-CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
+CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -Wstrict-aliasing=1
 ifdef WARN_UNUSED
 CWFLAGS += -Wp,-D_FORTIFY_SOURCE=2 -O
 endif
diff --git a/bitmap.h b/bitmap.h
index c8725a3..bfc4067 100644
--- a/bitmap.h
+++ b/bitmap.h
@@ -143,7 +143,7 @@ enum bitmap_state {
 };
 
 /* the superblock at the front of the bitmap file -- little endian */
-typedef struct bitmap_super_s {
+typedef struct __attribute__((may_alias)) bitmap_super_s {
 	__u32 magic;        /*  0  BITMAP_MAGIC */
 	__u32 version;      /*  4  the bitmap major for now, could change... */
 	__u8  uuid[16];     /*  8  128 bit uuid - must match md device uuid */
diff --git a/managemon.c b/managemon.c
index cde0d8b..10dad68 100644
--- a/managemon.c
+++ b/managemon.c
@@ -148,16 +148,16 @@ static void free_aa(struct active_array *aa)
 static struct active_array *duplicate_aa(struct active_array *aa)
 {
 	struct active_array *newa = malloc(sizeof(*newa));
-	struct mdinfo **dp1, **dp2;
+	mdinfo_pa *dp1, *dp2;
 
 	*newa = *aa;
 	newa->next = NULL;
 	newa->replaces = NULL;
 	newa->info.next = NULL;
 
-	dp2 = &newa->info.devs;
+	dp2 = (mdinfo_pa *)&newa->info.devs;
 
-	for (dp1 = &aa->info.devs; *dp1; dp1 = &(*dp1)->next) {
+	for (dp1 = (mdinfo_pa *)&aa->info.devs; *dp1; dp1 = (mdinfo_pa *)&(*dp1)->next) {
 		struct mdinfo *d;
 		if ((*dp1)->state_fd < 0)
 			continue;
@@ -165,7 +165,7 @@ static struct active_array *duplicate_aa(struct active_array *aa)
 		d = malloc(sizeof(*d));
 		*d = **dp1;
 		*dp2 = d;
-		dp2 = & d->next;
+		dp2 = (mdinfo_pa *)&d->next;
 	}
 	*dp2 = NULL;
 
@@ -351,7 +351,8 @@ static void manage_container(struct mdstat_ent *mdstat,
 	 * about spare assignment.... probably not.
 	 */
 	if (mdstat->devcnt != container->devcnt) {
-		struct mdinfo **cdp, *cd, *di, *mdi;
+		struct mdinfo *cd, *di, *mdi;
+		mdinfo_pa *cdp;
 		int found;
 
 		/* read /sys/block/NAME/md/dev-??/block/dev to find out
@@ -381,7 +382,7 @@ static void manage_container(struct mdstat_ent *mdstat,
 				remove_disk_from_container(container, cd);
 				free(cd);
 			} else
-				cdp = &(*cdp)->next;
+				cdp = (mdinfo_pa *)&(*cdp)->next;
 		}
 
 		/* check for additions */
diff --git a/md5.h b/md5.h
index 145970d..dde7a4d 100644
--- a/md5.h
+++ b/md5.h
@@ -65,6 +65,7 @@
 #endif
 
 typedef uint32_t md5_uint32;
+typedef uint32_t md5_uint32_a __attribute__((may_alias));
 
 /* Structure to save state of computation between the single steps.  */
 struct md5_ctx
diff --git a/mdadm.h b/mdadm.h
index 381ef86..c5f286a 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -105,7 +105,6 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 #include	"md_u.h"
 #include	"md_p.h"
 #include	"bitmap.h"
-#include	"msg.h"
 
 #include <endian.h>
 /* Redhat don't like to #include <asm/byteorder.h>, and
@@ -163,6 +162,13 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 #endif /* __KLIBC__ */
 
 
+/* strict-alias typedefs */
+typedef void *void_pa __attribute__((may_alias));
+typedef __u64 __u64_a __attribute__((may_alias));
+typedef __u32 __u32_a __attribute__((may_alias));
+typedef __u16 __u16_a __attribute__((may_alias));
+typedef __u8 *__u8_pa __attribute__((may_alias));
+
 /*
  * min()/max()/clamp() macros that also do
  * strict type-checking.. See the
@@ -181,7 +187,7 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 	_max1 > _max2 ? _max1 : _max2; })
 
 /* general information that might be extracted from a superblock */
-struct mdinfo {
+struct __attribute__((may_alias)) mdinfo {
 	mdu_array_info_t	array;
 	mdu_disk_info_t		disk;
 	__u64			events;
@@ -242,6 +248,9 @@ struct mdinfo {
 	int prev_state, curr_state, next_state;
 
 };
+typedef struct mdinfo *mdinfo_pa __attribute__((may_alias));
+
+#include	"msg.h"
 
 struct createinfo {
 	int	uid;
diff --git a/part.h b/part.h
index 0afea33..bf1131a 100644
--- a/part.h
+++ b/part.h
@@ -47,7 +47,7 @@ struct MBR {
 	__u8 pad[446];
 	struct MBR_part_record parts[MBR_PARTITIONS];
 	__u16 magic;
-} __attribute__((packed));
+} __attribute__((packed, may_alias));
 
 
 
@@ -79,4 +79,4 @@ struct GPT {
 	__u32 part_size;
 	__u32 part_crc;
 	__u8 pad2[420];
-} __attribute__((packed));
+} __attribute__((packed, may_alias));
diff --git a/restripe.c b/restripe.c
index 00e7a82..3880b18 100644
--- a/restripe.c
+++ b/restripe.c
@@ -223,7 +223,7 @@ static void xor_blocks(char *target, char **sources, int disks, int size)
 	}
 }
 
-void qsyndrome(uint8_t *p, uint8_t *q, uint8_t **sources, int disks, int size)
+void qsyndrome(uint8_t *p, uint8_t *q, __u8_pa *sources, int disks, int size)
 {
 	int d, z;
 	uint8_t wq0, wp0, wd0, w10, w20;
@@ -691,7 +691,7 @@ int restore_stripes(int *dest, unsigned long long *offsets,
 
 	int data_disks = raid_disks - (level == 0 ? 0 : level <= 5 ? 1 : 2);
 
-	if (posix_memalign((void**)&stripe_buf, 4096, raid_disks * chunk_size))
+	if (posix_memalign((void_pa *)&stripe_buf, 4096, raid_disks * chunk_size))
 		stripe_buf = NULL;
 
 	if (zero == NULL || chunk_size > zero_size) {
@@ -780,7 +780,7 @@ int restore_stripes(int *dest, unsigned long long *offsets,
 			}
 			qsyndrome((uint8_t*)stripes[disk],
 				  (uint8_t*)stripes[qdisk], 
-				  (uint8_t**)blocks,
+				  (__u8_pa *)blocks,
 				  syndrome_disks, chunk_size);
 			break;
 		}
@@ -847,7 +847,10 @@ int test_stripes(int *source, unsigned long long *offsets,
 		}
 		switch(level) {
 		case 6:
-			qsyndrome(p, q, (uint8_t**)blocks, data_disks, chunk_size);
+			qsyndrome((uint8_t*)p,
+				  (uint8_t*)q,
+				  (__u8_pa *)blocks,
+				  data_disks, chunk_size);
 			diskP = geo_map(-1, start/chunk_size, raid_disks,
 				       level, layout);
 			if (memcmp(p, stripes[diskP], chunk_size) != 0) {
diff --git a/sha1.c b/sha1.c
index 0258515..fab3c23 100644
--- a/sha1.c
+++ b/sha1.c
@@ -101,7 +101,6 @@ sha1_finish_ctx (struct sha1_ctx *ctx, void *resbuf)
   /* Take yet unprocessed bytes into account.  */
   md5_uint32 bytes = ctx->buflen;
   size_t pad;
-  md5_uint32 *ptr;
 
   /* Now count remaining bytes.  */
   ctx->total[0] += bytes;
@@ -112,10 +111,9 @@ sha1_finish_ctx (struct sha1_ctx *ctx, void *resbuf)
   memcpy (&ctx->buffer[bytes], fillbuf, pad);
 
   /* Put the 64-bit file length in *bits* at the end of the buffer.  */
-  ptr = (md5_uint32 *) &ctx->buffer[bytes + pad + 4];
-  *ptr = SWAP (ctx->total[0] << 3);
-  ptr = (md5_uint32 *) &ctx->buffer[bytes + pad];
-  *ptr = SWAP ((ctx->total[1] << 3) | (ctx->total[0] >> 29));
+  *(md5_uint32_a *) &ctx->buffer[bytes + pad + 4] = SWAP (ctx->total[0] << 3);
+  *(md5_uint32_a *) &ctx->buffer[bytes + pad] = SWAP ((ctx->total[1] << 3) |
+						    (ctx->total[0] >> 29));
 
   /* Process last bytes.  */
   sha1_process_block (ctx->buffer, bytes + pad + 8, ctx);
diff --git a/super-ddf.c b/super-ddf.c
index abd6793..4cef507 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -399,12 +399,12 @@ struct ddf_super {
 	unsigned int max_part, mppe, conf_rec_len;
 	int currentdev;
 	int updates_pending;
-	struct vcl {
+	struct __attribute__((may_alias)) vcl {
 		union {
 			char space[512];
 			struct {
 				struct vcl	*next;
-				__u64		*lba_offset; /* location in 'conf' of
+				__u64_a		*lba_offset; /* location in 'conf' of
 							      * the lba table */
 				unsigned int	vcnum; /* index into ->virt */
 				__u64		*block_sizes; /* NULL if all the same */
@@ -649,7 +649,7 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 	unsigned long long dsize;
 
 	/* First the local disk info */
-	if (posix_memalign((void**)&dl, 512,
+	if (posix_memalign((void_pa *)&dl, 512,
 		       sizeof(*dl) +
 		       (super->max_part) * sizeof(dl->vlist[0])) != 0) {
 		fprintf(stderr, Name ": %s could not allocate disk info buffer\n",
@@ -704,7 +704,7 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 		if (vd->magic == DDF_SPARE_ASSIGN_MAGIC) {
 			if (dl->spare)
 				continue;
-			if (posix_memalign((void**)&dl->spare, 512,
+			if (posix_memalign((void_pa *)&dl->spare, 512,
 				       super->conf_rec_len*512) != 0) {
 				fprintf(stderr, Name
 					": %s could not allocate spare info buf\n",
@@ -729,7 +729,7 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 			    __be32_to_cpu(vcl->conf.seqnum))
 				continue;
 		} else {
-			if (posix_memalign((void**)&vcl, 512,
+			if (posix_memalign((void_pa *)&vcl, 512,
 				       (super->conf_rec_len*512 +
 					offsetof(struct vcl, conf))) != 0) {
 				fprintf(stderr, Name
@@ -743,7 +743,7 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 			dl->vlist[vnum++] = vcl;
 		}
 		memcpy(&vcl->conf, vd, super->conf_rec_len*512);
-		vcl->lba_offset = (__u64*)
+		vcl->lba_offset = (__u64_a *)
 			&vcl->conf.phys_refnum[super->mppe];
 
 		for (i=0; i < max_virt_disks ; i++)
@@ -760,7 +760,7 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 
 #ifndef MDASSEMBLE
 static int load_super_ddf_all(struct supertype *st, int fd,
-			      void **sbp, char *devname);
+			      void_pa *sbp, char *devname);
 #endif
 
 static void free_super_ddf(struct supertype *st);
@@ -799,7 +799,7 @@ static int load_super_ddf(struct supertype *st, int fd,
 
 	free_super_ddf(st);
 
-	if (posix_memalign((void**)&super, 512, sizeof(*super))!= 0) {
+	if (posix_memalign((void_pa *)&super, 512, sizeof(*super))!= 0) {
 		fprintf(stderr, Name ": malloc of %zu failed.\n",
 			sizeof(*super));
 		return 1;
@@ -1336,7 +1336,6 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
 {
 	struct ddf_super *ddf = st->sb;
 	int map_disks = info->array.raid_disks;
-	__u32 *cptr;
 
 	if (ddf->currentconf) {
 		getinfo_super_ddf_bvd(st, info, map);
@@ -1348,9 +1347,8 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
 	info->array.level	  = LEVEL_CONTAINER;
 	info->array.layout	  = 0;
 	info->array.md_minor	  = -1;
-	cptr = (__u32 *)(ddf->anchor.guid + 16);
-	info->array.ctime	  = DECADE + __be32_to_cpu(*cptr);
-
+	info->array.ctime	  = DECADE + __be32_to_cpu(*(__u32_a *)
+							 (ddf->anchor.guid+16));
 	info->array.utime	  = 0;
 	info->array.chunk_size	  = 0;
 	info->container_enough	  = 1;
@@ -1409,7 +1407,6 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 	int j;
 	struct dl *dl;
 	int map_disks = info->array.raid_disks;
-	__u32 *cptr;
 
 	memset(info, 0, sizeof(*info));
 	/* FIXME this returns BVD info - what if we want SVD ?? */
@@ -1419,8 +1416,8 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 	info->array.layout	  = rlq_to_layout(vc->conf.rlq, vc->conf.prl,
 						  info->array.raid_disks);
 	info->array.md_minor	  = -1;
-	cptr = (__u32 *)(vc->conf.guid + 16);
-	info->array.ctime	  = DECADE + __be32_to_cpu(*cptr);
+	info->array.ctime	  = DECADE +
+		__be32_to_cpu(*(__u32_a *)(vc->conf.guid+16));
 	info->array.utime	  = DECADE + __be32_to_cpu(vc->conf.timestamp);
 	info->array.chunk_size	  = 512 << vc->conf.chunk_shift;
 	info->custom_array_size	  = 0;
@@ -1628,7 +1625,7 @@ static int init_super_ddf(struct supertype *st,
 	if (st->sb)
 		return init_super_ddf_bvd(st, info, size, name, homehost, uuid);
 
-	if (posix_memalign((void**)&ddf, 512, sizeof(*ddf)) != 0) {
+	if (posix_memalign((void_pa *)&ddf, 512, sizeof(*ddf)) != 0) {
 		fprintf(stderr, Name ": %s could not allocate superblock\n", __func__);
 		return 0;
 	}
@@ -1766,7 +1763,7 @@ static int init_super_ddf(struct supertype *st,
 	if (homehost && strlen(homehost) < 440)
 		strcpy((char*)ddf->controller.vendor_data, homehost);
 
-	if (posix_memalign((void**)&pd, 512, pdsize) != 0) {
+	if (posix_memalign((void_pa *)&pd, 512, pdsize) != 0) {
 		fprintf(stderr, Name ": %s could not allocate pd\n", __func__);
 		return 0;
 	}
@@ -1780,7 +1777,7 @@ static int init_super_ddf(struct supertype *st,
 	pd->max_pdes = __cpu_to_be16(max_phys_disks);
 	memset(pd->pad, 0xff, 52);
 
-	if (posix_memalign((void**)&vd, 512, vdsize) != 0) {
+	if (posix_memalign((void_pa *)&vd, 512, vdsize) != 0) {
 		fprintf(stderr, Name ": %s could not allocate vd\n", __func__);
 		return 0;
 	}
@@ -2021,12 +2018,12 @@ static int init_super_ddf_bvd(struct supertype *st,
 		__cpu_to_be16(__be16_to_cpu(ddf->virt->populated_vdes)+1);
 
 	/* Now create a new vd_config */
-	if (posix_memalign((void**)&vcl, 512,
+	if (posix_memalign((void_pa *)&vcl, 512,
 		           (offsetof(struct vcl, conf) + ddf->conf_rec_len * 512)) != 0) {
 		fprintf(stderr, Name ": %s could not allocate vd_config\n", __func__);
 		return 0;
 	}
-	vcl->lba_offset = (__u64*) &vcl->conf.phys_refnum[ddf->mppe];
+	vcl->lba_offset = (__u64_a *) &vcl->conf.phys_refnum[ddf->mppe];
 	vcl->vcnum = venum;
 	vcl->block_sizes = NULL; /* FIXME not for CONCAT */
 
@@ -2095,7 +2092,7 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 	struct dl *dl;
 	struct ddf_super *ddf = st->sb;
 	struct vd_config *vc;
-	__u64 *lba_offset;
+	__u64_a *lba_offset;
 	unsigned int working;
 	unsigned int i;
 	unsigned long long blocks, pos, esize;
@@ -2195,7 +2192,6 @@ static int add_to_super_ddf(struct supertype *st,
 	struct phys_disk_entry *pde;
 	unsigned int n, i;
 	struct stat stb;
-	__u32 *tptr;
 
 	if (ddf->currentconf) {
 		add_to_super_ddf_bvd(st, dk, fd, devname);
@@ -2206,7 +2202,7 @@ static int add_to_super_ddf(struct supertype *st,
 	 * a phys_disk entry and a more detailed disk_data entry.
 	 */
 	fstat(fd, &stb);
-	if (posix_memalign((void**)&dd, 512,
+	if (posix_memalign((void_pa *)&dd, 512,
 		           sizeof(*dd) + sizeof(dd->vlist[0]) * ddf->max_part) != 0) {
 		fprintf(stderr, Name
 			": %s could allocate buffer for new disk, aborting\n",
@@ -2224,9 +2220,8 @@ static int add_to_super_ddf(struct supertype *st,
 	tm = localtime(&now);
 	sprintf(dd->disk.guid, "%8s%04d%02d%02d",
 		T10, tm->tm_year+1900, tm->tm_mon+1, tm->tm_mday);
-	tptr = (__u32 *)(dd->disk.guid + 16);
-	*tptr++ = random32();
-	*tptr = random32();
+	*(__u32_a *)(dd->disk.guid + 16) = random32();
+	*(__u32_a *)(dd->disk.guid + 20) = random32();
 
 	do {
 		/* Cannot be bothered finding a CRC of some irrelevant details*/
@@ -2721,7 +2716,7 @@ static int validate_geometry_ddf(struct supertype *st,
 		 * and try to create a bvd
 		 */
 		struct ddf_super *ddf;
-		if (load_super_ddf_all(st, cfd, (void **)&ddf, NULL) == 0) {
+		if (load_super_ddf_all(st, cfd, (void_pa *)&ddf, NULL) == 0) {
 			st->sb = ddf;
 			st->container_dev = fd2devnum(cfd);
 			close(cfd);
@@ -2868,7 +2863,7 @@ static int validate_geometry_ddf_bvd(struct supertype *st,
 }
 
 static int load_super_ddf_all(struct supertype *st, int fd,
-			      void **sbp, char *devname)
+			      void_pa *sbp, char *devname)
 {
 	struct mdinfo *sra;
 	struct ddf_super *super;
@@ -2886,7 +2881,7 @@ static int load_super_ddf_all(struct supertype *st, int fd,
 	    strcmp(sra->text_version, "ddf") != 0)
 		return 1;
 
-	if (posix_memalign((void**)&super, 512, sizeof(*super)) != 0)
+	if (posix_memalign((void_pa *)&super, 512, sizeof(*super)) != 0)
 		return 1;
 	memset(super, 0, sizeof(*super));
 
@@ -2972,7 +2967,6 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 		unsigned int j;
 		struct mdinfo *this;
 		char *ep;
-		__u32 *cptr;
 
 		if (subarray &&
 		    (strtoul(subarray, &ep, 10) != vc->vcnum ||
@@ -2992,8 +2986,8 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 		this->array.md_minor      = -1;
 		this->array.major_version = -1;
 		this->array.minor_version = -2;
-		cptr = (__u32 *)(vc->conf.guid + 16);
-		this->array.ctime         = DECADE + __be32_to_cpu(*cptr);
+		this->array.ctime         = DECADE +
+			__be32_to_cpu(*(__u32_a *)(vc->conf.guid+16));
 		this->array.utime	  = DECADE +
 			__be32_to_cpu(vc->conf.timestamp);
 		this->array.chunk_size	  = 512 << vc->conf.chunk_shift;
@@ -3480,7 +3474,7 @@ static void ddf_process_update(struct supertype *st,
 			update->space = NULL;
 			vcl->next = ddf->conflist;
 			memcpy(&vcl->conf, vc, update->len);
-			vcl->lba_offset = (__u64*)
+			vcl->lba_offset = (__u64_a *)
 				&vcl->conf.phys_refnum[mppe];
 			for (ent = 0;
 			     ent < __be16_to_cpu(ddf->virt->populated_vdes);
@@ -3632,7 +3626,7 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 	struct dl *dl;
 	int i;
 	struct vd_config *vc;
-	__u64 *lba;
+	__u64_a *lba;
 
 	for (d = a->info.devs ; d ; d = d->next) {
 		if ((d->curr_state & DS_FAULTY) &&
@@ -3810,7 +3804,7 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 	memcpy(mu->buf, vc, ddf->conf_rec_len * 512);
 
 	vc = (struct vd_config*)mu->buf;
-	lba = (__u64*)&vc->phys_refnum[ddf->mppe];
+	lba = (__u64_a *)&vc->phys_refnum[ddf->mppe];
 	for (di = rv ; di ; di = di->next) {
 		vc->phys_refnum[di->disk.raid_disk] =
 			ddf->phys->entries[dl->pdnum].refnum;
diff --git a/super-gpt.c b/super-gpt.c
index 75269bf..3558219 100644
--- a/super-gpt.c
+++ b/super-gpt.c
@@ -76,7 +76,7 @@ static int load_gpt(struct supertype *st, int fd, char *devname)
 
 	free_gpt(st);
 
-	if (posix_memalign((void**)&super, 4096, 32*512) != 0) {
+	if (posix_memalign((void_pa *)&super, 4096, 32*512) != 0) {
 		fprintf(stderr, Name ": %s could not allocate superblock\n",
 			__func__);
 		return 1;
diff --git a/super-intel.c b/super-intel.c
index 0e9269f..20c0145 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -187,7 +187,7 @@ struct imsm_dev {
 #define IMSM_DEV_FILLERS 10
 	__u32 filler[IMSM_DEV_FILLERS];
 	struct imsm_vol vol;
-} __attribute__ ((packed));
+} __attribute__ ((packed, may_alias));
 
 struct imsm_super {
 	__u8 sig[MAX_SIGNATURE_LENGTH];	/* 0x00 - 0x1F */
@@ -345,7 +345,7 @@ struct intel_super {
 	__u32 create_offset; /* common start for 'current_vol' */
 	__u32 random; /* random data for seeding new family numbers */
 	struct intel_dev *devlist;
-	struct dl {
+	struct __attribute__((may_alias)) dl {
 		struct dl *next;
 		int index;
 		__u8 serial[MAX_RAID_SERIAL_LEN];
@@ -366,6 +366,7 @@ struct intel_super {
 	const struct imsm_orom *orom; /* platform firmware support */
 	struct intel_super *next; /* (temp) list for disambiguating family_num */
 };
+typedef struct dl *dl_pa __attribute__((may_alias));
 
 struct intel_disk {
 	struct imsm_disk disk;
@@ -654,7 +655,7 @@ static struct imsm_disk *get_imsm_disk(struct intel_super *super, __u8 index)
 static __u32 __gen_imsm_checksum(struct imsm_super *mpb)
 {
 	__u32 end = mpb->mpb_size / sizeof(end);
-	__u32 *p = (__u32 *) mpb;
+	__u32_a *p = (__u32_a *) mpb;
 	__u32 sum = 0;
 
         while (end--) {
@@ -3390,7 +3391,7 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 		return 1;
 	}
 
-	if (posix_memalign((void**)&anchor, 512, 512) != 0) {
+	if (posix_memalign((void_pa *)&anchor, 512, 512) != 0) {
 		if (devname)
 			fprintf(stderr,
 				Name ": Failed to allocate imsm anchor buffer"
@@ -4009,7 +4010,7 @@ imsm_thunderdome(struct intel_super **super_list, int len)
 	return champion;
 }
 
-static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
+static int load_super_imsm_all(struct supertype *st, int fd, void_pa *sbp,
 			       char *devname)
 {
 	struct mdinfo *sra;
@@ -5622,7 +5623,7 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 		 */
 		struct intel_super *super;
 
-		if (load_super_imsm_all(st, cfd, (void **) &super, NULL) == 0) {
+		if (load_super_imsm_all(st, cfd, (void_pa *) &super, NULL) == 0) {
 			st->sb = super;
 			st->container_dev = fd2devnum(cfd);
 			close(cfd);
@@ -7179,7 +7180,7 @@ static int apply_reshape_migration_update(struct imsm_update_reshape_migration *
 						void ***space_list)
 {
 	struct intel_dev *id;
-	void **tofree = NULL;
+	void_pa *tofree = NULL;
 	int ret_val = 0;
 
 	dprintf("apply_reshape_migration_update()\n");
@@ -7239,7 +7240,7 @@ static int apply_reshape_migration_update(struct imsm_update_reshape_migration *
 						     ord);
 			}
 			id->dev = new_dev;
-			tofree = (void **)dev;
+			tofree = (void_pa *)dev;
 
 			/* update chunk size
 			 */
@@ -7389,19 +7390,19 @@ static int apply_update_activate_spare(struct imsm_update_activate_spare *u,
 		 * utilized anywhere
 		 */
 		if (!found) {
-			struct dl **dlp;
+			dl_pa *dlp;
 
 			/* We know that 'manager' isn't touching anything,
 			 * so it is safe to delete
 			 */
-			for (dlp = &super->disks; *dlp; dlp = &(*dlp)->next)
+			for (dlp = (dl_pa *)&super->disks; *dlp; dlp = (dl_pa *)&(*dlp)->next)
 				if ((*dlp)->index == victim)
 					break;
 
 			/* victim may be on the missing list */
 			if (!*dlp)
 				for (dlp = &super->missing; *dlp;
-				     dlp = &(*dlp)->next)
+				     dlp = (dl_pa *)&(*dlp)->next)
 					if ((*dlp)->index == victim)
 						break;
 			imsm_delete(super, dlp, victim);
@@ -7455,7 +7456,7 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 	/* manage changes in volume
 	 */
 	for (dev_id = 0; dev_id < mpb->num_raid_devs; dev_id++) {
-		void **sp = *space_list;
+		void_pa *sp = *space_list;
 		struct imsm_dev *newdev;
 		struct imsm_map *newmap, *oldmap;
 
@@ -7498,7 +7499,7 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 			imsm_set_array_size(newdev);
 		}
 
-		sp = (void **)id->dev;
+		sp = (void_pa *)id->dev;
 		id->dev = newdev;
 		*sp = tofree;
 		tofree = sp;
@@ -7933,7 +7934,7 @@ static void imsm_prepare_update(struct supertype *st,
 	case update_takeover: {
 		struct imsm_update_takeover *u = (void *)update->buf;
 		if (u->direction == R0_TO_R10) {
-			void **tail = (void **)&update->space_list;
+			void_pa *tail = (void_pa *)&update->space_list;
 			struct imsm_dev *dev = get_imsm_dev(super, u->subarray);
 			struct imsm_map *map = get_imsm_map(dev, MAP_0);
 			int num_members = map->num_members;
@@ -7988,7 +7989,7 @@ static void imsm_prepare_update(struct supertype *st,
 		 */
 		struct imsm_update_reshape *u = (void *)update->buf;
 		struct intel_dev *dl;
-		void **space_tail = (void**)&update->space_list;
+		void_pa *space_tail = (void_pa *)&update->space_list;
 
 		dprintf("imsm: imsm_prepare_update() for update_reshape\n");
 
@@ -8019,7 +8020,7 @@ static void imsm_prepare_update(struct supertype *st,
 		 */
 		struct imsm_update_reshape_migration *u = (void *)update->buf;
 		struct intel_dev *id;
-		void **space_tail = (void **)&update->space_list;
+		void_pa *space_tail = (void_pa *)&update->space_list;
 		int size;
 		void *s;
 		int current_level = -1;
@@ -8618,7 +8619,7 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 			__le32_to_cpu(map_dest->pba_of_lba0)) * 512;
 
 	unit_len = __le32_to_cpu(migr_rec->dest_depth_per_unit) * 512;
-	if (posix_memalign((void **)&buf, 512, unit_len) != 0)
+	if (posix_memalign((void_pa *)&buf, 512, unit_len) != 0)
 		goto abort;
 	targets = malloc(new_disks * sizeof(int));
 	if (!targets)
@@ -9538,7 +9539,7 @@ static int imsm_manage_reshape(
 	buf_size += __le32_to_cpu(migr_rec->dest_depth_per_unit) * 512;
 	/* add space for stripe aligment */
 	buf_size += old_data_stripe_length;
-	if (posix_memalign((void **)&buf, 4096, buf_size)) {
+	if (posix_memalign((void_pa *)&buf, 4096, buf_size)) {
 		dprintf("imsm: Cannot allocate checpoint buffer\n");
 		goto abort;
 	}
diff --git a/super-mbr.c b/super-mbr.c
index 6499963..bb087c7 100644
--- a/super-mbr.c
+++ b/super-mbr.c
@@ -80,7 +80,7 @@ static int load_super_mbr(struct supertype *st, int fd, char *devname)
 
 	free_mbr(st);
 
-	if (posix_memalign((void**)&super, 512, 512) != 0) {
+	if (posix_memalign((void_pa *)&super, 512, 512) != 0) {
 		fprintf(stderr, Name ": %s could not allocate superblock\n",
 			__func__);
 		return 1;
@@ -120,7 +120,7 @@ static int store_mbr(struct supertype *st, int fd)
 {
 	struct MBR *old, *super;
 
-	if (posix_memalign((void**)&old, 512, 512) != 0) {
+	if (posix_memalign((void_pa *)&old, 512, 512) != 0) {
 		fprintf(stderr, Name ": %s could not allocate superblock\n",
 			__func__);
 		return 1;
diff --git a/super0.c b/super0.c
index dab85db..49bbde0 100644
--- a/super0.c
+++ b/super0.c
@@ -436,7 +436,7 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
 		 * So we copy the tail of the superblock
 		 * up 4 bytes before continuing
 		 */
-		__u32 *sb32 = (__u32*)sb;
+		__u32_a *sb32 = (__u32_a *)sb;
 		memcpy(sb32+MD_SB_GENERIC_CONSTANT_WORDS+7,
 		       sb32+MD_SB_GENERIC_CONSTANT_WORDS+7+1,
 		       (MD_SB_WORDS - (MD_SB_GENERIC_CONSTANT_WORDS+7+1))*4);
@@ -602,7 +602,7 @@ static int init_super0(struct supertype *st, mdu_array_info_t *info,
 	mdp_super_t *sb;
 	int spares;
 
-	if (posix_memalign((void**)&sb, 4096,
+	if (posix_memalign((void_pa *)&sb, 4096,
 			   MD_SB_BYTES + ROUND_UP(sizeof(bitmap_super_t), 4096)) != 0) {
 		fprintf(stderr, Name ": %s could not allocate superblock\n", __func__);
 		return 0;
@@ -682,6 +682,7 @@ struct devinfo {
 	mdu_disk_info_t disk;
 	struct devinfo *next;
 };
+typedef struct devinfo *devinfo_pa __attribute__((may_alias));
 
 #ifndef MDASSEMBLE
 /* Add a device to the superblock being created */
@@ -690,7 +691,8 @@ static int add_to_super0(struct supertype *st, mdu_disk_info_t *dinfo,
 {
 	mdp_super_t *sb = st->sb;
 	mdp_disk_t *dk = &sb->disks[dinfo->number];
-	struct devinfo *di, **dip;
+	struct devinfo *di;
+	devinfo_pa *dip;
 
 	dk->number = dinfo->number;
 	dk->major = dinfo->major;
@@ -703,7 +705,7 @@ static int add_to_super0(struct supertype *st, mdu_disk_info_t *dinfo,
 	sb->this_disk = sb->disks[dinfo->number];
 	sb->sb_csum = calc_sb0_csum(sb);
 
-	dip = (struct devinfo **)&st->info;
+	dip = (devinfo_pa *)&st->info;
 	while (*dip)
 		dip = &(*dip)->next;
 	di = malloc(sizeof(struct devinfo));
@@ -801,7 +803,7 @@ static int compare_super0(struct supertype *st, struct supertype *tst)
 	if (second->md_magic != MD_SB_MAGIC)
 		return 1;
 	if (!first) {
-		if (posix_memalign((void**)&first, 4096,
+		if (posix_memalign((void_pa *)&first, 4096,
 			     MD_SB_BYTES + 
 			     ROUND_UP(sizeof(struct bitmap_super_s), 4096)) != 0) {
 			fprintf(stderr, Name
@@ -873,7 +875,7 @@ static int load_super0(struct supertype *st, int fd, char *devname)
 		return 1;
 	}
 
-	if (posix_memalign((void**)&super, 4096,
+	if (posix_memalign((void_pa *)&super, 4096,
 			   MD_SB_BYTES +
 			   ROUND_UP(sizeof(bitmap_super_t), 4096)) != 0) {
 		fprintf(stderr, Name
diff --git a/super1.c b/super1.c
index 867aa58..5773b5d 100644
--- a/super1.c
+++ b/super1.c
@@ -110,7 +110,7 @@ static unsigned int calc_sb_1_csum(struct mdp_superblock_1 * sb)
 	unsigned int disk_csum, csum;
 	unsigned long long newcsum;
 	int size = sizeof(*sb) + __le32_to_cpu(sb->max_dev)*2;
-	unsigned int *isuper = (unsigned int*)sb;
+	__u32_a *isuper = (__u32_a *)sb;
 
 /* make sure I can count... */
 	if (offsetof(struct mdp_superblock_1,data_offset) != 128 ||
@@ -128,7 +128,7 @@ static unsigned int calc_sb_1_csum(struct mdp_superblock_1 * sb)
 	}
 
 	if (size == 2)
-		newcsum += __le16_to_cpu(*(unsigned short*) isuper);
+		newcsum += __le16_to_cpu(*(__u16_a *) isuper);
 
 	csum = (newcsum & 0xffffffff) + (newcsum >> 32);
 	sb->sb_csum = disk_csum;
@@ -828,7 +828,7 @@ static int init_super1(struct supertype *st, mdu_array_info_t *info,
 	int rfd;
 	char defname[10];
 
-	if (posix_memalign((void**)&sb, 512, (1024 + 512 + 
+	if (posix_memalign((void_pa *)&sb, 512, (1024 + 512 +
 			   sizeof(struct misc_dev_info))) != 0) {
 		fprintf(stderr, Name
 			": %s could not allocate superblock\n", __func__);
@@ -912,6 +912,8 @@ struct devinfo {
 	mdu_disk_info_t disk;
 	struct devinfo *next;
 };
+typedef struct devinfo *devinfo_pa __attribute__((may_alias));
+
 #ifndef MDASSEMBLE
 /* Add a device to the superblock being created */
 static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
@@ -919,7 +921,8 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 {
 	struct mdp_superblock_1 *sb = st->sb;
 	__u16 *rp = sb->dev_roles + dk->number;
-	struct devinfo *di, **dip;
+	struct devinfo *di;
+	devinfo_pa *dip;
 
 	if ((dk->state & 6) == 6) /* active, sync */
 		*rp = __cpu_to_le16(dk->raid_disk);
@@ -936,7 +939,7 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 	sb->devflags = 0; /* don't copy another disks flags */
 	sb->sb_csum = calc_sb_1_csum(sb);
 
-	dip = (struct devinfo **)&st->info;
+	dip = (devinfo_pa *)&st->info;
 	while (*dip)
 		dip = &(*dip)->next;
 	di = malloc(sizeof(struct devinfo));
@@ -1207,7 +1210,7 @@ static int compare_super1(struct supertype *st, struct supertype *tst)
 		return 1;
 
 	if (!first) {
-		if (posix_memalign((void**)&first, 512,
+		if (posix_memalign((void_pa *)&first, 512,
 			       1024 + 512 +
 			       sizeof(struct misc_dev_info)) != 0) {
 			fprintf(stderr, Name
@@ -1322,7 +1325,7 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 		return 1;
 	}
 
-	if (posix_memalign((void**)&super, 512,
+	if (posix_memalign((void_pa *)&super, 512,
 		       1024 + 512 +
 		       sizeof(struct misc_dev_info)) != 0) {
 		fprintf(stderr, Name ": %s could not allocate superblock\n",
diff --git a/util.c b/util.c
index 6985a70..796fc05 100644
--- a/util.c
+++ b/util.c
@@ -1730,7 +1730,8 @@ struct mdinfo *container_choose_spares(struct supertype *st,
 				       char *spare_group,
 				       const char *metadata, int get_one)
 {
-	struct mdinfo *d, **dp, *disks = NULL;
+	struct mdinfo *d, *disks = NULL;
+	mdinfo_pa *dp;
 
 	/* get list of all disks in container */
 	if (st->ss->getinfo_super_disks)
@@ -1739,7 +1740,7 @@ struct mdinfo *container_choose_spares(struct supertype *st,
 	if (!disks)
 		return disks;
 	/* find spare devices on the list */
-	dp = &disks->devs;
+	dp = (mdinfo_pa *)&disks->devs;
 	disks->array.spare_disks = 0;
 	while (*dp) {
 		int found = 0;
@@ -1765,7 +1766,7 @@ struct mdinfo *container_choose_spares(struct supertype *st,
 			}
 		}
 		if (found) {
-			dp = &d->next;
+			dp = (mdinfo_pa *)&d->next;
 			disks->array.spare_disks++;
 			if (get_one) {
 				sysfs_free(*dp);
-- 
1.7.7.1

