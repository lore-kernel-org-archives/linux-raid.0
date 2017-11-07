From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: [PATCH] sysfs: include faulty drive in disk count
Date: Tue,  7 Nov 2017 16:49:56 +0100
Message-ID: <1510069796-17515-1-git-send-email-mariusz.tkaczyk@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
List-Id: linux-raid.ids

When the disk fails, it goes into faulty state first and it is removed
from the array in a while. It gives mdadm monitor a chance to see the disk
has failed and notify an event (e.g. FailSpare). It doesn't work when 
sysfs is used to get a number of disks in the array as it skips faulty
disk. ioctl implementation doesn't differentiate between active and
faulty disk. Do the same for sysfs then. It should not matter that number
of disks reported is greater than list of disk structures returned by the
call because the same approach already takes place for offline disks.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sysfs.c b/sysfs.c
index bf5c8c5..df6fdda 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -307,6 +307,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 		dev->disk.raid_disk = strtoul(buf, &ep, 10);
 		if (*ep) dev->disk.raid_disk = -1;
 
+		sra->array.nr_disks++;
 		strcpy(dbase, "block/dev");
 		if (load_sys(fname, buf, sizeof(buf))) {
 			/* assume this is a stale reference to a hot
@@ -315,7 +316,6 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 			free(dev);
 			continue;
 		}
-		sra->array.nr_disks++;
 		sscanf(buf, "%d:%d", &dev->disk.major, &dev->disk.minor);
 
 		/* special case check for block devices that can go 'offline' */
-- 
1.8.3.1

