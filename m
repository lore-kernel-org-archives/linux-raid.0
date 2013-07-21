From: mwilck@arcor.de
Subject: [PATCH 3/6] DDF: convert big-endian __u64 to be64 type
Date: Sun, 21 Jul 2013 19:28:21 +0200
Message-ID: <1374427704-7903-4-git-send-email-mwilck@arcor.de>
References: <1374427704-7903-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374427704-7903-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

---
 super-ddf.c |  112 +++++++++++++++++++++++++++++-----------------------------
 1 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 5c016a4..91bfe9e 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -160,13 +160,13 @@ struct ddf_header {
 	__u8	pad1[12];	/* 12 * 0xff */
 	/* 64 bytes so far */
 	__u8	header_ext[32];	/* reserved: fill with 0xff */
-	__u64	primary_lba;
-	__u64	secondary_lba;
+	be64	primary_lba;
+	be64	secondary_lba;
 	__u8	type;
 	__u8	pad2[3];	/* 0xff */
 	be32	workspace_len;	/* sectors for vendor space -
 				 * at least 32768(sectors) */
-	__u64	workspace_lba;
+	be64	workspace_lba;
 	__u16	max_pd_entries;	/* one of 15, 63, 255, 1023, 4095 */
 	__u16	max_vd_entries; /* 2^(4,6,8,10,12)-1 : i.e. as above */
 	__u16	max_partitions; /* i.e. max num of configuration
@@ -229,7 +229,7 @@ struct phys_disk {
 		be32	refnum;
 		__u16	type;
 		__u16	state;
-		__u64	config_size; /* DDF structures must be after here */
+		be64	config_size; /* DDF structures must be after here */
 		char	path[18];	/* another horrible structure really */
 		__u8	pad[6];
 	} entries[0];
