From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 3 - Convert /proc/mdstat to use seq_file
Date: Thu, 13 Mar 2003 12:00:10 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18tH4s-0008I9-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Based on recent patch to 2.5

 ----------- Diffstat output ------------
 ./drivers/md/linear.c       |   16 +--
 ./drivers/md/md.c           |  216 +++++++++++++++++++++++++++++---------------
 ./drivers/md/multipath.c    |   11 +-
 ./drivers/md/raid0.c        |   25 ++---
 ./drivers/md/raid1.c        |   11 +-
 ./drivers/md/raid5.c        |   16 +--
 ./include/linux/raid/md.h   |    1 
 ./include/linux/raid/md_k.h |    2 
 8 files changed, 183 insertions(+), 115 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2003-03-12 11:57:52.000000000 +1100
+++ ./drivers/md/linear.c	2003-03-12 12:04:02.000000000 +1100
@@ -153,31 +153,29 @@ static int linear_make_request (mddev_t 
 	return 1;
 }
 
-static int linear_status (char *page, mddev_t *mddev)
+static void linear_status (struct seq_file *seq, mddev_t *mddev)
 {
-	int sz = 0;
 
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
 			partition_name(conf->hash_table[j].dev0->dev));
 
 		if (conf->hash_table[j].dev1)
-			sz += sprintf(page+sz, "/%s] ",
+			seq_printf(seq, "/%s] ",
 			  partition_name(conf->hash_table[j].dev1->dev));
 		else
-			sz += sprintf(page+sz, "] ");
+			seq_printf(seq, "] ");
 	}
-	sz += sprintf(page+sz, "\n");
+	seq_printf(seq, "\n");
 #endif
-	sz += sprintf(page+sz, " %dk rounding", mddev->param.chunk_size/1024);
-	return sz;
+	seq_printf(seq, " %dk rounding", mddev->param.chunk_size/1024);
 }
 
 

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-12 11:54:51.000000000 +1100
+++ ./drivers/md/md.c	2003-03-13 10:47:13.000000000 +1100
@@ -3065,13 +3065,13 @@ int md_error(mddev_t *mddev, kdev_t rdev
 	return 0;
 }
 
