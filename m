From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V3 01/11] Create n bitmaps for clustered mode
Date: Wed, 20 May 2015 11:20:33 +0800
Message-ID: <1432092043-24220-2-git-send-email-gqjiang@suse.com>
References: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

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
 bitmap.c   |  2 ++
 bitmap.h   |  7 +++++--
 mdadm.8.in |  7 ++++++-
 super1.c   | 53 ++++++++++++++++++++++++++++++++++-------------------
 5 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/Create.c b/Create.c
index ef28da0..69f5432 100644
--- a/Create.c
+++ b/Create.c
@@ -750,7 +750,8 @@ int Create(struct supertype *st, char *mddev,
 #endif
 	}
 
-	if (s->bitmap_file && strcmp(s->bitmap_file, "internal")==0) {
+	if (s->bitmap_file && (strcmp(s->bitmap_file, "internal")==0
+			|| strcmp(s->bitmap_file, "clustered")==0)) {
 		if ((vers%100) < 2) {
 			pr_err("internal bitmaps not supported by this kernel.\n");
 			goto abort_locked;
diff --git a/bitmap.c b/bitmap.c
index b1d54a6..920033a 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -32,6 +32,8 @@ inline void sb_le_to_cpu(bitmap_super_t *sb)
 	sb->daemon_sleep = __le32_to_cpu(sb->daemon_sleep);
 	sb->sync_size = __le64_to_cpu(sb->sync_size);
 	sb->write_behind = __le32_to_cpu(sb->write_behind);
+	sb->nodes = __le32_to_cpu(sb->nodes);
+	sb->sectors_reserved = __le32_to_cpu(sb->sectors_reserved);
 }
 
 inline void sb_cpu_to_le(bitmap_super_t *sb)
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
index a630310..4aec0db 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -694,7 +694,12 @@ and so is replicated on all devices.  If the word
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
diff --git a/super1.c b/super1.c
index f0508fe..7928a3d 100644
--- a/super1.c
+++ b/super1.c
@@ -2177,6 +2177,7 @@ static int write_bitmap1(struct supertype *st, int fd)
 	void *buf;
 	int towrite, n;
 	struct align_fd afd;
+	unsigned int i = 0;
 
 	init_afd(&afd, fd);
 
@@ -2185,27 +2186,41 @@ static int write_bitmap1(struct supertype *st, int fd)
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
+	do {
+		/* Only the bitmap[0] should resync
+		 * whole device on initial assembly
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
-	}
-	fsync(fd);
-	if (towrite)
-		rv = -2;
+		}
+	} while (++i < __le32_to_cpu(bms->nodes));
 
 	free(buf);
 	return rv;
-- 
1.7.12.4

