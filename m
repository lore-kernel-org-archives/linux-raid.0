From: bingjingc <bingjingc@synology.com>
Subject: Re: [PATCH] md/raid5: fix a potential deadlock of raid5 reshape
Date: Fri, 29 Dec 2017 17:44:23 +0800
Message-ID: <4b122714f0ba0694bb7c8dc9fa30301a@synology.com>
References: <612ff962d2c31459a88fedad314f19da@synology.com>
 <3321c473-5d17-3065-08bc-b5e51f906383@suse.com>
 <4f1dbb814cafc8dc21cc7c2d7f0af30c@synology.com>
 <ac91af2e-57d6-7d25-a639-25882d607a3b@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ac91af2e-57d6-7d25-a639-25882d607a3b@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.de>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org, shli@kernel.org
List-Id: linux-raid.ids

Subject: [PATCH] md: fix a potential deadlock of raid5/raid10 reshape

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

2017/12/29:
Thanks to Guoqing Jiang <gqjiang@suse.com>,
we confirmed that there is the same deadlock issue in raid10. It's
reproducible and can be fixed by this patch. For raid10.c, we can remove
the similar code to prevent deadlock as well since they has been called
before.

Reported-by: Alex Wu <alexwu@synology.com>
Reviewed-by: Alex Wu <alexwu@synology.com>
Reviewed-by: Chung-Chiang Cheng <cccheng@synology.com>
Signed-off-by: BingJing Chang <bingjingc@synology.com>
---
  drivers/md/md.c     | 13 +++++++++++++
  drivers/md/raid10.c |  8 +-------
  drivers/md/raid5.c  |  8 +-------
  3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e4dee0..52092de 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8528,6 +8528,19 @@ void md_do_sync(struct md_thread *thread)
  	set_mask_bits(&mddev->sb_flags, 0,
  		      BIT(MD_SB_CHANGE_PENDING) | BIT(MD_SB_CHANGE_DEVS));

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
+
  	spin_lock(&mddev->lock);
  	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
  		/* We completed so min/max setting can be forgotten if used. */
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c131835..8a46473 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4818,17 +4818,11 @@ static void raid10_finish_reshape(struct mddev 
*mddev)
  		return;

  	if (mddev->delta_disks > 0) {
-		sector_t size = raid10_size(mddev, 0, 0);
-		md_set_array_sectors(mddev, size);
  		if (mddev->recovery_cp > mddev->resync_max_sectors) {
  			mddev->recovery_cp = mddev->resync_max_sectors;
  			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
  		}
-		mddev->resync_max_sectors = size;
-		if (mddev->queue) {
-			set_capacity(mddev->gendisk, mddev->array_sectors);
-			revalidate_disk(mddev->gendisk);
-		}
+		mddev->resync_max_sectors = mddev->array_sectors;
  	} else {
  		int d;
  		rcu_read_lock();
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



Guoqing Jiang 於 2017-12-29 14:42 寫到:
> On 12/29/2017 02:02 PM, bingjingc wrote:
>> 
>> Guoqing Jiang 於 2017-12-28 15:59 寫到:
>>> On 12/27/2017 01:47 PM, bingjingc wrote:
>>>> 
>>>> There is a potential deadlock if mount/umount happens when
>>>> raid5_finish_reshape() tries to grow the size of emulated disk.
>>>> 
>>>> How the deadlock happens?
>>>> 1) The raid5 resync thread finished reshape (expanding array).
>>>> 2) The mount or umount thread holds VFS sb->s_umount lock and tries 
>>>> to
>>>>    write through critical data into raid5 emulated block device. So 
>>>> it
>>>>    waits for raid5 kernel thread handling stripes in order to finish 
>>>> it
>>>>    I/Os.
>>>> 3) In the routine of raid5 kernel thread, md_check_recovery() will 
>>>> be
>>>>    called first in order to reap the raid5 resync thread. That is,
>>>>    raid5_finish_reshape() will be called. In this function, it will 
>>>> try
>>>>    to update conf and call VFS revalidate_disk() to grow the raid5
>>>>    emulated block device. It will try to acquire VFS sb->s_umount 
>>>> lock.
>>>> The raid5 kernel thread cannot continue, so no one can handle mount/
>>>> umount I/Os (stripes). Once the write-through I/Os cannot be 
>>>> finished,
>>>> mount/umount will not release sb->s_umount lock. The deadlock 
>>>> happens.
>>>> 
>>>> The raid5 kernel thread is an emulated block device. It is 
>>>> responible to
>>>> handle I/Os (stripes) from upper layers. The emulated block device
>>>> should not request any I/Os on itself. That is, it should not call 
>>>> VFS
>>>> layer functions. (If it did, it will try to acquire VFS locks to
>>>> guarantee the I/Os sequence.) So we have the resync thread to send
>>>> resync I/O requests and to wait for the results.
>>>> 
>>>> For solving this potential deadlock, we can put the size growth of 
>>>> the
>>>> emulated block device as the final step of reshape thread.
>>> 
>>> Maybe another way to avoid the deadlock is to ensure the reshaping 
>>> array
>>> can't be mount at all. One reason is, if the reshaping is finished, 
>>> but fs still
>>> don't know about  the new array size since metadata is not refreshed. 
>>> Just
>>> my $0.02.
>>> 
>> 
>> It may take hours or couples of days to expand an array. So I bet that 
>> it's a
>> feature that an expanding array can still serve fs requests. Once it 
>> finished,
>> the new array size for metadata can be passed to fs layer via 
>> revalidate_disk().
>> From then, fs is able to be expanded, too. There are no needs to 
>> restart that
>> array. Based on this point, I don't want to break this feature.
> 
> Sorry, the metadata which I mentioned before is the metadata for file 
> system.
> How fs know about the new size without update fs's metadata? Pls see 
> the wiki:
> https://raid.wiki.kernel.org/index.php/Growing#Extending_the_filesystem

Sorry, you're right. It requires few more commands to grow the
filesystem's size. I used wrong wordings. In fact, what I want to
mention is the metadata of the emulated disk. In fs/block_dev.c,
revalidate_disk() will call check_disk_size_change(disk, bdev) to
adjust the monitored block device size. I guess that these structures
belong to VFS. So for MD, it keeps the same behavior to issue the
upper layer about the size change.

Thanks,
BingJing

> 
> Thanks,
> Guoqing
