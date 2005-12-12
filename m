From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 012 of 20] Allow array level to be set textually via sysfs.
Date: Mon, 12 Dec 2005 14:15:13 +1100
Message-ID: <1051212031513.5115@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt      |    8 +++++
 ./drivers/md/faulty.c       |    1 
 ./drivers/md/linear.c       |    3 +-
 ./drivers/md/md.c           |   61 ++++++++++++++++++++++++++++++++++----------
 ./drivers/md/multipath.c    |    1 
 ./drivers/md/raid0.c        |    1 
 ./drivers/md/raid1.c        |    1 
 ./drivers/md/raid10.c       |    1 
 ./drivers/md/raid5.c        |    2 +
 ./drivers/md/raid6main.c    |    1 
 ./include/linux/raid/md_k.h |    1 
 11 files changed, 67 insertions(+), 14 deletions(-)

diff ./Documentation/md.txt~current~ ./Documentation/md.txt
--- ./Documentation/md.txt~current~	2005-12-12 11:33:02.000000000 +1100
+++ ./Documentation/md.txt	2005-12-12 11:33:35.000000000 +1100
@@ -189,6 +189,14 @@ All md devices contain:
      1.2 (newer format in varying locations) or "none" indicating that
      the kernel isn't managing metadata at all.
 
+  level
+     The raid 'level' for this array.  The name will often (but not
+     always) be the same as the name of the module that implements the
+     level.  To be auto-loaded the module must have an alias
+        md-$LEVEL  e.g. md-raid5
+     This can be written only while the array is being assembled, not
+     after it is started.
+
 As component devices are added to an md array, they appear in the 'md'
 directory as new directories named
       dev-XXX

