From: "Sean Kormilo" <skormilo@nortelnetworks.com>
Subject: RE: Ways to query RAID status
Date: 14 Apr 2003 14:49:51 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1050346191.13718.63.camel@pcary03q.ca.nortel.com>
References: <05331901808F5A4CAEEAD68170C528282DF2D0@molokai.stoneflynetworks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-iwkhAv5sOoKxcCNV1ASJ"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <05331901808F5A4CAEEAD68170C528282DF2D0@molokai.stoneflynetworks.com>
To: Vicky Gonzalez <vgonzalez@stoneflynetworks.com>
Cc: Linux-RAID mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-iwkhAv5sOoKxcCNV1ASJ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Vicky,

> 
> I am currently monitoring the /proc/mdstat file for the current status, i.e. if there was a Failure detected, if it is currently in the rebuild stage and if there is only one disk currently active, as well as if it is in a good state. This is being done from a perl daemon that is a System V startup process, but it can easily be moved to a C program. 
> 
> What some initial testing has found is that during the query of the mdstat file, it was preventing some of our other processes from running. The initial theory is that the opening/closing of the mdstat file to read it is the culprit. So I am looking into moving it to C and monitoring it via an ioctl call with the hopes of streamlining the status checking process. 
> 
> Where would I find the appropriate ioctl calls to make in my program? 
> 
> Thanks again Sean for the quick response.

Just in case you want it, I've attached my rebuild ioctl patch to this
email.

The md user interface ioctls are defined in the
include/linux/raid/md_u.h file in the kernel source directory.

That being said, I'd still recommend looking at mdadm since it has the
ability to monitor raid arrays. It may already do what you want to do
and save you the hassel of building your own.

Sean.


-- 

Sean C. Kormilo, STORM Software Architect, Nortel Networks
              email: skormilo@nortelnetworks.com
  

--=-iwkhAv5sOoKxcCNV1ASJ
Content-Disposition: attachment; filename=md_get_rebuild_info.patch
Content-Type: text/x-patch; name=md_get_rebuild_info.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 7bit

diff -Naur patch/linux/drivers/md/md.c patch/kernel_patch_source/drivers/md/md.c
--- patch/linux/drivers/md/md.c	Mon Jul  8 15:27:32 2002
+++ patch/kernel_patch_source/drivers/md/md.c	Mon Jul  8 15:25:02 2002
@@ -2148,6 +2148,64 @@
 }
 #undef SET_FROM_SB
 
+static int get_array_rebuild_info(mddev_t * mddev, void * arg)
+{
+	/* state values: 0=no rebuild, 1=rebuilding, 2=delayed */
+
+	mdu_array_rebuild_info_t info;
+	unsigned long  dt, db;
+
+	memset(&info, 0, sizeof(mdu_array_rebuild_info_t));
+	
+	if (mddev->curr_resync) {
+		info.state = 1; /* rebuilding now */
+		
+	} else {
+		if (md_atomic_read(&mddev->resync_sem.count) != 1)
+			info.state = 2; /* delayed sync */
+	}
+
+	if( info.state != 1 )
+		goto get_array_rebuild_done;
+	
+	info.resync_blocks = 
+		(mddev->curr_resync - atomic_read(&mddev->recovery_active))/2;
+
+	info.max_blocks = mddev->sb->size;	
+
+	/*
+	 * Should not happen.
+	 */
+	if (!info.max_blocks) {
+		MD_BUG();
+		return 0;
+	}
+
+	/*
+	 * We do not want to overflow, so the order of operands and
+	 * the * 100 / 100 trick are important. We do a +1 to be
+	 * safe against division by zero. We only estimate anyway.
+	 *
+	 * dt: time from mark until now
+	 * db: blocks written from mark until now
+	 * rt: remaining time
+	 */
+	dt = ((jiffies - mddev->resync_mark) / HZ);
+	if (!dt) dt++;
+	db = info.resync_blocks - (mddev->resync_mark_cnt/2);
+	info.time_remaining = 
+		(dt * ((info.max_blocks-info.resync_blocks) / (db/100+1)))/100;
+	
+	info.speed = db/dt;
+
+ get_array_rebuild_done:
+
+	if (md_copy_to_user(arg, &info, sizeof(info)))
+		return -EFAULT;
+
+	return 0;
+}
+
 #define SET_FROM_SB(x) info.x = mddev->sb->disks[nr].x
 static int get_disk_info(mddev_t * mddev, void * arg)
 {
@@ -2736,6 +2794,10 @@
 		case GET_ARRAY_INFO:
 			err = get_array_info(mddev, (void *)arg);
 			goto done_unlock;
+
+	case GET_ARRAY_REBUILD_INFO:
+		err = get_array_rebuild_info(mddev, (void *) arg);
+		goto done_unlock;
 
 		case GET_DISK_INFO:
 			err = get_disk_info(mddev, (void *)arg);
diff -Naur patch/linux/include/linux/raid/md_u.h patch/kernel_patch_source/include/linux/raid/md_u.h
--- patch/linux/include/linux/raid/md_u.h	Mon Jul  8 15:27:32 2002
+++ patch/kernel_patch_source/include/linux/raid/md_u.h	Mon Jul  8 14:54:55 2002
@@ -23,6 +23,7 @@
 #define GET_DISK_INFO		_IOR (MD_MAJOR, 0x12, mdu_disk_info_t)
 #define PRINT_RAID_DEBUG	_IO (MD_MAJOR, 0x13)
 #define RAID_AUTORUN		_IO (MD_MAJOR, 0x14)
+#define GET_ARRAY_REBUILD_INFO  _IOR (MD_MAJOR, 0x15, mdu_array_rebuild_info_t)
 
 /* configuration */
 #define CLEAR_ARRAY		_IO (MD_MAJOR, 0x20)
@@ -82,6 +83,19 @@
 	int chunk_size;	/*  1 chunk size in bytes		      */
 
 } mdu_array_info_t;
