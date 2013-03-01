From: mwilck@arcor.de
Subject: [PATCH 03/12] DDF: increase seq number when writing meta data
Date: Fri,  1 Mar 2013 23:28:24 +0100
Message-ID: <1362176913-6804-4-git-send-email-mwilck@arcor.de>
References: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Cleanly increase the seq number when the DDF structures are
written, instead of always setting it back to 1.

Also, make sure that the sequential number of all headers and
VD conf records is the same.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 2f75fc3..e165927 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2377,6 +2377,7 @@ static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type,
 			c = (struct vcl *)d->spare;
 
 		if (c) {
+			c->conf.seqnum = ddf->primary.seq;
 			c->conf.crc = calc_crc(&c->conf, conf_size);
 			if (write(fd, &c->conf, conf_size) < 0)
 				break;
@@ -2409,12 +2410,20 @@ static int __write_init_super_ddf(struct supertype *st)
 	int successes = 0;
 	unsigned long long size;
 	char *null_aligned;
+	__u32 seq;
 
 	if (posix_memalign((void**)&null_aligned, 4096, NULL_CONF_SZ) != 0) {
 		return -ENOMEM;
 	}
 	memset(null_aligned, 0xff, NULL_CONF_SZ);
 
+	if (ddf->primary.seq != 0xffffffff)
+		seq = __cpu_to_be32(__be32_to_cpu(ddf->primary.seq)+1);
+	else if (ddf->secondary.seq != 0xffffffff)
+		seq = __cpu_to_be32(__be32_to_cpu(ddf->secondary.seq)+1);
+	else
+		seq = __cpu_to_be32(1);
+
 	/* try to write updated metadata,
 	 * if we catch a failure move on to the next disk
 	 */
@@ -2448,12 +2457,12 @@ static int __write_init_super_ddf(struct supertype *st)
 		else
 			ddf->anchor.secondary_lba =
 				__cpu_to_be64(size - 32*1024*2);
-		ddf->anchor.seq = __cpu_to_be32(1);
 		memcpy(&ddf->primary, &ddf->anchor, 512);
 		memcpy(&ddf->secondary, &ddf->anchor, 512);
 
 		ddf->anchor.openflag = 0xFF; /* 'open' means nothing */
 		ddf->anchor.seq = 0xFFFFFFFF; /* no sequencing in anchor */
+		ddf->secondary.seq = ddf->primary.seq = seq;
 		ddf->anchor.crc = calc_crc(&ddf->anchor, 512);
 
 		if (!__write_ddf_structure(d, ddf, DDF_HEADER_PRIMARY,
-- 
1.7.3.4
