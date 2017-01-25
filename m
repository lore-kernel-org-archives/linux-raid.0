From: Thomas Warntjen <thomas@warntjen.net>
Subject: drives failed during reshape, array won't even force-assemble
Date: Wed, 25 Jan 2017 14:27:18 +0100
Message-ID: <d08f3721-6a72-3fc3-58d6-29034a6962f1@warntjen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On my new Ubuntu Server 16.4 LTS server I have an old RAID5 made from 
5+1 WD Red 3TB drives which I wanted to upgrade first to RAID6 (5+2) and 
then to 6 data disks, so I added 2 new drives und started the reshape:

# mdadm /dev/md1 --grow --level=6 --backup=/root/raid6.backupfile

When the reshape was at ~70% some wonky cabling caused some of the 
drives to temporarily fail (I heard the drives spin down after I 
accidently touched the cable - SMART says the disks are ok and another 
array on those disks starts just fine).
After a reboot, the array won't start, marking all the drives as spares 
(md1):

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [linear] [multipath] 
[raid0] [raid10]
md1 : inactive sdg3[3](S) sdj3[1](S) sdi3[6](S) sdh3[0](S) sdc3[2](S) 
sdd3[4](S) sdf3[5](S) sde3[8](S)
       23429580800 blocks super 0.91

md127 : active (auto-read-only) raid6 sdj1[7] sdi1[4] sdg1[2] sdh1[6] 
sdc1[0] sdf1[1] sde1[5] sdd1[3]
       6346752 blocks super 1.2 level 6, 512k chunk, algorithm 2 [8/8] 
[UUUUUUUU]

md0 : active raid1 sdb1[2] sda1[1]
       240022528 blocks super 1.2 [2/2] [UU]
       bitmap: 1/2 pages [4KB], 65536KB chunk


# mdadm --detail /dev/md1
/dev/md1:
         Version : 0.91
      Raid Level : raid0
   Total Devices : 8
Preferred Minor : 0
     Persistence : Superblock is persistent

           State : inactive

       New Level : raid6
      New Layout : left-symmetric
   New Chunksize : 64K

            UUID : 7a58ed4f:baf1934e:a2963c6e:a542ed71
          Events : 0.12370980

     Number   Major   Minor   RaidDevice

        -       8       35        -        /dev/sdc3
        -       8       51        -        /dev/sdd3
        -       8       67        -        /dev/sde3
        -       8       83        -        /dev/sdf3
        -       8       99        -        /dev/sdg3
        -       8      115        -        /dev/sdh3
        -       8      131        -        /dev/sdi3
        -       8      147        -        /dev/sdj3


Since that was the second time the reshape was interrupted (the first 
time was an intentional reboot) I thaought I knew what I was doing and 
stopped and force-assembled the array. That didn't work and probably 
borked it some more...

So according to the RAID-Wiki 
(https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID) 
I stopped the array and created overlay files (and copied the backup-file).

mdadm -E tells me that probably sdd and sdf were the failing drives:

# parallel --tag -k mdadm -E ::: $OVERLAYS|grep -E 'Update'
/dev/mapper/sdc3            Update Time : Tue Jan 24 21:03:00 2017
/dev/mapper/sdd3            Update Time : Tue Jan 24 21:02:49 2017
/dev/mapper/sde3            Update Time : Tue Jan 24 21:10:19 2017
/dev/mapper/sdf3            Update Time : Tue Jan 24 21:02:49 2017
/dev/mapper/sdh3            Update Time : Tue Jan 24 21:03:00 2017
/dev/mapper/sdi3            Update Time : Tue Jan 24 21:10:19 2017
/dev/mapper/sdj3            Update Time : Tue Jan 24 21:03:00 2017
/dev/mapper/sdg3            Update Time : Tue Jan 24 21:10:19 2017

# parallel --tag -k mdadm -E ::: $OVERLAYS|grep -E 'Events'
/dev/mapper/sdc3                 Events : 12370980
/dev/mapper/sdd3                 Events : 12370974
/dev/mapper/sde3                 Events : 12370980
/dev/mapper/sdf3                 Events : 12370974
/dev/mapper/sdh3                 Events : 12370980
/dev/mapper/sdi3                 Events : 12370980
/dev/mapper/sdj3                 Events : 12370980
/dev/mapper/sdg3                 Events : 12370980


Obviously the disks have diverging ideas about the health of the array 
and interestingly also about their own identity:

/dev/sdc3:
       Number   Major   Minor   RaidDevice State
