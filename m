From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: Set disk faulty / hot disk remove ioctl bug for read-only MD?
Date: Tue, 12 Feb 2013 16:05:18 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1302121559540.11804@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,

I believe I found a bug when failing and removing component devices from 
read-only and auto-read-only MD RAID devices.

Prior to commit 1ca69c4b "md: avoid taking the mutex on some ioctls", when
failing a read-only MD device component via mdadm --fail, EROFS was
returned.  Failing (and removing) auto-read-only components was permitted.

After the change, MD allows the failure of component devices for both
read-only and auto-read-only RAID devices.  Running mdadm --remove will
return EROFS when attempted on a read-only device.

It gets a little interesting when trying to remove a component from an
auto-read-only MD.  The *first* attempt will fail with EBUSY as the rdev
was left in the Blocked state by the SET_DISK_FAULTY ioctl.  However,
because the HOT_REMOVE_DISK ioctl made it through to the "switch to rw mode
if started auto-readonly" code, it has been transitioned to read-write. 
Subsequent trips through the device's mddev->thread may clear the Blocked
flag via md_update_sb (should the reconfig_mutex be available).  A second or
third attempt at removing the failed component from the auto-read-only MD
would then succeed.

* After 1ca69c4b:

  ** Remove from auto-read-only:

  % cat /proc/mdstat 
  md124 : active (auto-read-only) raid1 sdr3[4] sdq3[2]
        4192192 blocks super 1.2 [2/2] [UU]
        bitmap: 0/1 pages [0KB], 65536KB chunk
  
  % mdadm --fail /dev/md124 /dev/sdq3 
  mdadm: set /dev/sdq3 faulty in /dev/md124
  
  % cat /sys/block/md124/md/dev-sdq3/state
  faulty,blocked
  
  % mdadm --remove /dev/md124 /dev/sdq3 
  mdadm: hot remove failed for /dev/sdq3: Device or resource busy
  
  % cat /sys/block/md124/md/dev-sdq3/state
  faulty
  
  % mdadm --remove /dev/md124 /dev/sdq3 
  mdadm: hot removed /dev/sdq3 from /dev/md124


  ** Remove from read-only MD:

  % mdadm --add /dev/md124 /dev/sdq3
  % mdadm --readonly /dev/md124
  % mdadm --fail /dev/md124 /dev/sdq3 
  mdadm: set /dev/sdq3 faulty in /dev/md124

  % cat /sys/block/md124/md/dev-sdq3/state
  faulty,blocked

  % mdadm --remove /dev/md124 /dev/sdq3 
  mdadm: hot remove failed for /dev/sdq3: Read-only file system


* After patch pasted at bottom of email:

  ** Remove from auto-read-only:

  % cat /proc/mdstat
  md124 : active (auto-read-only) raid1 sdq3[2] sdr3[4]
        4192192 blocks super 1.2 [2/2] [UU]
        bitmap: 0/1 pages [0KB], 65536KB chunk

  % mdadm --fail /dev/md124 /dev/sdq3
  mdadm: set /dev/sdq3 faulty in /dev/md124

  % cat /sys/block/md124/md/dev-sdq3/state
  faulty

  % mdadm --remove /dev/md124 /dev/sdq3
  mdadm: hot removed /dev/sdq3 from /dev/md124


  ** Remove from read-only MD:

  % mdadm --add /dev/md124 /dev/sdq3
  % mdadm --readonly /dev/md124
  % mdadm --fail /dev/md124 /dev/sdq3
  mdadm: set device faulty failed for /dev/sdq3:  Read-only file system

  % cat /sys/block/md124/md/dev-sdq3/state
  in_sync

  % cat /proc/mdstat
  md124 : active (read-only) raid1 sdq3[2] sdr3[4]
      4192192 blocks super 1.2 [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk
  

See the patch below on how I reverted the behavior.  There may be a 
cleaner way of providing the same read-only rules for SET_DISK_FAULTY 
without taking the mutex, but it seemed clearer to just put it back where 
it was.

Regards,

-- Joe

From 3f8d6c46085c6106cfd9be9ddd6a059667b45b6f Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Tue, 12 Feb 2013 15:07:45 -0500
Subject: [PATCH] md: SET_DISK_FAULTY should follow (auto) read-only rules

Commit 1ca69c4b "md: avoid taking the mutex on some ioctls" moved the
SET_DISK_FAULTY ioctl from out of the mddev_lock, but inadvertently changed
behavior for (auto) read-only arrays.  Revert that portion of the commit so
that marking a read-only MD device component as faulty is prevented (EROFS),
but still allowed for auto-read-only MD devices by transitioning to read-write
mode.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/md/md.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3db3d1b..3c41d3d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6392,10 +6392,6 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 		else
 			err = get_disk_info(mddev, argp);
 		goto abort;
-
-	case SET_DISK_FAULTY:
-		err = set_disk_faulty(mddev, new_decode_dev(arg));
-		goto abort;
 	}
 
 	if (cmd == ADD_NEW_DISK)
@@ -6551,6 +6547,10 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 		err = hot_add_disk(mddev, new_decode_dev(arg));
 		goto done_unlock;
 
+	case SET_DISK_FAULTY:
+		err = set_disk_faulty(mddev, new_decode_dev(arg));
+		goto done_unlock;
+
 	case RUN_ARRAY:
 		err = do_md_run(mddev);
 		goto done_unlock;
-- 
1.8.1.2

