From: "Kevin P. Fleming" <kpfleming@cox.net>
Subject: [PATCH] convert md to use seq_file for /proc/mdstat
Date: Wed, 05 Mar 2003 23:22:22 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E66E91E.1010307@cox.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020908030102090708050204"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020908030102090708050204
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

To make a long story short, I just converted my home server over to 
2.5.64, and started using LVM2 (device mapper) on top of an md RAID-1. 
Everything works great, except that /proc/mdstat is hosed because when 
device mapper is in use the md driver reports all 255 possible minors, 
overflowing the single-page proc read buffer.

So, even though the proper fix is probably to make md only report the 
minors that are actually in use, it's also a good idea to switch to 
using the more modern (:-) seq_file interface... so the patch is 
attached. It touches nearly everything in drivers/md, and 
include/linux/raid/md_k.h because the prototype for pers->status changed 
(to take struct seq_file * instead of char page *). It's relative to 
2.5.64 plain (no bk updates). I've compiled tested the entire patch, and 
run tested using the raid-1 personality; I don't have the facilities to 
test the other personalities, but the code changes were pretty simple in 
those files.

If the attachment is a problem for anyone, I'll post it on a web site 
(this mailer can't inline it without mangling it).

--------------020908030102090708050204
Content-Type: text/plain;
 name="md-seq_file-patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md-seq_file-patch"

diff -X dontdiff -u linux-2.5/drivers/md/linear.c linux-2.5-new/drivers/md/linear.c
--- linux-2.5/drivers/md/linear.c	Wed Mar  5 22:55:53 2003
+++ linux-2.5-new/drivers/md/linear.c	Wed Mar  5 22:38:35 2003
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 #include <linux/bio.h>
 #include <linux/raid/linear.h>
+#include <linux/seq_file.h>
 
 #define MAJOR_NR MD_MAJOR
 #define MD_DRIVER
@@ -208,31 +209,28 @@
 	return 1;
 }
 
