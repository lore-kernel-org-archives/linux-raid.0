From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 7 of 27 - Use symbolic names for multipath (-4) and linear (-1)
Date: Thu, 18 Jul 2002 23:32:54 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133254.4820@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Use symbolic names for multipath (-4) and linear (-1)

Also, a variable called "level" was being used to store a
"level" and a "personality" number.  This is potentially
confusing, so it is now two variables.






 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   28 ++++++++++++++--------------
 ./drivers/md/multipath.c    |    2 +-
 ./include/linux/raid/md_k.h |   11 +++++++----
 3 files changed, 22 insertions(+), 19 deletions(-)

--- ./drivers/md/md.c	2002/07/18 12:00:31	1.2
+++ ./drivers/md/md.c	2002/07/18 12:00:37	1.3
@@ -1051,7 +1051,7 @@ static mdk_rdev_t *md_import_device(kdev
 			goto abort_free;
 		}
 
-		if (rdev->sb->level != -4) {
+		if (rdev->sb->level != LEVEL_MULTIPATH) {
 			rdev->old_dev = mk_kdev(rdev->sb->this_disk.major,
 						rdev->sb->this_disk.minor);
 			rdev->desc_nr = rdev->sb->this_disk.number;
@@ -1211,7 +1211,7 @@ static int analyze_sbs(mddev_t * mddev)
 	 * Fix up changed device names ... but only if this disk has a
 	 * recent update time. Use faulty checksum ones too.
 	 */
-	if (mddev->sb->level != -4)
+	if (mddev->sb->level != LEVEL_MULTIPATH)
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		__u64 ev1, ev2, ev3;
 		if (rdev->faulty || rdev->alias_device) {
@@ -1269,7 +1269,7 @@ static int analyze_sbs(mddev_t * mddev)
 		 * care if it was previously marked as faulty, it's up now
 		 * so enable it.
 		 */
-		if (disk_faulty(desc) && mddev->sb->level != -4) {
+		if (disk_faulty(desc) && mddev->sb->level != LEVEL_MULTIPATH) {
 			found = 0;
 			ITERATE_RDEV(mddev,rdev,tmp) {
 				if (rdev->desc_nr != desc->number)
@@ -1312,7 +1312,7 @@ static int analyze_sbs(mddev_t * mddev)
 			 * we cannot check rdev->number.
 			 * We can check the device though.
 			 */
-			if ((sb->level == -4) &&
+			if ((sb->level == LEVEL_MULTIPATH) &&
 			    kdev_same(rdev->dev,
 				      mk_kdev(desc->major,desc->minor))) {
 				found = 1;
@@ -1362,7 +1362,7 @@ static int analyze_sbs(mddev_t * mddev)
 		 * disk is which, only the position of the device
 		 * in the superblock:
 		 */
-		if (mddev->sb->level == -4) {
+		if (mddev->sb->level == LEVEL_MULTIPATH) {
 			if ((rdev->desc_nr != -1) && (rdev->desc_nr != i)) {
 				MD_BUG();
 				goto abort;
@@ -1387,7 +1387,7 @@ static int analyze_sbs(mddev_t * mddev)
 	/*
 	 * Do a final reality check.
 	 */
-	if (mddev->sb->level != -4) {
+	if (mddev->sb->level != LEVEL_MULTIPATH) {
 		ITERATE_RDEV(mddev,rdev,tmp) {
 			if (rdev->desc_nr == -1) {
 				MD_BUG();
@@ -1473,7 +1473,7 @@ static int device_size_calculation(mddev
 	}
 
 	switch (sb->level) {
-		case -4:
+		case LEVEL_MULTIPATH:
 			data_disks = 1;
 			break;
 		case -3:
@@ -1482,7 +1482,7 @@ static int device_size_calculation(mddev
 		case -2:
 			data_disks = 1;
 			break;
-		case -1:
+		case LEVEL_LINEAR:
 			zoned_raid_size(mddev);
 			data_disks = 1;
 			break;
@@ -3614,7 +3614,7 @@ static struct {
  */
 static int __init md_setup(char *str)
 {
-	int minor, level, factor, fault;
+	int minor, level, factor, fault, pers;
 	char *pername = "";
 	char *str1 = str;
 
@@ -3631,7 +3631,7 @@ static int __init md_setup(char *str)
 	}
 	switch (get_option(&str, &level)) {	/* RAID Personality */
 	case 2: /* could be 0 or -1.. */
-		if (!level || level == -1) {
+		if (level == 0 || level == LEVEL_LINEAR) {
 			if (get_option(&str, &factor) != 2 ||	/* Chunk Size */
 					get_option(&str, &fault) != 2) {
 				printk(KERN_WARNING "md: Too few arguments supplied to md=.\n");
@@ -3640,12 +3640,12 @@ static int __init md_setup(char *str)
 			md_setup_args.pers[minor] = level;
 			md_setup_args.chunk[minor] = 1 << (factor+12);
 			switch(level) {
-			case -1:
-				level = LINEAR;
+			case LEVEL_LINEAR:
+				pers = LINEAR;
 				pername = "linear";
 				break;
 			case 0:
-				level = RAID0;
+				pers = RAID0;
 				pername = "raid0";
 				break;
 			default:
@@ -3654,7 +3654,7 @@ static int __init md_setup(char *str)
 				       level);
 				return 0;
 			}
-			md_setup_args.pers[minor] = level;
+			md_setup_args.pers[minor] = pers;
 			break;
 		}
 		/* FALL THROUGH */
--- ./drivers/md/multipath.c	2002/07/18 12:00:24	1.6
+++ ./drivers/md/multipath.c	2002/07/18 12:00:37	1.7
@@ -665,7 +665,7 @@ static int multipath_run (mddev_t *mddev
 
 	MOD_INC_USE_COUNT;
 
-	if (sb->level != -4) {
+	if (sb->level != LEVEL_MULTIPATH) {
 		printk(INVALID_LEVEL, mdidx(mddev), sb->level);
 		goto out;
 	}
--- ./include/linux/raid/md_k.h	2002/07/18 12:00:35	1.1
+++ ./include/linux/raid/md_k.h	2002/07/18 12:00:37	1.2
@@ -25,13 +25,16 @@
 #define MULTIPATH         7UL
 #define MAX_PERSONALITY   8UL
 
+#define	LEVEL_MULTIPATH		(-4)
+#define	LEVEL_LINEAR		(-1)
+
 static inline int pers_to_level (int pers)
 {
 	switch (pers) {
-		case MULTIPATH:		return -4;
+		case MULTIPATH:		return LEVEL_MULTIPATH;
 		case HSM:		return -3;
 		case TRANSLUCENT:	return -2;
-		case LINEAR:		return -1;
+		case LINEAR:		return LEVEL_LINEAR;
 		case RAID0:		return 0;
 		case RAID1:		return 1;
 		case RAID5:		return 5;
@@ -43,10 +46,10 @@ static inline int pers_to_level (int per
 static inline int level_to_pers (int level)
 {
 	switch (level) {
-		case -4: return MULTIPATH;
+		case LEVEL_MULTIPATH: return MULTIPATH;
 		case -3: return HSM;
 		case -2: return TRANSLUCENT;
-		case -1: return LINEAR;
+		case LEVEL_LINEAR: return LINEAR;
 		case 0: return RAID0;
 		case 1: return RAID1;
 		case 4:
