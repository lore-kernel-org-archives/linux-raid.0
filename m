From: hpg@gundelwein.de
Subject: strange behavior of a raid5 array after system crash
Date: Fri, 04 Mar 2005 20:42:25 +0100
Message-ID: <E1D7Igq-0005Nn-00@www.strato-webmail.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone,

I need your help with a strange behavior of a raid5 array.

My Linux fileserver was frozen for unknown reason. No mouse movement, 
no console, no disk activity nothing.
So I had to hit the reset button.

At boot time 5 raid5 arrays have been active without any faults.
Two other raid5 arrays resynchronized successfully.
Only one had some trouble to recover.

Because I am using LVM2 on top of all my raid5 arrays and have the root 
filesystem in that volume group which is using the raid5 array in
question.
I had to boot from a Fedora Core 3 Rescue CDROM.

# uname -a 
Linux localhost.localdomain 2.6.9-1.667 #1 Tue Nov 2 14:41:31 EST 2004
i686 unknown

On boot time I get the following:

[...]
md: autorun ...
md: considering hdi7 ...
md:  adding hdi7 ...
md:  adding hdk9 ...
md:  adding hdg5 ...
md:  adding hde10 ...
md:  adding hda11 ...
md: created md4
md: bind<hda11>
md: bind<hde10>
md: bind<hdg5>
md: bind<hdk9>
md: bind<hdi7>
md: running: <hdi7><hdk9><hdg5><hde10><hda11>
md: kicking non-fresh hde10 from array!
md: unbind<hde10>
md: export_rdev(hde10)
md: md4: raid array is not clean -- starting background reconstruction
raid5: device hdi7 operational as raid disk 4
raid5: device hdk9 operational as raid disk 3
raid5: device hdg5 operational as raid disk 2
raid5: device hda11 operational as raid disk 0
raid5: cannot start dirty degraded array for md4
RAID5 conf printout:
 --- rd:5 wd:4 fd:1
 disk 0, o:1, dev:hda11
 disk 2, o:1, dev:hdg5
 disk 3, o:1, dev:hdk9
 disk 4, o:1, dev:hdi7
raid5: failed to run raid set md4
md: pers->run() failed ...
md :do_md_run() returned -22
md: md4 stopped.
md: unbind<hdi7>
md: export_rdev(hdi7)
md: unbind<hdk9>
md: export_rdev(hdk9)
md: unbind<hdg5>
md: export_rdev(hdg5)
md: unbind<hda11>
md: export_rdev(hda11)
md: ... autorun DONE.
[...]

So I tried to reassemble the array:

# mdadm --assemble /dev/md4 /dev/hda11 /dev/hde10 /dev/hdg5 /dev/hdk9
/dev/hdi7
mdadm: /dev/md4 assembled from 4 drives - need all 5 to start it (use
--run to insist)

# dmesg
[...]
md: md4 stopped.
md: bind<hde10>
md: bind<hdg5>
md: bind<hdk9>
md: bind<hdi7>
md: bind<hda11>

# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid5] [raid6]
md1 : active raid5 hdi1[4] hdk1[3] hdg1[2] hde7[1] hda3[0]
      81919744 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]

md2 : active raid5 hdi2[4] hdk2[3] hdg2[2] hde8[1] hda5[0]
      81919744 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]

md3 : active raid5 hdi3[4] hdk3[3] hdg3[2] hde9[1] hda6[0]
      81919744 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]

md4 : inactive hda11[0] hdi7[4] hdk9[3] hdg5[2] hde10[1]
      65246272 blocks
md5 : active raid5 hdl5[3] hdi5[2] hdk5[1] hda7[0]
      61439808 blocks level 5, 64k chunk, algorithm 0 [4/4] [UUUU]

md6 : active raid5 hdl6[3] hdi6[2] hdk6[1] hda8[0]
      61439808 blocks level 5, 64k chunk, algorithm 0 [4/4] [UUUU]

