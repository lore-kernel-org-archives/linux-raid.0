From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - Convert Struct initialised in md to "the new way"
Date: Wed, 24 Jul 2002 22:40:31 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15678.41023.358517.85560@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids





 ----------- Diffstat output ------------
 ./drivers/md/linear.c    |   10 +++++-----
 ./drivers/md/md.c        |   30 +++++++++++++++---------------
 ./drivers/md/multipath.c |   16 ++++++++--------
 ./drivers/md/raid0.c     |   10 +++++-----
 ./drivers/md/raid1.c     |   24 ++++++++++++------------
 ./drivers/md/raid5.c     |   24 ++++++++++++------------
 6 files changed, 57 insertions(+), 57 deletions(-)

--- ./drivers/md/md.c	2002/07/24 11:18:32	1.2
+++ ./drivers/md/md.c	2002/07/24 12:21:21	1.3
@@ -118,14 +118,14 @@ static devfs_handle_t devfs_handle;
 
 static struct gendisk md_gendisk=
 {
-	major: MD_MAJOR,
-	major_name: "md",
-	minor_shift: 0,
-	part: md_hd_struct,
-	sizes: md_size,
-	nr_real: MAX_MD_DEVS,
-	next: NULL,
-	fops: &md_fops,
+	.major		= MD_MAJOR,
+	.major_name	= "md",
+	.minor_shift	= 0,
+	.part		= md_hd_struct,
+	.sizes		= md_size,
+	.nr_real	= MAX_MD_DEVS,
+	.next		= NULL,
+	.fops		= &md_fops,
 };
 
 /*
@@ -2496,10 +2496,10 @@ static int md_release(struct inode *inod
 
 static struct block_device_operations md_fops =
 {
-	owner:		THIS_MODULE,
-	open:		md_open,
-	release:	md_release,
-	ioctl:		md_ioctl,
+	.owner		= THIS_MODULE,
+	.open		= md_open,
+	.release	= md_release,
+	.ioctl		= md_ioctl,
 };
 
 
@@ -3187,9 +3187,9 @@ int md_notify_reboot(struct notifier_blo
 }
 
 struct notifier_block md_notifier = {
-	notifier_call:	md_notify_reboot,
-	next:		NULL,
-	priority:	INT_MAX, /* before any real devices */
+	.notifier_call	= md_notify_reboot,
+	.next		= NULL,
+	.priority	= INT_MAX, /* before any real devices */
 };
 
 static void md_geninit(void)
--- ./drivers/md/linear.c	2002/07/24 11:24:01	1.1
+++ ./drivers/md/linear.c	2002/07/24 12:21:22	1.2
@@ -193,11 +193,11 @@ static int linear_status (char *page, md
 
 static mdk_personality_t linear_personality=
 {
-	name:		"linear",
-	make_request:	linear_make_request,
-	run:		linear_run,
-	stop:		linear_stop,
-	status:		linear_status,
+	.name		= "linear",
+	.make_request	= linear_make_request,
+	.run		= linear_run,
+	.stop		= linear_stop,
+	.status		= linear_status,
 };
 
 static int __init linear_init (void)
--- ./drivers/md/raid0.c	2002/07/24 11:24:23	1.1
+++ ./drivers/md/raid0.c	2002/07/24 12:21:22	1.2
@@ -366,11 +366,11 @@ static int raid0_status (char *page, mdd
 
 static mdk_personality_t raid0_personality=
 {
-	name:		"raid0",
-	make_request:	raid0_make_request,
-	run:		raid0_run,
-	stop:		raid0_stop,
-	status:		raid0_status,
+	.name		= "raid0",
+	.make_request	= raid0_make_request,
+	.run		= raid0_run,
+	.stop		= raid0_stop,
+	.status		= raid0_status,
 };
 
 static int __init raid0_init (void)
--- ./drivers/md/raid1.c	2002/07/24 11:25:06	1.1
+++ ./drivers/md/raid1.c	2002/07/24 12:21:22	1.2
@@ -1346,18 +1346,18 @@ static int stop(mddev_t *mddev)
 
 static mdk_personality_t raid1_personality =
 {
-	name:		"raid1",
-	make_request:	make_request,
-	run:		run,
-	stop:		stop,
-	status:		status,
-	error_handler:	error,
-	hot_add_disk:	raid1_add_disk,
-	hot_remove_disk:raid1_remove_disk,
-	spare_write:	raid1_spare_write,
-	spare_inactive:	raid1_spare_inactive,
-	spare_active:	raid1_spare_active,
-	sync_request:	sync_request
+	.name		= "raid1",
+	.make_request	= make_request,
+	.run		= run,
+	.stop		= stop,
+	.status		= status,
+	.error_handler	= error,
+	.hot_add_disk	= raid1_add_disk,
+	.hot_remove_disk= raid1_remove_disk,
+	.spare_write	= raid1_spare_write,
+	.spare_inactive	= raid1_spare_inactive,
+	.spare_active	= raid1_spare_active,
+	.sync_request	= sync_request,
 };
 
 static int __init raid_init(void)
--- ./drivers/md/raid5.c	2002/07/24 11:26:05	1.1
+++ ./drivers/md/raid5.c	2002/07/24 12:21:22	1.2
@@ -1820,18 +1820,18 @@ static int raid5_add_disk(mddev_t *mddev
 
 static mdk_personality_t raid5_personality=
 {
-	name:		"raid5",
-	make_request:	make_request,
-	run:		run,
-	stop:		stop,
-	status:		status,
-	error_handler:	error,
-	hot_add_disk:	raid5_add_disk,
-	hot_remove_disk:raid5_remove_disk,
-	spare_write:	raid5_spare_write,
-	spare_inactive:	raid5_spare_inactive,
-	spare_active:	raid5_spare_active,
-	sync_request:	sync_request
+	.name		= "raid5",
+	.make_request	= make_request,
+	.run		= run,
+	.stop		= stop,
+	.status		= status,
+	.error_handler	= error,
+	.hot_add_disk	= raid5_add_disk,
+	.hot_remove_disk= raid5_remove_disk,
+	.spare_write	= raid5_spare_write,
+	.spare_inactive	= raid5_spare_inactive,
+	.spare_active	= raid5_spare_active,
+	.sync_request	= sync_request,
 };
 
 static int __init raid5_init (void)
--- ./drivers/md/multipath.c	2002/07/24 11:27:01	1.1
+++ ./drivers/md/multipath.c	2002/07/24 12:21:22	1.2
@@ -562,14 +562,14 @@ static int multipath_stop (mddev_t *mdde
 
 static mdk_personality_t multipath_personality=
 {
-	name:		"multipath",
-	make_request:	multipath_make_request,
-	run:		multipath_run,
-	stop:		multipath_stop,
-	status:		multipath_status,
-	error_handler:	multipath_error,
-	hot_add_disk:	multipath_add_disk,
-	hot_remove_disk:multipath_remove_disk,
+	.name		= "multipath",
+	.make_request	= multipath_make_request,
+	.run		= multipath_run,
+	.stop		= multipath_stop,
+	.status		= multipath_status,
+	.error_handler	= multipath_error,
+	.hot_add_disk	= multipath_add_disk,
+	.hot_remove_disk= multipath_remove_disk,
 };
 
 static int __init multipath_init (void)