@@ -327,10 +327,10 @@ struct vd_config {
 	__u8	sec_elmnt_count;
 	__u8	sec_elmnt_seq;
 	__u8	srl;
-	__u64	blocks;		/* blocks per component could be different
+	be64	blocks;		/* blocks per component could be different
 				 * on different component devices...(only
 				 * for concat I hope) */
-	__u64	array_blocks;	/* blocks in array */
+	be64	array_blocks;	/* blocks in array */
 	__u8	pad1[8];
 	be32	spare_refs[8];
 	__u8	cache_pol[8];
@@ -347,7 +347,7 @@ struct vd_config {
       /*__u64	lba_offset[0];  LBA offset in each phys.  Note extents in a
 				bvd are always the same size */
 };
-#define LBA_OFFSET(ddf, vd) ((__u64 *) &(vd)->phys_refnum[(ddf)->mppe])
+#define LBA_OFFSET(ddf, vd) ((be64 *) &(vd)->phys_refnum[(ddf)->mppe])
 
 /* vd_config.cache_pol[7] is a bitmap */
 #define	DDF_cache_writeback	1	/* else writethrough */
@@ -398,9 +398,9 @@ struct bad_block_log {
 	__u16	entry_count;
 	be32	spare_count;
 	__u8	pad[10];
-	__u64	first_spare;
+	be64	first_spare;
 	struct mapped_block {
-		__u64	defective_start;
+		be64	defective_start;
 		be32	replacement_start;
 		__u16	remap_count;
 		__u8	pad[2];
@@ -460,9 +460,9 @@ struct ddf_super {
 				char *devname;
 				int fd;
 				unsigned long long size; /* sectors */
-				unsigned long long primary_lba; /* sectors */
-				unsigned long long secondary_lba; /* sectors */
-				unsigned long long workspace_lba; /* sectors */
+				be64 primary_lba; /* sectors */
+				be64 secondary_lba; /* sectors */
+				be64 workspace_lba; /* sectors */
 				int pdnum;	/* index in ->phys */
 				struct spare_assign *spare;
 				void *mdupdate; /* hold metadata update */
@@ -756,8 +756,8 @@ static int load_ddf_header(int fd, unsigned long long lba,
 		return 0;
 	if (memcmp(anchor->guid, hdr->guid, DDF_GUID_LEN) != 0 ||
 	    memcmp(anchor->revision, hdr->revision, 8) != 0 ||
-	    anchor->primary_lba != hdr->primary_lba ||
-	    anchor->secondary_lba != hdr->secondary_lba ||
+	    !be64_eq(anchor->primary_lba, hdr->primary_lba) ||
+	    !be64_eq(anchor->secondary_lba, hdr->secondary_lba) ||
 	    hdr->type != type ||
 	    memcmp(anchor->pad2, hdr->pad2, 512 -
 		   offsetof(struct ddf_header, pad2)) != 0)
@@ -792,9 +792,9 @@ static void *load_section(int fd, struct ddf_super *super, void *buf,
 		return NULL;
 
 	if (super->active->type == 1)
-		offset += __be64_to_cpu(super->active->primary_lba);
+		offset += be64_to_cpu(super->active->primary_lba);
 	else
-		offset += __be64_to_cpu(super->active->secondary_lba);
+		offset += be64_to_cpu(super->active->secondary_lba);
 
 	if ((unsigned long long)lseek64(fd, offset<<9, 0) != (offset<<9)) {
 		if (dofree)
@@ -848,7 +848,7 @@ static int load_ddf_headers(int fd, struct ddf_super *super, char *devname)
 		return 2;
 	}
 	super->active = NULL;
-	if (load_ddf_header(fd, __be64_to_cpu(super->anchor.primary_lba),
+	if (load_ddf_header(fd, be64_to_cpu(super->anchor.primary_lba),
 			    dsize >> 9,  1,
 			    &super->primary, &super->anchor) == 0) {
 		if (devname)
@@ -857,7 +857,7 @@ static int load_ddf_headers(int fd, struct ddf_super *super, char *devname)
 	} else
 		super->active = &super->primary;
 
-	if (load_ddf_header(fd, __be64_to_cpu(super->anchor.secondary_lba),
+	if (load_ddf_header(fd, be64_to_cpu(super->anchor.secondary_lba),
 			    dsize >> 9,  2,
 			    &super->secondary, &super->anchor)) {
 		if (super->active == NULL
@@ -1398,9 +1398,9 @@ static void examine_vd(int n, struct ddf_super *sb, char *guid)
 			       map_num(ddf_sec_level, vc->srl) ?: "-unknown-");
 		}
 		printf("  Device Size[%d] : %llu\n", n,
-		       (unsigned long long)__be64_to_cpu(vc->blocks)/2);
+		       be64_to_cpu(vc->blocks)/2);
 		printf("   Array Size[%d] : %llu\n", n,
-		       (unsigned long long)__be64_to_cpu(vc->array_blocks)/2);
+		       be64_to_cpu(vc->array_blocks)/2);
 	}
 }
 
@@ -1450,7 +1450,7 @@ static void examine_pds(struct ddf_super *sb)
 		printf("       %3d    %08x  ", i,
 		       be32_to_cpu(pd->refnum));
 		printf("%8lluK ",
-		       (unsigned long long)__be64_to_cpu(pd->config_size)>>1);
+		       be64_to_cpu(pd->config_size)>>1);
 		for (dl = sb->dlist; dl ; dl = dl->next) {
 			if (be32_eq(dl->disk.refnum, pd->refnum)) {
 				char *dv = map_dev(dl->major, dl->minor, 0);
@@ -1621,10 +1621,10 @@ static int copy_metadata_ddf(struct supertype *st, int from, int to)
 		goto err;
 
 	offset = dsize - 512;
-	if ((__be64_to_cpu(ddf->primary_lba) << 9) < offset)
-		offset = __be64_to_cpu(ddf->primary_lba) << 9;
-	if ((__be64_to_cpu(ddf->secondary_lba) << 9) < offset)
-		offset = __be64_to_cpu(ddf->secondary_lba) << 9;
+	if ((be64_to_cpu(ddf->primary_lba) << 9) < offset)
+		offset = be64_to_cpu(ddf->primary_lba) << 9;
+	if ((be64_to_cpu(ddf->secondary_lba) << 9) < offset)
+		offset = be64_to_cpu(ddf->secondary_lba) << 9;
 
 	bytes = dsize - offset;
 
@@ -1852,7 +1852,7 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
 		info->disk.number = be32_to_cpu(ddf->dlist->disk.refnum);
 		info->disk.raid_disk = find_phys(ddf, ddf->dlist->disk.refnum);
 
-		info->data_offset = __be64_to_cpu(ddf->phys->
+		info->data_offset = be64_to_cpu(ddf->phys->
 						  entries[info->disk.raid_disk].
 						  config_size);
 		info->component_size = ddf->dlist->size - info->data_offset;
@@ -1920,11 +1920,11 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 
 	if (cd >= 0 && (unsigned)cd < ddf->mppe) {
 		info->data_offset =
-			__be64_to_cpu(LBA_OFFSET(ddf, conf)[cd]);
+			be64_to_cpu(LBA_OFFSET(ddf, conf)[cd]);
 		if (vc->block_sizes)
 			info->component_size = vc->block_sizes[cd];
 		else
-			info->component_size = __be64_to_cpu(conf->blocks);
+			info->component_size = be64_to_cpu(conf->blocks);
 	}
 
 	for (dl = ddf->dlist; dl ; dl = dl->next)
@@ -2200,13 +2200,13 @@ static int init_super_ddf(struct supertype *st,
 	ddf->anchor.pad0 = 0xff;
 	memset(ddf->anchor.pad1, 0xff, 12);
 	memset(ddf->anchor.header_ext, 0xff, 32);
-	ddf->anchor.primary_lba = ~(__u64)0;
-	ddf->anchor.secondary_lba = ~(__u64)0;
+	ddf->anchor.primary_lba = cpu_to_be64(~(__u64)0);
+	ddf->anchor.secondary_lba = cpu_to_be64(~(__u64)0);
 	ddf->anchor.type = DDF_HEADER_ANCHOR;
 	memset(ddf->anchor.pad2, 0xff, 3);
 	ddf->anchor.workspace_len = cpu_to_be32(32768); /* Must be reserved */
-	ddf->anchor.workspace_lba = ~(__u64)0; /* Put this at bottom
-						  of 32M reserved.. */
+	/* Put this at bottom of 32M reserved.. */
+	ddf->anchor.workspace_lba = cpu_to_be64(~(__u64)0);
 	max_phys_disks = 1023;   /* Should be enough */
 	ddf->anchor.max_pd_entries = __cpu_to_be16(max_phys_disks);
 	max_virt_disks = 255;
@@ -2383,13 +2383,13 @@ static struct extent *get_extents(struct ddf_super *ddf, struct dl *dl)
 		    get_pd_index_from_refnum(v, dl->disk.refnum, ddf->mppe,
 					     &bvd, &ibvd) == DDF_NOTFOUND)
 			continue;
-		rv[n].start = __be64_to_cpu(LBA_OFFSET(ddf, bvd)[ibvd]);
-		rv[n].size = __be64_to_cpu(bvd->blocks);
+		rv[n].start = be64_to_cpu(LBA_OFFSET(ddf, bvd)[ibvd]);
+		rv[n].size = be64_to_cpu(bvd->blocks);
 		n++;
 	}
 	qsort(rv, n, sizeof(*rv), cmp_extent);
 
-	rv[n].start = __be64_to_cpu(ddf->phys->entries[dl->pdnum].config_size);
+	rv[n].start = be64_to_cpu(ddf->phys->entries[dl->pdnum].config_size);
 	rv[n].size = 0;
 	return rv;
 }
@@ -2473,8 +2473,8 @@ static int init_super_ddf_bvd(struct supertype *st,
 		free(vcl);
 		return 0;
 	}
-	vc->blocks = __cpu_to_be64(info->size * 2);
-	vc->array_blocks = __cpu_to_be64(
+	vc->blocks = cpu_to_be64(info->size * 2);
+	vc->array_blocks = cpu_to_be64(
 		calc_array_size(info->level, info->raid_disks, info->layout,
 				info->chunk_size, info->size*2));
 	memset(vc->pad1, 0xff, 8);
@@ -2562,7 +2562,7 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 		return;
 
 	i = 0; pos = 0;
-	blocks = __be64_to_cpu(vc->blocks);
+	blocks = be64_to_cpu(vc->blocks);
 	if (ddf->currentconf->block_sizes)
 		blocks = ddf->currentconf->block_sizes[dk->raid_disk];
 
@@ -2580,7 +2580,7 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 
 	ddf->currentdev = dk->raid_disk;
 	vc->phys_refnum[raid_disk] = dl->disk.refnum;
-	LBA_OFFSET(ddf, vc)[raid_disk] = __cpu_to_be64(pos);
+	LBA_OFFSET(ddf, vc)[raid_disk] = cpu_to_be64(pos);
 
 	for (i = 0; i < ddf->max_part ; i++)
 		if (dl->vlist[i] == NULL)
@@ -2727,13 +2727,13 @@ static int add_to_super_ddf(struct supertype *st,
 #define __calc_lba(new, old, lba, mb) do { \
 		unsigned long long dif; \
 		if ((old) != NULL) \
-			dif = (old)->size - __be64_to_cpu((old)->lba); \
+			dif = (old)->size - be64_to_cpu((old)->lba); \
 		else \
 			dif = (new)->size; \
 		if ((new)->size > dif) \
-			(new)->lba = __cpu_to_be64((new)->size - dif); \
+			(new)->lba = cpu_to_be64((new)->size - dif); \
 		else \
-			(new)->lba = __cpu_to_be64((new)->size - (mb*1024*2)); \
+			(new)->lba = cpu_to_be64((new)->size - (mb*1024*2)); \
 	} while (0)
 	__calc_lba(dd, ddf->dlist, workspace_lba, 32);
 	__calc_lba(dd, ddf->dlist, primary_lba, 16);
@@ -2816,11 +2816,11 @@ static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type)
 	switch (type) {
 	case DDF_HEADER_PRIMARY:
 		header = &ddf->primary;
-		sector = __be64_to_cpu(header->primary_lba);
+		sector = be64_to_cpu(header->primary_lba);
 		break;
 	case DDF_HEADER_SECONDARY:
 		header = &ddf->secondary;
-		sector = __be64_to_cpu(header->secondary_lba);
+		sector = be64_to_cpu(header->secondary_lba);
 		break;
 	default:
 		return 0;
@@ -2919,21 +2919,21 @@ static int _write_super_to_disk(struct ddf_super *ddf, struct dl *d)
 	 */
 	get_dev_size(fd, NULL, &size);
 	size /= 512;
-	if (d->workspace_lba != 0)
+	if (be64_to_cpu(d->workspace_lba) != 0ULL)
 		ddf->anchor.workspace_lba = d->workspace_lba;
 	else
 		ddf->anchor.workspace_lba =
-			__cpu_to_be64(size - 32*1024*2);
-	if (d->primary_lba != 0)
+			cpu_to_be64(size - 32*1024*2);
+	if (be64_to_cpu(d->primary_lba) != 0ULL)
 		ddf->anchor.primary_lba = d->primary_lba;
 	else
 		ddf->anchor.primary_lba =
-			__cpu_to_be64(size - 16*1024*2);
-	if (d->secondary_lba != 0)
+			cpu_to_be64(size - 16*1024*2);
+	if (be64_to_cpu(d->secondary_lba) != 0ULL)
 		ddf->anchor.secondary_lba = d->secondary_lba;
 	else
 		ddf->anchor.secondary_lba =
-			__cpu_to_be64(size - 32*1024*2);
+			cpu_to_be64(size - 32*1024*2);
 	ddf->anchor.seq = ddf->active->seq;
 	memcpy(&ddf->primary, &ddf->anchor, 512);
 	memcpy(&ddf->secondary, &ddf->anchor, 512);
@@ -3550,7 +3550,7 @@ static int check_secondary(const struct vcl *vc)
 			pr_err("Different strip sizes for BVDs are unsupported\n");
 			return -1;
 		}
-		if (bvd->array_blocks != conf->array_blocks) {
+		if (!be64_eq(bvd->array_blocks, conf->array_blocks)) {
 			pr_err("Different BVD sizes are unsupported\n");
 			return -1;
 		}
@@ -3673,7 +3673,7 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 				this->name[j] = 0;
 
 		memset(this->uuid, 0, sizeof(this->uuid));
-		this->component_size = __be64_to_cpu(vc->conf.blocks);
+		this->component_size = be64_to_cpu(vc->conf.blocks);
 		this->array.size = this->component_size / 2;
 		this->container_member = i;
 
@@ -3730,8 +3730,8 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 
 			dev->events = be32_to_cpu(ddf->primary.seq);
 			dev->data_offset =
-				__be64_to_cpu(LBA_OFFSET(ddf, bvd)[iphys]);
-			dev->component_size = __be64_to_cpu(bvd->blocks);
+				be64_to_cpu(LBA_OFFSET(ddf, bvd)[iphys]);
+			dev->component_size = be64_to_cpu(bvd->blocks);
 			if (d->devname)
 				strcpy(dev->name, d->devname);
 		}
@@ -4161,7 +4161,7 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 			pd = dl->pdnum; /* FIXME: is this really correct ? */
 			vc->phys_refnum[n_bvd] = dl->disk.refnum;
 			LBA_OFFSET(ddf, vc)[n_bvd] =
-				__cpu_to_be64(mdi->data_offset);
+				cpu_to_be64(mdi->data_offset);
 			ddf->phys->entries[pd].type &=
 				~__cpu_to_be16(DDF_Global_Spare);
 			ddf->phys->entries[pd].type |=
@@ -4821,7 +4821,7 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 		vc->phys_refnum[di->disk.raid_disk] =
 			ddf->phys->entries[dl->pdnum].refnum;
 		LBA_OFFSET(ddf, vc)[di->disk.raid_disk]
-			= __cpu_to_be64(di->data_offset);
+			= cpu_to_be64(di->data_offset);
 	}
 	*updates = mu;
 	return rv;
-- 
1.7.1
