From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH 3/3] mdadm: bitmap async writes
Date: Thu, 17 Mar 2005 15:56:37 -0500
Message-ID: <4239EF05.5010901@steeleye.com>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <4239EDCA.4030502@steeleye.com> <4239EE55.7040804@steeleye.com> <4239EEB5.7020901@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050007030603070904080303"
In-Reply-To: <4239EEB5.7020901@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------050007030603070904080303
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch provides the write-mostly updates and async write capability 
for mdadm.

--------------050007030603070904080303
Content-Type: text/plain;
 name="mdadm_2_0_devel_1_async.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mdadm_2_0_devel_1_async.diff"


Signed-Off-By: Paul Clements <paul.clements@steeleye.com>

 Build.c  |    4 ++--
 Create.c |   13 +++++++++----
 Detail.c |    3 +++
 ReadMe.c |    2 ++
 bitmap.c |    8 ++++++++
 bitmap.h |   14 +++++++++++---
 md_p.h   |    5 +++++
 mdadm.8  |    7 +++++++
 mdadm.c  |   31 ++++++++++++++++++++++++++++---
 mdadm.h  |    6 ++++--
 super0.c |    8 +++++++-
 super1.c |    4 +++-
 12 files changed, 89 insertions(+), 16 deletions(-)
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff --exclude rpm --exclude mdadm.steeleye.spec --exclude *.KERNEL --exclude *.DIST mdadm-2.0-devel-1-bitmap-bug-fix/Build.c mdadm-2.0-devel-1-async-writes/Build.c
--- mdadm-2.0-devel-1-bitmap-bug-fix/Build.c	Sun Feb 13 22:00:00 2005
+++ mdadm-2.0-devel-1-async-writes/Build.c	Wed Mar  2 14:02:34 2005
@@ -36,7 +36,7 @@
 int Build(char *mddev, int mdfd, int chunk, int level, int layout,
 	  int raiddisks,
 	  mddev_dev_t devlist, int assume_clean,
-	  char *bitmap_file, int bitmap_chunk, int delay)
+	  char *bitmap_file, int bitmap_chunk, int async_writes, int delay)
 {
 	/* Build a linear or raid0 arrays without superblocks
 	 * We cannot really do any checks, we just do it.
@@ -185,7 +185,7 @@ int Build(char *mddev, int mdfd, int chu
 					return 1;
 				}
 				if (CreateBitmap(bitmap_file, 1, NULL, bitmap_chunk,
-						 delay, 0/* FIXME size */)) {
+						 delay, async_writes, 0/* FIXME size */)) {
 					return 1;
 				}
 				bitmap_fd = open(bitmap_file, O_RDWR);
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff --exclude rpm --exclude mdadm.steeleye.spec --exclude *.KERNEL --exclude *.DIST mdadm-2.0-devel-1-bitmap-bug-fix/Create.c mdadm-2.0-devel-1-async-writes/Create.c
--- mdadm-2.0-devel-1-bitmap-bug-fix/Create.c	Sun Feb 13 22:00:35 2005
+++ mdadm-2.0-devel-1-async-writes/Create.c	Wed Mar  2 14:01:43 2005
@@ -35,7 +35,7 @@ int Create(struct supertype *st, char *m
 	   int chunk, int level, int layout, unsigned long size, int raiddisks, int sparedisks,
 	   int subdevs, mddev_dev_t devlist,
 	   int runstop, int verbose, int force,
-	   char *bitmap_file, int bitmap_chunk, int delay)
+	   char *bitmap_file, int bitmap_chunk, int async_writes, int delay)
 {
 	/*
 	 * Create a new raid array.
@@ -363,7 +363,8 @@ int Create(struct supertype *st, char *m
 	if (bitmap_file) {
 		int uuid[4];
 		st->ss->uuid_from_super(uuid, super);
-		if (CreateBitmap(bitmap_file, force, (char*)uuid, bitmap_chunk, delay,
+		if (CreateBitmap(bitmap_file, force, (char*)uuid, bitmap_chunk,
+			delay, async_writes,
 				 array.size*2ULL /* FIXME wrong for raid10 */)) {
 			return 1;
 		}