+
+typedef struct mdu_array_rebuild_info_s {
+	/*
+	 *  rebuild status of one particular array
+	 */
+	int state; /* 0=no rebuild, 1=rebuilding, 2=delayed */
+	unsigned long resync_blocks;
+	unsigned long max_blocks;
+	unsigned long time_remaining;
+	unsigned long speed;
+	
+} mdu_array_rebuild_info_t;
+
 
 typedef struct mdu_disk_info_s {
 	/*
diff -Naur patch/linux/md_get_rebuild_info.patch patch/kernel_patch_source/md_get_rebuild_info.patch
--- patch/linux/md_get_rebuild_info.patch	Wed Dec 31 19:00:00 1969
+++ patch/kernel_patch_source/md_get_rebuild_info.patch	Mon Jul  8 15:27:32 2002
@@ -0,0 +1,110 @@
+diff -Naur patch/linux/drivers/md/md.c patch/kernel_patch_source/drivers/md/md.c
+--- patch/linux/drivers/md/md.c	Mon Jul  8 15:27:32 2002
++++ patch/kernel_patch_source/drivers/md/md.c	Mon Jul  8 15:25:02 2002
+@@ -2148,6 +2148,64 @@
+ }
+ #undef SET_FROM_SB
+ 
++static int get_array_rebuild_info(mddev_t * mddev, void * arg)
++{
++	/* state values: 0=no rebuild, 1=rebuilding, 2=delayed */
++
++	mdu_array_rebuild_info_t info;
++	unsigned long  dt, db;
++
++	memset(&info, 0, sizeof(mdu_array_rebuild_info_t));
++	
++	if (mddev->curr_resync) {
++		info.state = 1; /* rebuilding now */
++		
++	} else {
++		if (md_atomic_read(&mddev->resync_sem.count) != 1)
++			info.state = 2; /* delayed sync */
++	}
++
++	if( info.state != 1 )
++		goto get_array_rebuild_done;
++	
++	info.resync_blocks = 
++		(mddev->curr_resync - atomic_read(&mddev->recovery_active))/2;
++
++	info.max_blocks = mddev->sb->size;	
++
++	/*
++	 * Should not happen.
++	 */
++	if (!info.max_blocks) {
++		MD_BUG();
++		return 0;
++	}
++
++	/*
++	 * We do not want to overflow, so the order of operands and
++	 * the * 100 / 100 trick are important. We do a +1 to be
++	 * safe against division by zero. We only estimate anyway.
++	 *
++	 * dt: time from mark until now
++	 * db: blocks written from mark until now
++	 * rt: remaining time
++	 */
++	dt = ((jiffies - mddev->resync_mark) / HZ);
++	if (!dt) dt++;
++	db = info.resync_blocks - (mddev->resync_mark_cnt/2);
++	info.time_remaining = 
++		(dt * ((info.max_blocks-info.resync_blocks) / (db/100+1)))/100;
++	
++	info.speed = db/dt;
++
++ get_array_rebuild_done:
++
++	if (md_copy_to_user(arg, &info, sizeof(info)))
++		return -EFAULT;
++
++	return 0;
++}
++
+ #define SET_FROM_SB(x) info.x = mddev->sb->disks[nr].x
+ static int get_disk_info(mddev_t * mddev, void * arg)
+ {
+@@ -2736,6 +2794,10 @@
+ 		case GET_ARRAY_INFO:
+ 			err = get_array_info(mddev, (void *)arg);
+ 			goto done_unlock;
++
++	case GET_ARRAY_REBUILD_INFO:
++		err = get_array_rebuild_info(mddev, (void *) arg);
++		goto done_unlock;
+ 
+ 		case GET_DISK_INFO:
+ 			err = get_disk_info(mddev, (void *)arg);
+diff -Naur patch/linux/include/linux/raid/md_u.h patch/kernel_patch_source/include/linux/raid/md_u.h
+--- patch/linux/include/linux/raid/md_u.h	Mon Jul  8 15:27:32 2002
++++ patch/kernel_patch_source/include/linux/raid/md_u.h	Mon Jul  8 14:54:55 2002
+@@ -23,6 +23,7 @@
+ #define GET_DISK_INFO		_IOR (MD_MAJOR, 0x12, mdu_disk_info_t)
+ #define PRINT_RAID_DEBUG	_IO (MD_MAJOR, 0x13)
+ #define RAID_AUTORUN		_IO (MD_MAJOR, 0x14)
++#define GET_ARRAY_REBUILD_INFO  _IOR (MD_MAJOR, 0x15, mdu_array_rebuild_info_t)
+ 
+ /* configuration */
+ #define CLEAR_ARRAY		_IO (MD_MAJOR, 0x20)
+@@ -82,6 +83,19 @@
+ 	int chunk_size;	/*  1 chunk size in bytes		      */
+ 
+ } mdu_array_info_t;
++
++typedef struct mdu_array_rebuild_info_s {
++	/*
++	 *  rebuild status of one particular array
++	 */
++	int state; /* 0=no rebuild, 1=rebuilding, 2=delayed */
++	unsigned long resync_blocks;
++	unsigned long max_blocks;
++	unsigned long time_remaining;
++	unsigned long speed;
++	
++} mdu_array_rebuild_info_t;
++
+ 
+ typedef struct mdu_disk_info_s {
+ 	/*

--=-iwkhAv5sOoKxcCNV1ASJ--

