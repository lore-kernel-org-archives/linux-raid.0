From: mwilck@arcor.de
Subject: [PATCH 2/6] DDF: convert big endian to be32 type
Date: Sun, 21 Jul 2013 19:28:20 +0200
Message-ID: <1374427704-7903-3-git-send-email-mwilck@arcor.de>
References: <1374427704-7903-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374427704-7903-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Part 2 of endianness-safe conversion
---
 super-ddf.c |  340 ++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 171 insertions(+), 169 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 7f28d84..5c016a4 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -131,28 +131,28 @@ static inline be64 cpu_to_be64(__u64 x)
 #define	DDF_2SPANNED	0x03	/* This is also weird - be careful */
 
 /* Magic numbers */
-#define	DDF_HEADER_MAGIC	__cpu_to_be32(0xDE11DE11)
-#define	DDF_CONTROLLER_MAGIC	__cpu_to_be32(0xAD111111)
-#define	DDF_PHYS_RECORDS_MAGIC	__cpu_to_be32(0x22222222)
-#define	DDF_PHYS_DATA_MAGIC	__cpu_to_be32(0x33333333)
-#define	DDF_VIRT_RECORDS_MAGIC	__cpu_to_be32(0xDDDDDDDD)
-#define	DDF_VD_CONF_MAGIC	__cpu_to_be32(0xEEEEEEEE)
-#define	DDF_SPARE_ASSIGN_MAGIC	__cpu_to_be32(0x55555555)
-#define	DDF_VU_CONF_MAGIC	__cpu_to_be32(0x88888888)
-#define	DDF_VENDOR_LOG_MAGIC	__cpu_to_be32(0x01dBEEF0)
-#define	DDF_BBM_LOG_MAGIC	__cpu_to_be32(0xABADB10C)
+#define	DDF_HEADER_MAGIC	cpu_to_be32(0xDE11DE11)
+#define	DDF_CONTROLLER_MAGIC	cpu_to_be32(0xAD111111)
+#define	DDF_PHYS_RECORDS_MAGIC	cpu_to_be32(0x22222222)
+#define	DDF_PHYS_DATA_MAGIC	cpu_to_be32(0x33333333)
+#define	DDF_VIRT_RECORDS_MAGIC	cpu_to_be32(0xDDDDDDDD)
+#define	DDF_VD_CONF_MAGIC	cpu_to_be32(0xEEEEEEEE)
+#define	DDF_SPARE_ASSIGN_MAGIC	cpu_to_be32(0x55555555)
+#define	DDF_VU_CONF_MAGIC	cpu_to_be32(0x88888888)
+#define	DDF_VENDOR_LOG_MAGIC	cpu_to_be32(0x01dBEEF0)
+#define	DDF_BBM_LOG_MAGIC	cpu_to_be32(0xABADB10C)
 
 #define	DDF_GUID_LEN	24
 #define DDF_REVISION_0	"01.00.00"
 #define DDF_REVISION_2	"01.02.00"
 
 struct ddf_header {
-	__u32	magic;		/* DDF_HEADER_MAGIC */
-	__u32	crc;
+	be32	magic;		/* DDF_HEADER_MAGIC */
+	be32	crc;
 	char	guid[DDF_GUID_LEN];
 	char	revision[8];	/* 01.02.00 */
-	__u32	seq;		/* starts at '1' */
-	__u32	timestamp;
+	be32	seq;		/* starts at '1' */
+	be32	timestamp;
 	__u8	openflag;
 	__u8	foreignflag;
 	__u8	enforcegroups;
@@ -164,7 +164,7 @@ struct ddf_header {
 	__u64	secondary_lba;
 	__u8	type;
 	__u8	pad2[3];	/* 0xff */
-	__u32	workspace_len;	/* sectors for vendor space -
+	be32	workspace_len;	/* sectors for vendor space -
 				 * at least 32768(sectors) */
 	__u64	workspace_lba;
 	__u16	max_pd_entries;	/* one of 15, 63, 255, 1023, 4095 */
@@ -176,22 +176,22 @@ struct ddf_header {
 	__u16	max_primary_element_entries; /* 16, 64, 256, 1024, or 4096 */
 	__u8	pad3[54];	/* 0xff */
 	/* 192 bytes so far */
-	__u32	controller_section_offset;
-	__u32	controller_section_length;
-	__u32	phys_section_offset;
-	__u32	phys_section_length;
-	__u32	virt_section_offset;
-	__u32	virt_section_length;
-	__u32	config_section_offset;
-	__u32	config_section_length;
-	__u32	data_section_offset;
-	__u32	data_section_length;
-	__u32	bbm_section_offset;
-	__u32	bbm_section_length;
-	__u32	diag_space_offset;
-	__u32	diag_space_length;
-	__u32	vendor_offset;
-	__u32	vendor_length;
+	be32	controller_section_offset;
+	be32	controller_section_length;
+	be32	phys_section_offset;
+	be32	phys_section_length;
+	be32	virt_section_offset;
+	be32	virt_section_length;
+	be32	config_section_offset;
+	be32	config_section_length;
+	be32	data_section_offset;
+	be32	data_section_length;
+	be32	bbm_section_offset;
+	be32	bbm_section_length;
+	be32	diag_space_offset;
+	be32	diag_space_length;
+	be32	vendor_offset;
+	be32	vendor_length;
 	/* 256 bytes so far */
 	__u8	pad4[256];	/* 0xff */
 };
@@ -203,8 +203,8 @@ struct ddf_header {
 
 /* The content of the 'controller section' - global scope */
 struct ddf_controller_data {
-	__u32	magic;			/* DDF_CONTROLLER_MAGIC */
-	__u32	crc;
+	be32	magic;			/* DDF_CONTROLLER_MAGIC */
+	be32	crc;
 	char	guid[DDF_GUID_LEN];
 	struct controller_type {
 		__u16 vendor_id;
@@ -219,14 +219,14 @@ struct ddf_controller_data {
 
 /* The content of phys_section - global scope */
 struct phys_disk {
-	__u32	magic;		/* DDF_PHYS_RECORDS_MAGIC */
-	__u32	crc;
+	be32	magic;		/* DDF_PHYS_RECORDS_MAGIC */
+	be32	crc;
 	__u16	used_pdes;
 	__u16	max_pdes;
 	__u8	pad[52];
 	struct phys_disk_entry {
 		char	guid[DDF_GUID_LEN];
-		__u32	refnum;
+		be32	refnum;
 		__u16	type;
 		__u16	state;
 		__u64	config_size; /* DDF structures must be after here */
@@ -260,8 +260,8 @@ struct phys_disk {
 
 /* The content of the virt_section global scope */
 struct virtual_disk {
-	__u32	magic;		/* DDF_VIRT_RECORDS_MAGIC */
-	__u32	crc;
+	be32	magic;		/* DDF_VIRT_RECORDS_MAGIC */
+	be32	crc;
 	__u16	populated_vdes;
 	__u16	max_vdes;
 	__u8	pad[52];
@@ -314,11 +314,11 @@ struct virtual_disk {
  */
 
 struct vd_config {
-	__u32	magic;		/* DDF_VD_CONF_MAGIC */
-	__u32	crc;
+	be32	magic;		/* DDF_VD_CONF_MAGIC */
+	be32	crc;
 	char	guid[DDF_GUID_LEN];
-	__u32	timestamp;
-	__u32	seqnum;
+	be32	timestamp;
+	be32	seqnum;
 	__u8	pad0[24];
 	__u16	prim_elmnt_count;
 	__u8	chunk_shift;	/* 0 == 512, 1==1024 etc */
@@ -332,7 +332,7 @@ struct vd_config {
 				 * for concat I hope) */
 	__u64	array_blocks;	/* blocks in array */
 	__u8	pad1[8];
-	__u32	spare_refs[8];
+	be32	spare_refs[8];
 	__u8	cache_pol[8];
 	__u8	bg_rate;
 	__u8	pad2[3];
@@ -343,7 +343,7 @@ struct vd_config {
 	__u8	v2[16];	/* reserved- 0xff */
 	__u8	v3[16];	/* reserved- 0xff */
 	__u8	vendor[32];
-	__u32	phys_refnum[0];	/* refnum of each disk in sequence */
+	be32	phys_refnum[0];	/* refnum of each disk in sequence */
       /*__u64	lba_offset[0];  LBA offset in each phys.  Note extents in a
 				bvd are always the same size */
 };
@@ -359,9 +359,9 @@ struct vd_config {
 #define	DDF_cache_rallowed	64	/* enable read caching */
 
 struct spare_assign {
-	__u32	magic;		/* DDF_SPARE_ASSIGN_MAGIC */
-	__u32	crc;
-	__u32	timestamp;
+	be32	magic;		/* DDF_SPARE_ASSIGN_MAGIC */
+	be32	crc;
+	be32	timestamp;
 	__u8	reserved[7];
 	__u8	type;
 	__u16	populated;	/* SAEs used */
@@ -381,10 +381,10 @@ struct spare_assign {
 
 /* The data_section contents - local scope */
 struct disk_data {
-	__u32	magic;		/* DDF_PHYS_DATA_MAGIC */
-	__u32	crc;
+	be32	magic;		/* DDF_PHYS_DATA_MAGIC */
+	be32	crc;
 	char	guid[DDF_GUID_LEN];
-	__u32	refnum;		/* crc of some magic drive data ... */
+	be32	refnum;		/* crc of some magic drive data ... */
 	__u8	forced_ref;	/* set when above was not result of magic */
 	__u8	forced_guid;	/* set if guid was forced rather than magic */
 	__u8	vendor[32];
@@ -393,15 +393,15 @@ struct disk_data {
 
 /* bbm_section content */
 struct bad_block_log {
-	__u32	magic;
-	__u32	crc;
+	be32	magic;
+	be32	crc;
 	__u16	entry_count;
-	__u32	spare_count;
+	be32	spare_count;
 	__u8	pad[10];
 	__u64	first_spare;
 	struct mapped_block {
 		__u64	defective_start;
-		__u32	replacement_start;
+		be32	replacement_start;
 		__u16	remap_count;
 		__u8	pad[2];
 	} entries[0];
@@ -503,31 +503,31 @@ static void pr_state(const struct ddf_super *ddf, const char *msg) {}
 static void _ddf_set_updates_pending(struct ddf_super *ddf, const char *func)
 {
 	ddf->updates_pending = 1;
-	ddf->active->seq = __cpu_to_be32((__be32_to_cpu(ddf->active->seq)+1));
+	ddf->active->seq = cpu_to_be32((be32_to_cpu(ddf->active->seq)+1));
 	pr_state(ddf, func);
 }
 
 #define ddf_set_updates_pending(x) _ddf_set_updates_pending((x), __func__)
 
 static unsigned int get_pd_index_from_refnum(const struct vcl *vc,
-					     __u32 refnum, unsigned int nmax,
+					     be32 refnum, unsigned int nmax,
 					     const struct vd_config **bvd,
 					     unsigned int *idx);
 
-static unsigned int calc_crc(void *buf, int len)
+static be32 calc_crc(void *buf, int len)
 {
 	/* crcs are always at the same place as in the ddf_header */
 	struct ddf_header *ddf = buf;
-	__u32 oldcrc = ddf->crc;
+	be32 oldcrc = ddf->crc;
 	__u32 newcrc;
-	ddf->crc = 0xffffffff;
+	ddf->crc = cpu_to_be32(0xffffffff);
 
 	newcrc = crc32(0, buf, len);
 	ddf->crc = oldcrc;
 	/* The crc is store (like everything) bigendian, so convert
 	 * here for simplicity
 	 */
-	return __cpu_to_be32(newcrc);
+	return cpu_to_be32(newcrc);
 }
 
 #define DDF_INVALID_LEVEL 0xff
@@ -750,9 +750,9 @@ static int load_ddf_header(int fd, unsigned long long lba,
 	if (read(fd, hdr, 512) != 512)
 		return 0;
 
-	if (hdr->magic != DDF_HEADER_MAGIC)
+	if (!be32_eq(hdr->magic, DDF_HEADER_MAGIC))
 		return 0;
-	if (calc_crc(hdr, 512) != hdr->crc)
+	if (!be32_eq(calc_crc(hdr, 512), hdr->crc))
 		return 0;
 	if (memcmp(anchor->guid, hdr->guid, DDF_GUID_LEN) != 0 ||
 	    memcmp(anchor->revision, hdr->revision, 8) != 0 ||
@@ -768,10 +768,10 @@ static int load_ddf_header(int fd, unsigned long long lba,
 }
 
 static void *load_section(int fd, struct ddf_super *super, void *buf,
-			  __u32 offset_be, __u32 len_be, int check)
+			  be32 offset_be, be32 len_be, int check)
 {
-	unsigned long long offset = __be32_to_cpu(offset_be);
-	unsigned long long len = __be32_to_cpu(len_be);
+	unsigned long long offset = be32_to_cpu(offset_be);
+	unsigned long long len = be32_to_cpu(len_be);
 	int dofree = (buf == NULL);
 
 	if (check)
@@ -827,13 +827,13 @@ static int load_ddf_headers(int fd, struct ddf_super *super, char *devname)
 			       devname, strerror(errno));
 		return 1;
 	}
-	if (super->anchor.magic != DDF_HEADER_MAGIC) {
+	if (!be32_eq(super->anchor.magic, DDF_HEADER_MAGIC)) {
 		if (devname)
 			pr_err("no DDF anchor found on %s\n",
 				devname);
 		return 2;
 	}
-	if (calc_crc(&super->anchor, 512) != super->anchor.crc) {
+	if (!be32_eq(calc_crc(&super->anchor, 512), super->anchor.crc)) {
 		if (devname)
 			pr_err("bad CRC on anchor on %s\n",
 				devname);
@@ -856,15 +856,16 @@ static int load_ddf_headers(int fd, struct ddf_super *super, char *devname)
 			       "on %s\n", devname);
 	} else
 		super->active = &super->primary;
+
 	if (load_ddf_header(fd, __be64_to_cpu(super->anchor.secondary_lba),
 			    dsize >> 9,  2,
 			    &super->secondary, &super->anchor)) {
 		if (super->active == NULL
-		    || (__be32_to_cpu(super->primary.seq)
-			< __be32_to_cpu(super->secondary.seq) &&
+		    || (be32_to_cpu(super->primary.seq)
+			< be32_to_cpu(super->secondary.seq) &&
 			!super->secondary.openflag)
-		    || (__be32_to_cpu(super->primary.seq)
-			== __be32_to_cpu(super->secondary.seq) &&
+		    || (be32_to_cpu(super->primary.seq)
+			== be32_to_cpu(super->secondary.seq) &&
 			super->primary.openflag && !super->secondary.openflag)
 			)
 			super->active = &super->secondary;
@@ -887,13 +888,13 @@ static int load_ddf_global(int fd, struct ddf_super *super, char *devname)
 				   super->active->phys_section_offset,
 				   super->active->phys_section_length,
 				   1);
-	super->pdsize = __be32_to_cpu(super->active->phys_section_length) * 512;
+	super->pdsize = be32_to_cpu(super->active->phys_section_length) * 512;
 
 	super->virt = load_section(fd, super, NULL,
 				   super->active->virt_section_offset,
 				   super->active->virt_section_length,
 				   1);
-	super->vdsize = __be32_to_cpu(super->active->virt_section_length) * 512;
+	super->vdsize = be32_to_cpu(super->active->virt_section_length) * 512;
 	if (!ok ||
 	    !super->phys ||
 	    !super->virt) {
@@ -1025,13 +1026,13 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 
 	vnum = 0;
 	for (confsec = 0;
-	     confsec < __be32_to_cpu(super->active->config_section_length);
+	     confsec < be32_to_cpu(super->active->config_section_length);
 	     confsec += super->conf_rec_len) {
 		struct vd_config *vd =
 			(struct vd_config *)((char*)conf + confsec*512);
 		struct vcl *vcl;
 
-		if (vd->magic == DDF_SPARE_ASSIGN_MAGIC) {
+		if (be32_eq(vd->magic, DDF_SPARE_ASSIGN_MAGIC)) {
 			if (dl->spare)
 				continue;
 			if (posix_memalign((void**)&dl->spare, 512,
@@ -1044,7 +1045,7 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 			memcpy(dl->spare, vd, super->conf_rec_len*512);
 			continue;
 		}
-		if (vd->magic != DDF_VD_CONF_MAGIC)
+		if (!be32_eq(vd->magic, DDF_VD_CONF_MAGIC))
 			continue;
 		for (vcl = super->conflist; vcl; vcl = vcl->next) {
 			if (memcmp(vcl->conf.guid,
@@ -1059,8 +1060,8 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 				add_other_bvd(vcl, vd, super->conf_rec_len*512);
 				continue;
 			}
-			if (__be32_to_cpu(vd->seqnum) <=
-			    __be32_to_cpu(vcl->conf.seqnum))
+			if (be32_to_cpu(vd->seqnum) <=
+			    be32_to_cpu(vcl->conf.seqnum))
 				continue;
 		} else {
 			if (posix_memalign((void**)&vcl, 512,
@@ -1363,7 +1364,7 @@ static void examine_vd(int n, struct ddf_super *sb, char *guid)
 		unsigned int i;
 		struct vd_config *vc = &vcl->conf;
 
-		if (calc_crc(vc, crl*512) != vc->crc)
+		if (!be32_eq(calc_crc(vc, crl*512), vc->crc))
 			continue;
 		if (memcmp(vc->guid, guid, DDF_GUID_LEN) != 0)
 			continue;
@@ -1375,7 +1376,8 @@ static void examine_vd(int n, struct ddf_super *sb, char *guid)
 			int j;
 			int cnt = __be16_to_cpu(sb->phys->used_pdes);
 			for (j=0; j<cnt; j++)
-				if (vc->phys_refnum[i] == sb->phys->entries[j].refnum)
+				if (be32_eq(vc->phys_refnum[i],
+					    sb->phys->entries[j].refnum))
 					break;
 			if (i) printf(" ");
 			if (j < cnt)
@@ -1446,11 +1448,11 @@ static void examine_pds(struct ddf_super *sb)
 		//printf("      PD GUID[%d] : ", i); print_guid(pd->guid, 0);
 		//printf("\n");
 		printf("       %3d    %08x  ", i,
-		       __be32_to_cpu(pd->refnum));
+		       be32_to_cpu(pd->refnum));
 		printf("%8lluK ",
 		       (unsigned long long)__be64_to_cpu(pd->config_size)>>1);
 		for (dl = sb->dlist; dl ; dl = dl->next) {
-			if (dl->disk.refnum == pd->refnum) {
+			if (be32_eq(dl->disk.refnum, pd->refnum)) {
 				char *dv = map_dev(dl->major, dl->minor, 0);
 				if (dv) {
 					printf("%-15s", dv);
@@ -1485,14 +1487,15 @@ static void examine_super_ddf(struct supertype *st, char *homehost)
 {
 	struct ddf_super *sb = st->sb;
 
-	printf("          Magic : %08x\n", __be32_to_cpu(sb->anchor.magic));
+	printf("          Magic : %08x\n", be32_to_cpu(sb->anchor.magic));
 	printf("        Version : %.8s\n", sb->anchor.revision);
 	printf("Controller GUID : "); print_guid(sb->controller.guid, 0);
 	printf("\n");
 	printf(" Container GUID : "); print_guid(sb->anchor.guid, 1);
 	printf("\n");
-	printf("            Seq : %08x\n", __be32_to_cpu(sb->active->seq));
-	printf("  Redundant hdr : %s\n", sb->secondary.magic == DDF_HEADER_MAGIC
+	printf("            Seq : %08x\n", be32_to_cpu(sb->active->seq));
+	printf("  Redundant hdr : %s\n", be32_eq(sb->secondary.magic,
+						 DDF_HEADER_MAGIC)
 	       ?"yes" : "no");
 	examine_vds(sb);
 	examine_pds(sb);
@@ -1611,8 +1614,8 @@ static int copy_metadata_ddf(struct supertype *st, int from, int to)
 	if (read(from, buf, 512) != 512)
 		goto err;
 	ddf = buf;
-	if (ddf->magic != DDF_HEADER_MAGIC ||
-	    calc_crc(ddf, 512) != ddf->crc ||
+	if (!be32_eq(ddf->magic, DDF_HEADER_MAGIC) ||
+	    !be32_eq(calc_crc(ddf, 512), ddf->crc) ||
 	    (memcmp(ddf->revision, DDF_REVISION_0, 8) != 0 &&
 	     memcmp(ddf->revision, DDF_REVISION_2, 8) != 0))
 		goto err;
@@ -1702,7 +1705,7 @@ static int find_index_in_bvd(const struct ddf_super *ddf,
 	unsigned int i, j;
 	for (i = 0, j = 0; i < ddf->mppe &&
 		     j < __be16_to_cpu(conf->prim_elmnt_count); i++) {
-		if (conf->phys_refnum[i] != 0xffffffff) {
+		if (be32_to_cpu(conf->phys_refnum[i]) != 0xffffffff) {
 			if (n == j) {
 				*n_bvd = i;
 				return 1;
@@ -1764,14 +1767,14 @@ bad:
 }
 #endif
 
-static int find_phys(const struct ddf_super *ddf, __u32 phys_refnum)
+static int find_phys(const struct ddf_super *ddf, be32 phys_refnum)
 {
 	/* Find the entry in phys_disk which has the given refnum
 	 * and return it's index
 	 */
 	unsigned int i;
 	for (i = 0; i < __be16_to_cpu(ddf->phys->max_pdes); i++)
-		if (ddf->phys->entries[i].refnum == phys_refnum)
+		if (be32_eq(ddf->phys->entries[i].refnum, phys_refnum))
 			return i;
 	return -1;
 }
@@ -1846,7 +1849,7 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
 	info->disk.major = 0;
 	info->disk.minor = 0;
 	if (ddf->dlist) {
-		info->disk.number = __be32_to_cpu(ddf->dlist->disk.refnum);
+		info->disk.number = be32_to_cpu(ddf->dlist->disk.refnum);
 		info->disk.raid_disk = find_phys(ddf, ddf->dlist->disk.refnum);
 
 		info->data_offset = __be64_to_cpu(ddf->phys->
@@ -1903,7 +1906,7 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 	info->array.md_minor	  = -1;
 	cptr = (__u32 *)(vc->conf.guid + 16);
 	info->array.ctime	  = DECADE + __be32_to_cpu(*cptr);
-	info->array.utime	  = DECADE + __be32_to_cpu(vc->conf.timestamp);
+	info->array.utime	  = DECADE + be32_to_cpu(vc->conf.timestamp);
 	info->array.chunk_size	  = 512 << vc->conf.chunk_shift;
 	info->custom_array_size	  = 0;
 
@@ -1925,7 +1928,7 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 	}
 
 	for (dl = ddf->dlist; dl ; dl = dl->next)
-		if (dl->disk.refnum == conf->phys_refnum[cd])
+		if (be32_eq(dl->disk.refnum, conf->phys_refnum[cd]))
 			break;
 
 	info->disk.major = 0;
@@ -2052,7 +2055,7 @@ static int update_super_ddf(struct supertype *st, struct mdinfo *info,
 
 static void make_header_guid(char *guid)
 {
-	__u32 stamp;
+	be32 stamp;
 	/* Create a DDF Header of Virtual Disk GUID */
 
 	/* 24 bytes of fiction required.
@@ -2061,13 +2064,13 @@ static void make_header_guid(char *guid)
 	 * Remaining 8 random number plus timestamp
 	 */
 	memcpy(guid, T10, sizeof(T10));
-	stamp = __cpu_to_be32(0xdeadbeef);
+	stamp = cpu_to_be32(0xdeadbeef);
 	memcpy(guid+8, &stamp, 4);
-	stamp = __cpu_to_be32(0);
+	stamp = cpu_to_be32(0);
 	memcpy(guid+12, &stamp, 4);
-	stamp = __cpu_to_be32(time(0) - DECADE);
+	stamp = cpu_to_be32(time(0) - DECADE);
 	memcpy(guid+16, &stamp, 4);
-	stamp = random32();
+	stamp._v32 = random32();
 	memcpy(guid+20, &stamp, 4);
 }
 
@@ -2189,8 +2192,8 @@ static int init_super_ddf(struct supertype *st,
 	make_header_guid(ddf->anchor.guid);
 
 	memcpy(ddf->anchor.revision, DDF_REVISION_2, 8);
-	ddf->anchor.seq = __cpu_to_be32(1);
-	ddf->anchor.timestamp = __cpu_to_be32(time(0) - DECADE);
+	ddf->anchor.seq = cpu_to_be32(1);
+	ddf->anchor.timestamp = cpu_to_be32(time(0) - DECADE);
 	ddf->anchor.openflag = 0xFF;
 	ddf->anchor.foreignflag = 0;
 	ddf->anchor.enforcegroups = 0; /* Is this best?? */
@@ -2201,7 +2204,7 @@ static int init_super_ddf(struct supertype *st,
 	ddf->anchor.secondary_lba = ~(__u64)0;
 	ddf->anchor.type = DDF_HEADER_ANCHOR;
 	memset(ddf->anchor.pad2, 0xff, 3);
-	ddf->anchor.workspace_len = __cpu_to_be32(32768); /* Must be reserved */
+	ddf->anchor.workspace_len = cpu_to_be32(32768); /* Must be reserved */
 	ddf->anchor.workspace_lba = ~(__u64)0; /* Put this at bottom
 						  of 32M reserved.. */
 	max_phys_disks = 1023;   /* Should be enough */
@@ -2218,8 +2221,8 @@ static int init_super_ddf(struct supertype *st,
 	/* controller sections is one sector long immediately
 	 * after the ddf header */
 	sector = 1;
-	ddf->anchor.controller_section_offset = __cpu_to_be32(sector);
-	ddf->anchor.controller_section_length = __cpu_to_be32(1);
+	ddf->anchor.controller_section_offset = cpu_to_be32(sector);
+	ddf->anchor.controller_section_length = cpu_to_be32(1);
 	sector += 1;
 
 	/* phys is 8 sectors after that */
@@ -2230,9 +2233,9 @@ static int init_super_ddf(struct supertype *st,
 	case 2: case 8: case 32: case 128: case 512: break;
 	default: abort();
 	}
-	ddf->anchor.phys_section_offset = __cpu_to_be32(sector);
+	ddf->anchor.phys_section_offset = cpu_to_be32(sector);
 	ddf->anchor.phys_section_length =
-		__cpu_to_be32(pdsize/512); /* max_primary_element_entries/8 */
+		cpu_to_be32(pdsize/512); /* max_primary_element_entries/8 */
 	sector += pdsize/512;
 
 	/* virt is another 32 sectors */
@@ -2243,26 +2246,26 @@ static int init_super_ddf(struct supertype *st,
 	case 2: case 8: case 32: case 128: case 512: break;
 	default: abort();
 	}
-	ddf->anchor.virt_section_offset = __cpu_to_be32(sector);
+	ddf->anchor.virt_section_offset = cpu_to_be32(sector);
 	ddf->anchor.virt_section_length =
-		__cpu_to_be32(vdsize/512); /* max_vd_entries/8 */
+		cpu_to_be32(vdsize/512); /* max_vd_entries/8 */
 	sector += vdsize/512;
 
 	clen = ddf->conf_rec_len * (ddf->max_part+1);
-	ddf->anchor.config_section_offset = __cpu_to_be32(sector);
-	ddf->anchor.config_section_length = __cpu_to_be32(clen);
+	ddf->anchor.config_section_offset = cpu_to_be32(sector);
+	ddf->anchor.config_section_length = cpu_to_be32(clen);
 	sector += clen;
 
-	ddf->anchor.data_section_offset = __cpu_to_be32(sector);
-	ddf->anchor.data_section_length = __cpu_to_be32(1);
+	ddf->anchor.data_section_offset = cpu_to_be32(sector);
+	ddf->anchor.data_section_length = cpu_to_be32(1);
 	sector += 1;
 
-	ddf->anchor.bbm_section_length = __cpu_to_be32(0);
-	ddf->anchor.bbm_section_offset = __cpu_to_be32(0xFFFFFFFF);
-	ddf->anchor.diag_space_length = __cpu_to_be32(0);
-	ddf->anchor.diag_space_offset = __cpu_to_be32(0xFFFFFFFF);
-	ddf->anchor.vendor_length = __cpu_to_be32(0);
-	ddf->anchor.vendor_offset = __cpu_to_be32(0xFFFFFFFF);
+	ddf->anchor.bbm_section_length = cpu_to_be32(0);
+	ddf->anchor.bbm_section_offset = cpu_to_be32(0xFFFFFFFF);
+	ddf->anchor.diag_space_length = cpu_to_be32(0);
+	ddf->anchor.diag_space_offset = cpu_to_be32(0xFFFFFFFF);
+	ddf->anchor.vendor_length = cpu_to_be32(0);
+	ddf->anchor.vendor_offset = cpu_to_be32(0xFFFFFFFF);
 
 	memset(ddf->anchor.pad4, 0xff, 256);
 
@@ -2452,8 +2455,8 @@ static int init_super_ddf_bvd(struct supertype *st,
 
 	vc->magic = DDF_VD_CONF_MAGIC;
 	memcpy(vc->guid, ve->guid, DDF_GUID_LEN);
-	vc->timestamp = __cpu_to_be32(time(0)-DECADE);
-	vc->seqnum = __cpu_to_be32(1);
+	vc->timestamp = cpu_to_be32(time(0)-DECADE);
+	vc->seqnum = cpu_to_be32(1);
 	memset(vc->pad0, 0xff, 24);
 	vc->chunk_shift = chunk_to_shift(info->chunk_size);
 	if (layout_md2ddf(info, vc) == -1 ||
@@ -2475,14 +2478,14 @@ static int init_super_ddf_bvd(struct supertype *st,
 		calc_array_size(info->level, info->raid_disks, info->layout,
 				info->chunk_size, info->size*2));
 	memset(vc->pad1, 0xff, 8);
-	vc->spare_refs[0] = 0xffffffff;
-	vc->spare_refs[1] = 0xffffffff;
-	vc->spare_refs[2] = 0xffffffff;
-	vc->spare_refs[3] = 0xffffffff;
-	vc->spare_refs[4] = 0xffffffff;
-	vc->spare_refs[5] = 0xffffffff;
-	vc->spare_refs[6] = 0xffffffff;
-	vc->spare_refs[7] = 0xffffffff;
+	vc->spare_refs[0] = cpu_to_be32(0xffffffff);
+	vc->spare_refs[1] = cpu_to_be32(0xffffffff);
+	vc->spare_refs[2] = cpu_to_be32(0xffffffff);
+	vc->spare_refs[3] = cpu_to_be32(0xffffffff);
+	vc->spare_refs[4] = cpu_to_be32(0xffffffff);
+	vc->spare_refs[5] = cpu_to_be32(0xffffffff);
+	vc->spare_refs[6] = cpu_to_be32(0xffffffff);
+	vc->spare_refs[7] = cpu_to_be32(0xffffffff);
 	memset(vc->cache_pol, 0, 8);
 	vc->bg_rate = 0x80;
 	memset(vc->pad2, 0xff, 3);
@@ -2599,7 +2602,7 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 	ddf->phys->entries[dl->pdnum].type &= ~__cpu_to_be16(DDF_Global_Spare);
 	ddf->phys->entries[dl->pdnum].type |= __cpu_to_be16(DDF_Active_in_VD);
 	dprintf("%s: added disk %d/%08x to VD %d/%s as disk %d\n",
-		__func__, dl->pdnum, __be32_to_cpu(dl->disk.refnum),
+		__func__, dl->pdnum, be32_to_cpu(dl->disk.refnum),
 		ddf->currentconf->vcnum, guid_str(vc->guid),
 		dk->raid_disk);
 	ddf_set_updates_pending(ddf);
@@ -2679,10 +2682,11 @@ static int add_to_super_ddf(struct supertype *st,
 
 	do {
 		/* Cannot be bothered finding a CRC of some irrelevant details*/
-		dd->disk.refnum = random32();
+		dd->disk.refnum._v32 = random32();
 		for (i = __be16_to_cpu(ddf->active->max_pd_entries);
 		     i > 0; i--)
-			if (ddf->phys->entries[i-1].refnum == dd->disk.refnum)
+			if (be32_eq(ddf->phys->entries[i-1].refnum,
+				    dd->disk.refnum))
 				break;
 	} while (i > 0);
 
@@ -2863,7 +2867,7 @@ static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type)
 		}
 		if (c) {
 			dprintf("writing conf record %i on disk %08x for %s/%u\n",
-				i, __be32_to_cpu(d->disk.refnum),
+				i, be32_to_cpu(d->disk.refnum),
 				guid_str(vdc->guid),
 				vdc->sec_elmnt_seq);
 			vdc->seqnum = header->seq;
@@ -2935,7 +2939,7 @@ static int _write_super_to_disk(struct ddf_super *ddf, struct dl *d)
 	memcpy(&ddf->secondary, &ddf->anchor, 512);
 
 	ddf->anchor.openflag = 0xFF; /* 'open' means nothing */
-	ddf->anchor.seq = 0xFFFFFFFF; /* no sequencing in anchor */
+	ddf->anchor.seq = cpu_to_be32(0xFFFFFFFF); /* no sequencing in anchor */
 	ddf->anchor.crc = calc_crc(&ddf->anchor, 512);
 
 	if (!__write_ddf_structure(d, ddf, DDF_HEADER_PRIMARY))
@@ -3443,7 +3447,7 @@ static int load_super_ddf_all(struct supertype *st, int fd,
 		rv = load_ddf_headers(dfd, super, NULL);
 		close(dfd);
 		if (rv == 0) {
-			seq = __be32_to_cpu(super->active->seq);
+			seq = be32_to_cpu(super->active->seq);
 			if (super->active->openflag)
 				seq--;
 			if (!best || seq > bestseq) {
@@ -3562,7 +3566,7 @@ static int check_secondary(const struct vcl *vc)
 }
 
 static unsigned int get_pd_index_from_refnum(const struct vcl *vc,
-					     __u32 refnum, unsigned int nmax,
+					     be32 refnum, unsigned int nmax,
 					     const struct vd_config **bvd,
 					     unsigned int *idx)
 {
@@ -3573,9 +3577,9 @@ static unsigned int get_pd_index_from_refnum(const struct vcl *vc,
 
 	for (i = 0, j = 0 ; i < nmax ; i++) {
 		/* j counts valid entries for this BVD */
-		if (vc->conf.phys_refnum[i] != 0xffffffff)
+		if (be32_to_cpu(vc->conf.phys_refnum[i]) != 0xffffffff)
 			j++;
-		if (vc->conf.phys_refnum[i] == refnum) {
+		if (be32_eq(vc->conf.phys_refnum[i], refnum)) {
 			*bvd = &vc->conf;
 			*idx = i;
 			return sec * cnt + j - 1;
@@ -3590,9 +3594,9 @@ static unsigned int get_pd_index_from_refnum(const struct vcl *vc,
 		if (sec == DDF_UNUSED_BVD)
 			continue;
 		for (i = 0, j = 0 ; i < nmax ; i++) {
-			if (vd->phys_refnum[i] != 0xffffffff)
+			if (be32_to_cpu(vd->phys_refnum[i]) != 0xffffffff)
 				j++;
-			if (vd->phys_refnum[i] == refnum) {
+			if (be32_eq(vd->phys_refnum[i], refnum)) {
 				*bvd = vd;
 				*idx = i;
 				return sec * cnt + j - 1;
@@ -3649,7 +3653,7 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 		cptr = (__u32 *)(vc->conf.guid + 16);
 		this->array.ctime         = DECADE + __be32_to_cpu(*cptr);
 		this->array.utime	  = DECADE +
-			__be32_to_cpu(vc->conf.timestamp);
+			be32_to_cpu(vc->conf.timestamp);
 		this->array.chunk_size	  = 512 << vc->conf.chunk_shift;
 
 		i = vc->vcnum;
@@ -3688,7 +3692,8 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 			unsigned int iphys;
 			int stt;
 
-			if (ddf->phys->entries[pd].refnum == 0xFFFFFFFF)
+			if (be32_to_cpu(ddf->phys->entries[pd].refnum)
+			    == 0xFFFFFFFF)
 				continue;
 
 			stt = __be16_to_cpu(ddf->phys->entries[pd].state);
@@ -3705,8 +3710,8 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 			this->array.working_disks++;
 
 			for (d = ddf->dlist; d ; d=d->next)
-				if (d->disk.refnum ==
-				    ddf->phys->entries[pd].refnum)
+				if (be32_eq(d->disk.refnum,
+					    ddf->phys->entries[pd].refnum))
 					break;
 			if (d == NULL)
 				/* Haven't found that one yet, maybe there are others */
@@ -3716,14 +3721,14 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 			dev->next = this->devs;
 			this->devs = dev;
 
-			dev->disk.number = __be32_to_cpu(d->disk.refnum);
+			dev->disk.number = be32_to_cpu(d->disk.refnum);
 			dev->disk.major = d->major;
 			dev->disk.minor = d->minor;
 			dev->disk.raid_disk = i;
 			dev->disk.state = (1<<MD_DISK_SYNC)|(1<<MD_DISK_ACTIVE);
 			dev->recovery_start = MaxSector;
 
-			dev->events = __be32_to_cpu(ddf->primary.seq);
+			dev->events = be32_to_cpu(ddf->primary.seq);
 			dev->data_offset =
 				__be64_to_cpu(LBA_OFFSET(ddf, bvd)[iphys]);
 			dev->component_size = __be64_to_cpu(bvd->blocks);
@@ -3810,10 +3815,10 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 	if (memcmp(first->anchor.guid, second->anchor.guid, DDF_GUID_LEN) != 0)
 		return 2;
 
-	if (first->anchor.seq != second->anchor.seq) {
+	if (!be32_eq(first->anchor.seq, second->anchor.seq)) {
 		dprintf("%s: sequence number mismatch %u/%u\n", __func__,
-			__be32_to_cpu(first->anchor.seq),
-			__be32_to_cpu(second->anchor.seq));
+			be32_to_cpu(first->anchor.seq),
+			be32_to_cpu(second->anchor.seq));
 		return 3;
 	}
 	if (first->max_part != second->max_part ||
@@ -3826,18 +3831,19 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 	max_pds =  __be16_to_cpu(first->phys->used_pdes);
 	for (dl2 = second->dlist; dl2; dl2 = dl2->next) {
 		for (pd = 0; pd < max_pds; pd++)
-			if (first->phys->entries[pd].refnum == dl2->disk.refnum)
+			if (be32_eq(first->phys->entries[pd].refnum,
+				    dl2->disk.refnum))
 				break;
 		if (pd == max_pds) {
 			dprintf("%s: no match for disk %08x\n", __func__,
-				__be32_to_cpu(dl2->disk.refnum));
+				be32_to_cpu(dl2->disk.refnum));
 			return 3;
 		}
 	}
 
 	max_vds = __be16_to_cpu(first->active->max_vd_entries);
 	for (vl2 = second->conflist; vl2; vl2 = vl2->next) {
-		if (vl2->conf.magic != DDF_VD_CONF_MAGIC)
+		if (!be32_eq(vl2->conf.magic, DDF_VD_CONF_MAGIC))
 			continue;
 		for (vd = 0; vd < max_vds; vd++)
 			if (!memcmp(first->virt->entries[vd].guid,
@@ -3900,7 +3906,7 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 
 	for (dl2 = second->dlist; dl2; dl2 = dl2->next) {
 		for (dl1 = first->dlist; dl1; dl1 = dl1->next)
-			if (dl1->disk.refnum == dl2->disk.refnum)
+			if (be32_eq(dl1->disk.refnum, dl2->disk.refnum))
 				break;
 		if (dl1)
 			continue;
@@ -3917,7 +3923,8 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 		dl1->next = first->dlist;
 		dl1->fd = -1;
 		for (pd = 0; pd < max_pds; pd++)
-			if (first->phys->entries[pd].refnum == dl1->disk.refnum)
+			if (be32_eq(first->phys->entries[pd].refnum,
+				    dl1->disk.refnum))
 				break;
 		dl1->pdnum = pd;
 		if (dl2->spare) {
@@ -3944,7 +3951,7 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 		}
 		first->dlist = dl1;
 		dprintf("%s: added disk %d: %08x\n", __func__, dl1->pdnum,
-			__be32_to_cpu(dl1->disk.refnum));
+			be32_to_cpu(dl1->disk.refnum));
 	}
 
 	return 0;
@@ -4147,7 +4154,7 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 		 * If it is now in_sync, insert it. */
 		dprintf("%s: phys disk not found for %d: %d/%d ref %08x\n",
 			__func__, dl->pdnum, dl->major, dl->minor,
-			__be32_to_cpu(dl->disk.refnum));
+			be32_to_cpu(dl->disk.refnum));
 		dprintf("%s: array %u disk %u ref %08x pd %d\n",
 			__func__, inst, n_bvd, vc->phys_refnum[n_bvd], pd);
 		if ((state & DS_INSYNC) && ! (state & DS_FAULTY)) {
@@ -4349,7 +4356,7 @@ static void ddf_process_update(struct supertype *st,
 	 *    a spare-assignment record.
 	 */
 	struct ddf_super *ddf = st->sb;
-	__u32 *magic = (__u32*)update->buf;
+	be32 *magic = (be32 *)update->buf;
 	struct phys_disk *pd;
 	struct virtual_disk *vd;
 	struct vd_config *vc;
@@ -4358,10 +4365,9 @@ static void ddf_process_update(struct supertype *st,
 	unsigned int ent;
 	unsigned int pdnum, pd2, len;
 
-	dprintf("Process update %x\n", *magic);
+	dprintf("Process update %x\n", be32_to_cpu(*magic));
 
-	switch (*magic) {
-	case DDF_PHYS_RECORDS_MAGIC:
+	if (be32_eq(*magic, DDF_PHYS_RECORDS_MAGIC)) {
 
 		if (update->len != (sizeof(struct phys_disk) +
 				    sizeof(struct phys_disk_entry)))
@@ -4410,9 +4416,7 @@ static void ddf_process_update(struct supertype *st,
 			for (a = st->arrays ; a; a=a->next)
 				a->check_degraded = 1;
 		}
-		break;
-
-	case DDF_VIRT_RECORDS_MAGIC:
+	} else if (be32_eq(*magic, DDF_VIRT_RECORDS_MAGIC)) {
 
 		if (update->len != (sizeof(struct virtual_disk) +
 				    sizeof(struct virtual_entry)))
@@ -4445,9 +4449,9 @@ static void ddf_process_update(struct supertype *st,
 				ddf->virt->entries[ent].init_state);
 		}
 		ddf_set_updates_pending(ddf);
-		break;
+	}
 
-	case DDF_VD_CONF_MAGIC:
+	else if (be32_eq(*magic, DDF_VD_CONF_MAGIC)) {
 		vc = (struct vd_config*)update->buf;
 		len = ddf->conf_rec_len * 512;
 		if ((unsigned int)update->len != len * vc->sec_elmnt_count) {
@@ -4512,7 +4516,7 @@ static void ddf_process_update(struct supertype *st,
 					continue;
 				dprintf("dev %d/%08x has %s (sec=%u) at %d\n",
 					dl->pdnum,
-					__be32_to_cpu(dl->disk.refnum),
+					be32_to_cpu(dl->disk.refnum),
 					guid_str(conf->guid),
 					conf->sec_elmnt_seq, vn);
 				/* Clear the Transition flag */
@@ -4583,10 +4587,8 @@ static void ddf_process_update(struct supertype *st,
 		}
 
 		ddf_set_updates_pending(ddf);
-		break;
-	case DDF_SPARE_ASSIGN_MAGIC:
-	default: break;
 	}
+	/* case DDF_SPARE_ASSIGN_MAGIC */
 }
 
 static void ddf_prepare_update(struct supertype *st,
@@ -4597,8 +4599,8 @@ static void ddf_prepare_update(struct supertype *st,
 	 * If a malloc is needed, do it here.
 	 */
 	struct ddf_super *ddf = st->sb;
-	__u32 *magic = (__u32*)update->buf;
-	if (*magic == DDF_VD_CONF_MAGIC) {
+	be32 *magic = (be32 *)update->buf;
+	if (be32_eq(*magic, DDF_VD_CONF_MAGIC)) {
 		struct vcl *vcl;
 		struct vd_config *conf = (struct vd_config *) update->buf;
 		if (posix_memalign(&update->space, 512,
-- 
1.7.1
