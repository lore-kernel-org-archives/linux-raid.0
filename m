From: maximilian attems <max@stro.at>
Subject: [PATCH] [mdadm] mdopen.c don't shadow major() and minor()
Date: Wed, 26 Sep 2007 18:12:47 +0200
Message-ID: <11908231682482-git-send-email-max@stro.at>
References: <11908231671738-git-send-email-max@stro.at>
 <1190823168772-git-send-email-max@stro.at>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1190823168772-git-send-email-max@stro.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, maximilian attems <max@stro.at>
List-Id: linux-raid.ids

s/(major|minor)/\1_num/

Signed-off-by: maximilian attems <max@stro.at>
---
 mdopen.c |   64 +++++++++++++++++++++++++++++++-------------------------------
 1 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/mdopen.c b/mdopen.c
index 0b6951d..362d4d8 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -58,7 +58,7 @@ void make_parts(char *dev, int cnt, int symlinks)
 	 * else that of dev
 	 */
 	struct stat stb;
-	int major, minor;
+	int major_num, minor_num;
 	int i;
 	int nlen = strlen(dev) + 20;
 	char *name = malloc(nlen);
@@ -69,21 +69,21 @@ void make_parts(char *dev, int cnt, int symlinks)
 		return;
 	if (!S_ISBLK(stb.st_mode))
 		return;
