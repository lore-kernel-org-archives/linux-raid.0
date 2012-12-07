From: mwilck@arcor.de
Subject: [PATCH 1/3] DDF: cleanly save the secondary DDF structure
Date: Fri,  7 Dec 2012 23:38:59 +0100
Message-ID: <1354919941-12070-2-git-send-email-mwilck@arcor.de>
References: <1354919941-12070-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1354919941-12070-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

From: Martin Wilck <mwilck@arcor.de>

So far, mdadm only saved the header of the secondary structure.
With this patch, the full secondary DDF structure is saved
consistently
---
 super-ddf.c |  136 +++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 77 insertions(+), 59 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 3b3c1f0..c336db4 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2317,17 +2317,86 @@ static int remove_from_super_ddf(struct supertype *st, mdu_disk_info_t *dk)
  */
 #define NULL_CONF_SZ	4096
 
-static int __write_init_super_ddf(struct supertype *st)
+static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type, char *null_aligned)
 {
+	unsigned long long sector;
+	struct ddf_header *header;
+	int fd, i, n_config, conf_size;
+
+	fd = d->fd;
+	
+	switch (type) {
+	case DDF_HEADER_PRIMARY:
+		header = &ddf->primary;
+		sector = __be64_to_cpu(header->primary_lba);
+		break;
+	case DDF_HEADER_SECONDARY:
+		header = &ddf->secondary;
+		sector = __be64_to_cpu(header->secondary_lba);
+		break;
+	default:
+		return 0;
+	}
+
+	header->type = type;
+	header->openflag = 0;
+	header->crc = calc_crc(header, 512);
+		
+	lseek64(fd, sector<<9, 0);
+	if (write(fd, header, 512) < 0)
+		return 0;
+
+	ddf->controller.crc = calc_crc(&ddf->controller, 512);
+	if (write(fd, &ddf->controller, 512) < 0)
+		return 0;
+
+	ddf->phys->crc = calc_crc(ddf->phys, ddf->pdsize);
+	if (write(fd, ddf->phys, ddf->pdsize) < 0)
+		return 0;
+	ddf->virt->crc = calc_crc(ddf->virt, ddf->vdsize);
+	if (write(fd, ddf->virt, ddf->vdsize) < 0)
+		return 0;
+
+	/* Now write lots of config records. */
+	n_config = ddf->max_part;
+	conf_size = ddf->conf_rec_len * 512;
+	for (i = 0 ; i <= n_config ; i++) {
+		struct vcl *c = d->vlist[i];
+		if (i == n_config)
+			c = (struct vcl*)d->spare;
+
+		if (c) {
+			c->conf.crc = calc_crc(&c->conf, conf_size);
+			if (write(fd, &c->conf, conf_size) < 0)
+				break;
+		} else {
+			unsigned int togo = conf_size;
+			while (togo > NULL_CONF_SZ) {
+				if (write(fd, null_aligned, NULL_CONF_SZ) < 0)
+					break;
+				togo -= NULL_CONF_SZ;
+			}
+			if (write(fd, null_aligned, togo) < 0)
+				break;
+		}
+	}
+	if (i <= n_config)
+		return 0;
+
+	d->disk.crc = calc_crc(&d->disk, 512);
+	if (write(fd, &d->disk, 512) < 0)
+		return 0;
 
+	return 1;
+}
+
+static int __write_init_super_ddf(struct supertype *st)
+{
 	struct ddf_super *ddf = st->sb;
-	int i;
 	struct dl *d;
-	int n_config;
-	int conf_size;
 	int attempts = 0;
 	int successes = 0;
-	unsigned long long size, sector;
+	unsigned long long size;
 	char *null_aligned;
 
 	if (posix_memalign((void**)&null_aligned, 4096, NULL_CONF_SZ) != 0) {
@@ -2355,6 +2424,7 @@ static int __write_init_super_ddf(struct supertype *st)
 		size /= 512;
 		ddf->anchor.workspace_lba = __cpu_to_be64(size - 32*1024*2);
 		ddf->anchor.primary_lba = __cpu_to_be64(size - 16*1024*2);
+		ddf->anchor.secondary_lba = __cpu_to_be64(size - 31*1024*2);
 		ddf->anchor.seq = __cpu_to_be32(1);
 		memcpy(&ddf->primary, &ddf->anchor, 512);
 		memcpy(&ddf->secondary, &ddf->anchor, 512);
@@ -2363,64 +2433,12 @@ static int __write_init_super_ddf(struct supertype *st)
 		ddf->anchor.seq = 0xFFFFFFFF; /* no sequencing in anchor */
 		ddf->anchor.crc = calc_crc(&ddf->anchor, 512);
 
-		ddf->primary.openflag = 0;
-		ddf->primary.type = DDF_HEADER_PRIMARY;
-
-		ddf->secondary.openflag = 0;
-		ddf->secondary.type = DDF_HEADER_SECONDARY;
-
-		ddf->primary.crc = calc_crc(&ddf->primary, 512);
-		ddf->secondary.crc = calc_crc(&ddf->secondary, 512);
-
-		sector = size - 16*1024*2;
-		lseek64(fd, sector<<9, 0);
-		if (write(fd, &ddf->primary, 512) < 0)
+		if (!__write_ddf_structure(d, ddf, DDF_HEADER_PRIMARY, null_aligned))
 			continue;
 
-		ddf->controller.crc = calc_crc(&ddf->controller, 512);
-		if (write(fd, &ddf->controller, 512) < 0)
-			continue;
-
-		ddf->phys->crc = calc_crc(ddf->phys, ddf->pdsize);
-
-		if (write(fd, ddf->phys, ddf->pdsize) < 0)
+		if (!__write_ddf_structure(d, ddf, DDF_HEADER_SECONDARY, null_aligned))
 			continue;
 
-		ddf->virt->crc = calc_crc(ddf->virt, ddf->vdsize);
-		if (write(fd, ddf->virt, ddf->vdsize) < 0)
-			continue;
-
-		/* Now write lots of config records. */
-		n_config = ddf->max_part;
-		conf_size = ddf->conf_rec_len * 512;
-		for (i = 0 ; i <= n_config ; i++) {
-			struct vcl *c = d->vlist[i];
-			if (i == n_config)
-				c = (struct vcl*)d->spare;
-
-			if (c) {
-				c->conf.crc = calc_crc(&c->conf, conf_size);
-				if (write(fd, &c->conf, conf_size) < 0)
-					break;
-			} else {
-				unsigned int togo = conf_size;
-				while (togo > NULL_CONF_SZ) {
-					if (write(fd, null_aligned, NULL_CONF_SZ) < 0)
-						break;
-					togo -= NULL_CONF_SZ;
-				}
-				if (write(fd, null_aligned, togo) < 0)
-					break;
-			}
-		}
-		if (i <= n_config)
-			continue;
-		d->disk.crc = calc_crc(&d->disk, 512);
-		if (write(fd, &d->disk, 512) < 0)
-			continue;
-
-		/* Maybe do the same for secondary */
-
 		lseek64(fd, (size-1)*512, SEEK_SET);
 		if (write(fd, &ddf->anchor, 512) < 0)
 			continue;
-- 
1.7.1
