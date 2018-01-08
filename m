From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: Growing RAID10 with active XFS filesystem
Date: Mon, 8 Jan 2018 15:31:13 +0800
Message-ID: <232deaaa-7306-a01b-567f-ca5c74dc6077@suse.com>
References: <4892a03d-018c-8281-13d3-4fcc7acd2bb8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4892a03d-018c-8281-13d3-4fcc7acd2bb8@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: mdraid.pkoch@dfgh.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 01/06/2018 11:44 PM, mdraid.pkoch@dfgh.net wrote:
> Dear MD-experts:
>
> I was under the impression that growing a RAID10 device could be done
> with an active filesystem running on the device.

It depends on whether the specific filesystem provides related tool or 
not, eg,
resize2fs can serve ext fs:

https://raid.wiki.kernel.org/index.php/Growing#Extending_the_filesystem

And you can use xfs_growfs for your purpose.

>
> I did this a couple of times when I added additional 2TB disks to our
> production RAID10 running an ext3 Filesystem. That was a very time
> consuming process and we had to use the filesystem during the reshape.
>
> When I increased the size of the RAID10 from 16 to 20 2TB-disks I could
> not use ext3 anymore due to the 16TB maimum size limitation of ext3
> and I replaced the ext3 filesystem by xfs.
>
> Now today I increased the RAID10 again from 20 to 21 disks with the
> following commands:
>
> mdadm /dev/md5 --add /dev/sdo
> mdadm --grow /dev/md5 --raid-devices=21
>
> My plans were to add another disk after that and then grow
> the XFS-filesystem. I do not add multiple disks at once since
> its hard to predict which disk will end up in what disk-set
>
> Here's mdadm -D /dev/md5 output:
> /dev/md5:
>         Version : 1.2
>   Creation Time : Sun Feb 10 16:58:10 2013
>      Raid Level : raid10
>      Array Size : 19533829120 (18628.91 GiB 20002.64 GB)
>   Used Dev Size : 1953382912 (1862.89 GiB 2000.26 GB)
>    Raid Devices : 21
>   Total Devices : 21
>     Persistence : Superblock is persistent
>
>     Update Time : Sat Jan  6 15:08:37 2018
>           State : clean, reshaping
>  Active Devices : 21
> Working Devices : 21
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : near=2
>      Chunk Size : 512K
>
>  Reshape Status : 1% complete
>   Delta Devices : 1, (20->21)
>
>            Name : backup:5  (local to host backup)
>            UUID : 9030ff07:6a292a3c:26589a26:8c92a488
>          Events : 86002
>
>     Number   Major   Minor   RaidDevice State
>        0       8       16        0      active sync   /dev/sdb
>        1      65       48        1      active sync   /dev/sdt
>        2       8       64        2      active sync   /dev/sde
>        3      65       96        3      active sync   /dev/sdw
>        4       8      112        4      active sync   /dev/sdh
>        5      65      144        5      active sync   /dev/sdz
>        6       8      160        6      active sync   /dev/sdk
>        7      65      192        7      active sync   /dev/sdac
>        8       8      208        8      active sync   /dev/sdn
>        9      65      240        9      active sync   /dev/sdaf
>       10      65        0       10      active sync   /dev/sdq
>       11      66       32       11      active sync   /dev/sdai
>       12       8       32       12      active sync   /dev/sdc
>       13      65       64       13      active sync   /dev/sdu
>       14       8       80       14      active sync   /dev/sdf
>       15      65      112       15      active sync   /dev/sdx
>       16       8      128       16      active sync   /dev/sdi
>       17      65      160       17      active sync   /dev/sdaa
>       18       8      176       18      active sync   /dev/sdl
>       19      65      208       19      active sync   /dev/sdad
>       20       8      224       20      active sync   /dev/sdo
>
>
> As you can see the array-size is still 20TB.

Because the reshaping is not finished yet.

