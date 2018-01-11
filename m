From: "Jason Herring" <jaherring@usa.net>
Subject: Lost a mirror disk, md array wouldn't start,  vg's are missing
Date: Wed, 10 Jan 2018 22:33:01 -0800
Message-ID: <496wakgGB9904S08.1515652381@web08.cms.usa.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a crashed mirror array on Fedora 27. One disk is clicky-clicking, the
the other seems fine but the array won't assemble.  The machine may have
crashed during this time, causing the additional problems.  I can see the
partition fine and the details about this disk but mdadm scanning didn't find
it.

cat /proc/mdstat did not show the array.

Looking at the disk:

# mdadm --examine /dev/sds 
/dev/sds:
      Magic : a92b4efc
    Version : 1.2
Feature Map : 0x0
 Array UUID : 9746d015:9e39eeea:334aa92e:bfa480bb
       Name : pangea:2  (local to host pangea)
  Creation Time : Tue Oct 11 09:33:16 2011
Raid Level : raid1
Raid Devices : 2

Avail Dev Size : 2930275121 (1397.26 GiB 1500.30 GB)
Array Size : 1465137424 (1397.26 GiB 1500.30 GB)
Used Dev Size : 2930274848 (1397.26 GiB 1500.30 GB)
Data Offset : 2048 sectors
Super Offset : 8 sectors
Unused Space : before=1968 sectors, after=271 sectors
      State : clean
Device UUID : 0c044478:d64fa3be:815fbaef:8a0f9988

Update Time : Sun Jan  8 10:34:51 2012
   Checksum : d72883e9 - expected d4419587
     Events : 72


Device Role : Active device 0
Array State : ?? ('A' == active, '.' == missing, 'R' == replacing)

It may be that it thinks the array is created on the entire disk, not a
partition. However, if I look at the disk I see:

# fdisk -l /dev/sds
Disk /dev/sds: 1.4 TiB, 1500301909504 bytes, 2930277167 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x39fa8c19

Device     Boot Start        End    Sectors  Size Id Type
/dev/sds1           1 2930277168 2930277168  1.4T fd Linux raid autodetect

The array refused to start and gave me the above "??" array state. OK, so
looking around I found some problems mentioning it did not have a valid
superblock and something about the disk size being incorrect. I wish I still
had that message, but the GUI crashed and it's lost to history.

Next, I found some reference to using --update=devicesize to fix the incorrect
disk size, but I didn't know what to call this array. So, I used the UUID to
assemble it per a suggestion:

mdadm --assemble --update=devicesize  --uuid
9746d015:9e39eeea:334aa92e:bfa480bb /dev/md125

And this sort of worked.. (though could this be my mistake?) ...  I say that
because now it assembles:

# cat /proc/mdstat
Personalities : [raid1] 
md125 : active (auto-read-only) raid1 sds[0]
  1465137424 blocks super 1.2 [2/1] [U_]

But it shows up with a name the same as another array (this server has several
arrays):

# mdadm --examine --scan --verbose
ARRAY /dev/md/2  level=raid1 metadata=1.2 num-devices=2
UUID=2dae5fb0:bcce83e4:2855f921:1b3bb460 name=pangea:2
devices=/dev/sdj7,/dev/sdg7
ARRAY /dev/md/2  level=raid1 metadata=1.2 num-devices=2
UUID=9746d015:9e39eeea:334aa92e:bfa480bb name=pangea:2
devices=/dev/sds

Listing the devices, there are two entries for md/2, kind of, but mdadm can't
differentiate them? Seems like a bug?

# ls -l /dev/md/ 
lrwxrwxrwx. 1 root root 6 Jan 9 12:51 2 -> ../md2 
lrwxrwxrwx. 1 root root 8 Jan 9 19:13 2_0 -> ../md125

Next, I see it's assembled, and the PV is visible:

# pvs
/dev/md125               lvm2 ---    1.36t   1.36t

Note, it finds it at /dev/md125, not /dev/md/2 or md/2_0. So, there is some
confusion by mdadm.

There are no volume groups listed above, and lvs and the various tools to look
at them find nothing.

Finally, I rant "testdisk" to see what's in there. Selecting /dev/md125 ->
Intel partition table -> Analyse

I first see:

Disk /dev/md125 - 1500 GB / 1397 GiB - CHS 366284356 2 4
Current partition structure:
  Partition                  Start        End    Size in sectors


Partition sector doesn't have the endmark 0xAA55

I then do a "quick search" and get the below message:

Disk /dev/md125 - 1500 GB / 1397 GiB - CHS 366284356 2 4

Warning: the current number of heads per cylinder is 2
but the correct value may be 128.
You can use the Geometry menu to change this value.
It's something to try if
- some partitions are not found by TestDisk
- or the partition table can not be written because partitions overlaps.

I then hit "continue":

Disk /dev/md125 - 1500 GB / 1397 GiB - CHS 366284356 2 4

     Partition                  Start        End    Size in sectors

 1 * Linux                  256   0  1 366284031   1  4 2930270208

At this point I stop as I could start to do some real damage here and need
some help as to how to proceed to get my volume group and logical volume
back.. and save the filesystem.

Issues that need addressing:

1) conflicting /dev/md### numbers 
2) partition /dev/sds or /dev/sds1 
3) missing volume group and logical volume

Thanks for any thoughts on the best way forward!

