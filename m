From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: [Solved] Trouble creating/assembling/mounting Ver 1.0 raid1 disk in
 another box to recover data
Date: Wed, 25 Oct 2017 16:05:23 -0500
Message-ID: <72e0b049-2575-fd98-fbe4-39898f4704e4@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil, All,

(sometimes it's the painfully obvious that just slips right by... I was going
to ask for help, but discovered my problem while going through and composing
the information for this e-mail -- kind of funny, so I thought I would pass it
along... and maybe help someone else in the future)

  One of my long time boxes finally reached end of life due to a capacitor
issue a couple of days ago. I had "almost" everything I needed off the raid1
array before it finally died, but I missed getting the faxes out of the
hylafax/avantfax folder and I need to recover that data.

  I have the drive attached to another box via a ATA/usb cable and the drive
is recognized, etc., but when I try to create an array with the drive (and
missing) to be able to mount it somewhere, it always fails with "Device Busy".

(I don't know what "Busy" means here, but I suspect that when I try and
create/assemble it, it used to be a md0, md1, or md2 on the old box and this
current box has a md0-4 already. -- I don't know if that makes any sense, but
that is all I could think of off-hand)

<addendum -- I was wrong, keep reading :)>

  The drive is an older ATA drive and I don't have a box with ATA anymore, but
I do have a ATA/usb adapter from the time when laptop drives were ATA.
Unfortunately the power supply for the laptop drive won't spin the 3.5 inch
disk, so I have the power-supply from another computer sitting on the table,
plugged in, with the green and back wire from the 24-pin connector jumped to
start the power supply. The drive is sde in the current partition list:

# cat /proc/partitions
major minor  #blocks  name

  11        0    1048575 sr0
   8        0  976762584 sda
   8        1          1 sda1
   8        5     512000 sda5
   8        6   52428800 sda6
   8        7  921161728 sda7
   8        8    2117632 sda8
   8       16  976762584 sdb
   8       17          1 sdb1
   8       21     512000 sdb5
   8       22   52428800 sdb6
   8       23  921161728 sdb7
   8       24    2117632 sdb8
   8       32 2930266584 sdc
   8       48 2930266584 sdd
   9        4 2930135488 md4
   9        3    2115584 md3
   9        1   52396032 md1
   9        2  921030656 md2
   9        0     511680 md0
   8       64  245117376 sde
   8       65     104391 sde1
   8       66          1 sde2
   8       69   20972826 sde5
   8       70    2104483 sde6
   8       71  221929911 sde7


  The drive data is all in tact from the motherboard's time of death on Oct
20, e.g.

$ mdadm -E /dev/sde5
/dev/sde5:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
           Name : 1
  Creation Time : Thu Aug 21 01:43:22 2008
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 41945504 (20.00 GiB 21.48 GB)
     Array Size : 20972752 (20.00 GiB 21.48 GB)
   Super Offset : 41945632 sectors
   Unused Space : before=0 sectors, after=47 sectors
          State : clean
    Device UUID : e0c1c580:db4d853e:6fac1c8f:fb5399d7

Internal Bitmap : -81 sectors from superblock
    Update Time : Fri Oct 20 15:55:58 2017
       Checksum : db3d3417 - correct
         Events : 19154344


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing, 'R' == replacing)

  When I try and create a new array (say md20) out of this drive, it just says
"Device Busy", e.g.

# mdadm --verbose --create /dev/md20 --level=1 --raid-devices=2 /dev/sde5 missing
mdadm: super1.x cannot open /dev/sde5: Device or resource busy
mdadm: ddf: Cannot use /dev/sde5: Device or resource busy
mdadm: Cannot use /dev/sde5: It is busy
mdadm: cannot open /dev/sde5: Device or resource busy

  There is no md20 to conflict with:

# l /dev/md20
ls: cannot access '/dev/md20': No such file or directory

  The only md devices on this current system are:

l /dev/md*
brw-rw---- 1 root disk 9,   0 Oct 23 01:25 /dev/md0
brw-rw---- 1 root disk 9,   1 Oct 23 01:25 /dev/md1
brw-rw---- 1 root disk 9, 125 Oct 25 14:26 /dev/md125
brw-rw---- 1 root disk 9, 126 Oct 25 14:26 /dev/md126
brw-rw---- 1 root disk 9, 127 Oct 25 14:26 /dev/md127
brw-rw---- 1 root disk 9,   2 Oct 23 01:25 /dev/md2
brw-rw---- 1 root disk 9,   3 Oct 23 01:25 /dev/md3
brw-rw---- 1 root disk 9,   4 Oct 23 01:25 /dev/md4


...SMACKS SELF FOR BEING SO DUMB... (will place the pointy hat on head, and
turn and face the corner when this message is done)

  Duh! Where did md125-127 come from? Those are not normally there. Crap! When
I plugged the usb in, since mdadm was already running on the box, it saw the
drive at the end of my usb cable as an array and had already assembled -- but
not started the array --> which explains the "Device Busy" error.

# mdadm -D /dev/md126
/dev/md126:
        Version : 1.0
     Raid Level : raid0
  Total Devices : 1
    Persistence : Superblock is persistent

          State : inactive

           Name : 1
           UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
         Events : 19154344

    Number   Major   Minor   RaidDevice

       -       8       69        -        /dev/sde5


  I can't believe I wasted 20 minutes dorking with the getting the darn thing
assembled, but didn't snap to the fact it might already be assembled. Nothing
in my wildest expectations said plugging a usb cable from a bare drive laying
on the table powered by a jump-started PS would automatically be recognized as
an array and assembled -- but it did. Damn good job guys!

# mdadm --verbose --readonly --run /dev/md126
mdadm: started array /dev/md/1_0

  Hah! good!

# mdadm -D /dev/md126
/dev/md126:
        Version : 1.0
  Creation Time : Thu Aug 21 01:43:22 2008
     Raid Level : raid1
     Array Size : 20972752 (20.00 GiB 21.48 GB)
  Used Dev Size : 20972752 (20.00 GiB 21.48 GB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Fri Oct 20 15:55:58 2017
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : 1
           UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
         Events : 19154344

    Number   Major   Minor   RaidDevice State
       0       8       69        0      active sync   /dev/sde5
       -       0        0        1      removed

  Hah! Double Good!

# mount /dev/md126 /mnt/af/
# md /home/data/nemesis/srv/
# cd /mnt/af/srv/
# cp -a avantfax/faxes /home/data/nemesis/srv/
# cp -a avantfax/tmp /home/data/nemesis/srv/

  Bingo! Done!

  Thanks a lot for all the help -- really. If I hadn't been toiling through
the process of collecting all the information to prepare a well thought out
post for the list, who knows how long it would have taken me to stumble across
the fact that the arrays had already been assembled.

  So hopefully this brings a chuckle to all, and maybe some help to someone
similarly situated in the future (dunce hat and all)

-- 
David C. Rankin, J.D.,P.E.
