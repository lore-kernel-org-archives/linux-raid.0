From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH] mdadm: allow build to use --size
Date: Wed, 11 Feb 2009 13:49:26 -0500
Message-ID: <49931DB6.2060302@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090004020008080108030507"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090004020008080108030507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch enables the --size parameter for build operations.

Without this, if you have a raid1, for instance, where the 2 disks are 
not the exact same size, and you need to build the array but one of the 
disks is not available right at the moment (maybe it's USB and it's 
unplugged, or maybe it's a network disk and it's unavailable), then you 
have to play some weird games to get the array to size correctly (that 
is, to the size of the smaller of the two components or less).

There may be other uses for this too...

--
Paul

--------------090004020008080108030507
Content-Type: text/x-diff;
 name="mdadm-build-size.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mdadm-build-size.diff"

diff --exclude-from=/export/public/clemep/tmp/dontdiff -purN mdadm-2.5.1/Build.c mdadm-2.5.1-patched/Build.c
--- mdadm-2.5.1/Build.c	2006-05-19 01:21:44.000000000 -0400
+++ mdadm-2.5.1-patched/Build.c	2009-02-09 16:25:52.000000000 -0500
@@ -36,7 +36,8 @@
 int Build(char *mddev, int mdfd, int chunk, int level, int layout,
 	  int raiddisks,
 	  mddev_dev_t devlist, int assume_clean,
-	  char *bitmap_file, int bitmap_chunk, int write_behind, int delay, int verbose)
+	  char *bitmap_file, int bitmap_chunk, int write_behind, int delay,
+	  int verbose, unsigned long long size)
 {
 	/* Build a linear or raid0 arrays without superblocks
 	 * We cannot really do any checks, we just do it.
@@ -57,7 +58,6 @@ int Build(char *mddev, int mdfd, int chu
 	int subdevs = 0, missing_disks = 0;
 	mddev_dev_t dv;
 	int bitmap_fd;
-	unsigned long long size = ~0ULL;
 	unsigned long long bitmapsize;
 
 	/* scan all devices, make sure they really are block devices */
@@ -119,7 +119,7 @@ int Build(char *mddev, int mdfd, int chu
 	if (vers >= 9000) {
 		mdu_array_info_t array;
 		array.level = level;
-		array.size = 0;
+		array.size = size;
 		array.nr_disks = raiddisks;
 		array.raid_disks = raiddisks;
 		array.md_minor = 0;
@@ -171,11 +171,11 @@ int Build(char *mddev, int mdfd, int chu
 		if (ioctl(fd, BLKGETSIZE, &dsize) == 0 && dsize > 0) {
 			unsigned long long ldsize = dsize;
 			ldsize <<= 9;
-			if (size== 0 || ldsize < size)
+			if (size == 0 || ldsize < size)
 				size = ldsize;
 		}
 		close(fd);
-		if (vers>= 9000) {
+		if (vers >= 9000) {
 			mdu_disk_info_t disk;
 			disk.number = i;
 			disk.raid_disk = i;
Binary files mdadm-2.5.1/mdadm and mdadm-2.5.1-patched/mdadm differ
diff --exclude-from=/export/public/clemep/tmp/dontdiff -purN mdadm-2.5.1/mdadm.c mdadm-2.5.1-patched/mdadm.c
--- mdadm-2.5.1/mdadm.c	2006-06-02 01:51:01.000000000 -0400
+++ mdadm-2.5.1-patched/mdadm.c	2009-02-09 16:24:48.000000000 -0500
@@ -344,7 +344,8 @@ int main(int argc, char *argv[])
 			continue;
 
 		case O(GROW,'z'):
-		case O(CREATE,'z'): /* size */
+		case O(CREATE,'z'):
+		case O(BUILD,'z'): /* size */
 			if (size >= 0) {
 				fprintf(stderr, Name ": size may only be specified once. "
 					"Second value is %s.\n", optarg);
@@ -1095,7 +1096,8 @@ int main(int argc, char *argv[])
 		}
 		rv = Build(devlist->devname, mdfd, chunk, level, layout,
 			   raiddisks, devlist->next, assume_clean,
-			   bitmap_file, bitmap_chunk, write_behind, delay, verbose-quiet);
+			   bitmap_file, bitmap_chunk, write_behind, delay,
+			   verbose-quiet, size);
 		break;
 	case CREATE:
 		if (delay == 0) delay = DEFAULT_BITMAP_DELAY;
diff --exclude-from=/export/public/clemep/tmp/dontdiff -purN mdadm-2.5.1/mdadm.h mdadm-2.5.1-patched/mdadm.h
--- mdadm-2.5.1/mdadm.h	2006-06-02 01:35:22.000000000 -0400
+++ mdadm-2.5.1-patched/mdadm.h	2009-02-09 16:26:18.000000000 -0500
@@ -382,7 +382,8 @@ extern int Assemble(struct supertype *st
 extern int Build(char *mddev, int mdfd, int chunk, int level, int layout,
 		 int raiddisks,
 		 mddev_dev_t devlist, int assume_clean,
-		 char *bitmap_file, int bitmap_chunk, int write_behind, int delay, int verbose);
+		 char *bitmap_file, int bitmap_chunk, int write_behind,
+		 int delay, int verbose, unsigned long long size);
 
 
 extern int Create(struct supertype *st, char *mddev, int mdfd,

--------------090004020008080108030507--
