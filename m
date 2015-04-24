From: gqjiang@suse.com
Subject: [PATCH 03/10] Create n bitmaps for clustered mode
Date: Fri, 24 Apr 2015 15:30:34 +0800
Message-ID: <1429860641-5839-4-git-send-email-gqjiang@suse.com>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

For a clustered MD, create bitmaps equal to number of nodes so
each node has an independent bitmap.

Only the first bitmap is has the bits set so that the first node
that assembles the device also performs the sync.

The bitmaps are aligned to 4k boundaries.

On-disk format:

0                    4k                     8k                    12k
-------------------------------------------------------------------
| idle                | md super            | bm super [0] + bits |
| bm bits[0, contd]   | bm super[1] + bits  | bm bits[1, contd]   |
| bm super[2] + bits  | bm bits [2, contd]  | bm super[3] + bits  |
| bm bits [3, contd]  |                     |                     |

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Create.c   |  3 ++-
 bitmap.h   |  7 +++++--
 mdadm.8.in |  7 ++++++-
 mdadm.c    | 17 ++++++++++++++++-
 super1.c   | 59 +++++++++++++++++++++++++++++++++++++++++------------------
 5 files changed, 70 insertions(+), 23 deletions(-)

diff --git a/Create.c b/Create.c
index cd5485b..9663dc4 100644
--- a/Create.c
+++ b/Create.c
@@ -752,7 +752,8 @@ int Create(struct supertype *st, char *mddev,
 #endif
 	}
 
