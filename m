From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/2] md: set mddev readonly flag on blkdev BLKROSET ioctl
Date: Thu, 08 Jan 2009 00:24:38 -0700
Message-ID: <20090108072438.9577.22558.stgit@dwillia2-linux.ch.intel.com>
References: <20090108072023.9577.3585.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090108072023.9577.3585.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When the user sets the block device to readwrite then the mddev should
follow suit.  Otherwise, the BUG_ON in md_write_start() will be set to
trigger.

The reverse direction, setting mddev->ro to match a set readonly
request, can be ignored because the blkdev level readonly flag precludes
the need to have mddev->ro set correctly.  Nevermind the fact that
setting mddev->ro to 1 may fail if the array is in use.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/md.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1b1d326..7ac2b56 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4805,6 +4805,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	int err = 0;
 	void __user *argp = (void __user *)arg;
 	mddev_t *mddev = NULL;
+	int ro;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -4940,6 +4941,34 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 			err = do_md_stop(mddev, 1, 1);
 			goto done_unlock;
 
+		case BLKROSET:
+			if (get_user(ro, (int __user *)(arg))) {
+				err = -EFAULT;
+				goto done_unlock;
+			}
+			err = -EINVAL;
+
+			/* if the bdev is going readonly the value of mddev->ro
+			 * does not matter, no writes are coming
+			 */
+			if (ro)
+				goto done_unlock;
+
+			/* are we are already prepared for writes? */
+			if (mddev->ro != 1)
+				goto done_unlock;
+
+			/* transitioning to readauto need only happen for
+			 * arrays that call md_write_start
+			 */
+			if (mddev->pers) {
+				err = restart_array(mddev);
+				if (err == 0) {
+					mddev->ro = 2;
+					set_disk_ro(mddev->gendisk, 0);
+				}
+			}
+			goto done_unlock;
 	}
 
 	/*