-	major = major(stb.st_rdev);
-	minor = minor(stb.st_rdev);
+	major_num = major(stb.st_rdev);
+	minor_num = minor(stb.st_rdev);
 	for (i=1; i <= cnt ; i++) {
 		struct stat stb2;
 		snprintf(name, nlen, "%s%s%d", dev, dig?"p":"", i);
 		if (stat(name, &stb2)==0) {
 			if (!S_ISBLK(stb2.st_mode))
 				continue;
-			if (stb2.st_rdev == makedev(major, minor+i))
+			if (stb2.st_rdev == makedev(major_num, minor_num+i))
 				continue;
 			unlink(name);
 		} else {
 			stb2 = stb;
 		}
-		if (mknod(name, S_IFBLK | 0600, makedev(major, minor+i)))
+		if (mknod(name, S_IFBLK | 0600, makedev(major_num, minor_num+i)))
 			perror("mknod");
 		if (chown(name, stb2.st_uid, stb2.st_gid))
 			perror("chown");
@@ -110,8 +110,8 @@ int open_mddev(char *dev, int autof)
 {
 	int mdfd;
 	struct stat stb;
-	int major = MD_MAJOR;
-	int minor = 0;
+	int major_num = MD_MAJOR;
+	int minor_num = 0;
 	int must_remove = 0;
 	struct mdstat_ent *mdlist;
 	int num;
@@ -138,7 +138,7 @@ int open_mddev(char *dev, int autof)
 		/* check major number is correct */
 		num = -1;
 		std = is_standard(dev, &num);
-		if (std>0) major = get_mdp_major();
+		if (std>0) major_num = get_mdp_major();
 		switch(autof) {
 		case 2: /* only create is_standard names */
 			if (!std && !stb.st_mode) {
@@ -165,11 +165,11 @@ int open_mddev(char *dev, int autof)
 		case 5: /* default to md if not standard */
 			break;
 		case 6: /* default to mdp if not standard */
-			if (std == 0) major = get_mdp_major();
+			if (std == 0) major_num = get_mdp_major();
 			break;
 		}
 		/* major is final. num is -1 if not standard */
-		if (stb.st_mode && major(stb.st_rdev) != major)
+		if (stb.st_mode && major(stb.st_rdev) != major_num)
 			must_remove = 1;
 		if (stb.st_mode && !must_remove) {
 			/* looks ok, see if it is available */
@@ -184,7 +184,7 @@ int open_mddev(char *dev, int autof)
 				close(mdfd);
 				return -1;
 			}
-			if (major != MD_MAJOR && parts > 0)
+			if (major_num != MD_MAJOR && parts > 0)
 				make_parts(dev, parts, ci->symlinks);
 			return mdfd;
 		}
@@ -203,7 +203,7 @@ int open_mddev(char *dev, int autof)
 			for (num = 127 ; num != 128 ; num = num ? num-1 : (1<<22)-1) {
 				struct mdstat_ent *me;
 				int devnum = num;
-				if (major != MD_MAJOR)
+				if (major_num != MD_MAJOR)
 					devnum = -1-num;
 
 				for (me=mdlist; me; me=me->next)
@@ -214,11 +214,11 @@ int open_mddev(char *dev, int autof)
 					 * make sure it is new to /dev too
 					 */
 					char *dn;
-					if (major != MD_MAJOR)
-						minor = num << MdpMinorShift;
+					if (major_num != MD_MAJOR)
+						minor_num = num << MdpMinorShift;
 					else
-						minor = num;
-					dn = map_dev(major,minor, 0);
+						minor_num = num;
+					dn = map_dev(major_num,minor_num, 0);
 					if (dn==NULL || is_standard(dn, NULL)) {
 						/* this number only used by a 'standard' name,
 						 * so it is safe to use
@@ -227,21 +227,21 @@ int open_mddev(char *dev, int autof)
 					}
 				}
 			}
-		} else if (major == MD_MAJOR)
-			minor = num;
+		} else if (major_num == MD_MAJOR)
+			minor_num = num;
 		else
-			minor = num << MdpMinorShift;
+			minor_num = num << MdpMinorShift;
 		/* major and minor have been chosen */
 
 		/* If it was a 'standard' name and it is in-use, then
 		 * the device could already be correct
 		 */
-		if (stb.st_mode && major(stb.st_rdev) == major &&
-		    minor(stb.st_rdev) == minor)
+		if (stb.st_mode && major(stb.st_rdev) == major_num &&
+		    minor(stb.st_rdev) == minor_num)
 			;
 		else {
-			if (major(makedev(major,minor)) != major ||
-			    minor(makedev(major,minor)) != minor) {
+			if (major(makedev(major_num,minor_num)) != major_num ||
+			    minor(makedev(major_num,minor_num)) != minor_num) {
 				fprintf(stderr, Name ": Need newer C library to use more than 4 partitionable md devices, sorry\n");
 				return -1;
 			}
@@ -256,7 +256,7 @@ int open_mddev(char *dev, int autof)
 						perror("chmod /dev/md");
 				}
 			}
-			if (mknod(dev, S_IFBLK|0600, makedev(major, minor))!= 0) {
+			if (mknod(dev, S_IFBLK|0600, makedev(major_num, minor_num))!= 0) {
 				fprintf(stderr, Name ": failed to create %s\n", dev);
 				return -1;
 			}
@@ -275,7 +275,7 @@ int open_mddev(char *dev, int autof)
 			add_dev(dev, &stb, 0, NULL);
 			if (ci->symlinks && strncmp(dev, "/dev/md/", 8) == 0)
 				make_dev_symlink(dev);
-			if (major != MD_MAJOR)
+			if (major_num != MD_MAJOR)
 				make_parts(dev,parts, ci->symlinks);
 		}
 	}
@@ -299,7 +299,7 @@ int open_mddev_devnum(char *devname, int devnum, char *name, char *chosen_name)
 	 * possibly constructing a name with 'name', but in any case, copying
 	 * the name into 'chosen_name'
 	 */
-	int major, minor;
+	int major_num, minor_num;
 	struct stat stb;
 
 	if (devname)
@@ -318,22 +318,22 @@ int open_mddev_devnum(char *devname, int devnum, char *name, char *chosen_name)
 			sprintf(chosen_name, "/dev/md/d%d", -1-devnum);
 	}
 	if (devnum >= 0) {
-		major = MD_MAJOR;
-		minor = devnum;
+		major_num = MD_MAJOR;
+		minor_num = devnum;
 	} else {
-		major = get_mdp_major();
-		minor = (-1-devnum) << 6;
+		major_num = get_mdp_major();
+		minor_num = (-1-devnum) << 6;
 	}
 	if (stat(chosen_name, &stb) == 0) {
 		/* It already exists.  Check it is right. */
 		if ( ! S_ISBLK(stb.st_mode) ||
-		     stb.st_rdev != makedev(major, minor)) {
+		     stb.st_rdev != makedev(major_num, minor_num)) {
 			errno = EEXIST;
 			return -1;
 		}
 	} else {
 		if (mknod(chosen_name, S_IFBLK | 0600,
-			  makedev(major, minor)) != 0) {
+			  makedev(major_num, minor_num)) != 0) {
 			return -1;
 		}
 		/* FIXME chown/chmod ?? */
-- 
1.5.3.1

