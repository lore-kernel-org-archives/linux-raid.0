From: Chuck Ebbert <76306.1226@compuserve.com>
Subject: Re: [PATCH] raid1d bugfix/2.4
Date: Wed, 9 Apr 2003 02:19:05 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200304090222_MC3-1-33A7-11C5@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain;
	 charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:


>> 
>>   The second 'if' is assuming that conf->last_used can't change during
>> rebuild,
>> but it can (line 1419):
>> 
>> 
>> 	disk = conf->last_used;
>> 	/* make sure disk is operational */
>> 	while (!conf->mirrors[disk].operational) {
>> 		if (disk <= 0) disk = conf->raid_disks;
>> 		disk--;
>> 		if (disk == conf->last_used)
>> 			break;
>> 	}
>> 	conf->last_used = disk;
>> 
>> 
>>   This could only happen if a second disk failed during rebuild of a 3+
>> disk array.
>
>True, but if a disk fails during a rebuild the rebuild is aborted, so
>it doesn't really matter.


 Even on a 3-disk mirror where there's a good data disk left to rebuild
from?
That sounds bad, and it looked to me like the code I quoted was looking for
another working drive if one failed during rebuild/resync.


>However there are more cosmetic changes than real content, making it
>harder for me to find the significant change.  It is much easier to
>read a patch if it just does one thing.

diff -u --exclude-from=/home/me/.exclude -r linux-2.4.21-pre6-ref/drivers/md/raid1.c pre6-raid1d-a/drivers/md/raid1.c
--- linux-2.4.21-pre6-ref/drivers/md/raid1.c	Thu Apr  3 13:21:37 2003
+++ pre6-raid1d-a/drivers/md/raid1.c	Wed Apr  9 01:24:06 2003
@ -1188,7 +1188,7 @
 				for (i = 0; i < disks ; i++) {
 					if (!conf->mirrors[i].operational)
 						continue;
-					if (i==conf->last_used)
+					if (conf->mirrors[i].dev == bh->b_dev)
 						/* we read from here, no need to write */
 						continue;
 					if (i < conf->raid_disks



I rebuilt a mirror with this patch (cut from a larger one)
applied to 2.4.20aa1 and it didn't complain:


@@ -1160,6 +1174,7 @@
 	raid1_conf_t *conf = data;
 	mddev_t *mddev = conf->mddev;
 	kdev_t dev;
+	static int _warned = 0; /* FIXME debug */
 
 	if (mddev->sb_dirty)
 		md_update_sb(mddev);
@ -1191,7 +1206,14 @
 						continue;
 					if (i==conf->last_used)
 						/* we read from here, no need to write */
+					{	/* FIXME just checking */
+						if (_warned < 5
+						    && conf->mirrors[i].dev != bh->b_dev) {
+							printk(KERN_WARNING "raid1d: dev != b_dev");
+							_warned++;
+						}
 						continue;
+					}
 					if (i < conf->raid_disks
 					    && !conf->resync_mirrors)
 						/* don't need to write this,


--
 Chuck
 I am not a number!