this     2       8       35        2      active sync   /dev/sdc3

    0     0       8      131        0      active sync   /dev/sdi3
    1     1       8      163        1      active sync
    2     2       8       35        2      active sync   /dev/sdc3
    3     3       8      115        3      active sync   /dev/sdh3
    4     4       0        0        4      faulty removed
    5     5       0        0        5      faulty removed
    6     6       8      147        6      active   /dev/sdj3
    7     7       8       67        7      spare   /dev/sde3

/dev/sdd3:
       Number   Major   Minor   RaidDevice State
this     4       8       51        4      active sync   /dev/sdd3

    0     0       8      131        0      active sync   /dev/sdi3
    1     1       8      163        1      active sync
    2     2       8       35        2      active sync   /dev/sdc3
    3     3       8      115        3      active sync   /dev/sdh3
    4     4       8       51        4      active sync   /dev/sdd3
    5     5       8       83        5      active sync   /dev/sdf3
    6     6       8      147        6      active   /dev/sdj3
    7     7       8       67        7      spare   /dev/sde3

/dev/sde3:
       Number   Major   Minor   RaidDevice State
this     8       8       67        8      spare   /dev/sde3

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8      115        3      active sync   /dev/sdh3
    4     4       0        0        4      faulty removed
    5     5       0        0        5      faulty removed
    6     6       8      147        6      active   /dev/sdj3
    7     7       8      131        7      faulty   /dev/sdi3

/dev/sdf3:
       Number   Major   Minor   RaidDevice State
this     5       8       83        5      active sync   /dev/sdf3

    0     0       8      131        0      active sync   /dev/sdi3
    1     1       8      163        1      active sync
    2     2       8       35        2      active sync   /dev/sdc3
    3     3       8      115        3      active sync   /dev/sdh3
    4     4       8       51        4      active sync   /dev/sdd3
    5     5       8       83        5      active sync   /dev/sdf3
    6     6       8      147        6      active   /dev/sdj3
    7     7       8       67        7      spare   /dev/sde3

/dev/sdg3:
       Number   Major   Minor   RaidDevice State
this     3       8      115        3      active sync   /dev/sdh3

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8      115        3      active sync   /dev/sdh3
    4     4       0        0        4      faulty removed
    5     5       0        0        5      faulty removed
    6     6       8      147        6      active   /dev/sdj3
    7     7       8      131        7      faulty   /dev/sdi3

/dev/sdh3:
       Number   Major   Minor   RaidDevice State
this     0       8      131        0      active sync   /dev/sdi3

    0     0       8      131        0      active sync   /dev/sdi3
    1     1       8      163        1      active sync
    2     2       8       35        2      active sync   /dev/sdc3
    3     3       8      115        3      active sync   /dev/sdh3
    4     4       0        0        4      faulty removed
    5     5       0        0        5      faulty removed
    6     6       8      147        6      active   /dev/sdj3
    7     7       8       67        7      spare   /dev/sde3

/dev/sdi3:
       Number   Major   Minor   RaidDevice State
this     6       8      147        6      active   /dev/sdj3

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8      115        3      active sync   /dev/sdh3
    4     4       0        0        4      faulty removed
    5     5       0        0        5      faulty removed
    6     6       8      147        6      active   /dev/sdj3
    7     7       8      131        7      faulty   /dev/sdi3

/dev/sdj3:
       Number   Major   Minor   RaidDevice State
this     1       8      163        1      active sync

    0     0       8      131        0      active sync   /dev/sdi3
    1     1       8      163        1      active sync
    2     2       8       35        2      active sync   /dev/sdc3
    3     3       8      115        3      active sync   /dev/sdh3
    4     4       0        0        4      faulty removed
    5     5       0        0        5      faulty removed
    6     6       8      147        6      active   /dev/sdj3
    7     7       8       67        7      spare   /dev/sde3


(for reference)

# l /dev/mapper/
total 0
drwxr-xr-x  2 root root     220 Jan 25 12:34 .
drwxr-xr-x 20 root root    5.5K Jan 25 12:34 ..
crw-------  1 root root 10, 236 Jan 25 12:20 control
lrwxrwxrwx  1 root root       7 Jan 25 12:55 sdc3 -> ../dm-4
lrwxrwxrwx  1 root root       7 Jan 25 12:55 sdd3 -> ../dm-6
lrwxrwxrwx  1 root root       7 Jan 25 12:55 sde3 -> ../dm-5
lrwxrwxrwx  1 root root       7 Jan 25 12:55 sdf3 -> ../dm-7
lrwxrwxrwx  1 root root       7 Jan 25 12:55 sdg3 -> ../dm-2
lrwxrwxrwx  1 root root       7 Jan 25 12:55 sdh3 -> ../dm-3
lrwxrwxrwx  1 root root       7 Jan 25 12:55 sdi3 -> ../dm-0
lrwxrwxrwx  1 root root       7 Jan 25 12:55 sdj3 -> ../dm-1