-static int status_unused(char * page)
+static int status_unused(struct seq_file *seq)
 {
-	int sz = 0, i = 0;
+	int i = 0;
 	mdk_rdev_t *rdev;
 	struct md_list_head *tmp;
 
-	sz += sprintf(page + sz, "unused devices: ");
+	seq_printf(seq, "unused devices: ");
 
 	ITERATE_RDEV_ALL(rdev,tmp) {
 		if (!rdev->same_set.next && !rdev->same_set.prev) {
@@ -3079,21 +3079,19 @@ static int status_unused(char * page)
 			 * The device is not yet used by any array.
 			 */
 			i++;
-			sz += sprintf(page + sz, "%s ",
+			seq_printf(seq, "%s ",
 				partition_name(rdev->dev));
 		}
 	}
 	if (!i)
-		sz += sprintf(page + sz, "<none>");
+		seq_printf(seq, "<none>");
 
-	sz += sprintf(page + sz, "\n");
-	return sz;
+	seq_printf(seq, "\n");
 }
 
 
-static int status_resync(char * page, mddev_t * mddev)
+static void status_resync(struct seq_file *seq, mddev_t * mddev)
 {
-	int sz = 0;
 	unsigned long max_blocks, resync, res, dt, db, rt;
 
 	resync = (mddev->curr_resync - atomic_read(&mddev->recovery_active))/2;
@@ -3102,32 +3100,31 @@ static int status_resync(char * page, md
 	/*
 	 * Should not happen.
 	 */
-	if (!max_blocks) {
+	if (!max_blocks)
 		MD_BUG();
-		return 0;
-	}
+
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
 	if (!mddev->recovery_running)
 		/*
 		 * true resync
 		 */
-		sz += sprintf(page + sz, " resync =%3lu.%lu%% (%lu/%lu)",
+		seq_printf(seq, " resync =%3lu.%lu%% (%lu/%lu)",
 				res/10, res % 10, resync, max_blocks);
 	else
 		/*
 		 * recovery ...
 		 */
-		sz += sprintf(page + sz, " recovery =%3lu.%lu%% (%lu/%lu)",
+		seq_printf(seq, " recovery =%3lu.%lu%% (%lu/%lu)",
 				res/10, res % 10, resync, max_blocks);
 
 	/*
@@ -3144,84 +3141,156 @@ static int status_resync(char * page, md
 	db = resync - (mddev->resync_mark_cnt/2);
 	rt = (dt * ((max_blocks-resync) / (db/100+1)))/100;
 
-	sz += sprintf(page + sz, " finish=%lu.%lumin", rt / 60, (rt % 60)/6);
+	seq_printf(seq, " finish=%lu.%lumin", rt / 60, (rt % 60)/6);
 
-	sz += sprintf(page + sz, " speed=%ldK/sec", db/dt);
+	seq_printf(seq, " speed=%ldK/sec", db/dt);
 
-	return sz;
 }
 
-static int md_status_read_proc(char *page, char **start, off_t off,
-			int count, int *eof, void *data)
+
+static void *md_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	int sz = 0, j, size;
-	struct md_list_head *tmp, *tmp2;
-	mdk_rdev_t *rdev;
+	struct list_head *tmp;
+	loff_t l = *pos;
 	mddev_t *mddev;
 
-	sz += sprintf(page + sz, "Personalities : ");
-	for (j = 0; j < MAX_PERSONALITY; j++)
-	if (pers[j])
-		sz += sprintf(page+sz, "[%s] ", pers[j]->name);
+	if (l > 0x10000)
+		return NULL;
+	if (!l--)
+		/* header */
+		return (void*)1;
+
+	list_for_each(tmp,&all_mddevs)
+		if (!l--) {
+			mddev = list_entry(tmp, mddev_t, all_mddevs);
+			return mddev;
+		}
+	return (void*)2;/* tail */
+}
+
+static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct list_head *tmp;
+	mddev_t *next_mddev, *mddev = v;
+	
+	++*pos;
+	if (v == (void*)2)
+		return NULL;
 
-	sz += sprintf(page+sz, "\n");
+	if (v == (void*)1)
+		tmp = all_mddevs.next;
+	else
+		tmp = mddev->all_mddevs.next;
+	if (tmp != &all_mddevs)
+		next_mddev = list_entry(tmp,mddev_t,all_mddevs);
+	else {
+		next_mddev = (void*)2;
+		*pos = 0x10000;
+	}		
 
+	return next_mddev;
 
-	sz += sprintf(page+sz, "read_ahead ");
-	if (read_ahead[MD_MAJOR] == INT_MAX)
-		sz += sprintf(page+sz, "not set\n");
-	else
-		sz += sprintf(page+sz, "%d sectors\n", read_ahead[MD_MAJOR]);
+}
 
-	ITERATE_MDDEV(mddev,tmp) {
-		sz += sprintf(page + sz, "md%d : %sactive", mdidx(mddev),
-						mddev->pers ? "" : "in");
-		if (mddev->pers) {
-			if (mddev->ro)
-				sz += sprintf(page + sz, " (read-only)");
-			sz += sprintf(page + sz, " %s", mddev->pers->name);
-		}
+static void md_seq_stop(struct seq_file *seq, void *v)
+{
 
-		size = 0;
-		ITERATE_RDEV(mddev,rdev,tmp2) {
-			sz += sprintf(page + sz, " %s[%d]",
-				partition_name(rdev->dev), rdev->desc_nr);
-			if (rdev->faulty) {
-				sz += sprintf(page + sz, "(F)");
-				continue;
-			}
-			size += rdev->size;
-		}
+}
 
-		if (mddev->nb_dev) {
-			if (mddev->pers)
-				sz += sprintf(page + sz, "\n      %d blocks",
-						 md_size[mdidx(mddev)]);
-			else
-				sz += sprintf(page + sz, "\n      %d blocks", size);
-		}
+static int md_seq_show(struct seq_file *seq, void *v)
+{
+	int j, size;
+	struct md_list_head *tmp2;
+	mdk_rdev_t *rdev;
+	mddev_t *mddev = v;
 
-		if (!mddev->pers) {
-			sz += sprintf(page+sz, "\n");
+	if (v == (void*)1) {
+		seq_printf(seq, "Personalities : ");
+		for (j = 0; j < MAX_PERSONALITY; j++)
+			if (pers[j])
+				seq_printf(seq, "[%s] ", pers[j]->name);
+
+		seq_printf(seq, "\n");
+		seq_printf(seq, "read_ahead ");
+		if (read_ahead[MD_MAJOR] == INT_MAX)
+			seq_printf(seq, "not set\n");
+		else
+			seq_printf(seq, "%d sectors\n", read_ahead[MD_MAJOR]);
+		return 0;
+	}
+	if (v == (void*)2) {
+		status_unused(seq);
+		return 0;
+	}
+
+	seq_printf(seq, "md%d : %sactive", mdidx(mddev),
+		   mddev->pers ? "" : "in");
+	if (mddev->pers) {
+		if (mddev->ro)
+			seq_printf(seq, " (read-only)");
+		seq_printf(seq, " %s", mddev->pers->name);
+	}
+	
+	size = 0;
+	ITERATE_RDEV(mddev,rdev,tmp2) {
+		seq_printf(seq, " %s[%d]",
+			   partition_name(rdev->dev), rdev->desc_nr);
+		if (rdev->faulty) {
+			seq_printf(seq, "(F)");
 			continue;
 		}
+		size += rdev->size;
+	}
 
-		sz += mddev->pers->status (page+sz, mddev);
+	if (mddev->nb_dev) {
+		if (mddev->pers)
+			seq_printf(seq, "\n      %d blocks",
+				   md_size[mdidx(mddev)]);
+		else
+			seq_printf(seq, "\n      %d blocks", size);
+	}
+
+	if (mddev->pers) {
 
-		sz += sprintf(page+sz, "\n      ");
+		mddev->pers->status (seq, mddev);
+
+		seq_printf(seq, "\n      ");
 		if (mddev->curr_resync) {
-			sz += status_resync (page+sz, mddev);
+			status_resync (seq, mddev);
 		} else {
 			if (sem_getcount(&mddev->resync_sem) != 1)
-				sz += sprintf(page + sz, "	resync=DELAYED");
+				seq_printf(seq, "	resync=DELAYED");
 		}
-		sz += sprintf(page + sz, "\n");
 	}
-	sz += status_unused(page + sz);
+	seq_printf(seq, "\n");
+
+	return 0;
+}
 
-	return sz;
+  
+static struct seq_operations md_seq_ops = {
+	.start  = md_seq_start,
+	.next   = md_seq_next,
+	.stop   = md_seq_stop,
+	.show   = md_seq_show,
+};
+
+static int md_seq_open(struct inode *inode, struct file *file)
+{
+	int error;
+
+	error = seq_open(file, &md_seq_ops);
+	return error;
 }
 
+static struct file_operations md_seq_fops = {
+	.open           = md_seq_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release	= seq_release,
+};
+
+
 int register_md_personality(int pnum, mdk_personality_t *p)
 {
 	if (pnum >= MAX_PERSONALITY) {
@@ -3621,6 +3690,7 @@ struct notifier_block md_notifier = {
 
 static void md_geninit(void)
 {
+	struct proc_dir_entry *p;
 	int i;
 
 	for(i = 0; i < MAX_MD_DEVS; i++) {
@@ -3637,7 +3707,9 @@ static void md_geninit(void)
 	dprintk("md: sizeof(mdp_super_t) = %d\n", (int)sizeof(mdp_super_t));
 
 #ifdef CONFIG_PROC_FS
-	create_proc_read_entry("mdstat", 0, NULL, md_status_read_proc, NULL);
+	p = create_proc_entry("mdstat", S_IRUGO, NULL);
+	if (p)
+		p->proc_fops = &md_seq_fops;
 #endif
 }
 

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2003-03-12 11:57:52.000000000 +1100
+++ ./drivers/md/multipath.c	2003-03-13 09:52:01.000000000 +1100
@@ -281,18 +281,17 @@ static int multipath_make_request (mddev
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
 			conf->multipaths[i].operational ? "U" : "_");
-	sz += sprintf (page+sz, "]");
-	return sz;
+	seq_printf (seq, "]");
 }
 
 #define LAST_DISK KERN_ALERT \

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-03-12 11:57:53.000000000 +1100
+++ ./drivers/md/raid0.c	2003-03-12 12:06:04.000000000 +1100
@@ -289,41 +289,40 @@ bad_zone1:
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
-			sz += sprintf (page+sz, "%s/", partition_name(
+			seq_printf (seq, "%s/", partition_name(
 				conf->strip_zone[j].dev[k]->dev));
-		sz--;
-		sz += sprintf (page+sz, "] zo=%d do=%d s=%d\n",
+
+		seq_printf (seq, "] zo=%d do=%d s=%d\n",
 				conf->strip_zone[j].zone_offset,
 				conf->strip_zone[j].dev_offset,
 				conf->strip_zone[j].size);
 	}
 #endif
-	sz += sprintf(page + sz, " %dk chunks", mddev->param.chunk_size/1024);
-	return sz;
+	seq_printf(seq, " %dk chunks", mddev->param.chunk_size/1024);
+	return;
 }
 
 static mdk_personality_t raid0_personality=

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-03-12 11:57:53.000000000 +1100
+++ ./drivers/md/raid1.c	2003-03-12 12:11:13.000000000 +1100
@@ -719,18 +719,17 @@ static int raid1_make_request (mddev_t *
 	return (0);
 }
 
-static int raid1_status (char *page, mddev_t *mddev)
+static void raid1_status(struct seq_file *seq, mddev_t *mddev)
 {
 	raid1_conf_t *conf = mddev_to_conf(mddev);
-	int sz = 0, i;
+	int i;
 	
-	sz += sprintf (page+sz, " [%d/%d] [", conf->raid_disks,
+	seq_printf(seq, " [%d/%d] [", conf->raid_disks,
 						 conf->working_disks);
 	for (i = 0; i < conf->raid_disks; i++)
-		sz += sprintf (page+sz, "%s",
+		seq_printf(seq, "%s",
 			conf->mirrors[i].operational ? "U" : "_");
-	sz += sprintf (page+sz, "]");
-	return sz;
+	seq_printf(seq, "]");
 }
 
 #define LAST_DISK KERN_ALERT \

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-03-12 11:57:53.000000000 +1100
+++ ./drivers/md/raid5.c	2003-03-13 09:49:58.000000000 +1100
@@ -1681,23 +1681,23 @@ static void printall (raid5_conf_t *conf
 }
 #endif
 
-static int raid5_status (char *page, mddev_t *mddev)
+static void raid5_status (struct seq_file *seq, mddev_t *mddev)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	mdp_super_t *sb = mddev->sb;
-	int sz = 0, i;
+	int i;
 
-	sz += sprintf (page+sz, " level %d, %dk chunk, algorithm %d", sb->level, sb->chunk_size >> 10, sb->layout);
-	sz += sprintf (page+sz, " [%d/%d] [", conf->raid_disks, conf->working_disks);
+	seq_printf (seq, " level %d, %dk chunk, algorithm %d", sb->level, sb->chunk_size >> 10, sb->layout);
+	seq_printf (seq, " [%d/%d] [", conf->raid_disks, conf->working_disks);
 	for (i = 0; i < conf->raid_disks; i++)
-		sz += sprintf (page+sz, "%s", conf->disks[i].operational ? "U" : "_");
-	sz += sprintf (page+sz, "]");
+		seq_printf (seq, "%s", conf->disks[i].operational ? "U" : "_");
+	seq_printf (seq, "]");
 #if RAID5_DEBUG
 #define D(x) \
-	sz += sprintf (page+sz, "<"#x":%d>", atomic_read(&conf->x))
+	seq_printf (seq, "<"#x":%d>", atomic_read(&conf->x))
 	printall(conf);
 #endif
-	return sz;
+
 }
 
 static void print_raid5_conf (raid5_conf_t *conf)

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2003-03-12 11:57:53.000000000 +1100
+++ ./include/linux/raid/md.h	2003-03-13 09:51:03.000000000 +1100
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/hdreg.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <net/checksum.h>

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2003-03-12 11:57:53.000000000 +1100
+++ ./include/linux/raid/md_k.h	2003-03-13 09:49:51.000000000 +1100
@@ -224,7 +224,7 @@ struct mdk_personality_s
 	int (*make_request)(mddev_t *mddev, int rw, struct buffer_head * bh);
 	int (*run)(mddev_t *mddev);
 	int (*stop)(mddev_t *mddev);
-	int (*status)(char *page, mddev_t *mddev);
+	void (*status)(struct seq_file *seq, mddev_t *mddev);
 	int (*error_handler)(mddev_t *mddev, kdev_t dev);
 
 /*