-	if (s->bitmap_file && strcmp(s->bitmap_file, "internal")==0) {
+	if (s->bitmap_file && (strcmp(s->bitmap_file, "internal")==0
+			|| strcmp(s->bitmap_file, "clustered")==0)) {
 		if ((vers%100) < 2) {
 			pr_err("internal bitmaps not supported by this kernel.\n");
 			goto abort_locked;
diff --git a/bitmap.h b/bitmap.h
index c8725a3..adbf0b4 100644
--- a/bitmap.h
+++ b/bitmap.h
@@ -154,8 +154,11 @@ typedef struct bitmap_super_s {
 	__u32 chunksize;    /* 52  the bitmap chunk size in bytes */
 	__u32 daemon_sleep; /* 56  seconds between disk flushes */
 	__u32 write_behind; /* 60  number of outstanding write-behind writes */
-
-	__u8  pad[256 - 64]; /* set to zero */
+	__u32 sectors_reserved; /* 64 number of 512-byte sectors that are
+				 * reserved for the bitmap. */
+	__u32 nodes;        /* 68 the maximum number of nodes in cluster. */
+	__u8 cluster_name[64]; /* 72 cluster name to which this md belongs */
+	__u8  pad[256 - 136]; /* set to zero */
 } bitmap_super_t;
 
 /* notes:
diff --git a/mdadm.8.in b/mdadm.8.in
index a0e8288..c015cbf 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -700,7 +700,12 @@ and so is replicated on all devices.  If the word
 .B "none"
 is given with
 .B \-\-grow
-mode, then any bitmap that is present is removed.
+mode, then any bitmap that is present is removed. If the word
+.B "clustered"
+is given, the array is created for a clustered environment. One bitmap
+is created for each node as defined by the
+.B \-\-nodes
+parameter and are stored internally.
 
 To help catch typing errors, the filename must contain at least one
 slash ('/') if it is a real file (not 'internal' or 'none').
diff --git a/mdadm.c b/mdadm.c
index e4f8568..6963a09 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1111,6 +1111,15 @@ int main(int argc, char *argv[])
 				s.bitmap_file = optarg;
 				continue;
 			}
+			if (strcmp(optarg, "clustered")== 0) {
+				s.bitmap_file = optarg;
+				/* Set the default number of cluster nodes
+				 * to 4 if not already set by user
+				 */
+				if (c.nodes < 1)
+					c.nodes = 4;
+				continue;
+			}
 			/* probable typo */
 			pr_err("bitmap file must contain a '/', or be 'internal', or 'none'\n"
 				"       not '%s'\n", optarg);
@@ -1404,7 +1413,13 @@ int main(int argc, char *argv[])
 		if (c.delay == 0)
 			c.delay = DEFAULT_BITMAP_DELAY;
 
-		if (!strncmp(s.bitmap_file, "internal", 9) ||
+		if (!strncmp(s.bitmap_file, "clustered", 9)) {
+			if (s.level != 1) {
+				pr_err("--bitmap=clustered is currently supported with RAID mirror only\n");
+				rv = 1;
+				break;
+			}
+		} else if (!strncmp(s.bitmap_file, "internal", 9) ||
 			!strncmp(s.bitmap_file,"none", 4)) {
 			if (c.nodes) {
 				pr_err("--nodes argument is incompatible with --bitmap=%s.\n",
diff --git a/super1.c b/super1.c
index f0508fe..ac1b011 100644
--- a/super1.c
+++ b/super1.c
@@ -2144,6 +2144,10 @@ add_internal_bitmap1(struct supertype *st,
 	bms->daemon_sleep = __cpu_to_le32(delay);
 	bms->sync_size = __cpu_to_le64(size);
 	bms->write_behind = __cpu_to_le32(write_behind);
+	bms->nodes = __cpu_to_le32(st->nodes);
+	if (st->cluster_name)
+		strncpy((char *)bms->cluster_name,
+				st->cluster_name, strlen(st->cluster_name));
 
 	*chunkp = chunk;
 	return 1;
@@ -2177,6 +2181,7 @@ static int write_bitmap1(struct supertype *st, int fd)
 	void *buf;
 	int towrite, n;
 	struct align_fd afd;
+	unsigned int i;
 
 	init_afd(&afd, fd);
 
@@ -2185,27 +2190,45 @@ static int write_bitmap1(struct supertype *st, int fd)
 	if (posix_memalign(&buf, 4096, 4096))
 		return -ENOMEM;
 
-	memset(buf, 0xff, 4096);
-	memcpy(buf, (char *)bms, sizeof(bitmap_super_t));
-
-	towrite = __le64_to_cpu(bms->sync_size) / (__le32_to_cpu(bms->chunksize)>>9);
-	towrite = (towrite+7) >> 3; /* bits to bytes */
-	towrite += sizeof(bitmap_super_t);
-	towrite = ROUND_UP(towrite, 512);
-	while (towrite > 0) {
-		n = towrite;
-		if (n > 4096)
-			n = 4096;
-		n = awrite(&afd, buf, n);
-		if (n > 0)
-			towrite -= n;
+	/* We use bms->nodes as opposed to st->nodes to
+	 * be compatible with write-after-reads such as
+	 * the GROW operation.
+	 */
+	for (i = 0; i < __le32_to_cpu(bms->nodes); i++) {
+		/* Only the first bitmap should resync
+		 * the whole device
+		 */
+		if (i)
+			memset(buf, 0x00, 4096);
 		else
+			memset(buf, 0xff, 4096);
+		memcpy(buf, (char *)bms, sizeof(bitmap_super_t));
+
+		towrite = __le64_to_cpu(bms->sync_size) / (__le32_to_cpu(bms->chunksize)>>9);
+		towrite = (towrite+7) >> 3; /* bits to bytes */
+		towrite += sizeof(bitmap_super_t);
+		/* we need the bitmaps to be at 4k boundary */
+		towrite = ROUND_UP(towrite, 4096);
+		while (towrite > 0) {
+			n = towrite;
+			if (n > 4096)
+				n = 4096;
+			n = awrite(&afd, buf, n);
+			if (n > 0)
+				towrite -= n;
+			else
+				break;
+			if (i)
+				memset(buf, 0x00, 4096);
+			else
+				memset(buf, 0xff, 4096);
+		}
+		fsync(fd);
+		if (towrite) {
+			rv = -2;
 			break;
-		memset(buf, 0xff, 4096);
+		}
 	}
-	fsync(fd);
-	if (towrite)
-		rv = -2;
 
 	free(buf);
 	return rv;
-- 
1.7.12.4

