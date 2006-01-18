From: Neil Brown <neilb@suse.de>
Subject: Re: Adding a device to an active RAID1 array
Date: Thu, 19 Jan 2006 10:31:18 +1100
Message-ID: <17358.53190.557928.948108@cse.unsw.edu.au>
References: <43CE8FDC.4020501@rcn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Cizek on Wednesday January 18
Sender: linux-raid-owner@vger.kernel.org
To: Bill Cizek <cizek@rcn.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 18, cizek@rcn.com wrote:
> 
> Hi,
> 
> Are there any known issues with changing the number of active devices in 
> a RAID1 array?

There is now, thanks.

> 
> I'm trying to add a third mirror to an existing RAID1 array of two disks.
> 
> I have /dev/md5 as a mirrored pair of two 40 GB disks.  Directly on top 
> of it is a 40 GB XFS filesystem.
> 
> When I do "mdadm --grow /dev/md5 -n 3" the count of devices changes from 
> 2 to 3, as expected.
> If the XFS filesystem is mounted, the array size changes to 3.0 GB.
> If it is not mounted everything works fine.
> 
> Is this supposed to work, is it required that the array be inactive to 
> add a disk, or am I just doing
> something stupid?

It is supposed to work, it doesn't, but it is the code doing something
stupid, not you.
Try the patch below.

> 
> If there is a better forum for this question, please direct me there.
> In any case TIA for any help.

This is exactly the correct forum.

NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-01-17 17:42:31.000000000 +1100
+++ ./drivers/md/md.c	2006-01-19 10:29:46.000000000 +1100
@@ -3488,7 +3488,7 @@ static int update_raid_disks(mddev_t *md
 		bdev = bdget_disk(mddev->gendisk, 0);
 		if (bdev) {
 			mutex_lock(&bdev->bd_inode->i_mutex);
-			i_size_write(bdev->bd_inode, mddev->array_size << 10);
+			i_size_write(bdev->bd_inode, (loff_t)mddev->array_size << 10);
 			mutex_unlock(&bdev->bd_inode->i_mutex);
 			bdput(bdev);
 		}
