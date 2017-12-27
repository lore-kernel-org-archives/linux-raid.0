From: bingjingc <bingjingc@synology.com>
Subject: [PATCH] md/raid5: fix a potential deadlock of raid5 reshape
Date: Wed, 27 Dec 2017 13:47:56 +0800
Message-ID: <612ff962d2c31459a88fedad314f19da@synology.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org
List-Id: linux-raid.ids


There is a potential deadlock if mount/umount happens when
raid5_finish_reshape() tries to grow the size of emulated disk.

How the deadlock happens?
1) The raid5 resync thread finished reshape (expanding array).
2) The mount or umount thread holds VFS sb->s_umount lock and tries to
    write through critical data into raid5 emulated block device. So it
    waits for raid5 kernel thread handling stripes in order to finish it
    I/Os.
3) In the routine of raid5 kernel thread, md_check_recovery() will be
    called first in order to reap the raid5 resync thread. That is,
    raid5_finish_reshape() will be called. In this function, it will try
    to update conf and call VFS revalidate_disk() to grow the raid5
    emulated block device. It will try to acquire VFS sb->s_umount lock.
The raid5 kernel thread cannot continue, so no one can handle mount/
umount I/Os (stripes). Once the write-through I/Os cannot be finished,
mount/umount will not release sb->s_umount lock. The deadlock happens.

The raid5 kernel thread is an emulated block device. It is responible to
handle I/Os (stripes) from upper layers. The emulated block device
should not request any I/Os on itself. That is, it should not call VFS
layer functions. (If it did, it will try to acquire VFS locks to
guarantee the I/Os sequence.) So we have the resync thread to send
resync I/O requests and to wait for the results.

For solving this potential deadlock, we can put the size growth of the
emulated block device as the final step of reshape thread.

Reported-by: Alex Wu <alexwu@synology.com>
Reviewed-by: Alex Wu <alexwu@synology.com>
Reviewed-by: Chung-Chiang Cheng <cccheng@synology.com>
Signed-off-by: BingJing Chang <bingjingc@synology.com>
---
  drivers/md/md.c    | 13 +++++++++++++
  drivers/md/raid5.c |  8 +-------
  2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e4dee0..77d6d85 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8527,6 +8527,19 @@ void md_do_sync(struct md_thread *thread)
  	 * raid */
  	set_mask_bits(&mddev->sb_flags, 0,
  		      BIT(MD_SB_CHANGE_PENDING) | BIT(MD_SB_CHANGE_DEVS));
+
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
+			!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
+			mddev->delta_disks > 0 &&
+			mddev->pers->finish_reshape &&
+			mddev->pers->size &&
+			mddev->queue) {
+		mddev_lock_nointr(mddev);
+		md_set_array_sectors(mddev, mddev->pers->size(mddev, 0, 0));
+		mddev_unlock(mddev);
+		set_capacity(mddev->gendisk, mddev->array_sectors);
+		revalidate_disk(mddev->gendisk);
+	}

  	spin_lock(&mddev->lock);
  	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 98ce427..0f68faa 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8001,13 +8001,7 @@ static void raid5_finish_reshape(struct mddev 
*mddev)

  	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {

-		if (mddev->delta_disks > 0) {
-			md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
-			if (mddev->queue) {
-				set_capacity(mddev->gendisk, mddev->array_sectors);
-				revalidate_disk(mddev->gendisk);
-			}
-		} else {
+		if (mddev->delta_disks <= 0) {
  			int d;
  			spin_lock_irq(&conf->device_lock);
  			mddev->degraded = raid5_calc_degraded(conf);
-- 
2.7.4

