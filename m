From: "John Stoffel" <john@stoffel.org>
Subject: Re: Growing RAID10 with active XFS filesystem
Date: Sun, 7 Jan 2018 14:33:11 -0500
Message-ID: <23122.30199.628369.880991@quad.stoffel.home>
References: <4892a03d-018c-8281-13d3-4fcc7acd2bb8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4892a03d-018c-8281-13d3-4fcc7acd2bb8@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid.pkoch@dfgh.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


mdraid> I was under the impression that growing a RAID10 device could
mdraid> be done with an active filesystem running on the device.

It should be just fine.  But in this case, you might also want to talk
with the XFS experts.  

mdraid> I did this a couple of times when I added additional 2TB disks
mdraid> to our production RAID10 running an ext3 Filesystem. That was
mdraid> a very time consuming process and we had to use the filesystem
mdraid> during the reshape.

What kernel and distro are you running here?  What are the mdadm tools
versions?  You need to give more details please. 

mdraid> When I increased the size of the RAID10 from 16 to 20
mdraid> 2TB-disks I could not use ext3 anymore due to the 16TB maimum
mdraid> size limitation of ext3 and I replaced the ext3 filesystem by
mdraid> xfs.

That must have been fun... not. 

mdraid> Now today I increased the RAID10 again from 20 to 21 disks with the
mdraid> following commands:

mdraid> mdadm /dev/md5 --add /dev/sdo
mdraid> mdadm --grow /dev/md5 --raid-devices=21

mdraid> My plans were to add another disk after that and then grow
mdraid> the XFS-filesystem. I do not add multiple disks at once since
mdraid> its hard to predict which disk will end up in what disk-set

mdraid> Here's mdadm -D /dev/md5 output:
mdraid> /dev/md5:
mdraid>          Version : 1.2
mdraid>    Creation Time : Sun Feb 10 16:58:10 2013
mdraid>       Raid Level : raid10
mdraid>       Array Size : 19533829120 (18628.91 GiB 20002.64 GB)
mdraid>    Used Dev Size : 1953382912 (1862.89 GiB 2000.26 GB)
mdraid>     Raid Devices : 21
mdraid>    Total Devices : 21
mdraid>      Persistence : Superblock is persistent

mdraid>      Update Time : Sat Jan  6 15:08:37 2018
mdraid>            State : clean, reshaping
mdraid>   Active Devices : 21
mdraid> Working Devices : 21
mdraid>   Failed Devices : 0
mdraid>    Spare Devices : 0

mdraid>           Layout : near=2
mdraid>       Chunk Size : 512K

mdraid>   Reshape Status : 1% complete
mdraid>    Delta Devices : 1, (20->21)

mdraid>             Name : backup:5  (local to host backup)
mdraid>             UUID : 9030ff07:6a292a3c:26589a26:8c92a488
mdraid>           Events : 86002

mdraid>      Number   Major   Minor   RaidDevice State
mdraid>         0       8       16        0      active sync   /dev/sdb
mdraid>         1      65       48        1      active sync   /dev/sdt
mdraid>         2       8       64        2      active sync   /dev/sde
mdraid>         3      65       96        3      active sync   /dev/sdw
mdraid>         4       8      112        4      active sync   /dev/sdh
mdraid>         5      65      144        5      active sync   /dev/sdz
mdraid>         6       8      160        6      active sync   /dev/sdk
mdraid>         7      65      192        7      active sync   /dev/sdac
mdraid>         8       8      208        8      active sync   /dev/sdn
mdraid>         9      65      240        9      active sync   /dev/sdaf
mdraid>        10      65        0       10      active sync   /dev/sdq
mdraid>        11      66       32       11      active sync   /dev/sdai
mdraid>        12       8       32       12      active sync   /dev/sdc
mdraid>        13      65       64       13      active sync   /dev/sdu
mdraid>        14       8       80       14      active sync   /dev/sdf
mdraid>        15      65      112       15      active sync   /dev/sdx
mdraid>        16       8      128       16      active sync   /dev/sdi
mdraid>        17      65      160       17      active sync   /dev/sdaa
mdraid>        18       8      176       18      active sync   /dev/sdl
mdraid>        19      65      208       19      active sync   /dev/sdad
mdraid>        20       8      224       20      active sync   /dev/sdo

This all looks fine... but I'm thinking what you *should* have done
instead is build a bunch of 2tb pairs, and them use LVM to span across
them with a volume, then build your XFS filesystem ontop of that.
This way you would have /dev/md1,2,3,4,5,6,7,8,9,10 all inside a VG,
then you would use LVM to stripe across the pairs.  

But that's water under the bridge now.

mdraid> As you can see the array-size is still 20TB.

mdraid> Just one second after starting the reshape operation
mdraid> XFS failed with the following messages:

I *think* the mdadm --grow did something, or XFS noticed the change in
array size and grew on it's own.  Can you provide the output of
'xfs_info /dev/md5' for us?  


