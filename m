From: mwilck@arcor.de
Subject: [PATCH 3/3] DDF: factor out writing super block to single disk
Date: Thu, 18 Jul 2013 20:49:01 +0200
Message-ID: <1374173341-9264-3-git-send-email-mwilck@arcor.de>
References: <20130715153141.4ac1cef9@notabene.brown>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130715153141.4ac1cef9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Factor out single disk from __write_init_super_ddf to a new function
_write_super_to_disk. Use this function in store_super_ddf.
---
 super-ddf.c |  112 ++++++++++++++++++++++++++++-------------------------------
 1 files changed, 53 insertions(+), 59 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index efdba6d..8c6fa6d 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2864,70 +2864,72 @@ out:
 	return ret;
 }
 
+static int _write_super_to_disk(struct ddf_super *ddf, struct dl *d)
+{
+	unsigned long long size;
+	int fd = d->fd;
+	if (fd < 0)
+		return 0;
+
+	/* We need to fill in the primary, (secondary) and workspace
+	 * lba's in the headers, set their checksums,
+	 * Also checksum phys, virt....
+	 *
+	 * Then write everything out, finally the anchor is written.
+	 */
+	get_dev_size(fd, NULL, &size);
+	size /= 512;
+	if (d->workspace_lba != 0)
+		ddf->anchor.workspace_lba = d->workspace_lba;
+	else
+		ddf->anchor.workspace_lba =
+			__cpu_to_be64(size - 32*1024*2);
+	if (d->primary_lba != 0)
+		ddf->anchor.primary_lba = d->primary_lba;
+	else
+		ddf->anchor.primary_lba =
+			__cpu_to_be64(size - 16*1024*2);
+	if (d->secondary_lba != 0)
+		ddf->anchor.secondary_lba = d->secondary_lba;
+	else
+		ddf->anchor.secondary_lba =
+			__cpu_to_be64(size - 32*1024*2);
+	ddf->anchor.seq = ddf->active->seq;
+	memcpy(&ddf->primary, &ddf->anchor, 512);
+	memcpy(&ddf->secondary, &ddf->anchor, 512);
+
+	ddf->anchor.openflag = 0xFF; /* 'open' means nothing */
+	ddf->anchor.seq = 0xFFFFFFFF; /* no sequencing in anchor */
+	ddf->anchor.crc = calc_crc(&ddf->anchor, 512);
+
+	if (!__write_ddf_structure(d, ddf, DDF_HEADER_PRIMARY))
+		return 0;
+
+	if (!__write_ddf_structure(d, ddf, DDF_HEADER_SECONDARY))
+		return 0;
+
+	lseek64(fd, (size-1)*512, SEEK_SET);
+	if (write(fd, &ddf->anchor, 512) < 0)
+		return 0;
+
+	return 1;
+}
+
 static int __write_init_super_ddf(struct supertype *st)
 {
 	struct ddf_super *ddf = st->sb;
 	struct dl *d;
 	int attempts = 0;
 	int successes = 0;
-	unsigned long long size;
-	__u32 seq;
 
 	pr_state(ddf, __func__);
 
-	seq = ddf->active->seq;
-
 	/* try to write updated metadata,
 	 * if we catch a failure move on to the next disk
 	 */
 	for (d = ddf->dlist; d; d=d->next) {
-		int fd = d->fd;
-
-		if (fd < 0)
-			continue;
-
 		attempts++;
-		/* We need to fill in the primary, (secondary) and workspace
-		 * lba's in the headers, set their checksums,
-		 * Also checksum phys, virt....
-		 *
-		 * Then write everything out, finally the anchor is written.
-		 */
-		get_dev_size(fd, NULL, &size);
-		size /= 512;
-		if (d->workspace_lba != 0)
-			ddf->anchor.workspace_lba = d->workspace_lba;
-		else
-			ddf->anchor.workspace_lba =
-				__cpu_to_be64(size - 32*1024*2);
-		if (d->primary_lba != 0)
-			ddf->anchor.primary_lba = d->primary_lba;
-		else
-			ddf->anchor.primary_lba =
-				__cpu_to_be64(size - 16*1024*2);
-		if (d->secondary_lba != 0)
-			ddf->anchor.secondary_lba = d->secondary_lba;
-		else
-			ddf->anchor.secondary_lba =
-				__cpu_to_be64(size - 32*1024*2);
-		ddf->anchor.seq = seq;
-		memcpy(&ddf->primary, &ddf->anchor, 512);
-		memcpy(&ddf->secondary, &ddf->anchor, 512);
-
-		ddf->anchor.openflag = 0xFF; /* 'open' means nothing */
-		ddf->anchor.seq = 0xFFFFFFFF; /* no sequencing in anchor */
-		ddf->anchor.crc = calc_crc(&ddf->anchor, 512);
-
-		if (!__write_ddf_structure(d, ddf, DDF_HEADER_PRIMARY))
-			continue;
-
-		if (!__write_ddf_structure(d, ddf, DDF_HEADER_SECONDARY))
-			continue;
-
-		lseek64(fd, (size-1)*512, SEEK_SET);
-		if (write(fd, &ddf->anchor, 512) < 0)
-			continue;
-		successes++;
+		successes += _write_super_to_disk(ddf, d);
 	}
 
 	return attempts != successes;
@@ -3729,17 +3731,9 @@ static int store_super_ddf(struct supertype *st, int fd)
 			       (int)minor(sta.st_rdev));
 			return 1;
 		}
-		/*
-		   For DDF, writing to just one disk makes no sense.
-		   We would run the risk of writing inconsistent meta data
-		   to the devices. So just call __write_init_super_ddf and
-		   write to all devices, including this one.
-		   Use the fd passed to this function, just in case dl->fd
-		   is invalid.
-		 */
 		ofd = dl->fd;
 		dl->fd = fd;
-		ret =  __write_init_super_ddf(st);
+		ret = (_write_super_to_disk(ddf, dl) != 1);
 		dl->fd = ofd;
 		return ret;
 	}
-- 
1.7.1