-static int linear_status (char *page, mddev_t *mddev)
+static void linear_status (struct seq_file *seq, mddev_t *mddev)
 {
-	int sz = 0;
-
 #undef MD_DEBUG
 #ifdef MD_DEBUG
 	int j;
 	linear_conf_t *conf = mddev_to_conf(mddev);
   
-	sz += sprintf(page+sz, "      ");
+	seq_printf(seq, "      ");
 	for (j = 0; j < conf->nr_zones; j++)
 	{
-		sz += sprintf(page+sz, "[%s",
+		seq_printf(seq, "[%s",
 			bdev_partition_name(conf->hash_table[j].dev0->rdev->bdev));
 
 		if (conf->hash_table[j].dev1)
-			sz += sprintf(page+sz, "/%s] ",
+			seq_printf(seq, "/%s] ",
 			  bdev_partition_name(conf->hash_table[j].dev1->rdev->bdev));
 		else
-			sz += sprintf(page+sz, "] ");
+			seq_printf(seq, "] ");
 	}
-	sz += sprintf(page+sz, "\n");
+	seq_printf(seq, "\n");
 #endif
-	sz += sprintf(page+sz, " %dk rounding", mddev->chunk_size/1024);
-	return sz;
+	seq_printf(seq, " %dk rounding", mddev->chunk_size/1024);
 }
 
 
diff -X dontdiff -u linux-2.5/drivers/md/md.c linux-2.5-new/drivers/md/md.c
--- linux-2.5/drivers/md/md.c	Wed Mar  5 22:56:00 2003
+++ linux-2.5-new/drivers/md/md.c	Wed Mar  5 22:58:38 2003
@@ -39,6 +39,8 @@
 #include <linux/suspend.h>
 
 #include <linux/init.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 #ifdef CONFIG_KMOD
 #include <linux/kmod.h>
@@ -133,6 +135,15 @@
 
 static struct gendisk *disks[MAX_MD_DEVS];
 
+static int md_state_open_fs(struct inode *inode, struct file *file);
+
+static struct file_operations md_state_fops = {
+	.open = md_state_open_fs,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
 /*
  * Enables to iterate over all existing md arrays
  * all_mddevs_lock protects this list as well as mddev_map.
@@ -2621,30 +2632,28 @@
 	md_recover_arrays();
 }
 
-static int status_unused(char * page)
+static void status_unused(struct seq_file * seq)
 {
-	int sz = 0, i = 0;
+	int i = 0;
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
 
-	sz += sprintf(page + sz, "unused devices: ");
+	seq_printf(seq, "unused devices: ");
 
 	ITERATE_RDEV_PENDING(rdev,tmp) {
 		i++;
-		sz += sprintf(page + sz, "%s ",
+		seq_printf(seq, "%s ",
 			      bdev_partition_name(rdev->bdev));
 	}
 	if (!i)
-		sz += sprintf(page + sz, "<none>");
+		seq_printf(seq, "<none>");
 
-	sz += sprintf(page + sz, "\n");
-	return sz;
+	seq_printf(seq, "\n");
 }
 
 
-static int status_resync(char * page, mddev_t * mddev)
+static void status_resync(struct seq_file * seq, mddev_t * mddev)
 {
-	int sz = 0;
 	unsigned long max_blocks, resync, res, dt, db, rt;
 
 	resync = (mddev->curr_resync - atomic_read(&mddev->recovery_active))/2;
@@ -2655,20 +2664,19 @@
 	 */
 	if (!max_blocks) {
 		MD_BUG();
-		return 0;
 	}
 	res = (resync/1024)*1000/(max_blocks/1024 + 1);
 	{
 		int i, x = res/50, y = 20-x;
-		sz += sprintf(page + sz, "[");
+		seq_printf(seq, "[");
 		for (i = 0; i < x; i++)
-			sz += sprintf(page + sz, "=");
-		sz += sprintf(page + sz, ">");
+			seq_printf(seq, "=");
+		seq_printf(seq, ">");
 		for (i = 0; i < y; i++)
-			sz += sprintf(page + sz, ".");
-		sz += sprintf(page + sz, "] ");
+			seq_printf(seq, ".");
+		seq_printf(seq, "] ");
 	}
-	sz += sprintf(page + sz, " %s =%3lu.%lu%% (%lu/%lu)",
+	seq_printf(seq, " %s =%3lu.%lu%% (%lu/%lu)",
 		      (mddev->spares ? "recovery" : "resync"),
 		      res/10, res % 10, resync, max_blocks);
 
@@ -2686,44 +2694,40 @@
 	db = resync - (mddev->resync_mark_cnt/2);
 	rt = (dt * ((max_blocks-resync) / (db/100+1)))/100;
 
-	sz += sprintf(page + sz, " finish=%lu.%lumin", rt / 60, (rt % 60)/6);
+	seq_printf(seq, " finish=%lu.%lumin", rt / 60, (rt % 60)/6);
 
-	sz += sprintf(page + sz, " speed=%ldK/sec", db/dt);
-
-	return sz;
+	seq_printf(seq, " speed=%ldK/sec", db/dt);
 }
 
-static int md_status_read_proc(char *page, char **start, off_t off,
-			int count, int *eof, void *data)
+static int md_state_seq_show(struct seq_file *seq, void *dummy)
 {
-	int sz = 0, j;
+	int j;
 	sector_t size;
 	struct list_head *tmp, *tmp2;
 	mdk_rdev_t *rdev;
 	mddev_t *mddev;
 
-	sz += sprintf(page + sz, "Personalities : ");
+	seq_printf(seq, "Personalities : ");
 	for (j = 0; j < MAX_PERSONALITY; j++)
-	if (pers[j])
-		sz += sprintf(page+sz, "[%s] ", pers[j]->name);
-
-	sz += sprintf(page+sz, "\n");
+		if (pers[j])
+			seq_printf(seq, "[%s] ", pers[j]->name);
+	seq_printf(seq, "\n");
 
 	ITERATE_MDDEV(mddev,tmp) if (mddev_lock(mddev)==0) {
-		sz += sprintf(page + sz, "md%d : %sactive", mdidx(mddev),
+		seq_printf(seq, "md%d : %sactive", mdidx(mddev),
 						mddev->pers ? "" : "in");
 		if (mddev->pers) {
 			if (mddev->ro)
-				sz += sprintf(page + sz, " (read-only)");
-			sz += sprintf(page + sz, " %s", mddev->pers->name);
+				seq_printf(seq, " (read-only)");
+			seq_printf(seq, " %s", mddev->pers->name);
 		}
 
 		size = 0;
 		ITERATE_RDEV(mddev,rdev,tmp2) {
-			sz += sprintf(page + sz, " %s[%d]",
+			seq_printf(seq, " %s[%d]",
 				bdev_partition_name(rdev->bdev), rdev->desc_nr);
 			if (rdev->faulty) {
-				sz += sprintf(page + sz, "(F)");
+				seq_printf(seq, "(F)");
 				continue;
 			}
 			size += rdev->size;
@@ -2731,32 +2735,37 @@
 
 		if (!list_empty(&mddev->disks)) {
 			if (mddev->pers)
-				sz += sprintf(page + sz, "\n      %llu blocks",
+				seq_printf(seq, "\n      %llu blocks",
 						 (unsigned long long)md_size[mdidx(mddev)]);
 			else
-				sz += sprintf(page + sz, "\n      %llu blocks", (unsigned long long)size);
+				seq_printf(seq, "\n      %llu blocks", (unsigned long long)size);
 		}
 
 		if (!mddev->pers) {
-			sz += sprintf(page+sz, "\n");
+			seq_printf(seq, "\n");
 			mddev_unlock(mddev);
 			continue;
 		}
 
-		sz += mddev->pers->status (page+sz, mddev);
+		mddev->pers->status (seq, mddev);
 
-		sz += sprintf(page+sz, "\n      ");
+		seq_printf(seq, "\n      ");
 		if (mddev->curr_resync > 2)
-			sz += status_resync (page+sz, mddev);
+			status_resync(seq, mddev);
 		else if (mddev->curr_resync == 1 || mddev->curr_resync == 2)
-				sz += sprintf(page + sz, "	resync=DELAYED");
+				seq_printf(seq, "	resync=DELAYED");
 
-		sz += sprintf(page + sz, "\n");
+		seq_printf(seq, "\n");
 		mddev_unlock(mddev);
 	}
-	sz += status_unused(page + sz);
+	status_unused(seq);
+
+	return 0;
+}
 
-	return sz;
+static int md_state_open_fs(struct inode *inode, struct file *file)
+{
+	return single_open(file, md_state_seq_show, NULL);
 }
 
 int register_md_personality(int pnum, mdk_personality_t *p)
@@ -3199,16 +3208,13 @@
 	}
 
 	dprintk("md: sizeof(mdp_super_t) = %d\n", (int)sizeof(mdp_super_t));
-
-#ifdef CONFIG_PROC_FS
-	create_proc_read_entry("mdstat", 0, NULL, md_status_read_proc, NULL);
-#endif
 }
 
 int __init md_init(void)
 {
 	static char * name = "mdrecoveryd";
 	int minor;
+	struct proc_dir_entry * entry = NULL;
 
 	printk(KERN_INFO "md: md driver %d.%d.%d MAX_MD_DEVS=%d, MD_SB_DISKS=%d\n",
 			MD_MAJOR_VERSION, MD_MINOR_VERSION,
@@ -3237,6 +3243,13 @@
 	raid_table_header = register_sysctl_table(raid_root_table, 1);
 
 	md_geninit();
+	entry = create_proc_entry("mdstat", S_IRUGO, NULL);
+	if (!entry)
+		printk(KERN_ALERT
+		       "md: bug: couldn't create /proc/mdstat\n");
+	else {
+		entry->proc_fops = &md_state_fops;
+	}
 	return (0);
 }
 
@@ -3298,9 +3311,7 @@
 	unregister_blkdev(MAJOR_NR,"md");
 	unregister_reboot_notifier(&md_notifier);
 	unregister_sysctl_table(raid_table_header);
-#ifdef CONFIG_PROC_FS
 	remove_proc_entry("mdstat", NULL);
-#endif
 	for (i = 0; i < MAX_MD_DEVS; i++) {
 		struct gendisk *disk = disks[i];
 		mddev_t *mddev;
diff -X dontdiff -u linux-2.5/drivers/md/multipath.c linux-2.5-new/drivers/md/multipath.c
--- linux-2.5/drivers/md/multipath.c	Wed Mar  5 22:55:53 2003
+++ linux-2.5-new/drivers/md/multipath.c	Wed Mar  5 22:39:24 2003
@@ -26,6 +26,7 @@
 #include <linux/bio.h>
 #include <linux/buffer_head.h>
 #include <asm/atomic.h>
+#include <linux/seq_file.h>
 
 #define MAJOR_NR MD_MAJOR
 #define MD_DRIVER
@@ -185,19 +186,18 @@
 	return 0;
 }
 
-static int multipath_status (char *page, mddev_t *mddev)
+static void multipath_status (struct seq_file *seq, mddev_t *mddev)
 {
 	multipath_conf_t *conf = mddev_to_conf(mddev);
-	int sz = 0, i;
+	int i;
 	
-	sz += sprintf (page+sz, " [%d/%d] [", conf->raid_disks,
+	seq_printf (seq, " [%d/%d] [", conf->raid_disks,
 						 conf->working_disks);
 	for (i = 0; i < conf->raid_disks; i++)
-		sz += sprintf (page+sz, "%s",
+		seq_printf (seq, "%s",
 			       conf->multipaths[i].rdev && 
 			       conf->multipaths[i].rdev->in_sync ? "U" : "_");
-	sz += sprintf (page+sz, "]");
-	return sz;
+	seq_printf (seq, "]");
 }
 
 #define LAST_DISK KERN_ALERT \
diff -X dontdiff -u linux-2.5/drivers/md/raid0.c linux-2.5-new/drivers/md/raid0.c
--- linux-2.5/drivers/md/raid0.c	Wed Jan  1 20:22:18 2003
+++ linux-2.5-new/drivers/md/raid0.c	Wed Mar  5 22:41:13 2003
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/raid/raid0.h>
 #include <linux/bio.h>
+#include <linux/seq_file.h>
 
 #define MAJOR_NR MD_MAJOR
 #define MD_DRIVER
@@ -372,41 +373,38 @@
 	return 0;
 }
 			   
-static int raid0_status (char *page, mddev_t *mddev)
+static void raid0_status (struct seq_file *seq, mddev_t *mddev)
 {
-	int sz = 0;
 #undef MD_DEBUG
 #ifdef MD_DEBUG
 	int j, k;
 	raid0_conf_t *conf = mddev_to_conf(mddev);
   
-	sz += sprintf(page + sz, "      ");
+	seq_printf(seq, "      ");
 	for (j = 0; j < conf->nr_zones; j++) {
-		sz += sprintf(page + sz, "[z%d",
+		seq_printf(seq, "[z%d",
 				conf->hash_table[j].zone0 - conf->strip_zone);
 		if (conf->hash_table[j].zone1)
-			sz += sprintf(page+sz, "/z%d] ",
+			seq_printf(seq, "/z%d] ",
 				conf->hash_table[j].zone1 - conf->strip_zone);
 		else
-			sz += sprintf(page+sz, "] ");
+			seq_printf(seq, "] ");
 	}
   
-	sz += sprintf(page + sz, "\n");
+	seq_printf(seq, "\n");
   
 	for (j = 0; j < conf->nr_strip_zones; j++) {
-		sz += sprintf(page + sz, "      z%d=[", j);
+		seq_printf(seq, "      z%d=[", j);
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
-			sz += sprintf (page+sz, "%s/", bdev_partition_name(
+			seq_printf (seq, "%s/", bdev_partition_name(
 				conf->strip_zone[j].dev[k]->bdev));
-		sz--;
-		sz += sprintf (page+sz, "] zo=%d do=%d s=%d\n",
+		seq_printf (seq, "] zo=%d do=%d s=%d\n",
 				conf->strip_zone[j].zone_offset,
 				conf->strip_zone[j].dev_offset,
 				conf->strip_zone[j].size);
 	}
 #endif
-	sz += sprintf(page + sz, " %dk chunks", mddev->chunk_size/1024);
-	return sz;
+	seq_printf(seq, " %dk chunks", mddev->chunk_size/1024);
 }
 
 static mdk_personality_t raid0_personality=
diff -X dontdiff -u linux-2.5/drivers/md/raid1.c linux-2.5-new/drivers/md/raid1.c
--- linux-2.5/drivers/md/raid1.c	Wed Mar  5 22:55:53 2003
+++ linux-2.5-new/drivers/md/raid1.c	Wed Mar  5 22:42:29 2003
@@ -24,6 +24,7 @@
 
 #include <linux/raid/raid1.h>
 #include <linux/bio.h>
+#include <linux/seq_file.h>
 
 #define MAJOR_NR MD_MAJOR
 #define MD_DRIVER
@@ -571,19 +572,18 @@
 	return 0;
 }
 
-static int status(char *page, mddev_t *mddev)
+static void status(struct seq_file *seq, mddev_t *mddev)
 {
 	conf_t *conf = mddev_to_conf(mddev);
-	int sz = 0, i;
+	int i;
 
-	sz += sprintf(page+sz, " [%d/%d] [", conf->raid_disks,
+	seq_printf(seq, " [%d/%d] [", conf->raid_disks,
 						conf->working_disks);
 	for (i = 0; i < conf->raid_disks; i++)
-		sz += sprintf(page+sz, "%s",
+		seq_printf(seq, "%s",
 			      conf->mirrors[i].rdev &&
 			      conf->mirrors[i].rdev->in_sync ? "U" : "_");
-	sz += sprintf (page+sz, "]");
-	return sz;
+	seq_printf(seq, "]");
 }
 
 #define LAST_DISK KERN_ALERT \
diff -X dontdiff -u linux-2.5/drivers/md/raid5.c linux-2.5-new/drivers/md/raid5.c
--- linux-2.5/drivers/md/raid5.c	Wed Mar  5 22:55:53 2003
+++ linux-2.5-new/drivers/md/raid5.c	Wed Mar  5 22:43:25 2003
@@ -23,6 +23,7 @@
 #include <linux/bio.h>
 #include <asm/bitops.h>
 #include <asm/atomic.h>
+#include <linux/seq_file.h>
 
 /*
  * Stripe cache
@@ -1579,24 +1580,23 @@
 }
 #endif
 
-static int status (char *page, mddev_t *mddev)
+static void status (struct seq_file *seq, mddev_t *mddev)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
-	int sz = 0, i;
+	int i;
 
-	sz += sprintf (page+sz, " level %d, %dk chunk, algorithm %d", mddev->level, mddev->chunk_size >> 10, mddev->layout);
-	sz += sprintf (page+sz, " [%d/%d] [", conf->raid_disks, conf->working_disks);
+	seq_printf (seq, " level %d, %dk chunk, algorithm %d", mddev->level, mddev->chunk_size >> 10, mddev->layout);
+	seq_printf (seq, " [%d/%d] [", conf->raid_disks, conf->working_disks);
 	for (i = 0; i < conf->raid_disks; i++)
-		sz += sprintf (page+sz, "%s",
+		seq_printf (seq, "%s",
 			       conf->disks[i].rdev &&
 			       conf->disks[i].rdev->in_sync ? "U" : "_");
-	sz += sprintf (page+sz, "]");
+	seq_printf (seq, "]");
 #if RAID5_DEBUG
 #define D(x) \
-	sz += sprintf (page+sz, "<"#x":%d>", atomic_read(&conf->x))
+	seq_printf (seq, "<"#x":%d>", atomic_read(&conf->x))
 	printall(conf);
 #endif
-	return sz;
 }
 
 static void print_raid5_conf (raid5_conf_t *conf)

--------------020908030102090708050204--