>
> Just one second after starting the reshape operation
> XFS failed with the following messages:
>
> # dmesg
> ...
> RAID10 conf printout:
>  --- wd:21 rd:21
>  disk 0, wo:0, o:1, dev:sdb
>  disk 1, wo:0, o:1, dev:sdt
>  disk 2, wo:0, o:1, dev:sde
>  disk 3, wo:0, o:1, dev:sdw
>  disk 4, wo:0, o:1, dev:sdh
>  disk 5, wo:0, o:1, dev:sdz
>  disk 6, wo:0, o:1, dev:sdk
>  disk 7, wo:0, o:1, dev:sdac
>  disk 8, wo:0, o:1, dev:sdn
>  disk 9, wo:0, o:1, dev:sdaf
>  disk 10, wo:0, o:1, dev:sdq
>  disk 11, wo:0, o:1, dev:sdai
>  disk 12, wo:0, o:1, dev:sdc
>  disk 13, wo:0, o:1, dev:sdu
>  disk 14, wo:0, o:1, dev:sdf
>  disk 15, wo:0, o:1, dev:sdx
>  disk 16, wo:0, o:1, dev:sdi
>  disk 17, wo:0, o:1, dev:sdaa
>  disk 18, wo:0, o:1, dev:sdl
>  disk 19, wo:0, o:1, dev:sdad
>  disk 20, wo:1, o:1, dev:sdo
> md: reshape of RAID array md5
> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than 
> 200000 KB/sec) for reshape.
> md: using 128k window, over a total of 19533829120k.
> XFS (md5): metadata I/O error: block 0x12c08f360 
> ("xfs_trans_read_buf_map") error 5 numblks 16
> XFS (md5): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
> XFS (md5): metadata I/O error: block 0x12c08f360 
> ("xfs_trans_read_buf_map") error 5 numblks 16
> XFS (md5): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
> XFS (md5): metadata I/O error: block 0xebb62c00 
> ("xfs_trans_read_buf_map") error 5 numblks 16
> XFS (md5): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
> ...
> ... lots of the above messages deleted
> ...
> XFS (md5): xfs_do_force_shutdown(0x1) called from line 138 of file 
> fs/xfs/xfs_bmap_util.c.  Return address = 0xffffffff8113908f
> XFS (md5): metadata I/O error: block 0x48c710b00 ("xlog_iodone") error 
> 5 numblks 64
> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
> XFS (md5): Log I/O Error Detected.  Shutting down filesystem
> XFS (md5): Please umount the filesystem and rectify the problem(s)
> XFS (md5): metadata I/O error: block 0x48c710b40 ("xlog_iodone") error 
> 5 numblks 64
> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
> XFS (md5): metadata I/O error: block 0x48c710b80 ("xlog_iodone") error 
> 5 numblks 64
> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
> XFS (md5): metadata I/O error: block 0x48c710bc0 ("xlog_iodone") error 
> 5 numblks 64
> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
> XFS (md5): metadata I/O error: block 0x48c710c00 ("xlog_iodone") error 
> 5 numblks 64
> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
> XFS (md5): metadata I/O error: block 0x48c710c40 ("xlog_iodone") error 
> 5 numblks 64
> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
> XFS (md5): metadata I/O error: block 0x48c710c80 ("xlog_iodone") error 
> 5 numblks 64
> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
> XFS (md5): metadata I/O error: block 0x48c710cc0 ("xlog_iodone") error 
> 5 numblks 64
> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
> XFS (md5): I/O Error Detected. Shutting down filesystem

I guess the IOs from xfs were competing with the md internal IO, not good.

> I did an "umount /dev/md5" and now I'm wondering what my options are:

Though xfs file systems can be grown while mounted, it is better to umount
it first if md reshaping is in progress.

> Should I wait until the reshape has finisched? I assume yes since 
> stopping that operation will most likely make things worse.
> Unfortunately reshaping a 20TB RAID10 to 21TB will last about
> 10 hours but it's saturday and I have approx. 40 hours to fix the 
> problem until monday morning.
>
> Should I reduce array-size back to 20 disks?
>
> My plans are to run xfs_check first, maybe followed by xfs_repair and
> see what happens.
>
> Any other suggestions?
>
> Do you have an explanation why reshaping a RAID10 with a running
> ext3 filesystem does work while a running XFS-filesystems fails during
> a reshape?
>
> How did the XFS-filesystem notice that a reshape was running? I was
> sure that during the reshape operation every single block of the RAID10
> device could be read or written no matter wether it belongs to the part
> of the RAID that was already reshaped or not. Obviously that's working
> in theory only - or with ext3-filesystems only.

If the IO from fs could conflict with reshape IO, then it could be 
trouble, so
again, it is more safer to umount fs first before reshaping, my 0.02$.

Thanks,
Guoqing
