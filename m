From: Jes.Sorensen@redhat.com
Subject: [PATCH 06/11] Use struct align_fd to cache fd's block size for aligned reads/writes
Date: Tue, 20 Mar 2012 17:54:11 +0100
Message-ID: <1332262456-5109-7-git-send-email-Jes.Sorensen@redhat.com>
References: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This uses a struct to cache the block size for aligned reads/writes,
to avoid repeated ioctl(BLKSSZGET) calls.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super1.c |   75 ++++++++++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/super1.c b/super1.c
index 513f406..350e27a 100644
--- a/super1.c
+++ b/super1.c
@@ -137,8 +137,25 @@ static unsigned int calc_sb_1_csum(struct mdp_superblock_1 * sb)
 	return __cpu_to_le32(csum);
 }
 
+/*
+ * Information related to file descriptor used for aligned reads/writes.
+ * Cache the block size.
+ */
+struct align_fd {
+	int fd;
+	int blk_sz;
+};
+
+static void init_afd(struct align_fd *afd, int fd)
+{
+	afd->fd = fd;
+
+	if (ioctl(afd->fd, BLKSSZGET, &afd->blk_sz) != 0)
+		afd->blk_sz = 512;
+}
+
 static char abuf[4096+4096];
-static int aread(int fd, void *buf, int len)
+static int aread(struct align_fd *afd, void *buf, int len)
 {
 	/* aligned read.
 	 * On devices with a 4K sector size, we need to read
@@ -148,26 +165,30 @@ static int aread(int fd, void *buf, int len)
 	int bsize, iosize;
 	char *b;
 	int n;
-	if (ioctl(fd, BLKSSZGET, &bsize) != 0)
-		bsize = 512;
 
-	if (bsize > 4096 || len > 4096)
+	bsize = afd->blk_sz;
+
+	if (!bsize || bsize > 4096 || len > 4096) {
+		if (!bsize)
+			fprintf(stderr, "WARNING - aread() called with "
+				"invalid block size\n");
 		return -1;
+	}
 	b = (char*)(((long)(abuf+4096))&~4095UL);
 
 	for (iosize = 0; iosize < len; iosize += bsize)
 		;
-	n = read(fd, b, iosize);
+	n = read(afd->fd, b, iosize);
 	if (n <= 0)
 		return n;
-	lseek(fd, len - n, 1);
+	lseek(afd->fd, len - n, 1);
 	if (n > len)
 		n = len;
 	memcpy(buf, b, n);
 	return n;
 }
 
-static int awrite(int fd, void *buf, int len)
+static int awrite(struct align_fd *afd, void *buf, int len)
 {
 	/* aligned write.
 	 * On devices with a 4K sector size, we need to write
@@ -178,27 +199,31 @@ static int awrite(int fd, void *buf, int len)
 	int bsize, iosize;
 	char *b;
 	int n;
-	if (ioctl(fd, BLKSSZGET, &bsize) != 0)
-		bsize = 512;
-	if (bsize > 4096 || len > 4096)
+
+	bsize = afd->blk_sz;
+	if (!bsize || bsize > 4096 || len > 4096) {
+		if (!bsize)
+			fprintf(stderr, "WARNING - awrite() called with "
+				"invalid block size\n");
 		return -1;
+	}
 	b = (char*)(((long)(abuf+4096))&~4095UL);
 
 	for (iosize = 0; iosize < len ; iosize += bsize)
 		;
 
 	if (len != iosize) {
-		n = read(fd, b, iosize);
+		n = read(afd->fd, b, iosize);
 		if (n <= 0)
 			return n;
-		lseek(fd, -n, 1);
+		lseek(afd->fd, -n, 1);
 	}
 
 	memcpy(b, buf, len);
-	n = write(fd, b, iosize);
+	n = write(afd->fd, b, iosize);
 	if (n <= 0)
 		return n;
-	lseek(fd, len - n, 1);
+	lseek(afd->fd, len - n, 1);
 	return len;
 }
 
@@ -962,6 +987,7 @@ static int store_super1(struct supertype *st, int fd)
 {
 	struct mdp_superblock_1 *sb = st->sb;
 	unsigned long long sb_offset;
+	struct align_fd afd;
 	int sbsize;
 	unsigned long long dsize;
 
@@ -973,6 +999,8 @@ static int store_super1(struct supertype *st, int fd)
 	if (dsize < 24)
 		return 2;
 
+	init_afd(&afd, fd);
+
 	/*
 	 * Calculate the position of the superblock.
 	 * It is always aligned to a 4K boundary and
@@ -1012,7 +1040,7 @@ static int store_super1(struct supertype *st, int fd)
 	sbsize = sizeof(*sb) + 2 * __le32_to_cpu(sb->max_dev);
 	sbsize = (sbsize+511)&(~511UL);
 
-	if (awrite(fd, sb, sbsize) != sbsize)
+	if (awrite(&afd, sb, sbsize) != sbsize)
 		return 4;
 
 	if (sb->feature_map & __cpu_to_le32(MD_FEATURE_BITMAP_OFFSET)) {
@@ -1020,9 +1048,8 @@ static int store_super1(struct supertype *st, int fd)
 			(((char*)sb)+1024);
 		if (__le32_to_cpu(bm->magic) == BITMAP_MAGIC) {
 			locate_bitmap1(st, fd);
-			if (awrite(fd, bm, sizeof(*bm)) !=
-			    sizeof(*bm))
-			    return 5;
+			if (awrite(&afd, bm, sizeof(*bm)) != sizeof(*bm))
+				return 5;
 		}
 	}
 	fsync(fd);
@@ -1250,9 +1277,12 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 	int uuid[4];
 	struct bitmap_super_s *bsb;
 	struct misc_dev_info *misc;
+	struct align_fd afd;
 
 	free_super1(st);
 
+	init_afd(&afd, fd);
+
 	if (st->ss == NULL || st->minor_version == -1) {
 		int bestvers = -1;
 		struct supertype tst;
@@ -1338,7 +1368,7 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 		return 1;
 	}
 
-	if (aread(fd, super, 1024) != 1024) {
+	if (aread(&afd, super, 1024) != 1024) {
 		if (devname)
 			fprintf(stderr, Name ": Cannot read superblock on %s\n",
 				devname);
@@ -1383,7 +1413,7 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 	 * should get that written out.
 	 */
 	locate_bitmap1(st, fd);
-	if (aread(fd, bsb, 512) != 512)
+	if (aread(&afd, bsb, 512) != 512)
 		goto no_bitmap;
 
 	uuid_from_super1(st, uuid);
@@ -1643,6 +1673,9 @@ static int write_bitmap1(struct supertype *st, int fd)
 	int rv = 0;
 	void *buf;
 	int towrite, n;
+	struct align_fd afd;
+
+	init_afd(&afd, fd);
 
 	locate_bitmap1(st, fd);
 
@@ -1660,7 +1693,7 @@ static int write_bitmap1(struct supertype *st, int fd)
 		n = towrite;
 		if (n > 4096)
 			n = 4096;
-		n = awrite(fd, buf, n);
+		n = awrite(&afd, buf, n);
 		if (n > 0)
 			towrite -= n;
 		else
-- 
1.7.7.6

