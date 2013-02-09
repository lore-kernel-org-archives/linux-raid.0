From: Dave Cundiff <syshackmin@gmail.com>
Subject: Re: help please, can't mount/recover raid 5 array
Date: Sat, 9 Feb 2013 18:00:31 -0500
Message-ID: <CAKHEz2aE8dz3+GgfchYS7WsLxXjT+1adJbdeiBjqo2uiXzJbcw@mail.gmail.com>
References: <CAHscji2-8KaKOA041VykHeA+jCEka5afgEoH=EHVGDak-D4UFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji2-8KaKOA041VykHeA+jCEka5afgEoH=EHVGDak-D4UFg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Feb 9, 2013 at 4:03 PM, Daniel Sanabria <sanabria.d@gmail.com> wrote:
> Hi,
>
> I'm having issues with my raid 5 array after upgrading my os and I
> have to say I'm desperate :-(
>
> whenever I try to mount the array I get the following:
>
> [root@lamachine ~]# mount /mnt/raid/
> mount: /dev/sda3 is already mounted or /mnt/raid busy
> [root@lamachine ~]#
>
> and the messages log is recording the following:
>
> Feb  9 20:25:10 lamachine kernel: [ 3887.287305] EXT4-fs (md2): VFS:
> Can't find ext4 filesystem
> Feb  9 20:25:10 lamachine kernel: [ 3887.304025] EXT4-fs (md2): VFS:
> Can't find ext4 filesystem
> Feb  9 20:25:10 lamachine kernel: [ 3887.320702] EXT4-fs (md2): VFS:
> Can't find ext4 filesystem
> Feb  9 20:25:10 lamachine kernel: [ 3887.353233] ISOFS: Unable to
> identify CD-ROM format.
> Feb  9 20:25:10 lamachine kernel: [ 3887.353571] FAT-fs (md2): invalid
> media value (0x82)
> Feb  9 20:25:10 lamachine kernel: [ 3887.368809] FAT-fs (md2): Can't
> find a valid FAT filesystem
> Feb  9 20:25:10 lamachine kernel: [ 3887.369140] hfs: can't find a HFS
> filesystem on dev md2.
> Feb  9 20:25:10 lamachine kernel: [ 3887.369665] hfs: unable to find
> HFS+ superblock
>
> /etc/fstab is as follows:
>
> [root@lamachine ~]# cat /etc/fstab
>
> #
> # /etc/fstab
> # Created by anaconda on Fri Feb  8 17:33:14 2013
> #
> # Accessible filesystems, by reference, are maintained under '/dev/disk'
> # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
> #
> /dev/mapper/vg_bigblackbox-LogVol_root /                       ext4
> defaults        1 1
> UUID=7bee0f50-3e23-4a5b-bfb5-42006d6c8561 /boot                   ext4
>    defaults        1 2
> UUID=48be851b-f021-0b64-e9fb-efdf24c84c5f /mnt/raid ext4 defaults 1 2
> /dev/mapper/vg_bigblackbox-LogVol_opt /opt                    ext4
> defaults        1 2
> /dev/mapper/vg_bigblackbox-LogVol_tmp /tmp                    ext4
> defaults        1 2
> /dev/mapper/vg_bigblackbox-LogVol_var /var                    ext4
> defaults        1 2
> UUID=70933ff3-8ed0-4486-abf1-01f00023d1b2 swap                    swap
>    defaults        0 0
> [root@lamachine ~]#
>
> After the upgrade I had to assemble the array manually and didn't get
> any errors but I was still getting the mount problem. I went ahead and
> recreated it with mdadm --create --assume-clean and still the smae result.
>
> here's some more info about md2:
> [root@lamachine ~]# mdadm --misc --detail /dev/md2
> /dev/md2:
>         Version : 1.2
>   Creation Time : Sat Feb  9 17:30:32 2013
>      Raid Level : raid5
>      Array Size : 511996928 (488.28 GiB 524.28 GB)
>   Used Dev Size : 255998464 (244.14 GiB 262.14 GB)
>    Raid Devices : 3
>   Total Devices : 3
>     Persistence : Superblock is persistent
>
>     Update Time : Sat Feb  9 20:47:46 2013
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>            Name : lamachine:2  (local to host lamachine)
>            UUID : 48be851b:f0210b64:e9fbefdf:24c84c5f
>          Events : 2
>
>     Number   Major   Minor   RaidDevice State
>        0       8        3        0      active sync   /dev/sda3
>        1       8       18        1      active sync   /dev/sdb2
>        2       8       34        2      active sync   /dev/sdc2
> [root@lamachine ~]#
>
> it looks like it know about how much space is being used which might
> indicate that the data is still there?
>
> what can I do to recover the data?
>
> Any  help or guidance is more than welcome.
>
> Thanks in advance,
>
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

What OS did you upgrade from and to? What OS was the array originally
created on?

Looks like you have LVM on top the of md array so the output of
pvdisplay and vgdisplay would be useful.

Did you specify metadata version when re-creating the array?
Recreating the array at best changed the UUID, and depending on what
OS the array was created on, overwrote the beginning of your
partitions.

--
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