The event-count of the drives doesn't look too bad, so I try to assemble 
the array:

# mdadm --assemble /dev/md1 $OVERLAYS --verbose 
--backup-file=raid6.backupfile
mdadm: looking for devices for /dev/md1
mdadm: /dev/mapper/sdc3 is identified as a member of /dev/md1, slot 2.
mdadm: /dev/mapper/sdd3 is identified as a member of /dev/md1, slot 4.
mdadm: /dev/mapper/sde3 is identified as a member of /dev/md1, slot 8.
mdadm: /dev/mapper/sdf3 is identified as a member of /dev/md1, slot 5.
mdadm: /dev/mapper/sdh3 is identified as a member of /dev/md1, slot 0.
mdadm: /dev/mapper/sdi3 is identified as a member of /dev/md1, slot 6.
mdadm: /dev/mapper/sdj3 is identified as a member of /dev/md1, slot 1.
mdadm: /dev/mapper/sdg3 is identified as a member of /dev/md1, slot 3.
mdadm: ignoring /dev/mapper/sdg3 as it reports /dev/mapper/sdc3 as failed
mdadm: ignoring /dev/mapper/sdi3 as it reports /dev/mapper/sdc3 as failed
mdadm: device 16 in /dev/md1 has wrong state in superblock, but 
/dev/mapper/sde3 seems ok
mdadm: /dev/md1 has an active reshape - checking if critical section 
needs to be restored
mdadm: restoring critical section
mdadm: added /dev/mapper/sdj3 to /dev/md1 as 1
mdadm: added /dev/mapper/sdc3 to /dev/md1 as 2
mdadm: no uptodate device for slot 3 of /dev/md1
mdadm: added /dev/mapper/sdd3 to /dev/md1 as 4 (possibly out of date)
mdadm: added /dev/mapper/sdf3 to /dev/md1 as 5 (possibly out of date)
mdadm: no uptodate device for slot 6 of /dev/md1
mdadm: added /dev/mapper/sde3 to /dev/md1 as 8
mdadm: added /dev/mapper/sdh3 to /dev/md1 as 0
mdadm: /dev/md1 assembled from 3 drives and 1 spare - not enough to 
start the array.


that was to be expected, now with --force:

# mdadm --assemble /dev/md1 $OVERLAYS --verbose 
--backup-file=raid6.backupfile --force
mdadm: looking for devices for /dev/md1
mdadm: /dev/mapper/sdc3 is identified as a member of /dev/md1, slot 2.
mdadm: /dev/mapper/sdd3 is identified as a member of /dev/md1, slot 4.
mdadm: /dev/mapper/sde3 is identified as a member of /dev/md1, slot 8.
mdadm: /dev/mapper/sdf3 is identified as a member of /dev/md1, slot 5.
mdadm: /dev/mapper/sdh3 is identified as a member of /dev/md1, slot 0.
mdadm: /dev/mapper/sdi3 is identified as a member of /dev/md1, slot 6.
mdadm: /dev/mapper/sdj3 is identified as a member of /dev/md1, slot 1.
mdadm: /dev/mapper/sdg3 is identified as a member of /dev/md1, slot 3.
mdadm: clearing FAULTY flag for device 2 in /dev/md1 for /dev/mapper/sde3
mdadm: Marking array /dev/md1 as 'clean'
mdadm: /dev/md1 has an active reshape - checking if critical section 
needs to be restored
mdadm: restoring critical section
mdadm: added /dev/mapper/sdj3 to /dev/md1 as 1
mdadm: added /dev/mapper/sdc3 to /dev/md1 as 2
mdadm: added /dev/mapper/sdg3 to /dev/md1 as 3
mdadm: added /dev/mapper/sdd3 to /dev/md1 as 4 (possibly out of date)
mdadm: added /dev/mapper/sdf3 to /dev/md1 as 5 (possibly out of date)
mdadm: added /dev/mapper/sdi3 to /dev/md1 as 6
mdadm: added /dev/mapper/sde3 to /dev/md1 as 8
mdadm: added /dev/mapper/sdh3 to /dev/md1 as 0
mdadm: failed to RUN_ARRAY /dev/md1: Input/output error


in the kern.log the following messages appeared:

Jan 25 13:02:51 Oghma kernel: [  765.051249] md: md1 stopped.
Jan 25 13:03:04 Oghma kernel: [  778.562635] md: bind<dm-1>
Jan 25 13:03:04 Oghma kernel: [  778.562780] md: bind<dm-4>
Jan 25 13:03:04 Oghma kernel: [  778.562891] md: bind<dm-2>
Jan 25 13:03:04 Oghma kernel: [  778.562999] md: bind<dm-6>
Jan 25 13:03:04 Oghma kernel: [  778.563104] md: bind<dm-7>
Jan 25 13:03:04 Oghma kernel: [  778.563207] md: bind<dm-0>
Jan 25 13:03:04 Oghma kernel: [  778.563400] md: bind<dm-5>
Jan 25 13:03:04 Oghma kernel: [  778.563577] md: bind<dm-3>
Jan 25 13:03:04 Oghma kernel: [  778.563720] md: kicking non-fresh dm-7 
from array!
Jan 25 13:03:04 Oghma kernel: [  778.563729] md: unbind<dm-7>
Jan 25 13:03:04 Oghma kernel: [  778.577201] md: export_rdev(dm-7)
Jan 25 13:03:04 Oghma kernel: [  778.577213] md: kicking non-fresh dm-6 
from array!
Jan 25 13:03:04 Oghma kernel: [  778.577223] md: unbind<dm-6>
Jan 25 13:03:04 Oghma kernel: [  778.605194] md: export_rdev(dm-6)
Jan 25 13:03:04 Oghma kernel: [  778.607491] md/raid:md1: reshape will 
continue
Jan 25 13:03:04 Oghma kernel: [  778.607541] md/raid:md1: device dm-3 
operational as raid disk 0
Jan 25 13:03:04 Oghma kernel: [  778.607545] md/raid:md1: device dm-2 
operational as raid disk 3
Jan 25 13:03:04 Oghma kernel: [  778.607549] md/raid:md1: device dm-4 
operational as raid disk 2
Jan 25 13:03:04 Oghma kernel: [  778.607551] md/raid:md1: device dm-1 
operational as raid disk 1
Jan 25 13:03:04 Oghma kernel: [  778.608605] md/raid:md1: allocated 7548kB
Jan 25 13:03:04 Oghma kernel: [  778.608733] md/raid:md1: not enough 
operational devices (3/7 failed)
Jan 25 13:03:04 Oghma kernel: [  778.608760] RAID conf printout:
Jan 25 13:03:04 Oghma kernel: [  778.608763]  --- level:6 rd:7 wd:4
Jan 25 13:03:04 Oghma kernel: [  778.608766]  disk 0, o:1, dev:dm-3
Jan 25 13:03:04 Oghma kernel: [  778.608769]  disk 1, o:1, dev:dm-1
Jan 25 13:03:04 Oghma kernel: [  778.608771]  disk 2, o:1, dev:dm-4
Jan 25 13:03:04 Oghma kernel: [  778.608773]  disk 3, o:1, dev:dm-2
Jan 25 13:03:04 Oghma kernel: [  778.608776]  disk 6, o:1, dev:dm-0
Jan 25 13:03:04 Oghma kernel: [  778.609364] md/raid:md1: failed to run 
raid set.
Jan 25 13:03:04 Oghma kernel: [  778.609367] md: pers->run() failed ...
Jan 25 13:03:04 Oghma kernel: [  778.609509] md: md1 stopped.
Jan 25 13:03:04 Oghma kernel: [  778.609519] md: unbind<dm-3>
Jan 25 13:03:04 Oghma kernel: [  778.629256] md: export_rdev(dm-3)
Jan 25 13:03:04 Oghma kernel: [  778.629273] md: unbind<dm-5>
Jan 25 13:03:04 Oghma kernel: [  778.649237] md: export_rdev(dm-5)
Jan 25 13:03:04 Oghma kernel: [  778.649255] md: unbind<dm-0>
Jan 25 13:03:04 Oghma kernel: [  778.665242] md: export_rdev(dm-0)
Jan 25 13:03:04 Oghma kernel: [  778.665259] md: unbind<dm-2>
Jan 25 13:03:04 Oghma kernel: [  778.681241] md: export_rdev(dm-2)
Jan 25 13:03:04 Oghma kernel: [  778.681258] md: unbind<dm-4>
Jan 25 13:03:04 Oghma kernel: [  778.693306] md: export_rdev(dm-4)
Jan 25 13:03:04 Oghma kernel: [  778.693323] md: unbind<dm-1>
Jan 25 13:03:04 Oghma kernel: [  778.705242] md: export_rdev(dm-1)


This seems to be the same problem this guy had 5 years ago 
https://www.spinics.net/lists/raid/msg37483.html but he got enough disks 
going to start the array.
What else is there I can do? This is my last hope :/

kernel: 4.4.0-59-generic #80-Ubuntu SMP Fri Jan 6 17:47:47 UTC 2017 
x86_64 x86_64 x86_64 GNU/Linux
mdadm: installed was "v3.3 - 3rd September 2013", now updated to "v3.4 - 
28th January 2016"

Thanks in advance!
