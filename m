From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 reshape bug with XFS
Date: Mon, 6 Nov 2006 09:56:40 +1100
Message-ID: <17742.27688.120840.900652@cse.unsw.edu.au>
References: <454D459D.4000003@rcn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Cizek on Saturday November 4
Sender: linux-raid-owner@vger.kernel.org
To: Bill Cizek <cizek@rcn.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday November 4, cizek@rcn.com wrote:
> Hi,
> 
> I'm setting up a raid 5 system and I ran across a bug when reshaping an 
> array with a mounted XFS filesystem on it.  This is under linux 2.6.18.2 
> and mdadm 2.5.5
> 
...
> root@localhost $ mdadm --detail /dev/md4
> /dev/md4:
>         Version : 00.90.03
>   Creation Time : Sat Nov  4 18:58:59 2006
>      Raid Level : raid5
>  >>
>  >>    Array Size : 2086592 (2038.03 MiB 2136.67 MB)
>  >>
>     Device Size : 10482240 (10.00 GiB 10.73 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 4
>     Persistence : Superblock is persistent
> 
> (2086592 != 31446720 -- Bad, much too small)


You have CONFIG_LBD=n don't you?

Thanks for the report.  This should fix it.  Please let me know if it does.

NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-11-03 15:11:52.000000000 +1100
+++ ./drivers/md/raid5.c	2006-11-06 09:55:20.000000000 +1100
@@ -3909,7 +3909,7 @@ static void end_reshape(raid5_conf_t *co
 		bdev = bdget_disk(conf->mddev->gendisk, 0);
 		if (bdev) {
 			mutex_lock(&bdev->bd_inode->i_mutex);
-			i_size_write(bdev->bd_inode, conf->mddev->array_size << 10);
+			i_size_write(bdev->bd_inode, (loff_t)conf->mddev->array_size << 10);
 			mutex_unlock(&bdev->bd_inode->i_mutex);
 			bdput(bdev);
 		}
