From: Travis M <tmiller@web-1hosting.net>
Subject: mke2fs segmentation fault
Date: Thu, 8 Aug 2002 22:48:28 -0500 (CDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.21.0208082225010.27756-100000@mail.web-1hosting.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone,

A search on google and the list archives came up empty, maybe someone here
can give me a hand?

I have been using software raid1 on my root file system for quite some
time now without problems.  Today I decided to play with linear raid as I
have heard that you can resize the array when you add disks.  I setup a
test box with Slackware 8.0, kernel 2.4.18, the .90 raidtools, and the
lastest e2fs and reiserfs tools.  I have an 80Gig drive so I created some
partitions to play around on, like this:

   Device Boot    Start       End    Blocks   Id  System
/dev/hda1             1       128   1028128+  82  Linux swap
/dev/hda2           129       766   5124735   83  Linux native
/dev/hda3           767      2041  10241437+  83  Linux native
/dev/hda4          2042     10011  64019025    5  Extended
/dev/hda5          2042      2679   5124703+  83  Linux native
/dev/hda6          2680      3317   5124703+  83  Linux native
/dev/hda7          3318      3955   5124703+  83  Linux native 

hda5,hda6 were to be in the first raid array.  To test "growing" the
array, I would then add hda7 and resize.

I used the following in my /etc/raidtab:
raiddev /dev/md0
        raid-level      linear
        nr-raid-disks   2
        chunk-size      32
        persistent-superblock 1
        device          /dev/hda6
        raid-disk       0
        device          /dev/hda7
        raid-disk       1

I then did the following steps:
root# mkraid /dev/md0
root# mkreiserfs /dev/md0
root# mount /dev/md0 /mnt
root# cp -arv /usr /mnt

All this worked fine.  I had a linear array of 10GB up and mounted on
/mnt with the contents of /usr.  Now for the resizing test:

root# umount /mnt
root# raidstop /dev/md0

altered /etc/raidtab to look like:
raiddev /dev/md0
        raid-level      linear
        nr-raid-disks   3
        chunk-size      32
        persistent-superblock 1
        device          /dev/hda6
        raid-disk       0
        device          /dev/hda7
        raid-disk       1
	device		/dev/hda8
	raid-disk	2

then I continued on with:

root# mkraid -f /dev/md0
root# reiserfs_resize /dev/md0
root# mount /dev/md0 /mnt

YAY! It worked fine, i was about to view,alter,add,delete data from my
linear array that was now 15G.  Glad that this had worked, I decided to
try setting up the box in production trim.  I had planned to use a second
80gig drive which I did not have at the time, but figured that was OK
because I could resize like I just had when I got ready to add it.  The
final setup was going to be:

/hda1 <Swap>
/hda2 /
/hda3 /home
/hda4 <extended>
/hda5 /tmp
/hda6 <rest of the drive setup on /dev/md0 mounted to /home/storage>

the commands were as such:

root# umount /mnt
root# raidstop /dev/md0
root# fdisk /dev/hda
root# vim /etc/raidtab

setup raidtab as:
raiddev /dev/md0
        raid-level      linear
        nr-raid-disks   1
        chunk-size      32
        persistent-superblock 1
        device          /dev/hda6
        raid-disk       0

root# shutdown -r now

(I figured with a partition change rebooting was a good idea)

When the box came back up I did the following,

root# mkraid -f /dev/md0
root# mkreiserfs /dev/md0

... and I got...

<-------------mkreiserfs, 2001------------->
reiserfsprogs 3.x.0j

===================================================================
LEAF NODE (8211) contains level=1, nr_items=2, free_space=3932 rdkey
-------------------------------------------------------------------------------
|###|type|ilen|f/sp| loc|fmt|fsck|                   key
|
|   |    |    |e/cn|    |   |need|
|
-------------------------------------------------------------------------------
Segmentation fault


... so then I tried ext2 just to see and got;

mke2fs 1.22, 22-Jun-2001 for EXT2 FS 0.5b, 95/08/09
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
8011776 inodes, 16004756 blocks
800237 blocks (5.00%) reserved for the super user
First data block=0
489 block groups
32768 blocks per group, 32768 fragments per group
16384 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632,
2654208,
        4096000, 7962624, 11239424

Writing inode tables: Segmentation fault


I am at a loss!!  I have tried deleting the partitions, recreating,
reboots in between, creating just a /dev/hda4 as a regular partion and
formating (no raid at all) and still get segmentation faults.  Has anyone
seen this before, suggested fixes?


Thanks,
Travis

