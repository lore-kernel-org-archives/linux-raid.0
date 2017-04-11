From: LM <linux-raid@moellendorf.eu>
Subject: Re:  Level change from 4 disk RAID5 to 4 disk RAID6
Date: Tue, 11 Apr 2017 23:27:58 +0200
Message-ID: <20170411212758.GC25873@lars-laptop>
References: <20170408214239.GF10267@lars-laptop>
 <87vaqdxech.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87vaqdxech.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 10, 2017 at 11:04:30AM +1000, NeilBrown wrote:
>On Sat, Apr 08 2017, LM wrote:
>
>> Hi,
>>
>> I have a 4 disk RAID5, the used dev size is 640.05 GB. Now I want to
>> replace the 4 disks by 4 disks with a size of 2TB each.
>>
>> As far as I understand the man page, this can be achieved by replacing
>> the devices one after another and for each device rebuild the degraded
>> array with:
>>
>>    mdadm /dev/md0 --add /dev/sdX1
>>
>> Then the level change can be done together with growing the array:
>>
>>    mdadm --grow /dev/md0 --level=raid6 --backup-file=/root/backup-md0
>>
>> Does this work?
>>
>> I am asking if it works, because the man page also says:
>>
>>> mdadm --grow /dev/md4 --level=6 --backup-file=/root/backup-md4
>>>        The array /dev/md4 which is currently a RAID5 array will
>>>        be converted to RAID6.  There should normally already be
>>>        a spare drive attached to the array as a RAID6 needs one
>>>        more drive than a matching RAID5.
>>
>> And in my case only the size of disks is increased, not their number.
>>
>
>Yes, it probably works, and you probably don't need a backup file.
>Though you might need to explicitly tell mdadm to keep the number of
>devices unchanged by specifying "--raid-disk=4".
>
>You probably aren't very encouraged that I say "probably" and "might",
>and this is deliberate.
>
>I recommend that you crate 4 10Meg files, use losetup to create 10M
>devices, and build a RAID5 over them with --size=5M.
>Then try the --grow --level=6 command, and see what happens.
>If you mess up, you can easily start from scratch and try again.
>If it works, you can have some confidence that the same process will
>have the same result on real devices.
>
>NeilBrown

Thx, I tried what you suggested and found out it works like this:

* Grow the RAID5 to its maximum size. (mdadm will add a spare device which it
  later will refuse to remove if the array size is not reduced):
* Level change RAID5 -> RAID6 (will create a degraded 5 disk array,
  despite --raid-disk=4)
* Reduce the array size so the 5th disk can be removed
* Remove the 5th disk and normalize the layout



Here is the full log:


Create 4x 10M files:

# fallocate -l 10M A
# fallocate -l 10M B
# fallocate -l 10M C
# fallocate -l 10M D

Create 4x 10M devices:

# losetup /dev/loop10 A
# losetup /dev/loop11 B
# losetup /dev/loop12 C
# losetup /dev/loop13 D

Create a 4 disk RAID5 using 5M of each device:

# mdadm --create /dev/md/test --level=raid5 --size=5M --raid-devices=4 /dev/loop10 /dev/loop11 /dev/loop12 /dev/loop13
> mdadm: largest drive (/dev/loop10) exceeds size (5120K) by more than 1%
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md/test started.

Create a FS on the RAID:

# mkfs.ext4 -T small /dev/md/test
> mke2fs 1.43.3 (04-Sep-2016)
> Creating filesystem with 15360 1k blocks and 3840 inodes
> Filesystem UUID: 0d538322-2e07-463d-9f56-b9d22f5c9f8f
> Superblock backups stored on blocks:
>         8193
>
> Allocating group tables: done
> Writing inode tables: done
> Creating journal (1024 blocks): done
> Writing superblocks and filesystem accounting information: done

Mount the RAID:

# mount /dev/md/test test/
# ls -al test/
> total 13
> drwxr-xr-x 3 root root  1024 10. Apr 22:50 .
> drwxrwxrwt 5 root root   240 10. Apr 22:49 ..
> drwx------ 2 root root 12288 10. Apr 22:50 lost+found

Store some file on the RAID to see if it survives:

# cd test/
# wget https://www.kernel.org/theme/images/logos/tux.png
> --2017-04-10 22:53:18--  https://www.kernel.org/theme/images/logos/tux.png
> Resolving www.kernel.org (www.kernel.org)... 147.75.205.195, 2604:1380:2000:f000::7
> Connecting to www.kernel.org (www.kernel.org)|147.75.205.195|:443... connected.
> HTTP request sent, awaiting response... 200 OK
> Length: 8657 (8,5K) [image/png]
> Saving to: ‘tux.png’
>
> tux.png                       100%[================================================>]   8,45K  --.-KB/s    in 0,001s
>
> 2017-04-10 22:53:19 (6,21 MB/s) - ‘tux.png’ saved [8657/8657]