mdraid> # dmesg
mdraid> ...
mdraid> RAID10 conf printout:
mdraid>   --- wd:21 rd:21
mdraid>   disk 0, wo:0, o:1, dev:sdb
mdraid>   disk 1, wo:0, o:1, dev:sdt
mdraid>   disk 2, wo:0, o:1, dev:sde
mdraid>   disk 3, wo:0, o:1, dev:sdw
mdraid>   disk 4, wo:0, o:1, dev:sdh
mdraid>   disk 5, wo:0, o:1, dev:sdz
mdraid>   disk 6, wo:0, o:1, dev:sdk
mdraid>   disk 7, wo:0, o:1, dev:sdac
mdraid>   disk 8, wo:0, o:1, dev:sdn
mdraid>   disk 9, wo:0, o:1, dev:sdaf
mdraid>   disk 10, wo:0, o:1, dev:sdq
mdraid>   disk 11, wo:0, o:1, dev:sdai
mdraid>   disk 12, wo:0, o:1, dev:sdc
mdraid>   disk 13, wo:0, o:1, dev:sdu
mdraid>   disk 14, wo:0, o:1, dev:sdf
mdraid>   disk 15, wo:0, o:1, dev:sdx
mdraid>   disk 16, wo:0, o:1, dev:sdi
mdraid>   disk 17, wo:0, o:1, dev:sdaa
mdraid>   disk 18, wo:0, o:1, dev:sdl
mdraid>   disk 19, wo:0, o:1, dev:sdad
mdraid>   disk 20, wo:1, o:1, dev:sdo
mdraid> md: reshape of RAID array md5
mdraid> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
mdraid> md: using maximum available idle IO bandwidth (but not more than 200000 
mdraid> KB/sec) for reshape.
mdraid> md: using 128k window, over a total of 19533829120k.
mdraid> XFS (md5): metadata I/O error: block 0x12c08f360 
mdraid> ("xfs_trans_read_buf_map") error 5 numblks 16
mdraid> XFS (md5): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
mdraid> XFS (md5): metadata I/O error: block 0x12c08f360 
mdraid> ("xfs_trans_read_buf_map") error 5 numblks 16
mdraid> XFS (md5): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
mdraid> XFS (md5): metadata I/O error: block 0xebb62c00 
mdraid> ("xfs_trans_read_buf_map") error 5 numblks 16
mdraid> XFS (md5): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
mdraid> ...
mdraid> ... lots of the above messages deleted
mdraid> ...
mdraid> XFS (md5): xfs_do_force_shutdown(0x1) called from line 138 of file 
mdraid> fs/xfs/xfs_bmap_util.c.  Return address = 0xffffffff8113908f
mdraid> XFS (md5): metadata I/O error: block 0x48c710b00 ("xlog_iodone") error 5 
mdraid> numblks 64
mdraid> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
mdraid> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
mdraid> XFS (md5): Log I/O Error Detected.  Shutting down filesystem
mdraid> XFS (md5): Please umount the filesystem and rectify the problem(s)
mdraid> XFS (md5): metadata I/O error: block 0x48c710b40 ("xlog_iodone") error 5 
mdraid> numblks 64
mdraid> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
mdraid> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
mdraid> XFS (md5): metadata I/O error: block 0x48c710b80 ("xlog_iodone") error 5 
mdraid> numblks 64
mdraid> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
mdraid> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
mdraid> XFS (md5): metadata I/O error: block 0x48c710bc0 ("xlog_iodone") error 5 
mdraid> numblks 64
mdraid> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
mdraid> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
mdraid> XFS (md5): metadata I/O error: block 0x48c710c00 ("xlog_iodone") error 5 
mdraid> numblks 64
mdraid> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
mdraid> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
mdraid> XFS (md5): metadata I/O error: block 0x48c710c40 ("xlog_iodone") error 5 
mdraid> numblks 64
mdraid> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
mdraid> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
mdraid> XFS (md5): metadata I/O error: block 0x48c710c80 ("xlog_iodone") error 5 
mdraid> numblks 64
mdraid> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
mdraid> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
mdraid> XFS (md5): metadata I/O error: block 0x48c710cc0 ("xlog_iodone") error 5 
mdraid> numblks 64
mdraid> XFS (md5): xfs_do_force_shutdown(0x2) called from line 1170 of file 
mdraid> fs/xfs/xfs_log.c.  Return address = 0xffffffff8117cdf4
mdraid> XFS (md5): I/O Error Detected. Shutting down filesystem

mdraid> I did an "umount /dev/md5" and now I'm wondering what my options are:

What does 'xfs_fsck -n /dev/md5' say? 

mdraid> Should I wait until the reshape has finisched? I assume yes
mdraid> since stopping that operation will most likely make things
mdraid> worse.  Unfortunately reshaping a 20TB RAID10 to 21TB will
mdraid> last about 10 hours but it's saturday and I have approx. 40
mdraid> hours to fix the problem until monday morning.

Are you still having the problem?

mdraid> Should I reduce array-size back to 20 disks?

I don't think so.

mdraid> My plans are to run xfs_check first, maybe followed by
mdraid> xfs_repair and see what happens.

Talk to the XFS folks first, before you do anything!  

mdraid> Any other suggestions?

mdraid> Do you have an explanation why reshaping a RAID10 with a running
mdraid> ext3 filesystem does work while a running XFS-filesystems fails during
mdraid> a reshape?

mdraid> How did the XFS-filesystem notice that a reshape was running? I was
mdraid> sure that during the reshape operation every single block of the RAID10
mdraid> device could be read or written no matter wether it belongs to the part
mdraid> of the RAID that was already reshaped or not. Obviously that's working
mdraid> in theory only - or with ext3-filesystems only.

mdraid> Or was i totally wrong with my assumption?

mdraid> Much thanks in advance for any assistance.

mdraid> Peter Koch

mdraid> --
mdraid> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
mdraid> the body of a message to majordomo@vger.kernel.org
mdraid> More majordomo info at  http://vger.kernel.org/majordomo-info.html