diff ./drivers/md/faulty.c~current~ ./drivers/md/faulty.c
--- ./drivers/md/faulty.c~current~	2005-12-12 11:30:59.000000000 +1100
+++ ./drivers/md/faulty.c	2005-12-12 11:33:35.000000000 +1100
@@ -342,4 +342,5 @@ module_init(raid_init);
 module_exit(raid_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-10"); /* faulty */
+MODULE_ALIAS("md-faulty");
 MODULE_ALIAS("md-level--5");

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2005-12-12 11:30:59.000000000 +1100
+++ ./drivers/md/linear.c	2005-12-12 11:33:35.000000000 +1100
@@ -376,5 +376,6 @@ static void linear_exit (void)
 module_init(linear_init);
 module_exit(linear_exit);
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("md-personality-1"); /* LINEAR - degrecated*/
+MODULE_ALIAS("md-personality-1"); /* LINEAR - deprecated*/
+MODULE_ALIAS("md-linear");
 MODULE_ALIAS("md-level--1");

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-12 11:33:24.000000000 +1100
+++ ./drivers/md/md.c	2005-12-12 11:33:56.000000000 +1100
@@ -303,12 +303,15 @@ static mdk_rdev_t * find_rdev(mddev_t * 
 	return NULL;
 }
 
-static struct mdk_personality *find_pers(int level)
+static struct mdk_personality *find_pers(int level, char *clevel)
 {
 	struct mdk_personality *pers;
-	list_for_each_entry(pers, &pers_list, list)
-		if (pers->level == level)
+	list_for_each_entry(pers, &pers_list, list) {
+		if (level != LEVEL_NONE && pers->level == level)
 			return pers;
+		if (strcmp(pers->name, clevel)==0)
+			return pers;
+	}
 	return NULL;
 }
 
@@ -715,6 +718,7 @@ static int super_90_validate(mddev_t *md
 		mddev->ctime = sb->ctime;
 		mddev->utime = sb->utime;
 		mddev->level = sb->level;
+		mddev->clevel[0] = 0;
 		mddev->layout = sb->layout;
 		mddev->raid_disks = sb->raid_disks;
 		mddev->size = sb->size;
@@ -1051,6 +1055,7 @@ static int super_1_validate(mddev_t *mdd
 		mddev->ctime = le64_to_cpu(sb->ctime) & ((1ULL << 32)-1);
 		mddev->utime = le64_to_cpu(sb->utime) & ((1ULL << 32)-1);
 		mddev->level = le32_to_cpu(sb->level);
+		mddev->clevel[0] = 0;
 		mddev->layout = le32_to_cpu(sb->layout);
 		mddev->raid_disks = le32_to_cpu(sb->raid_disks);
 		mddev->size = le64_to_cpu(sb->size)/2;
@@ -1774,15 +1779,36 @@ static ssize_t
 level_show(mddev_t *mddev, char *page)
 {
 	struct mdk_personality *p = mddev->pers;
-	if (p == NULL && mddev->raid_disks == 0)
-		return 0;
-	if (mddev->level >= 0)
-		return sprintf(page, "raid%d\n", mddev->level);
-	else
+	if (p)
 		return sprintf(page, "%s\n", p->name);
+	else if (mddev->clevel[0])
+		return sprintf(page, "%s\n", mddev->clevel);
+	else if (mddev->level != LEVEL_NONE)
+		return sprintf(page, "%d\n", mddev->level);
+	else
+		return 0;
+}
+
+static ssize_t
+level_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	int rv = len;
+	if (mddev->pers)
+		return -EBUSY;
+	if (len == 0)
+		return 0;
+	if (len >= sizeof(mddev->clevel))
+		return -ENOSPC;
+	strncpy(mddev->clevel, buf, len);
+	if (mddev->clevel[len-1] == '\n')
+		len--;
+	mddev->clevel[len] = 0;
+	mddev->level = LEVEL_NONE;
+	return rv;
 }
 
-static struct md_sysfs_entry md_level = __ATTR_RO(level);
+static struct md_sysfs_entry md_level =
+__ATTR(level, 0644, level_show, level_store);
 
 static ssize_t
 raid_disks_show(mddev_t *mddev, char *page)
@@ -2158,7 +2184,10 @@ static int do_md_run(mddev_t * mddev)
 	}
 
 #ifdef CONFIG_KMOD
-	request_module("md-level-%d", mddev->level);
+	if (mddev->level != LEVEL_NONE)
+		request_module("md-level-%d", mddev->level);
+	else if (mddev->clevel[0])
+		request_module("md-%s", mddev->clevel);
 #endif
 
 	/*
@@ -2180,15 +2209,21 @@ static int do_md_run(mddev_t * mddev)
 		return -ENOMEM;
 
 	spin_lock(&pers_lock);
-	pers = find_pers(mddev->level);
+	pers = find_pers(mddev->level, mddev->clevel);
 	if (!pers || !try_module_get(pers->owner)) {
 		spin_unlock(&pers_lock);
-		printk(KERN_WARNING "md: personality for level %d is not loaded!\n",
-		       mddev->level);
+		if (mddev->level != LEVEL_NONE)
+			printk(KERN_WARNING "md: personality for level %d is not loaded!\n",
+			       mddev->level);
+		else
+			printk(KERN_WARNING "md: personality for level %s is not loaded!\n",
+			       mddev->clevel);
 		return -EINVAL;
 	}
 	mddev->pers = pers;
 	spin_unlock(&pers_lock);
+	mddev->level = pers->level;
+	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
 
 	mddev->recovery = 0;
 	mddev->resync_max_sectors = mddev->size << 1; /* may be over-ridden by personality */

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2005-12-12 11:30:59.000000000 +1100
+++ ./drivers/md/multipath.c	2005-12-12 11:33:35.000000000 +1100
@@ -579,4 +579,5 @@ module_init(multipath_init);
 module_exit(multipath_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-7"); /* MULTIPATH */
+MODULE_ALIAS("md-multipath");
 MODULE_ALIAS("md-level--4");

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2005-12-12 11:30:59.000000000 +1100
+++ ./drivers/md/raid0.c	2005-12-12 11:33:35.000000000 +1100
@@ -536,4 +536,5 @@ module_init(raid0_init);
 module_exit(raid0_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-2"); /* RAID0 */
+MODULE_ALIAS("md-raid0");
 MODULE_ALIAS("md-level-0");

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-12-12 11:30:59.000000000 +1100
+++ ./drivers/md/raid1.c	2005-12-12 11:33:35.000000000 +1100
@@ -2092,4 +2092,5 @@ module_init(raid_init);
 module_exit(raid_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-3"); /* RAID1 */
+MODULE_ALIAS("md-raid1");
 MODULE_ALIAS("md-level-1");

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-12-12 11:30:59.000000000 +1100
+++ ./drivers/md/raid10.c	2005-12-12 11:33:35.000000000 +1100
@@ -2117,4 +2117,5 @@ module_init(raid_init);
 module_exit(raid_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-9"); /* RAID10 */
+MODULE_ALIAS("md-raid10");
 MODULE_ALIAS("md-level-10");

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-12-12 11:30:59.000000000 +1100
+++ ./drivers/md/raid5.c	2005-12-12 11:33:35.000000000 +1100
@@ -2240,5 +2240,7 @@ module_init(raid5_init);
 module_exit(raid5_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-4"); /* RAID5 */
+MODULE_ALIAS("md-raid5");
+MODULE_ALIAS("md-raid4");
 MODULE_ALIAS("md-level-5");
 MODULE_ALIAS("md-level-4");

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-12-12 11:30:59.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-12-12 11:33:35.000000000 +1100
@@ -2341,4 +2341,5 @@ module_init(raid6_init);
 module_exit(raid6_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md-personality-8"); /* RAID6 */
+MODULE_ALIAS("md-raid6");
 MODULE_ALIAS("md-level-6");

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-12-12 11:30:59.000000000 +1100
+++ ./include/linux/raid/md_k.h	2005-12-12 11:33:35.000000000 +1100
@@ -119,6 +119,7 @@ struct mddev_s
 	int				chunk_size;
 	time_t				ctime, utime;
 	int				level, layout;
+	char				clevel[16];
 	int				raid_disks;
 	int				max_disks;
 	sector_t			size; /* used size of component devices */
