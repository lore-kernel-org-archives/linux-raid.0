From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 2 - Add name of md device to name of thread managing that device.
Date: Tue, 11 Feb 2003 15:41:27 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18iSEZ-0008I2-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
This allows us to locate and in particular signal the thead that manages 
a particular device.  The next patch will do something with that signal.

 ----------- Diffstat output ------------
 ./drivers/md/raid1.c         |    4 ++--
 ./drivers/md/raid5.c         |    4 ++--
 ./include/linux/raid/md_k.h  |    1 +
 ./include/linux/raid/raid1.h |    1 +
 ./include/linux/raid/raid5.h |    1 +
 5 files changed, 7 insertions(+), 4 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-02-11 14:25:46.000000000 +1100
+++ ./drivers/md/raid1.c	2003-02-11 14:25:46.000000000 +1100
@@ -1184,9 +1184,9 @@ static int run(mddev_t *mddev)
 
 
 	{
-		const char * name = "raid1d";
+		snprintf(conf->thread_name,MD_THREAD_NAME_MAX,"raid1d_md%d",mdidx(mddev));
 
-		conf->thread = md_register_thread(raid1d, conf, name);
+		conf->thread = md_register_thread(raid1d, conf, conf->thread_name);
 		if (!conf->thread) {
 			printk(THREAD_ERROR, mdidx(mddev));
 			goto out_free_conf;

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-02-11 14:25:46.000000000 +1100
+++ ./drivers/md/raid5.c	2003-02-11 14:25:46.000000000 +1100
@@ -1477,9 +1477,9 @@ static int run (mddev_t *mddev)
 	}
 
 	{
-		const char * name = "raid5d";
+		snprintf(conf->thread_name,MD_THREAD_NAME_MAX,"raid5d_md%d",mdidx(mddev));
 
-		conf->thread = md_register_thread(raid5d, conf, name);
+		conf->thread = md_register_thread(raid5d, conf, conf->thread_name);
 		if (!conf->thread) {
 			printk(KERN_ERR "raid5: couldn't allocate thread for md%d\n", mdidx(mddev));
 			goto abort;

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2003-02-11 14:25:46.000000000 +1100
+++ ./include/linux/raid/md_k.h	2003-02-11 14:25:46.000000000 +1100
@@ -29,6 +29,7 @@
 #define	LEVEL_LINEAR		(-1)
 
 #define MaxSector (~(sector_t)0)
+#define MD_THREAD_NAME_MAX 14
 
 static inline int pers_to_level (int pers)
 {

diff ./include/linux/raid/raid1.h~current~ ./include/linux/raid/raid1.h
--- ./include/linux/raid/raid1.h~current~	2003-02-11 14:25:46.000000000 +1100
+++ ./include/linux/raid/raid1.h	2003-02-11 14:25:46.000000000 +1100
@@ -34,6 +34,7 @@ struct r1_private_data_s {
 
 	mempool_t *r1bio_pool;
 	mempool_t *r1buf_pool;
+	char thread_name[MD_THREAD_NAME_MAX];
 };
 
 typedef struct r1_private_data_s conf_t;

diff ./include/linux/raid/raid5.h~current~ ./include/linux/raid/raid5.h
--- ./include/linux/raid/raid5.h~current~	2003-02-11 14:25:46.000000000 +1100
+++ ./include/linux/raid/raid5.h	2003-02-11 14:25:46.000000000 +1100
@@ -226,6 +226,7 @@ struct raid5_private_data {
 							 * waiting for 25% to be free
 							 */        
 	spinlock_t		device_lock;
+	char			thread_name[MD_THREAD_NAME_MAX];
 };
 
 typedef struct raid5_private_data raid5_conf_t;
