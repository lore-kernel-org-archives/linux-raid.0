From: Jes.Sorensen@redhat.com
Subject: [PATCH] Fix race between removing raid1 device and I/O error handling on underlying device
Date: Mon,  8 Oct 2012 15:57:14 +0200
Message-ID: <1349704634-18904-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pyu@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Avoid calling rdev_set_badblocks() if the underlying device has been
removed by raid1d() prior to calling fix_read_error().

This should be applicable to the 3.x stable kernel series as well.

Original bug analysis from Peng Yu:

Assume this condition:

We have a software raid1 device /dev/md0, it has two underlying
devices, they are /dev/sda and /dev/sdb. Assign an IO to sda,
rdev->pending add 1, an IO error occur on sda, rdev->pending dec 1,
then wakeup the raid1d thread. At the same time, a user run such a
command:

Kernel will set Faulty bit to rdev->flags, then wakeup raid1d
thread. The raid1d thread will call md_check_recovery function, this
function will call raid1_remove_disk function if it see the Faulty
flag is set. In raid1_remove_disk function, the rdev->nr_pending is
zero, so it will set rdev to NULL. Then raid1d thread return from
md_check_recovery function, continue call handle_read_error to hand
the read error, handle_read_error function will call fix_read_error
function, in fix_read_error function, see these lines:

		if (!success) {
			/* Cannot read from anywhere - mark it bad */
			struct md_rdev *rdev = conf->mirrors[read_disk].rdev;
			if (!rdev_set_badblocks(rdev, sect, s, 0))
				md_error(mddev, rdev);
			break;
		}

It doesn't check whether the rdev is NULL, just pass it to
rdev_set_badblocks function, and it maybe a NULL pointer, so the
kernel crash.

Reported-by: Peng Yu <pyu@redhat.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 611b5f7..ffdad74 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2005,7 +2005,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 		if (!success) {
 			/* Cannot read from anywhere - mark it bad */
 			struct md_rdev *rdev = conf->mirrors[read_disk].rdev;
-			if (!rdev_set_badblocks(rdev, sect, s, 0))
+			if (rdev && !rdev_set_badblocks(rdev, sect, s, 0))
 				md_error(mddev, rdev);
 			break;
 		}
-- 
1.7.11.4