@@ -397,14 +398,18 @@ int Create(struct supertype *st, char *m
 			}
 			disk.raid_disk = disk.number;
 			if (disk.raid_disk < raiddisks)
-				disk.state = 6; /* active and in sync */
+				disk.state = (1<<MD_DISK_ACTIVE) |
+						(1<<MD_DISK_SYNC);
 			else
 				disk.state = 0;
+			if (dnum && async_writes)
+				disk.state |= (1<<MD_DISK_WRITEONLY);
+
 			if (dnum == insert_point ||
 			    strcasecmp(dv->devname, "missing")==0) {
 				disk.major = 0;
 				disk.minor = 0;
-				disk.state = 1; /* faulty */
+				disk.state = (1<<MD_DISK_FAULTY);
 			} else {
 				fd = open(dv->devname, O_RDONLY, 0);
 				if (fd < 0) {
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff --exclude rpm --exclude mdadm.steeleye.spec --exclude *.KERNEL --exclude *.DIST mdadm-2.0-devel-1-bitmap-bug-fix/Detail.c mdadm-2.0-devel-1-async-writes/Detail.c
--- mdadm-2.0-devel-1-bitmap-bug-fix/Detail.c	Sun Feb 13 21:59:45 2005
+++ mdadm-2.0-devel-1-async-writes/Detail.c	Wed Mar  2 14:17:35 2005
@@ -213,6 +213,8 @@ int Detail(char *dev, int brief, int tes
 	for (d= 0; d<MD_SB_DISKS; d++) {
 		mdu_disk_info_t disk;
 		char *dv;
+		int wonly = disk.state & (1<<MD_DISK_WRITEONLY);
+		disk.state &= ~(1<<MD_DISK_WRITEONLY);
 		disk.number = d;
 		if (ioctl(fd, GET_DISK_INFO, &disk) < 0) {
 			if (d < array.raid_disks)
@@ -241,6 +243,7 @@ int Detail(char *dev, int brief, int tes
 			if (disk.state & (1<<MD_DISK_ACTIVE)) printf(" active");
 			if (disk.state & (1<<MD_DISK_SYNC)) printf(" sync");
 			if (disk.state & (1<<MD_DISK_REMOVED)) printf(" removed");
+			if (wonly) printf(" writeonly");
 			if (disk.state == 0) printf(" spare");
 			if (disk.state == 0) {
 				if (is_26) {
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff --exclude rpm --exclude mdadm.steeleye.spec --exclude *.KERNEL --exclude *.DIST mdadm-2.0-devel-1-bitmap-bug-fix/ReadMe.c mdadm-2.0-devel-1-async-writes/ReadMe.c
--- mdadm-2.0-devel-1-bitmap-bug-fix/ReadMe.c	Thu Feb 17 19:17:13 2005
+++ mdadm-2.0-devel-1-async-writes/ReadMe.c	Fri Mar  4 13:33:36 2005
@@ -131,6 +131,7 @@ struct option long_options[] = {
     {"metadata",  1, 0, 'e'}, /* superblock format */
     {"bitmap",	  1, 0, 'b'},
     {"bitmap-chunk", 1, 0, 4},
+    {"async",     2, 0, 5},
 
     /* For assemble */
     {"uuid",      1, 0, 'u'},
@@ -232,6 +233,7 @@ char OptionHelp[] =
 "  --assume-clean     : Assume the array is already in-sync. This is dangerous.\n"
 "  --bitmap-chunk=    : chunksize of bitmap in bitmap file (Kilobytes)\n"
 "  --delay=      -d   : seconds between bitmap updates\n"
+"  --async=           : number of simultaneous asynchronous writes to allow (requires bitmap)\n"
 "\n"
 " For assemble:\n"
 "  --bitmap=     -b   : File to find bitmap information in\n"
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff --exclude rpm --exclude mdadm.steeleye.spec --exclude *.KERNEL --exclude *.DIST mdadm-2.0-devel-1-bitmap-bug-fix/bitmap.c mdadm-2.0-devel-1-async-writes/bitmap.c
--- mdadm-2.0-devel-1-bitmap-bug-fix/bitmap.c	Mon Mar  7 12:15:38 2005
+++ mdadm-2.0-devel-1-async-writes/bitmap.c	Thu Mar 17 14:46:09 2005
@@ -204,6 +204,7 @@ int ExamineBitmap(char *filename, int br
 	bitmap_super_t *sb;
 	bitmap_info_t *info;
 	int rv = 1;
+	char buf[64];
 
 	info = bitmap_file_read(filename, brief);
 	if (!info)
@@ -235,6 +236,11 @@ int ExamineBitmap(char *filename, int br
 	printf("           State : %s\n", bitmap_state(sb->state));
 	printf("       Chunksize : %s\n", human_chunksize(sb->chunksize));
 	printf("          Daemon : %ds flush period\n", sb->daemon_sleep);
+	if (sb->async_writes)
+		sprintf(buf, "Asynchronous (%d)", sb->async_writes);
+	else
+		sprintf(buf, "Synchronous");
+	printf("      Write Mode : %s\n", buf);
 	printf("       Sync Size : %lluKB%s\n", sb->sync_size / 2,
 					human_size(sb->sync_size * 512));
 	if (brief)
@@ -249,6 +255,7 @@ free_info:
 
 int CreateBitmap(char *filename, int force, char uuid[16],
 		unsigned long chunksize, unsigned long daemon_sleep,
+		unsigned long async_writes,
 		unsigned long long array_size)
 {
 	/*
@@ -280,6 +287,7 @@ int CreateBitmap(char *filename, int for
 		memcpy(sb.uuid, uuid, 16);
 	sb.chunksize = chunksize;
 	sb.daemon_sleep = daemon_sleep;
+	sb.async_writes = async_writes;
 	sb.sync_size = array_size;
 
 	sb_cpu_to_le(&sb); /* convert to on-disk byte ordering */
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff --exclude rpm --exclude mdadm.steeleye.spec --exclude *.KERNEL --exclude *.DIST mdadm-2.0-devel-1-bitmap-bug-fix/bitmap.h mdadm-2.0-devel-1-async-writes/bitmap.h
--- mdadm-2.0-devel-1-bitmap-bug-fix/bitmap.h	Thu Mar 17 14:37:15 2005
+++ mdadm-2.0-devel-1-async-writes/bitmap.h	Mon Mar 14 10:13:36 2005
@@ -6,8 +6,8 @@
 #ifndef BITMAP_H
 #define BITMAP_H 1
 
-#define BITMAP_MAJOR 3
-#define BITMAP_MINOR 38
+#define BITMAP_MAJOR 4
+#define BITMAP_MINOR 0
 
 /*
  * in-memory bitmap:
@@ -43,6 +43,13 @@
  * When we set a bit, or in the counter (to start a write), if the fields is
  * 0, we first set the disk bit and set the counter to 1.
  *
+ * If the counter is 0, the on-disk bit is clear and the stipe is clean
+ * Anything that dirties the stipe pushes the counter to 2 (at least)
+ * and sets the on-disk bit (lazily).
+ * If a periodic sweep find the counter at 2, it is decremented to 1.
+ * If the sweep find the counter at 1, the on-disk bit is cleared and the
+ * counter goes to zero.
+ *
  * Also, we'll hijack the "map" pointer itself and use it as two 16 bit block
  * counters as a fallback when "page" memory cannot be allocated:
  *
@@ -140,8 +147,9 @@ typedef struct bitmap_super_s {
 	__u32 state;        /* 48  bitmap state information */
 	__u32 chunksize;    /* 52  the bitmap chunk size in bytes */
 	__u32 daemon_sleep; /* 56  seconds between disk flushes */
+	__u32 async_writes; /* 60  number of outstanding async writes */
 
-	__u8  pad[4096 - 60]; /* set to zero */
+	__u8  pad[256 - 64]; /* set to zero */
 } bitmap_super_t;
 
 /* notes:
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff --exclude rpm --exclude mdadm.steeleye.spec --exclude *.KERNEL --exclude *.DIST mdadm-2.0-devel-1-bitmap-bug-fix/md_p.h mdadm-2.0-devel-1-async-writes/md_p.h
--- mdadm-2.0-devel-1-bitmap-bug-fix/md_p.h	Thu Mar 17 14:36:32 2005
+++ mdadm-2.0-devel-1-async-writes/md_p.h	Mon Mar 14 10:11:13 2005
@@ -79,6 +79,11 @@
 #define MD_DISK_SYNC		2 /* disk is in sync with the raid set */
 #define MD_DISK_REMOVED		3 /* disk is in sync with the raid set */
 
+#define	MD_DISK_WRITEONLY	9 /* disk is "write-only" is RAID1 config.
+				   * read requests will only be sent here in 
+				   * dire need
+				   */
+
 typedef struct mdp_device_descriptor_s {
 	__u32 number;		/* 0 Device number in the entire set	      */
 	__u32 major;		/* 1 Device major number		      */
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff --exclude rpm --exclude mdadm.steeleye.spec --exclude *.KERNEL --exclude *.DIST mdadm-2.0-devel-1-bitmap-bug-fix/mdadm.8 mdadm-2.0-devel-1-async-writes/mdadm.8
--- mdadm-2.0-devel-1-bitmap-bug-fix/mdadm.8	Thu Feb 17 19:26:05 2005
+++ mdadm-2.0-devel-1-async-writes/mdadm.8	Wed Mar  2 14:12:32 2005
@@ -204,6 +204,13 @@ exist).
 .BR --bitmap-chunk=
 Set the Chunksize of the bitmap. Each bit corresponds to that many
 Kilobytes of storage. Default is 4.
+
+.TP
+.BR --async=
+Specify that asynchronous write mode should be enabled (valid for RAID1
+only). If an argument is specified, it will set the maximum number
+of outstanding asynchronous writes allowed. The default value is 256.
+(A bitmap is required in order to use asynchronous write mode.)
 
 
 .TP
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff --exclude rpm --exclude mdadm.steeleye.spec --exclude *.KERNEL --exclude *.DIST mdadm-2.0-devel-1-bitmap-bug-fix/mdadm.c mdadm-2.0-devel-1-async-writes/mdadm.c
--- mdadm-2.0-devel-1-bitmap-bug-fix/mdadm.c	Sun Feb 13 22:01:51 2005
+++ mdadm-2.0-devel-1-async-writes/mdadm.c	Wed Mar  2 15:24:54 2005
@@ -59,6 +59,7 @@ int main(int argc, char *argv[])
 	char devmode = 0;
 	int runstop = 0;
 	int readonly = 0;
+	int async_writes = 0;
 	int bitmap_fd = -1;
 	char *bitmap_file = NULL;
 	int bitmap_chunk = UnSet;
@@ -722,6 +723,19 @@ int main(int argc, char *argv[])
 			/* convert K to B, chunk of 0K means 512B */
 			bitmap_chunk = bitmap_chunk ? bitmap_chunk * 1024 : 512;
 			continue;
+
+		case O(BUILD, 5):
+		case O(CREATE, 5): /* asynchronous write mode */
+			async_writes = DEFAULT_ASYNC_MAX_WRITES;
+			if (optarg) {
+				async_writes = strtol(optarg, &c, 10);
+				if (async_writes < 0 || *c ||
+				    async_writes > 16383) {
+					fprintf(stderr, Name ": Invalid value for maximum outstanding asynchronous writes: %s.\n\tMust be between 0 (i.e., fully synchronous) and 16383.\n", optarg);
+					exit(2);
+				}
+			}
+			continue;
 		}
 		/* We have now processed all the valid options. Anything else is
 		 * an error
@@ -862,6 +876,12 @@ int main(int argc, char *argv[])
 	case BUILD:
 		if (bitmap_chunk == UnSet) bitmap_chunk = DEFAULT_BITMAP_CHUNK;
 		if (delay == 0) delay = DEFAULT_BITMAP_DELAY;
+		if (async_writes && !bitmap_file) {
+			fprintf(stderr, Name ": async write mode requires a bitmap.\n");
+			rv = 1;
+			break;
+		}
+
 		if (bitmap_file) {
 			bitmap_fd = open(bitmap_file, O_RDWR,0);
 			if (bitmap_fd < 0 && errno != ENOENT) {
@@ -871,16 +891,21 @@ int main(int argc, char *argv[])
 			}
 			if (bitmap_fd < 0) {
 				bitmap_fd = CreateBitmap(bitmap_file, force, NULL,
-							 bitmap_chunk, delay, size);
+							 bitmap_chunk, delay, async_writes, size);
 			}
 		}
 		rv = Build(devlist->devname, mdfd, chunk, level, layout,
 			   raiddisks, devlist->next, assume_clean,
-			   bitmap_file, bitmap_chunk, delay);
+			   bitmap_file, bitmap_chunk, async_writes, delay);
 		break;
 	case CREATE:
 		if (bitmap_chunk == UnSet) bitmap_chunk = DEFAULT_BITMAP_CHUNK;
 		if (delay == 0) delay = DEFAULT_BITMAP_DELAY;
+		if (async_writes && !bitmap_file) {
+			fprintf(stderr, Name ": async write mode requires a bitmap.\n");
+			rv = 1;
+			break;
+		}
 		if (ss == NULL) {
 			for(i=0; !ss && superlist[i]; i++) 
 				ss = superlist[i]->match_metadata_desc("default");
@@ -893,7 +918,7 @@ int main(int argc, char *argv[])
 		rv = Create(ss, devlist->devname, mdfd, chunk, level, layout, size<0 ? 0 : size,
 			    raiddisks, sparedisks,
 			    devs_found-1, devlist->next, runstop, verbose, force,
-			    bitmap_file, bitmap_chunk, delay);
+			    bitmap_file, bitmap_chunk, async_writes, delay);
 		break;
 	case MISC:
 
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff --exclude rpm --exclude mdadm.steeleye.spec --exclude *.KERNEL --exclude *.DIST mdadm-2.0-devel-1-bitmap-bug-fix/mdadm.h mdadm-2.0-devel-1-async-writes/mdadm.h
--- mdadm-2.0-devel-1-bitmap-bug-fix/mdadm.h	Sun Feb 13 22:00:00 2005
+++ mdadm-2.0-devel-1-async-writes/mdadm.h	Wed Mar  2 14:24:19 2005
@@ -63,6 +63,7 @@ char *strncpy(char *dest, const char *sr
 
 #define DEFAULT_BITMAP_CHUNK 4096
 #define DEFAULT_BITMAP_DELAY 5
+#define DEFAULT_ASYNC_MAX_WRITES 256
 
 #include	"md_u.h"
 #include	"md_p.h"
@@ -217,14 +218,14 @@ extern int Assemble(struct supertype *st
 extern int Build(char *mddev, int mdfd, int chunk, int level, int layout,
 		 int raiddisks,
 		 mddev_dev_t devlist, int assume_clean,
-		 char *bitmap_file, int bitmap_chunk, int delay);
+		 char *bitmap_file, int bitmap_chunk, int async_writes, int delay);
 
 
 extern int Create(struct supertype *st, char *mddev, int mdfd,
 		  int chunk, int level, int layout, unsigned long size, int raiddisks, int sparedisks,
 		  int subdevs, mddev_dev_t devlist,
 		  int runstop, int verbose, int force,
-		  char *bitmap_file, int bitmap_chunk, int delay);
+		  char *bitmap_file, int bitmap_chunk, int async_writes, int delay);
 
 extern int Detail(char *dev, int brief, int test);
 extern int Query(char *dev);
@@ -239,6 +240,7 @@ extern int Kill(char *dev, int force);
 
 extern int CreateBitmap(char *filename, int force, char uuid[16],
 			unsigned long chunksize, unsigned long daemon_sleep,
+			unsigned long async_writes,
 			unsigned long long array_size);
 extern int ExamineBitmap(char *filename, int brief);
 
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff --exclude rpm --exclude mdadm.steeleye.spec --exclude *.KERNEL --exclude *.DIST mdadm-2.0-devel-1-bitmap-bug-fix/super0.c mdadm-2.0-devel-1-async-writes/super0.c
--- mdadm-2.0-devel-1-bitmap-bug-fix/super0.c	Mon Mar  7 13:27:38 2005
+++ mdadm-2.0-devel-1-async-writes/super0.c	Mon Mar 14 10:14:05 2005
@@ -112,15 +112,19 @@ static void examine_super0(void *sbv)
 		mdp_disk_t *dp;
 		char *dv;
 		char nb[5];
+		int wonly;
 		if (d>=0) dp = &sb->disks[d];
 		else dp = &sb->this_disk;
 		sprintf(nb, "%4d", d);
 		printf("%4s %5d   %5d    %5d    %5d     ", d < 0 ? "this" :  nb,
 		       dp->number, dp->major, dp->minor, dp->raid_disk);
+		wonly = dp->state & (1<<MD_DISK_WRITEONLY);
+		dp->state &= ~(1<<MD_DISK_WRITEONLY);
 		if (dp->state & (1<<MD_DISK_FAULTY)) printf(" faulty");
 		if (dp->state & (1<<MD_DISK_ACTIVE)) printf(" active");
 		if (dp->state & (1<<MD_DISK_SYNC)) printf(" sync");
 		if (dp->state & (1<<MD_DISK_REMOVED)) printf(" removed");
+		if (wonly) printf(" writeonly");
 		if (dp->state == 0) printf(" spare");
 		if ((dv=map_dev(dp->major, dp->minor)))
 			printf("   %s", dv);
@@ -275,8 +279,10 @@ static int update_super0(struct mdinfo *
 	}
 	if (strcmp(update, "assemble")==0) {
 		int d = info->disk.number;
+		int wonly = sb->disks[d].state & (1<<MD_DISK_WRITEONLY);
+		sb->disks[d].state &= ~(1<<MD_DISK_WRITEONLY);
 		if (sb->disks[d].state != info->disk.state) {
-			sb->disks[d].state = info->disk.state;
+			sb->disks[d].state = info->disk.state & wonly;
 			rv = 1;
 		}
 	}
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff --exclude rpm --exclude mdadm.steeleye.spec --exclude *.KERNEL --exclude *.DIST mdadm-2.0-devel-1-bitmap-bug-fix/super1.c mdadm-2.0-devel-1-async-writes/super1.c
--- mdadm-2.0-devel-1-bitmap-bug-fix/super1.c	Mon Mar  7 11:34:16 2005
+++ mdadm-2.0-devel-1-async-writes/super1.c	Thu Mar 10 11:55:54 2005
@@ -65,7 +66,9 @@ struct mdp_superblock_1 {
 	__u32	dev_number;	/* permanent identifier of this  device - not role in raid */
 	__u32	cnt_corrected_read; /* number of read errors that were corrected by re-writing */
 	__u8	device_uuid[16]; /* user-space setable, ignored by kernel */
-	__u8	pad2[64-56];	/* set to 0 when writing */
+        __u8    devflags;        /* per-device flags.  Only one defined...*/
+#define WriteMostly1    1        /* mask for writemostly flag in above */
+	__u8	pad2[64-57];	/* set to 0 when writing */
 
 	/* array state information - 64 bytes */
 	__u64	utime;		/* 40 bits second, 24 btes microseconds */

--------------050007030603070904080303--
