From: mwilck@arcor.de
Subject: [PATCH 2/3] DDF: make "null_aligned" a static buffer
Date: Thu, 18 Jul 2013 20:49:00 +0200
Message-ID: <1374173341-9264-2-git-send-email-mwilck@arcor.de>
References: <20130715153141.4ac1cef9@notabene.brown>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130715153141.4ac1cef9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Use a static buffer for this "zero page". This makes it easier
to factor out the header writing code.
---
 super-ddf.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index e5007b9..efdba6d 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2756,14 +2756,21 @@ static int remove_from_super_ddf(struct supertype *st, mdu_disk_info_t *dk)
  */
 #define NULL_CONF_SZ	4096
 
-static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type,
-				 char *null_aligned)
+static char *null_aligned;
+static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type)
 {
 	unsigned long long sector;
 	struct ddf_header *header;
 	int fd, i, n_config, conf_size;
 	int ret = 0;
 
+	if (null_aligned == NULL) {
+		if (posix_memalign((void **)&null_aligned, 4096, NULL_CONF_SZ)
+		    != 0)
+			return 0;
+		memset(null_aligned, 0xff, NULL_CONF_SZ);
+	}
+
 	fd = d->fd;
 
 	switch (type) {
@@ -2864,14 +2871,9 @@ static int __write_init_super_ddf(struct supertype *st)
 	int attempts = 0;
 	int successes = 0;
 	unsigned long long size;
-	char *null_aligned;
 	__u32 seq;
 
 	pr_state(ddf, __func__);
-	if (posix_memalign((void**)&null_aligned, 4096, NULL_CONF_SZ) != 0) {
-		return -ENOMEM;
-	}
-	memset(null_aligned, 0xff, NULL_CONF_SZ);
 
 	seq = ddf->active->seq;
 
@@ -2916,12 +2918,10 @@ static int __write_init_super_ddf(struct supertype *st)
 		ddf->anchor.seq = 0xFFFFFFFF; /* no sequencing in anchor */
 		ddf->anchor.crc = calc_crc(&ddf->anchor, 512);
 
-		if (!__write_ddf_structure(d, ddf, DDF_HEADER_PRIMARY,
-					   null_aligned))
+		if (!__write_ddf_structure(d, ddf, DDF_HEADER_PRIMARY))
 			continue;
 
-		if (!__write_ddf_structure(d, ddf, DDF_HEADER_SECONDARY,
-					   null_aligned))
+		if (!__write_ddf_structure(d, ddf, DDF_HEADER_SECONDARY))
 			continue;
 
 		lseek64(fd, (size-1)*512, SEEK_SET);
@@ -2929,7 +2929,6 @@ static int __write_init_super_ddf(struct supertype *st)
 			continue;
 		successes++;
 	}
-	free(null_aligned);
 
 	return attempts != successes;
 }
-- 
1.7.1