md7 : active raid5 hdl7[2] hdk7[1] hda9[0]
      40965504 blocks level 5, 64k chunk, algorithm 0 [3/3] [UUU]

md8 : active raid5 hdl8[2] hdk8[1] hda10[0]
      40965504 blocks level 5, 64k chunk, algorithm 0 [3/3] [UUU]

unused devices: <none>


# mdadm --stop /dev/md4
# mdadm --assemble --run /dev/md4 /dev/hda11 /dev/hde10 /dev/hdg5
/dev/hdk9 /dev/hdi7
mdadm: /dev/md4 has been started with 4 drives (out of 5).

# cat /proc/mdstat
[...]
md4 : active raid5 hda11[0] hdi7[4] hdk9[3] hdg5[2]
      49126144 blocks level 5, 64k chunk, algorithm 2 [5/4] [U_UUU]
[...]

# dmesg
[...]
md: bind<hde10>
md: bind<hdg5>
md: bind<hdk9>
md: bind<hdi7>
md: bind<hda11>
md: kicking non-fresh hde10 from array!
md: unbind<hde10>
md: export_rdev(hde10)
raid5: device hda11 operational as raid disk 0
raid5: device hdi7 operational as raid disk 4
raid5: device hdk9 operational as raid disk 3
raid5: device hdg5 operational as raid disk 2
raid5: allocated 5248kB for md4
raid5: raid level 5 set md4 active with 4 out of 5 devices, algorithm 2
RAID5 conf printout:
 --- rd:5 wd:4 fd:1
 disk 0, o:1, dev:hda11
 disk 2, o:1, dev:hdg5
 disk 3, o:1, dev:hdk9
 disk 4, o:1, dev:hdi7


So far everything looks ok for me.
But now things become funny:

# dd if=/dev/md4 of=/dev/null
0+0 records in
0+0 records out

# mdadm --stop /dev/md4
mdadm: fail to stop array /dev/md4: Device or resource busy

# dmesg
[...]
md: md4 still in use.

# dd if=/dev/hda11 of=/dev/null count=1000
1000+0 records in
1000+0 records out
# dd if=/dev/hde10 of=/dev/null count=1000
1000+0 records in
1000+0 records out
# dd if=/dev/hdg5 of=/dev/null count=1000
1000+0 records in
1000+0 records out
# dd if=/dev/hdi7 of=/dev/null count=1000
1000+0 records in
1000+0 records out
# dd if=/dev/hdk9 of=/dev/null count=1000
1000+0 records in
1000+0 records out
# dd if=/dev/md1 of=/dev/null count=1000
1000+0 records in
1000+0 records out
# dd if=/dev/md2 of=/dev/null count=1000
1000+0 records in
1000+0 records out
# dd if=/dev/md3 of=/dev/null count=1000
1000+0 records in
1000+0 records out
# dd if=/dev/md5 of=/dev/null count=1000
1000+0 records in
1000+0 records out
# dd if=/dev/md6 of=/dev/null count=1000
1000+0 records in
1000+0 records out
# dd if=/dev/md7 of=/dev/null count=1000
1000+0 records in
1000+0 records out
# dd if=/dev/md8 of=/dev/null count=1000
1000+0 records in
1000+0 records out


Now some still missing details:

