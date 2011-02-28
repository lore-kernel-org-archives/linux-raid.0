From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH] Warn the user about too small array size
Date: Mon, 28 Feb 2011 06:00:43 +0100
Message-ID: <20110228050043.23112.65994.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

If single-disk RAID0 or RAID1 array is created, user may preserve data on
disk. If array given size covers all partitions on disk, all data will be
available on created array. If array size is too small (not covers
all partitions), data will be not accessible.
This patch introduces warning message during array creation if given size
is too small. User may interrupt creation process to avoid data loss.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Create.c |    7 +++----
 mdadm.h  |    2 +-
 util.c   |    9 ++++++++-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/Create.c b/Create.c
index bbd25e5..ff18ff8 100644
--- a/Create.c
+++ b/Create.c
@@ -121,7 +121,6 @@ int Create(struct supertype *st, char *mddev,
 	unsigned long long newsize;
 
 	int major_num = BITMAP_MAJOR_HI;
-
 	memset(&info, 0, sizeof(info));
 	if (level == UnSet && st && st->ss->default_geometry)
 		st->ss->default_geometry(st, &level, NULL, NULL);
@@ -380,14 +379,14 @@ int Create(struct supertype *st, char *mddev,
 			if (strcmp(st->ss->name, "1.x") == 0 &&
 			    st->minor_version >= 1)
 				/* metadata at front */
-				warn |= check_partitions(fd, dname, 0);
+				warn |= check_partitions(fd, dname, 0, 0);
 			else if (level == 1 || level == LEVEL_CONTAINER
 				    || (level == 0 && raiddisks == 1))
 				/* partitions could be meaningful */
-				warn |= check_partitions(fd, dname, freesize*2);
+				warn |= check_partitions(fd, dname, freesize*2, size*2);
 			else
 				/* partitions cannot be meaningful */
-				warn |= check_partitions(fd, dname, 0);
+				warn |= check_partitions(fd, dname, 0, 0);
 			if (strcmp(st->ss->name, "1.x") == 0 &&
 			    st->minor_version >= 1 &&
 			    did_default &&
diff --git a/mdadm.h b/mdadm.h
index a1be856..476a2be 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1078,7 +1078,7 @@ extern int parse_layout_faulty(char *layout);
 extern int check_ext2(int fd, char *name);
 extern int check_reiser(int fd, char *name);
 extern int check_raid(int fd, char *name);
-extern int check_partitions(int fd, char *dname, unsigned long long freesize);
+extern int check_partitions(int fd, char *dname, unsigned long long freesize, unsigned long long size);
 
 extern int get_mdp_major(void);
 extern int dev_open(char *dev, int flags);
diff --git a/util.c b/util.c
index 87c23dc..0f72b0e 100644
--- a/util.c
+++ b/util.c
@@ -1370,7 +1370,8 @@ static int get_last_partition_end(int fd, unsigned long long *endofpart)
 	return retval;
 }
 
-int check_partitions(int fd, char *dname, unsigned long long freesize)
+int check_partitions(int fd, char *dname, unsigned long long freesize,
+			unsigned long long size)
 {
 	/*
 	 * Check where the last partition ends
@@ -1393,6 +1394,12 @@ int check_partitions(int fd, char *dname, unsigned long long freesize)
 				Name ": metadata will over-write last partition on %s.\n",
 				dname);
 			return 1;
+		} else if (size && endofpart > size) {
+			/* partitions will be truncated in new device */
+			fprintf(stderr,
+				Name ": array size is too small to cover all partitions on %s.\n",
+				dname);
+			return 1;
 		}
 	}
 	return 0;

