From: <ian_bruce@mail.ru>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component
 devices
Date: Tue, 28 Feb 2017 02:25:38 -0800
Message-ID: <20170228022513.2cf5445a.ian_bruce@mail.ru>
References: <20170224040816.41f2f372.ian_bruce@mail.ru>
        <87y3wsp47n.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y3wsp47n.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 27 Feb 2017 16:55:56 +1100
NeilBrown <neilb@suse.com> wrote:

>> When assembling non-metadata arrays ("mdadm --build"), the in-kernel
>> superblock apparently defaults to the MD-RAID v0.90 type. This
>> imposes a maximum of 27 component block devices, presumably as well
>> as limits on device size.
>>
>> mdadm does not allow you to override this default, by specifying the
>> v1.2 superblock. It is not clear whether mdadm tells the kernel to
>> use the v0.90 superblock, or the kernel assumes this by itself. One
>> or other of them should be fixed; there does not appear to be any
>> reason why the v1.2 superblock should not be the default in this
>> case.
> 
> Can you see if this change improves the behavior for you?

Unfortunately, I'm not set up for kernel compilation at the moment. But
here is my test case; it shouldn't be any harder to reproduce than this,
on extremely ordinary hardware (= no actual disk RAID array):


# truncate -s 64M img64m.{00..31}   # requires no space on ext4,
#                                   # because sparse files are created
# 
# ls img64m.*
img64m.00  img64m.04  img64m.08  img64m.12  img64m.16  img64m.20  img64m.24  img64m.28
img64m.01  img64m.05  img64m.09  img64m.13  img64m.17  img64m.21  img64m.25  img64m.29
img64m.02  img64m.06  img64m.10  img64m.14  img64m.18  img64m.22  img64m.26  img64m.30
img64m.03  img64m.07  img64m.11  img64m.15  img64m.19  img64m.23  img64m.27  img64m.31
# 
# RAID=$(for x in img64m.* ; do losetup --show -f $x ; done)
# 
# echo $RAID
/dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 /dev/loop5 /dev/loop6 /dev/loop7
/dev/loop8 /dev/loop9 /dev/loop10 /dev/loop11 /dev/loop12 /dev/loop13 /dev/loop14 /dev/loop15
/dev/loop16 /dev/loop17 /dev/loop18 /dev/loop19 /dev/loop20 /dev/loop21 /dev/loop22 /dev/loop23
/dev/loop24 /dev/loop25 /dev/loop26 /dev/loop27 /dev/loop28 /dev/loop29 /dev/loop30 /dev/loop31
# 
# mdadm --build /dev/md/md-test --level=linear --raid-devices=32 $RAID
mdadm: ADD_NEW_DISK failed for /dev/loop27: Device or resource busy
# 

kernel log:

    kernel: [109524.168624] md: nonpersistent superblock ...
    kernel: [109524.168638] md: md125: array is limited to 27 devices
    kernel: [109524.168643] md: export_rdev(loop27)
    kernel: [109524.180676] md: md125 stopped.


It appears that I was wrong in assuming that the MD-RAID v0.90
limitation of 4TB per component device would be in effect:


# truncate -s 5T img5t.{00..03}   # sparse files again
# 
# ls -l img5t.*
-rw-r--r-- 1 root root 5497558138880 Feb 28 00:09 img5t.00
-rw-r--r-- 1 root root 5497558138880 Feb 28 00:09 img5t.01
-rw-r--r-- 1 root root 5497558138880 Feb 28 00:09 img5t.02
-rw-r--r-- 1 root root 5497558138880 Feb 28 00:09 img5t.03
# 
# RAID=$(for x in img5t.* ; do losetup --show -f $x ; done)
# 
# echo $RAID
/dev/loop32 /dev/loop33 /dev/loop34 /dev/loop35
# 
# mdadm --build /dev/md/md-test --level=linear --raid-devices=4 $RAID
mdadm: array /dev/md/md-test built and started.
# 
# mdadm --detail /dev/md/md-test
/dev/md/md-test:
        Version : 
  Creation Time : Tue Feb 28 00:18:21 2017
     Raid Level : linear
     Array Size : 21474836480 (20480.00 GiB 21990.23 GB)
   Raid Devices : 4
  Total Devices : 4

          State : clean 
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

       Rounding : 64K

    Number   Major   Minor   RaidDevice State
       0       7       32        0      active sync   /dev/loop32
       1       7       33        1      active sync   /dev/loop33
       2       7       34        2      active sync   /dev/loop34
       3       7       35        3      active sync   /dev/loop35
# 
# mkfs.ext4 /dev/md/md-test
mke2fs 1.43.4 (31-Jan-2017)
Discarding device blocks: done                            
Creating filesystem with 5368709120 4k blocks and 335544320 inodes
Filesystem UUID: da293fd3-b4ec-40e3-b5be-3caeef55edcf
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
	4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
	102400000, 214990848, 512000000, 550731776, 644972544, 1934917632, 
	2560000000, 3855122432

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information: done         

# 
# fsck.ext4 -f /dev/md/md-test
e2fsck 1.43.4 (31-Jan-2017)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/md/md-test: 11/335544320 files (0.0% non-contiguous), 21625375/5368709120 blocks
# 


> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ba485dcf1064..e0ac7f5a8e68 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6464,9 +6464,8 @@ static int set_array_info(struct mddev *mddev, mdu_array_info_t *info)
>  	mddev->layout        = info->layout;
>  	mddev->chunk_sectors = info->chunk_size >> 9;
>  
> -	mddev->max_disks     = MD_SB_DISKS;
> -
>  	if (mddev->persistent) {
> +		mddev->max_disks     = MD_SB_DISKS;
>  		mddev->flags         = 0;
>  		mddev->sb_flags         = 0;
>  	}

What value does mddev->max_disks get in the opposite case,
(!mddev->persistent) ?

I note this comment from the top of the function:

    * set_array_info is used two different ways
    * The original usage is when creating a new array.
    * In this usage, raid_disks is > 0 and it together with
    *  level, size, not_persistent,layout,chunksize determine the
    *  shape of the array.
    *  This will always create an array with a type-0.90.0 superblock.

http://lxr.free-electrons.com/source/drivers/md/md.c#L6410

Surely there is an equivalent function which creates arrays with a
type-1 superblock?


-- Ian Bruce
