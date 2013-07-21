From: mwilck@arcor.de
Subject: [PATCH 4/6] DDF: convert big-endian __u16 to be16 type
Date: Sun, 21 Jul 2013 19:28:22 +0200
Message-ID: <1374427704-7903-5-git-send-email-mwilck@arcor.de>
References: <1374427704-7903-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374427704-7903-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Last step of endian-safe recoding. This requires also bit
operations.
---
 super-ddf.c |  357 ++++++++++++++++++++++++++++++++---------------------------
 1 files changed, 195 insertions(+), 162 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 91bfe9e..bd42194 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -62,6 +62,10 @@ typedef struct __be16 {
 	__u16 _v16;
 } be16;
 #define be16_eq(x, y) ((x)._v16 == (y)._v16)
+#define be16_and(x, y) ((x)._v16 & (y)._v16)
+#define be16_or(x, y) ((x)._v16 | (y)._v16)
+#define be16_clear(x, y) ((x)._v16 &= ~(y)._v16)
+#define be16_set(x, y) ((x)._v16 |= (y)._v16)
 
 typedef struct __be32 {
 	__u32 _v32;
@@ -167,13 +171,13 @@ struct ddf_header {
 	be32	workspace_len;	/* sectors for vendor space -
 				 * at least 32768(sectors) */
 	be64	workspace_lba;
-	__u16	max_pd_entries;	/* one of 15, 63, 255, 1023, 4095 */
-	__u16	max_vd_entries; /* 2^(4,6,8,10,12)-1 : i.e. as above */
-	__u16	max_partitions; /* i.e. max num of configuration
+	be16	max_pd_entries;	/* one of 15, 63, 255, 1023, 4095 */
+	be16	max_vd_entries; /* 2^(4,6,8,10,12)-1 : i.e. as above */
+	be16	max_partitions; /* i.e. max num of configuration
 				   record entries per disk */
-	__u16	config_record_len; /* 1 +ROUNDUP(max_primary_element_entries
+	be16	config_record_len; /* 1 +ROUNDUP(max_primary_element_entries
 				                 *12/512) */
-	__u16	max_primary_element_entries; /* 16, 64, 256, 1024, or 4096 */
+	be16	max_primary_element_entries; /* 16, 64, 256, 1024, or 4096 */
 	__u8	pad3[54];	/* 0xff */
 	/* 192 bytes so far */
 	be32	controller_section_offset;
@@ -207,10 +211,10 @@ struct ddf_controller_data {
 	be32	crc;
 	char	guid[DDF_GUID_LEN];
 	struct controller_type {
-		__u16 vendor_id;
-		__u16 device_id;
-		__u16 sub_vendor_id;
-		__u16 sub_device_id;
+		be16 vendor_id;
+		be16 device_id;
+		be16 sub_vendor_id;
+		be16 sub_device_id;
 	} type;
 	char	product_id[16];
 	__u8	pad[8];	/* 0xff */
@@ -221,14 +225,14 @@ struct ddf_controller_data {
 struct phys_disk {
 	be32	magic;		/* DDF_PHYS_RECORDS_MAGIC */
 	be32	crc;
-	__u16	used_pdes;
-	__u16	max_pdes;
+	be16	used_pdes;
+	be16	max_pdes;
 	__u8	pad[52];
 	struct phys_disk_entry {
 		char	guid[DDF_GUID_LEN];
 		be32	refnum;
-		__u16	type;
-		__u16	state;
+		be16	type;
+		be16	state;
 		be64	config_size; /* DDF structures must be after here */
 		char	path[18];	/* another horrible structure really */
 		__u8	pad[6];
@@ -262,15 +266,15 @@ struct phys_disk {
 struct virtual_disk {
 	be32	magic;		/* DDF_VIRT_RECORDS_MAGIC */
 	be32	crc;
-	__u16	populated_vdes;
-	__u16	max_vdes;
+	be16	populated_vdes;
+	be16	max_vdes;
 	__u8	pad[52];
 	struct virtual_entry {
 		char	guid[DDF_GUID_LEN];
-		__u16	unit;
+		be16	unit;
 		__u16	pad0;	/* 0xffff */
-		__u16	guid_crc;
-		__u16	type;
+		be16	guid_crc;
+		be16	type;
 		__u8	state;
 		__u8	init_state;
 		__u8	pad1[14];
@@ -320,7 +324,7 @@ struct vd_config {
 	be32	timestamp;
 	be32	seqnum;
 	__u8	pad0[24];
-	__u16	prim_elmnt_count;
+	be16	prim_elmnt_count;
 	__u8	chunk_shift;	/* 0 == 512, 1==1024 etc */
 	__u8	prl;
 	__u8	rlq;
@@ -364,12 +368,12 @@ struct spare_assign {
 	be32	timestamp;
 	__u8	reserved[7];
 	__u8	type;
-	__u16	populated;	/* SAEs used */
-	__u16	max;		/* max SAEs */
+	be16	populated;	/* SAEs used */
+	be16	max;		/* max SAEs */
 	__u8	pad[8];
 	struct spare_assign_entry {
 		char	guid[DDF_GUID_LEN];
-		__u16	secondary_element;
+		be16	secondary_element;
 		__u8	pad[6];
 	} spare_ents[0];
 };
@@ -395,14 +399,14 @@ struct disk_data {
 struct bad_block_log {
 	be32	magic;
 	be32	crc;
-	__u16	entry_count;
+	be16	entry_count;
 	be32	spare_count;
 	__u8	pad[10];
 	be64	first_spare;
 	struct mapped_block {
 		be64	defective_start;
 		be32	replacement_start;
-		__u16	remap_count;
+		be16	remap_count;
 		__u8	pad[2];
 	} entries[0];
 };
@@ -487,7 +491,7 @@ static void pr_state(struct ddf_super *ddf, const char *msg)
 {
 	unsigned int i;
 	dprintf("%s/%s: ", __func__, msg);
-	for (i = 0; i < __be16_to_cpu(ddf->active->max_vd_entries); i++) {
+	for (i = 0; i < be16_to_cpu(ddf->active->max_vd_entries); i++) {
 		if (all_ff(ddf->virt->entries[i].guid))
 			continue;
 		dprintf("%u(s=%02x i=%02x) ", i,
@@ -542,7 +546,7 @@ static int err_bad_md_layout(const mdu_array_info_t *array)
 static int layout_md2ddf(const mdu_array_info_t *array,
 			 struct vd_config *conf)
 {
-	__u16 prim_elmnt_count = __cpu_to_be16(array->raid_disks);
+	be16 prim_elmnt_count = cpu_to_be16(array->raid_disks);
 	__u8 prl = DDF_INVALID_LEVEL, rlq = 0;
 	__u8 sec_elmnt_count = 1;
 	__u8 srl = DDF_NO_SECONDARY;
@@ -611,12 +615,12 @@ static int layout_md2ddf(const mdu_array_info_t *array,
 	case 10:
 		if (array->raid_disks % 2 == 0 && array->layout == 0x102) {
 			rlq = DDF_RAID1_SIMPLE;
-			prim_elmnt_count =  __cpu_to_be16(2);
+			prim_elmnt_count =  cpu_to_be16(2);
 			sec_elmnt_count = array->raid_disks / 2;
 		} else if (array->raid_disks % 3 == 0
 			   && array->layout == 0x103) {
 			rlq = DDF_RAID1_MULTI;
-			prim_elmnt_count =  __cpu_to_be16(3);
+			prim_elmnt_count =  cpu_to_be16(3);
 			sec_elmnt_count = array->raid_disks / 3;
 		} else
 			return err_bad_md_layout(array);
@@ -637,7 +641,7 @@ static int layout_md2ddf(const mdu_array_info_t *array,
 static int err_bad_ddf_layout(const struct vd_config *conf)
 {
 	pr_err("DDF RAID %u qualifier %u with %u disks is unsupported\n",
-	       conf->prl, conf->rlq, __be16_to_cpu(conf->prim_elmnt_count));
+	       conf->prl, conf->rlq, be16_to_cpu(conf->prim_elmnt_count));
 	return -1;
 }
 
@@ -646,7 +650,7 @@ static int layout_ddf2md(const struct vd_config *conf,
 {
 	int level = LEVEL_UNSUPPORTED;
 	int layout = 0;
-	int raiddisks = __be16_to_cpu(conf->prim_elmnt_count);
+	int raiddisks = be16_to_cpu(conf->prim_elmnt_count);
 
 	if (conf->sec_elmnt_count > 1) {
 		/* see also check_secondary() */
@@ -907,9 +911,9 @@ static int load_ddf_global(int fd, struct ddf_super *super, char *devname)
 	super->conflist = NULL;
 	super->dlist = NULL;
 
-	super->max_part = __be16_to_cpu(super->active->max_partitions);
-	super->mppe = __be16_to_cpu(super->active->max_primary_element_entries);
-	super->conf_rec_len = __be16_to_cpu(super->active->config_record_len);
+	super->max_part = be16_to_cpu(super->active->max_partitions);
+	super->mppe = be16_to_cpu(super->active->max_primary_element_entries);
+	super->conf_rec_len = be16_to_cpu(super->active->config_record_len);
 	return 0;
 }
 
@@ -969,7 +973,8 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 	unsigned int i;
 	unsigned int confsec;
 	int vnum;
-	unsigned int max_virt_disks = __be16_to_cpu(super->active->max_vd_entries);
+	unsigned int max_virt_disks = be16_to_cpu
+		(super->active->max_vd_entries);
 	unsigned long long dsize;
 
 	/* First the local disk info */
@@ -1008,7 +1013,7 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 		dl->vlist[i] = NULL;
 	super->dlist = dl;
 	dl->pdnum = -1;
-	for (i = 0; i < __be16_to_cpu(super->active->max_pd_entries); i++)
+	for (i = 0; i < be16_to_cpu(super->active->max_pd_entries); i++)
 		if (memcmp(super->phys->entries[i].guid,
 			   dl->disk.guid, DDF_GUID_LEN) == 0)
 			dl->pdnum = i;
@@ -1371,10 +1376,10 @@ static void examine_vd(int n, struct ddf_super *sb, char *guid)
 
 		/* Ok, we know about this VD, let's give more details */
 		printf(" Raid Devices[%d] : %d (", n,
-		       __be16_to_cpu(vc->prim_elmnt_count));
-		for (i = 0; i < __be16_to_cpu(vc->prim_elmnt_count); i++) {
+		       be16_to_cpu(vc->prim_elmnt_count));
+		for (i = 0; i < be16_to_cpu(vc->prim_elmnt_count); i++) {
 			int j;
-			int cnt = __be16_to_cpu(sb->phys->used_pdes);
+			int cnt = be16_to_cpu(sb->phys->used_pdes);
 			for (j=0; j<cnt; j++)
 				if (be32_eq(vc->phys_refnum[i],
 					    sb->phys->entries[j].refnum))
@@ -1406,18 +1411,18 @@ static void examine_vd(int n, struct ddf_super *sb, char *guid)
 
 static void examine_vds(struct ddf_super *sb)
 {
-	int cnt = __be16_to_cpu(sb->virt->populated_vdes);
+	int cnt = be16_to_cpu(sb->virt->populated_vdes);
 	unsigned int i;
 	printf("  Virtual Disks : %d\n", cnt);
 
-	for (i = 0; i < __be16_to_cpu(sb->virt->max_vdes); i++) {
+	for (i = 0; i < be16_to_cpu(sb->virt->max_vdes); i++) {
 		struct virtual_entry *ve = &sb->virt->entries[i];
 		if (all_ff(ve->guid))
 			continue;
 		printf("\n");
 		printf("      VD GUID[%d] : ", i); print_guid(ve->guid, 1);
 		printf("\n");
-		printf("         unit[%d] : %d\n", i, __be16_to_cpu(ve->unit));
+		printf("         unit[%d] : %d\n", i, be16_to_cpu(ve->unit));
 		printf("        state[%d] : %s, %s%s\n", i,
 		       map_num(ddf_state, ve->state & 7),
 		       (ve->state & 8) ? "Morphing, ": "",
@@ -1434,7 +1439,7 @@ static void examine_vds(struct ddf_super *sb)
 
 static void examine_pds(struct ddf_super *sb)
 {
-	int cnt = __be16_to_cpu(sb->phys->used_pdes);
+	int cnt = be16_to_cpu(sb->phys->used_pdes);
 	int i;
 	struct dl *dl;
 	printf(" Physical Disks : %d\n", cnt);
@@ -1442,8 +1447,8 @@ static void examine_pds(struct ddf_super *sb)
 
 	for (i=0 ; i<cnt ; i++) {
 		struct phys_disk_entry *pd = &sb->phys->entries[i];
-		int type = __be16_to_cpu(pd->type);
-		int state = __be16_to_cpu(pd->state);
+		int type = be16_to_cpu(pd->type);
+		int state = be16_to_cpu(pd->state);
 
 		//printf("      PD GUID[%d] : ", i); print_guid(pd->guid, 0);
 		//printf("\n");
@@ -1531,7 +1536,7 @@ static unsigned int get_vd_num_of_subarray(struct supertype *st)
 	if (sub != NULL)
 		vcnum = strtoul(sub + 1, &end, 10);
 	if (sub == NULL || *sub == '\0' || *end != '\0' ||
-	    vcnum >= __be16_to_cpu(ddf->active->max_vd_entries))
+	    vcnum >= be16_to_cpu(ddf->active->max_vd_entries))
 		return DDF_NOTFOUND;
 
 	return vcnum;
@@ -1560,7 +1565,7 @@ static void brief_examine_subarrays_ddf(struct supertype *st, int verbose)
 	getinfo_super_ddf(st, &info, NULL);
 	fname_from_uuid(st, &info, nbuf, ':');
 
-	for (i = 0; i < __be16_to_cpu(ddf->virt->max_vdes); i++) {
+	for (i = 0; i < be16_to_cpu(ddf->virt->max_vdes); i++) {
 		struct virtual_entry *ve = &ddf->virt->entries[i];
 		struct vcl vcl;
 		char nbuf1[64];
@@ -1704,7 +1709,7 @@ static int find_index_in_bvd(const struct ddf_super *ddf,
 	 */
 	unsigned int i, j;
 	for (i = 0, j = 0; i < ddf->mppe &&
-		     j < __be16_to_cpu(conf->prim_elmnt_count); i++) {
+		     j < be16_to_cpu(conf->prim_elmnt_count); i++) {
 		if (be32_to_cpu(conf->phys_refnum[i]) != 0xffffffff) {
 			if (n == j) {
 				*n_bvd = i;
@@ -1714,7 +1719,7 @@ static int find_index_in_bvd(const struct ddf_super *ddf,
 		}
 	}
 	dprintf("%s: couldn't find BVD member %u (total %u)\n",
-		__func__, n, __be16_to_cpu(conf->prim_elmnt_count));
+		__func__, n, be16_to_cpu(conf->prim_elmnt_count));
 	return 0;
 }
 
@@ -1742,7 +1747,7 @@ static struct vd_config *find_vdcr(struct ddf_super *ddf, unsigned int inst,
 			       __func__, conf->sec_elmnt_count);
 			goto bad;
 		}
-		nsec = n / __be16_to_cpu(conf->prim_elmnt_count);
+		nsec = n / be16_to_cpu(conf->prim_elmnt_count);
 		if (conf->sec_elmnt_seq != nsec) {
 			for (ibvd = 1; ibvd < conf->sec_elmnt_count; ibvd++) {
 				if (v->other_bvds[ibvd-1]->sec_elmnt_seq
@@ -1773,7 +1778,7 @@ static int find_phys(const struct ddf_super *ddf, be32 phys_refnum)
 	 * and return it's index
 	 */
 	unsigned int i;
-	for (i = 0; i < __be16_to_cpu(ddf->phys->max_pdes); i++)
+	for (i = 0; i < be16_to_cpu(ddf->phys->max_pdes); i++)
 		if (be32_eq(ddf->phys->entries[i].refnum, phys_refnum))
 			return i;
 	return -1;
@@ -1835,7 +1840,7 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
 	}
 	memset(info, 0, sizeof(*info));
 
-	info->array.raid_disks    = __be16_to_cpu(ddf->phys->used_pdes);
+	info->array.raid_disks    = be16_to_cpu(ddf->phys->used_pdes);
 	info->array.level	  = LEVEL_CONTAINER;
 	info->array.layout	  = 0;
 	info->array.md_minor	  = -1;
@@ -1879,8 +1884,10 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
 		int i;
 		for (i = 0 ; i < map_disks; i++) {
 			if (i < info->array.raid_disks &&
-			    (__be16_to_cpu(ddf->phys->entries[i].state) & DDF_Online) &&
-			    !(__be16_to_cpu(ddf->phys->entries[i].state) & DDF_Failed))
+			    (be16_to_cpu(ddf->phys->entries[i].state)
+			     & DDF_Online) &&
+			    !(be16_to_cpu(ddf->phys->entries[i].state)
+			      & DDF_Failed))
 				map[i] = 1;
 			else
 				map[i] = 0;
@@ -1911,7 +1918,7 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 	info->custom_array_size	  = 0;
 
 	conf = &vc->conf;
-	n_prim = __be16_to_cpu(conf->prim_elmnt_count);
+	n_prim = be16_to_cpu(conf->prim_elmnt_count);
 	if (conf->sec_elmnt_count > 1 && cd >= n_prim) {
 		int ibvd = cd / n_prim - 1;
 		cd %= n_prim;
@@ -1938,7 +1945,7 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 		info->disk.major = dl->major;
 		info->disk.minor = dl->minor;
 		info->disk.raid_disk = cd + conf->sec_elmnt_seq
-			* __be16_to_cpu(conf->prim_elmnt_count);
+			* be16_to_cpu(conf->prim_elmnt_count);
 		info->disk.number = dl->pdnum;
 		info->disk.state = (1<<MD_DISK_SYNC)|(1<<MD_DISK_ACTIVE);
 	}
@@ -1977,8 +1984,10 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 			if (j <  info->array.raid_disks) {
 				int i = find_phys(ddf, vc->conf.phys_refnum[j]);
 				if (i >= 0 &&
-				    (__be16_to_cpu(ddf->phys->entries[i].state) & DDF_Online) &&
-				    !(__be16_to_cpu(ddf->phys->entries[i].state) & DDF_Failed))
+				    (be16_to_cpu(ddf->phys->entries[i].state)
+				     & DDF_Online) &&
+				    !(be16_to_cpu(ddf->phys->entries[i].state)
+				      & DDF_Failed))
 					map[i] = 1;
 			}
 		}
@@ -2077,7 +2086,7 @@ static void make_header_guid(char *guid)
 static unsigned int find_unused_vde(const struct ddf_super *ddf)
 {
 	unsigned int i;
-	for (i = 0; i < __be16_to_cpu(ddf->virt->max_vdes); i++) {
+	for (i = 0; i < be16_to_cpu(ddf->virt->max_vdes); i++) {
 		if (all_ff(ddf->virt->entries[i].guid))
 			return i;
 	}
@@ -2090,7 +2099,7 @@ static unsigned int find_vde_by_name(const struct ddf_super *ddf,
 	unsigned int i;
 	if (name == NULL)
 		return DDF_NOTFOUND;
-	for (i = 0; i < __be16_to_cpu(ddf->virt->max_vdes); i++) {
+	for (i = 0; i < be16_to_cpu(ddf->virt->max_vdes); i++) {
 		if (all_ff(ddf->virt->entries[i].guid))
 			continue;
 		if (!strncmp(name, ddf->virt->entries[i].name,
@@ -2106,7 +2115,7 @@ static unsigned int find_vde_by_guid(const struct ddf_super *ddf,
 	unsigned int i;
 	if (guid == NULL || all_ff(guid))
 		return DDF_NOTFOUND;
-	for (i = 0; i < __be16_to_cpu(ddf->virt->max_vdes); i++)
+	for (i = 0; i < be16_to_cpu(ddf->virt->max_vdes); i++)
 		if (!memcmp(ddf->virt->entries[i].guid, guid, DDF_GUID_LEN))
 			return i;
 	return DDF_NOTFOUND;
@@ -2208,15 +2217,15 @@ static int init_super_ddf(struct supertype *st,
 	/* Put this at bottom of 32M reserved.. */
 	ddf->anchor.workspace_lba = cpu_to_be64(~(__u64)0);
 	max_phys_disks = 1023;   /* Should be enough */
-	ddf->anchor.max_pd_entries = __cpu_to_be16(max_phys_disks);
+	ddf->anchor.max_pd_entries = cpu_to_be16(max_phys_disks);
 	max_virt_disks = 255;
-	ddf->anchor.max_vd_entries = __cpu_to_be16(max_virt_disks); /* ?? */
-	ddf->anchor.max_partitions = __cpu_to_be16(64); /* ?? */
+	ddf->anchor.max_vd_entries = cpu_to_be16(max_virt_disks); /* ?? */
+	ddf->anchor.max_partitions = cpu_to_be16(64); /* ?? */
 	ddf->max_part = 64;
 	ddf->mppe = 256;
 	ddf->conf_rec_len = 1 + ROUND_UP(ddf->mppe * (4+8), 512)/512;
-	ddf->anchor.config_record_len = __cpu_to_be16(ddf->conf_rec_len);
-	ddf->anchor.max_primary_element_entries = __cpu_to_be16(ddf->mppe);
+	ddf->anchor.config_record_len = cpu_to_be16(ddf->conf_rec_len);
+	ddf->anchor.max_primary_element_entries = cpu_to_be16(ddf->mppe);
 	memset(ddf->anchor.pad3, 0xff, 54);
 	/* controller sections is one sector long immediately
 	 * after the ddf header */
@@ -2294,10 +2303,10 @@ static int init_super_ddf(struct supertype *st,
 	for (i = strlen(T10) ; i+hostlen < 24; i++)
 		ddf->controller.guid[i] = ' ';
 
-	ddf->controller.type.vendor_id = __cpu_to_be16(0xDEAD);
-	ddf->controller.type.device_id = __cpu_to_be16(0xBEEF);
-	ddf->controller.type.sub_vendor_id = 0;
-	ddf->controller.type.sub_device_id = 0;
+	ddf->controller.type.vendor_id = cpu_to_be16(0xDEAD);
+	ddf->controller.type.device_id = cpu_to_be16(0xBEEF);
+	ddf->controller.type.sub_vendor_id = cpu_to_be16(0);
+	ddf->controller.type.sub_device_id = cpu_to_be16(0);
 	memcpy(ddf->controller.product_id, "What Is My PID??", 16);
 	memset(ddf->controller.pad, 0xff, 8);
 	memset(ddf->controller.vendor_data, 0xff, 448);
@@ -2314,8 +2323,8 @@ static int init_super_ddf(struct supertype *st,
 	memset(pd, 0xff, pdsize);
 	memset(pd, 0, sizeof(*pd));
 	pd->magic = DDF_PHYS_RECORDS_MAGIC;
-	pd->used_pdes = __cpu_to_be16(0);
-	pd->max_pdes = __cpu_to_be16(max_phys_disks);
+	pd->used_pdes = cpu_to_be16(0);
+	pd->max_pdes = cpu_to_be16(max_phys_disks);
 	memset(pd->pad, 0xff, 52);
 	for (i = 0; i < max_phys_disks; i++)
 		memset(pd->entries[i].guid, 0xff, DDF_GUID_LEN);
@@ -2328,8 +2337,8 @@ static int init_super_ddf(struct supertype *st,
 	ddf->vdsize = vdsize;
 	memset(vd, 0, vdsize);
 	vd->magic = DDF_VIRT_RECORDS_MAGIC;
-	vd->populated_vdes = __cpu_to_be16(0);
-	vd->max_vdes = __cpu_to_be16(max_virt_disks);
+	vd->populated_vdes = cpu_to_be16(0);
+	vd->max_vdes = cpu_to_be16(max_virt_disks);
 	memset(vd->pad, 0xff, 52);
 
 	for (i=0; i<max_virt_disks; i++)
@@ -2426,10 +2435,11 @@ static int init_super_ddf_bvd(struct supertype *st,
 	 * timestamp, random number
 	 */
 	make_header_guid(ve->guid);
-	ve->unit = __cpu_to_be16(info->md_minor);
+	ve->unit = cpu_to_be16(info->md_minor);
 	ve->pad0 = 0xFFFF;
-	ve->guid_crc = crc32(0, (unsigned char*)ddf->anchor.guid, DDF_GUID_LEN);
-	ve->type = 0;
+	ve->guid_crc._v16 = crc32(0, (unsigned char *)ddf->anchor.guid,
+				  DDF_GUID_LEN);
+	ve->type = cpu_to_be16(0);
 	ve->state = DDF_state_degraded; /* Will be modified as devices are added */
 	if (info->state & 1) /* clean */
 		ve->init_state = DDF_init_full;
@@ -2441,7 +2451,7 @@ static int init_super_ddf_bvd(struct supertype *st,
 	if (name)
 		strncpy(ve->name, name, 16);
 	ddf->virt->populated_vdes =
-		__cpu_to_be16(__be16_to_cpu(ddf->virt->populated_vdes)+1);
+		cpu_to_be16(be16_to_cpu(ddf->virt->populated_vdes)+1);
 
 	/* Now create a new vd_config */
 	if (posix_memalign((void**)&vcl, 512,
@@ -2460,7 +2470,7 @@ static int init_super_ddf_bvd(struct supertype *st,
 	memset(vc->pad0, 0xff, 24);
 	vc->chunk_shift = chunk_to_shift(info->chunk_size);
 	if (layout_md2ddf(info, vc) == -1 ||
-		__be16_to_cpu(vc->prim_elmnt_count) > ddf->mppe) {
+		be16_to_cpu(vc->prim_elmnt_count) > ddf->mppe) {
 		pr_err("%s: unsupported RAID level/layout %d/%d with %d disks\n",
 		       __func__, info->level, info->layout, info->raid_disks);
 		free(vcl);
@@ -2551,7 +2561,7 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 
 	vc = &ddf->currentconf->conf;
 	if (vc->sec_elmnt_count > 1) {
-		unsigned int n = __be16_to_cpu(vc->prim_elmnt_count);
+		unsigned int n = be16_to_cpu(vc->prim_elmnt_count);
 		if (raid_disk >= n)
 			vc = ddf->currentconf->other_bvds[raid_disk / n - 1];
 		raid_disk %= n;
@@ -2599,8 +2609,10 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 	ddf->virt->entries[i].state =
 		(ddf->virt->entries[i].state & ~DDF_state_mask)
 		| get_svd_state(ddf, ddf->currentconf);
-	ddf->phys->entries[dl->pdnum].type &= ~__cpu_to_be16(DDF_Global_Spare);
-	ddf->phys->entries[dl->pdnum].type |= __cpu_to_be16(DDF_Active_in_VD);
+	be16_clear(ddf->phys->entries[dl->pdnum].type,
+		   cpu_to_be16(DDF_Global_Spare));
+	be16_set(ddf->phys->entries[dl->pdnum].type,
+		 cpu_to_be16(DDF_Active_in_VD));
 	dprintf("%s: added disk %d/%08x to VD %d/%s as disk %d\n",
 		__func__, dl->pdnum, be32_to_cpu(dl->disk.refnum),
 		ddf->currentconf->vcnum, guid_str(vc->guid),
@@ -2611,7 +2623,7 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 static unsigned int find_unused_pde(const struct ddf_super *ddf)
 {
 	unsigned int i;
-	for (i = 0; i < __be16_to_cpu(ddf->phys->max_pdes); i++) {
+	for (i = 0; i < be16_to_cpu(ddf->phys->max_pdes); i++) {
 		if (all_ff(ddf->phys->entries[i].guid))
 			return i;
 	}
@@ -2683,7 +2695,7 @@ static int add_to_super_ddf(struct supertype *st,
 	do {
 		/* Cannot be bothered finding a CRC of some irrelevant details*/
 		dd->disk.refnum._v32 = random32();
-		for (i = __be16_to_cpu(ddf->active->max_pd_entries);
+		for (i = be16_to_cpu(ddf->active->max_pd_entries);
 		     i > 0; i--)
 			if (be32_eq(ddf->phys->entries[i-1].refnum,
 				    dd->disk.refnum))
@@ -2707,17 +2719,17 @@ static int add_to_super_ddf(struct supertype *st,
 
 		pd = xmalloc(len);
 		pd->magic = DDF_PHYS_RECORDS_MAGIC;
-		pd->used_pdes = __cpu_to_be16(n);
+		pd->used_pdes = cpu_to_be16(n);
 		pde = &pd->entries[0];
 		dd->mdupdate = pd;
 	} else
-		ddf->phys->used_pdes = __cpu_to_be16(
-			1 + __be16_to_cpu(ddf->phys->used_pdes));
+		ddf->phys->used_pdes = cpu_to_be16(
+			1 + be16_to_cpu(ddf->phys->used_pdes));
 
 	memcpy(pde->guid, dd->disk.guid, DDF_GUID_LEN);
 	pde->refnum = dd->disk.refnum;
-	pde->type = __cpu_to_be16(DDF_Forced_PD_GUID | DDF_Global_Spare);
-	pde->state = __cpu_to_be16(DDF_Online);
+	pde->type = cpu_to_be16(DDF_Forced_PD_GUID | DDF_Global_Spare);
+	pde->state = cpu_to_be16(DDF_Online);
 	dd->size = size;
 	/*
 	 * If there is already a device in dlist, try to reserve the same
@@ -2782,8 +2794,8 @@ static int remove_from_super_ddf(struct supertype *st, mdu_disk_info_t *dk)
 
 		pd = xmalloc(len);
 		pd->magic = DDF_PHYS_RECORDS_MAGIC;
-		pd->used_pdes = __cpu_to_be16(dl->pdnum);
-		pd->entries[0].state = __cpu_to_be16(DDF_Missing);
+		pd->used_pdes = cpu_to_be16(dl->pdnum);
+		pd->entries[0].state = cpu_to_be16(DDF_Missing);
 		append_metadata_update(st, pd, len);
 	}
 	return 0;
@@ -3010,7 +3022,7 @@ static int write_init_super_ddf(struct supertype *st)
 		vd = xmalloc(len);
 		*vd = *ddf->virt;
 		vd->entries[0] = ddf->virt->entries[currentconf->vcnum];
-		vd->populated_vdes = __cpu_to_be16(currentconf->vcnum);
+		vd->populated_vdes = cpu_to_be16(currentconf->vcnum);
 		append_metadata_update(st, vd, len);
 
 		/* Then the vd_config */
@@ -3542,7 +3554,7 @@ static int check_secondary(const struct vcl *vc)
 			pr_err("Different RAID levels for BVDs are unsupported\n");
 			return -1;
 		}
-		if (bvd->prim_elmnt_count != conf->prim_elmnt_count) {
+		if (!be16_eq(bvd->prim_elmnt_count, conf->prim_elmnt_count)) {
 			pr_err("All BVDs must have the same number of primary elements\n");
 			return -1;
 		}
@@ -3572,7 +3584,7 @@ static unsigned int get_pd_index_from_refnum(const struct vcl *vc,
 {
 	unsigned int i, j, n, sec, cnt;
 
-	cnt = __be16_to_cpu(vc->conf.prim_elmnt_count);
+	cnt = be16_to_cpu(vc->conf.prim_elmnt_count);
 	sec = (vc->conf.sec_elmnt_count == 1 ? 0 : vc->conf.sec_elmnt_seq);
 
 	for (i = 0, j = 0 ; i < nmax ; i++) {
@@ -3685,7 +3697,7 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 		sprintf(this->text_version, "/%s/%d",
 			st->container_devnm, this->container_member);
 
-		for (pd = 0; pd < __be16_to_cpu(ddf->phys->used_pdes); pd++) {
+		for (pd = 0; pd < be16_to_cpu(ddf->phys->used_pdes); pd++) {
 			struct mdinfo *dev;
 			struct dl *d;
 			const struct vd_config *bvd;
@@ -3696,7 +3708,7 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 			    == 0xFFFFFFFF)
 				continue;
 
-			stt = __be16_to_cpu(ddf->phys->entries[pd].state);
+			stt = be16_to_cpu(ddf->phys->entries[pd].state);
 			if ((stt & (DDF_Online|DDF_Failed|DDF_Rebuilding))
 			    != DDF_Online)
 				continue;
@@ -3822,13 +3834,14 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 		return 3;
 	}
 	if (first->max_part != second->max_part ||
-	    first->phys->used_pdes != second->phys->used_pdes ||
-	    first->virt->populated_vdes != second->virt->populated_vdes) {
+	    !be16_eq(first->phys->used_pdes, second->phys->used_pdes) ||
+	    !be16_eq(first->virt->populated_vdes,
+		     second->virt->populated_vdes)) {
 		dprintf("%s: PD/VD number mismatch\n", __func__);
 		return 3;
 	}
 
-	max_pds =  __be16_to_cpu(first->phys->used_pdes);
+	max_pds =  be16_to_cpu(first->phys->used_pdes);
 	for (dl2 = second->dlist; dl2; dl2 = dl2->next) {
 		for (pd = 0; pd < max_pds; pd++)
 			if (be32_eq(first->phys->entries[pd].refnum,
@@ -3841,7 +3854,7 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 		}
 	}
 
-	max_vds = __be16_to_cpu(first->active->max_vd_entries);
+	max_vds = be16_to_cpu(first->active->max_vd_entries);
 	for (vl2 = second->conflist; vl2; vl2 = vl2->next) {
 		if (!be32_eq(vl2->conf.magic, DDF_VD_CONF_MAGIC))
 			continue;
@@ -4026,7 +4039,7 @@ static int get_bvd_state(const struct ddf_super *ddf,
 			 const struct vd_config *vc)
 {
 	unsigned int i, n_bvd, working = 0;
-	unsigned int n_prim = __be16_to_cpu(vc->prim_elmnt_count);
+	unsigned int n_prim = be16_to_cpu(vc->prim_elmnt_count);
 	int pd, st, state;
 	for (i = 0; i < n_prim; i++) {
 		if (!find_index_in_bvd(ddf, vc, i, &n_bvd))
@@ -4034,7 +4047,7 @@ static int get_bvd_state(const struct ddf_super *ddf,
 		pd = find_phys(ddf, vc->phys_refnum[n_bvd]);
 		if (pd < 0)
 			continue;
-		st = __be16_to_cpu(ddf->phys->entries[pd].state);
+		st = be16_to_cpu(ddf->phys->entries[pd].state);
 		if ((st & (DDF_Online|DDF_Failed|DDF_Rebuilding))
 		    == DDF_Online)
 			working++;
@@ -4162,21 +4175,24 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 			vc->phys_refnum[n_bvd] = dl->disk.refnum;
 			LBA_OFFSET(ddf, vc)[n_bvd] =
 				cpu_to_be64(mdi->data_offset);
-			ddf->phys->entries[pd].type &=
-				~__cpu_to_be16(DDF_Global_Spare);
-			ddf->phys->entries[pd].type |=
-				__cpu_to_be16(DDF_Active_in_VD);
+			be16_clear(ddf->phys->entries[pd].type,
+				   cpu_to_be16(DDF_Global_Spare));
+			be16_set(ddf->phys->entries[pd].type,
+				 cpu_to_be16(DDF_Active_in_VD));
 			ddf_set_updates_pending(ddf);
 		}
 	} else {
-		int old = ddf->phys->entries[pd].state;
+		be16 old = ddf->phys->entries[pd].state;
 		if (state & DS_FAULTY)
-			ddf->phys->entries[pd].state  |= __cpu_to_be16(DDF_Failed);
+			be16_set(ddf->phys->entries[pd].state,
+				 cpu_to_be16(DDF_Failed));
 		if (state & DS_INSYNC) {
-			ddf->phys->entries[pd].state  |= __cpu_to_be16(DDF_Online);
-			ddf->phys->entries[pd].state  &= __cpu_to_be16(~DDF_Rebuilding);
+			be16_set(ddf->phys->entries[pd].state,
+				 cpu_to_be16(DDF_Online));
+			be16_clear(ddf->phys->entries[pd].state,
+				   cpu_to_be16(DDF_Rebuilding));
 		}
-		if (old != ddf->phys->entries[pd].state)
+		if (!be16_eq(old, ddf->phys->entries[pd].state))
 			ddf_set_updates_pending(ddf);
 	}
 
@@ -4291,7 +4307,7 @@ static int kill_subarray_ddf(struct supertype *st)
 		}
 		memset(vd, 0 , len);
 		vd->magic = DDF_VIRT_RECORDS_MAGIC;
-		vd->populated_vdes = 0;
+		vd->populated_vdes = cpu_to_be16(0);
 		memcpy(vd->entries[0].guid, conf->guid, DDF_GUID_LEN);
 		/* we use DDF_state_deleted as marker */
 		vd->entries[0].state = DDF_state_deleted;
@@ -4309,7 +4325,7 @@ static void copy_matching_bvd(struct ddf_super *ddf,
 			      const struct metadata_update *update)
 {
 	unsigned int mppe =
-		__be16_to_cpu(ddf->anchor.max_primary_element_entries);
+		be16_to_cpu(ddf->anchor.max_primary_element_entries);
 	unsigned int len = ddf->conf_rec_len * 512;
 	char *p;
 	struct vd_config *vc;
@@ -4374,13 +4390,14 @@ static void ddf_process_update(struct supertype *st,
 			return;
 		pd = (struct phys_disk*)update->buf;
 
-		ent = __be16_to_cpu(pd->used_pdes);
-		if (ent >= __be16_to_cpu(ddf->phys->max_pdes))
+		ent = be16_to_cpu(pd->used_pdes);
+		if (ent >= be16_to_cpu(ddf->phys->max_pdes))
 			return;
-		if (pd->entries[0].state & __cpu_to_be16(DDF_Missing)) {
+		if (be16_and(pd->entries[0].state, cpu_to_be16(DDF_Missing))) {
 			struct dl **dlp;
 			/* removing this disk. */
-			ddf->phys->entries[ent].state |= __cpu_to_be16(DDF_Missing);
+			be16_set(ddf->phys->entries[ent].state,
+				 cpu_to_be16(DDF_Missing));
 			for (dlp = &ddf->dlist; *dlp; dlp = &(*dlp)->next) {
 				struct dl *dl = *dlp;
 				if (dl->pdnum == (signed)ent) {
@@ -4399,8 +4416,8 @@ static void ddf_process_update(struct supertype *st,
 		if (!all_ff(ddf->phys->entries[ent].guid))
 			return;
 		ddf->phys->entries[ent] = pd->entries[0];
-		ddf->phys->used_pdes = __cpu_to_be16(1 +
-						     __be16_to_cpu(ddf->phys->used_pdes));
+		ddf->phys->used_pdes = cpu_to_be16
+			(1 + be16_to_cpu(ddf->phys->used_pdes));
 		ddf_set_updates_pending(ddf);
 		if (ddf->add_list) {
 			struct active_array *a;
@@ -4440,8 +4457,8 @@ static void ddf_process_update(struct supertype *st,
 				return;
 			ddf->virt->entries[ent] = vd->entries[0];
 			ddf->virt->populated_vdes =
-				__cpu_to_be16(
-					1 + __be16_to_cpu(
+				cpu_to_be16(
+					1 + be16_to_cpu(
 						ddf->virt->populated_vdes));
 			dprintf("%s: added VD %s in slot %d(s=%02x i=%02x)\n",
 				__func__, guid_str(vd->entries[0].guid), ent,
@@ -4495,11 +4512,12 @@ static void ddf_process_update(struct supertype *st,
 		/* Set DDF_Transition on all Failed devices - to help
 		 * us detect those that are no longer in use
 		 */
-		for (pdnum = 0; pdnum < __be16_to_cpu(ddf->phys->used_pdes); pdnum++)
-			if (ddf->phys->entries[pdnum].state
-			    & __be16_to_cpu(DDF_Failed))
-				ddf->phys->entries[pdnum].state
-					|= __be16_to_cpu(DDF_Transition);
+		for (pdnum = 0; pdnum < be16_to_cpu(ddf->phys->used_pdes);
+		     pdnum++)
+			if (be16_and(ddf->phys->entries[pdnum].state,
+				     cpu_to_be16(DDF_Failed)))
+				be16_set(ddf->phys->entries[pdnum].state,
+					 cpu_to_be16(DDF_Transition));
 		/* Now make sure vlist is correct for each dl. */
 		for (dl = ddf->dlist; dl; dl = dl->next) {
 			unsigned int vn = 0;
@@ -4520,10 +4538,12 @@ static void ddf_process_update(struct supertype *st,
 					guid_str(conf->guid),
 					conf->sec_elmnt_seq, vn);
 				/* Clear the Transition flag */
-				if (ddf->phys->entries[dl->pdnum].state
-				    & __be16_to_cpu(DDF_Failed))
-					ddf->phys->entries[dl->pdnum].state &=
-						~__be16_to_cpu(DDF_Transition);
+				if (be16_and
+				    (ddf->phys->entries[dl->pdnum].state,
+				     cpu_to_be16(DDF_Failed)))
+					be16_clear(ddf->phys
+						   ->entries[dl->pdnum].state,
+						   cpu_to_be16(DDF_Transition));
 				dl->vlist[vn++] = vcl;
 				vstate = ddf->virt->entries[vcl->vcnum].state
 					& DDF_state_mask;
@@ -4534,29 +4554,35 @@ static void ddf_process_update(struct supertype *st,
 			while (vn < ddf->max_part)
 				dl->vlist[vn++] = NULL;
 			if (dl->vlist[0]) {
-				ddf->phys->entries[dl->pdnum].type &=
-					~__cpu_to_be16(DDF_Global_Spare);
-				if (!(ddf->phys->entries[dl->pdnum].type &
-				      __cpu_to_be16(DDF_Active_in_VD))) {
-					ddf->phys->entries[dl->pdnum].type |=
-						__cpu_to_be16(DDF_Active_in_VD);
+				be16_clear(ddf->phys->entries[dl->pdnum].type,
+					   cpu_to_be16(DDF_Global_Spare));
+				if (!be16_and(ddf->phys
+					      ->entries[dl->pdnum].type,
+					      cpu_to_be16(DDF_Active_in_VD))) {
+					be16_set(ddf->phys
+						 ->entries[dl->pdnum].type,
+						 cpu_to_be16(DDF_Active_in_VD));
 					if (in_degraded)
-						ddf->phys->entries[dl->pdnum].state |=
-							__cpu_to_be16(DDF_Rebuilding);
+						be16_set(ddf->phys
+							 ->entries[dl->pdnum]
+							 .state,
+							 cpu_to_be16
+							 (DDF_Rebuilding));
 				}
 			}
 			if (dl->spare) {
-				ddf->phys->entries[dl->pdnum].type &=
-					~__cpu_to_be16(DDF_Global_Spare);
-				ddf->phys->entries[dl->pdnum].type |=
-					__cpu_to_be16(DDF_Spare);
+				be16_clear(ddf->phys->entries[dl->pdnum].type,
+					   cpu_to_be16(DDF_Global_Spare));
+				be16_set(ddf->phys->entries[dl->pdnum].type,
+					 cpu_to_be16(DDF_Spare));
 			}
 			if (!dl->vlist[0] && !dl->spare) {
-				ddf->phys->entries[dl->pdnum].type |=
-					__cpu_to_be16(DDF_Global_Spare);
-				ddf->phys->entries[dl->pdnum].type &=
-					~__cpu_to_be16(DDF_Spare |
-						       DDF_Active_in_VD);
+				be16_set(ddf->phys->entries[dl->pdnum].type,
+					 cpu_to_be16(DDF_Global_Spare));
+				be16_clear(ddf->phys->entries[dl->pdnum].type,
+					   cpu_to_be16(DDF_Spare));
+				be16_clear(ddf->phys->entries[dl->pdnum].type,
+					   cpu_to_be16(DDF_Active_in_VD));
 			}
 		}
 
@@ -4565,24 +4591,27 @@ static void ddf_process_update(struct supertype *st,
 		 * Once done, we need to update all dl->pdnum numbers.
 		 */
 		pd2 = 0;
-		for (pdnum = 0; pdnum < __be16_to_cpu(ddf->phys->used_pdes); pdnum++)
-			if ((ddf->phys->entries[pdnum].state
-			     & __be16_to_cpu(DDF_Failed))
-			    && (ddf->phys->entries[pdnum].state
-				& __be16_to_cpu(DDF_Transition)))
+		for (pdnum = 0; pdnum < be16_to_cpu(ddf->phys->used_pdes);
+		     pdnum++)
+			if (be16_and(ddf->phys->entries[pdnum].state,
+				     cpu_to_be16(DDF_Failed))
+			    && be16_and(ddf->phys->entries[pdnum].state,
+					cpu_to_be16(DDF_Transition)))
 				/* skip this one */;
 			else if (pdnum == pd2)
 				pd2++;
 			else {
-				ddf->phys->entries[pd2] = ddf->phys->entries[pdnum];
+				ddf->phys->entries[pd2] =
+					ddf->phys->entries[pdnum];
 				for (dl = ddf->dlist; dl; dl = dl->next)
 					if (dl->pdnum == (int)pdnum)
 						dl->pdnum = pd2;
 				pd2++;
 			}
-		ddf->phys->used_pdes = __cpu_to_be16(pd2);
+		ddf->phys->used_pdes = cpu_to_be16(pd2);
 		while (pd2 < pdnum) {
-			memset(ddf->phys->entries[pd2].guid, 0xff, DDF_GUID_LEN);
+			memset(ddf->phys->entries[pd2].guid, 0xff,
+			       DDF_GUID_LEN);
 			pd2++;
 		}
 
@@ -4658,7 +4687,8 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 			working ++;
 	}
 
-	dprintf("ddf_activate: working=%d (%d) level=%d\n", working, a->info.array.raid_disks,
+	dprintf("ddf_activate: working=%d (%d) level=%d\n", working,
+		a->info.array.raid_disks,
 		a->info.array.level);
 	if (working == a->info.array.raid_disks)
 		return NULL; /* array not degraded */
@@ -4710,14 +4740,16 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 				}
 			if (d2)
 				continue;
-			if (ddf->phys->entries[dl->pdnum].type &
-			    __cpu_to_be16(DDF_Spare)) {
+			if (be16_and(ddf->phys->entries[dl->pdnum].type,
+				     cpu_to_be16(DDF_Spare))) {
 				/* Check spare assign record */
 				if (dl->spare) {
 					if (dl->spare->type & DDF_spare_dedicated) {
 						/* check spare_ents for guid */
 						for (j = 0 ;
-						     j < __be16_to_cpu(dl->spare->populated);
+						     j < be16_to_cpu
+							     (dl->spare
+							      ->populated);
 						     j++) {
 							if (memcmp(dl->spare->spare_ents[j].guid,
 								   ddf->virt->entries[a->info.container_member].guid,
@@ -4727,11 +4759,12 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 					} else
 						is_global = 1;
 				}
-			} else if (ddf->phys->entries[dl->pdnum].type &
-				   __cpu_to_be16(DDF_Global_Spare)) {
+			} else if (be16_and(ddf->phys->entries[dl->pdnum].type,
+					    cpu_to_be16(DDF_Global_Spare))) {
 				is_global = 1;
-			} else if (!(ddf->phys->entries[dl->pdnum].state &
-				     __cpu_to_be16(DDF_Failed))) {
+			} else if (!be16_and(ddf->phys
+					     ->entries[dl->pdnum].state,
+					     cpu_to_be16(DDF_Failed))) {
 				/* we can possibly use some of this */
 				is_global = 1;
 			}
-- 
1.7.1