# feh test/tux.png
# cd ..
# umount test

Details about the RAID:

# mdadm --detail /dev/md/test
> /dev/md/test:
>         Version : 1.2
>   Creation Time : Mon Apr 10 22:50:39 2017
>      Raid Level : raid5
>      Array Size : 15360 (15.00 MiB 15.73 MB)
>   Used Dev Size : 5120 (5.00 MiB 5.24 MB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Apr 10 22:53:37 2017
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>            Name : lars-server:test  (local to host lars-server)
>            UUID : 49095ada:eadf4362:4f5386f5:c615e5bf
>          Events : 18
>
>     Number   Major   Minor   RaidDevice State
>        0       7       10        0      active sync   /dev/loop10
>        1       7       11        1      active sync   /dev/loop11
>        2       7       12        2      active sync   /dev/loop12
>        4       7       13        3      active sync   /dev/loop13

Grow the RAID5 to its maximum size. (mdadm will add a spare device which it
later will refuse to remove if the array size is not reduced):

# mdadm --grow /dev/md/test --size=7680
> mdadm: component size of /dev/md/test has been set to 7680K

See if tux is still alive:

# mount /dev/md/test test/
# feh test/tux.png
# umount test/

Change to level 6:

# mdadm --grow /dev/md/test --level=6 --raid-disk=4 --backup-file=/root/backup-md-test
> mdadm: Need 1 spare to avoid degraded array, and only have 0.
>        Use --force to over-ride this check.

Try to force it:

# mdadm --grow /dev/md/test --level=6 --raid-disk=4 --backup-file=/root/backup-md-test  --force
> mdadm: level of /dev/md/test changed to raid6
> mdadm: this change will reduce the size of the array.
>        use --grow --array-size first to truncate array.
>        e.g. mdadm --grow /dev/md/test --array-size 15360

Reduce the array size:

# mdadm --grow /dev/md/test --array-size 15360

See if tux is still alive:

# mount /dev/md/test test/
# feh test/tux.png
# umount test

Check the size:

# mdadm --detail /dev/md/test
> /dev/md/test:
>         Version : 1.2
>   Creation Time : Mon Apr 10 23:53:10 2017
>      Raid Level : raid6
>      Array Size : 15360 (15.00 MiB 15.73 MB)
>   Used Dev Size : 7680 (7.50 MiB 7.86 MB)
>    Raid Devices : 5
>   Total Devices : 4
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Apr 10 23:57:05 2017
>           State : clean, degraded
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric-6
>      Chunk Size : 512K
>
>            Name : lars-server:test  (local to host lars-server)
>            UUID : 30ce9f41:03cd27d9:0f0317a8:e4117b5c
>          Events : 34
>
>     Number   Major   Minor   RaidDevice State
>        0       7       10        0      active sync   /dev/loop10
>        1       7       11        1      active sync   /dev/loop11
>        2       7       12        2      active sync   /dev/loop12
>        4       7       13        3      active sync   /dev/loop13
>        -       0        0        4      removed

Now remove the 5th spare disk mdadm added:

# mdadm --grow /dev/md/test --raid-disk=4 --layout=normalise --backup-file=/root/backup-md-test
> mdadm: Need to backup 3072K of critical section..

See if it worked:

# mdadm --detail /dev/md/test
> /dev/md/test:
>         Version : 1.2
>   Creation Time : Mon Apr 10 23:53:10 2017
>      Raid Level : raid6
>      Array Size : 15360 (15.00 MiB 15.73 MB)
>   Used Dev Size : 7680 (7.50 MiB 7.86 MB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Apr 10 23:57:58 2017
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>            Name : lars-server:test  (local to host lars-server)
>            UUID : 30ce9f41:03cd27d9:0f0317a8:e4117b5c
>          Events : 46
>
>     Number   Major   Minor   RaidDevice State
>        0       7       10        0      active sync   /dev/loop10
>        1       7       11        1      active sync   /dev/loop11
>        2       7       12        2      active sync   /dev/loop12
>        4       7       13        3      active sync   /dev/loop13

And tux is still alive!

# mount /dev/md/test test/
# feh test/tux.png
# umount test

And the FS is clean, too!

# fsck /dev/md/test
fsck from util-linux 2.28.2
e2fsck 1.43.3 (04-Sep-2016)
/dev/md126: clean, 12/3840 files, 1775/15360 blocks

Clean-up the test setup:

# mdadm --stop /dev/md/test
# losetup -d /dev/loop10
# losetup -d /dev/loop11
# losetup -d /dev/loop12
# losetup -d /dev/loop13
# rm {A..D}
