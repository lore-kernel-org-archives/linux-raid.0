From: Jes.Sorensen@redhat.com
Subject: [PATCH] Use posix_memalign() for memory used to write bitmaps
Date: Tue, 14 Feb 2012 11:52:13 +0100
Message-ID: <1329216733-7081-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: alexandermurashkin@msn.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This makes super[01].c properly align buffers used for the bitmap
using posix_memalign() to make sure the writes don't fail in case the
bitmap is opened using O_DIRECT.

This is based on https://bugzilla.redhat.com/show_bug.cgi?id=789898
and an initial patch by Alexander Murashkin.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super0.c |    8 +++++---
 super1.c |    7 +++++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/super0.c b/super0.c
index dab85db..d53f025 100644
--- a/super0.c
+++ b/super0.c
@@ -1065,13 +1065,11 @@ static int write_bitmap0(struct supertype *st, int fd)
 	int rv = 0;
 
 	int towrite, n;
-	char abuf[4096+4096];
-	char *buf = (char*)(((long)(abuf+4096))&~4095L);
+	void *buf;
 
 	if (!get_dev_size(fd, NULL, &dsize))
 		return 1;
 
-
 	if (dsize < MD_RESERVED_SECTORS*512)
 		return -1;
 
@@ -1082,6 +1080,9 @@ static int write_bitmap0(struct supertype *st, int fd)
 	if (lseek64(fd, offset + 4096, 0)< 0LL)
 		return 3;
 
+	if (posix_memalign(&buf, 4096, 4096))
+		return -ENOMEM;
+
 	memset(buf, 0xff, 4096);
 	memcpy(buf,  ((char*)sb)+MD_SB_BYTES, sizeof(bitmap_super_t));
 	towrite = 60*1024;
@@ -1100,6 +1101,7 @@ static int write_bitmap0(struct supertype *st, int fd)
 	if (towrite)
 		rv = -2;
 
+	free(buf);
 	return rv;
 }
 
diff --git a/super1.c b/super1.c
index cfa237a..a18952a 100644
--- a/super1.c
+++ b/super1.c
@@ -1641,12 +1641,14 @@ static int write_bitmap1(struct supertype *st, int fd)
 	struct mdp_superblock_1 *sb = st->sb;
 	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb)+1024);
 	int rv = 0;
-
+	void *buf;
 	int towrite, n;
-	char buf[4096];
 
 	locate_bitmap1(st, fd);
 
+	if (posix_memalign(&buf, 4096, 4096))
+		return -ENOMEM;
+
 	memset(buf, 0xff, 4096);
 	memcpy(buf, ((char*)sb)+1024, sizeof(bitmap_super_t));
 
@@ -1669,6 +1671,7 @@ static int write_bitmap1(struct supertype *st, int fd)
 	if (towrite)
 		rv = -2;
 
+	free(buf);
 	return rv;
 }
 
-- 
1.7.4.4