# mdadm --detail /dev/md4
/dev/md4:
        Version : 00.90.01
  Creation Time : Sat Jul 24 12:38:25 2004
     Raid Level : raid5
    Device Size : 12281536 (11.71 GiB 12.58 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 4
    Persistence : Superblock is persistent

    Update Time : Mon Feb 28 21:10:13 2005
          State : clean, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0       3       11        0      active sync   /dev/hda11
       1       0        0       -1      removed
       2      34        5        2      active sync   /dev/hdg5
       3      57        9        3      active sync   /dev/hdk9
       4      56        7        4      active sync   /dev/hdi7
           UUID : 1da63142:e1bcc45b:e0287a1a:f9c7c3a8
         Events : 0.26324

# mdadm --examine /dev/hda11 /dev/hde10 /dev/hdg5 /dev/hdi7 /dev/hdk9
/dev/hda11:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 1da63142:e1bcc45b:e0287a1a:f9c7c3a8
  Creation Time : Sat Jul 24 12:38:25 2004
     Raid Level : raid5
    Device Size : 12281536 (11.71 GiB 12.58 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 4

    Update Time : Mon Feb 28 21:10:13 2005
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 661328a - correct
         Events : 0.26324

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       3       11        0      active sync   /dev/hda11
   0     0       3       11        0      active sync   /dev/hda11
   1     1      33       10        1      active sync   /dev/hde10
   2     2      34        5        2      active sync   /dev/hdg5
   3     3      57        9        3      active sync   /dev/hdk9
   4     4      56        7        4      active sync   /dev/hdi7
/dev/hde10:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 1da63142:e1bcc45b:e0287a1a:f9c7c3a8
  Creation Time : Sat Jul 24 12:38:25 2004
     Raid Level : raid5
    Device Size : 12281536 (11.71 GiB 12.58 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 4

    Update Time : Mon Feb 28 21:10:13 2005
          State : dirty
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 66132a6 - correct
         Events : 0.26322

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1      33       10        1      active sync   /dev/hde10
   0     0       3       11        0      active sync   /dev/hda11
   1     1      33       10        1      active sync   /dev/hde10
   2     2      34        5        2      active sync   /dev/hdg5
   3     3      57        9        3      active sync   /dev/hdk9
   4     4      56        7        4      active sync   /dev/hdi7
/dev/hdg5:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 1da63142:e1bcc45b:e0287a1a:f9c7c3a8
  Creation Time : Sat Jul 24 12:38:25 2004
     Raid Level : raid5
    Device Size : 12281536 (11.71 GiB 12.58 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 4

    Update Time : Mon Feb 28 21:10:13 2005
          State : dirty
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 66132a6 - correct
         Events : 0.26324

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2      34        5        2      active sync   /dev/hdg5
   0     0       3       11        0      active sync   /dev/hda11
   1     1      33       10        1      active sync   /dev/hde10
   2     2      34        5        2      active sync   /dev/hdg5
   3     3      57        9        3      active sync   /dev/hdk9
   4     4      56        7        4      active sync   /dev/hdi7
/dev/hdi7:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 1da63142:e1bcc45b:e0287a1a:f9c7c3a8
  Creation Time : Sat Jul 24 12:38:25 2004
     Raid Level : raid5
    Device Size : 12281536 (11.71 GiB 12.58 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 4

    Update Time : Mon Feb 28 21:10:13 2005
          State : dirty
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 66132c2 - correct
         Events : 0.26324

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4      56        7        4      active sync   /dev/hdi7
   0     0       3       11        0      active sync   /dev/hda11
   1     1      33       10        1      active sync   /dev/hde10
   2     2      34        5        2      active sync   /dev/hdg5
   3     3      57        9        3      active sync   /dev/hdk9
   4     4      56        7        4      active sync   /dev/hdi7
/dev/hdk9:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 1da63142:e1bcc45b:e0287a1a:f9c7c3a8
  Creation Time : Sat Jul 24 12:38:25 2004
     Raid Level : raid5
    Device Size : 12281536 (11.71 GiB 12.58 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 4

    Update Time : Mon Feb 28 21:10:13 2005
          State : dirty
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 66132c3 - correct
         Events : 0.26324

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3      57        9        3      active sync   /dev/hdk9
   0     0       3       11        0      active sync   /dev/hda11
   1     1      33       10        1      active sync   /dev/hde10
   2     2      34        5        2      active sync   /dev/hdg5
   3     3      57        9        3      active sync   /dev/hdk9
   4     4      56        7        4      active sync   /dev/hdi7


I really would appreciate some help.

Regards,
Peter

-- 
Hans Peter Gundelwein
Email: hpg@Gundelwein.de

