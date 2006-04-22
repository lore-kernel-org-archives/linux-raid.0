From: Jonathan <jrs@abhost.net>
Subject: Re: data recovery on raid5
Date: Sat, 22 Apr 2006 11:57:29 -0700
Message-ID: <444A7C99.80006@abhost.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Having raid fail on friday evening is pretty bad timing - not there is 
perhaps any good time for such a thing.  I'm the sys-admin for the 
machine in question (apologies for starting a new thread rather than 
replying - I just subscribed to the list)

 From my reading, it seems like maybe:

mdadm --assemble /dev/md0 --uuid=8fe1fe85:eeb90460:c525faab:cdaab792 
/dev/etherd/e0.[01234]

would be a thing to try?

Frankly, I'm terrified that I'll screw this up - I'm not too savy with raid.

following is a record of the only thing that I've done so far:

Please note that /dev/md1 is composed of 5 attitional drive which share 
the same hardware as the failed /dev/md0, but are in no other way related.

We're seriously considering sending the drives to a data recovery place 
and spending a bazillion bucks to recover the data.  if anyone reading 
this feels confident that they can help us rebuild this array and get us 
to a place where we can copy the data off of it. Please send mail to 
support@abhost.net.  We'll be happy to pay you for your services. - I'll 
post a summary of what we did when all is done.

help, please.

comparing the superblocks below with those posted yesterday, you can see 
that things have changed. I'm pulling my hair out - I hope I didn't bork 
our data.

-- Jonathan

hazel /tmp # df -H
Filesystem             Size   Used  Avail Use% Mounted on
/dev/hda4               67G   5.8G    58G  10% /
udev                   526M   177k   526M   1% /dev
/dev/hda3              8.1G    34M   7.7G   1% /tmp
none                   526M      0   526M   0% /dev/shm
/dev/md1               591G    34M   561G   1% /md1
hazel /tmp # mdadm -C /dev/md0 -n 4 -l 5 missing /dev/etherd/e0.[023]
mdadm: /dev/etherd/e0.0 appears to be part of a raid array:
    level=5 devices=4 ctime=Mon Jan  3 03:16:48 2005
mdadm: /dev/etherd/e0.2 appears to be part of a raid array:
    level=5 devices=4 ctime=Mon Jan  3 03:16:48 2005
mdadm: /dev/etherd/e0.3 appears to contain an ext2fs file system
    size=720300416K  mtime=Wed Oct  5 16:39:28 2005
mdadm: /dev/etherd/e0.3 appears to be part of a raid array:
    level=5 devices=4 ctime=Mon Jan  3 03:16:48 2005
Continue creating array? y
mdadm: array /dev/md0 started.
hazel /tmp # aoe-stat
    e0.0            eth1              up
    e0.1            eth1              up
    e0.2            eth1              up
    e0.3            eth1              up
    e0.4            eth1              up
    e0.5            eth1              up
    e0.6            eth1              up
    e0.7            eth1              up
    e0.8            eth1              up
    e0.9            eth1              up
hazel /tmp # cat /proc/mdstat
Personalities : [raid5]
md1 : active raid5 etherd/e0.9[4] etherd/e0.8[3] etherd/e0.7[2] 
etherd/e0.6[1] etherd/e0.5[0]
      586082688 blocks level 5, 32k chunk, algorithm 0 [4/4] [UUUU]

md0 : active raid5 etherd/e0.3[3] etherd/e0.2[2] etherd/e0.0[1]
      586082688 blocks level 5, 64k chunk, algorithm 2 [4/3] [_UUU]

unused devices: <none>
hazel /tmp # mkdir /md0
hazel /tmp # mount -r /dev/md0 /md0
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       or too many mounted file systems
hazel /tmp # mount -t ext2 -r /dev/md0 /md0
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       or too many mounted file systems
hazel /tmp # mdadm -S /dev/md0
hazel /tmp # aoe-stat
    e0.0            eth1              up
    e0.1            eth1              up
    e0.2            eth1              up
    e0.3            eth1              up
    e0.4            eth1              up
    e0.5            eth1              up
    e0.6            eth1              up
    e0.7            eth1              up
    e0.8            eth1              up
    e0.9            eth1              up
hazel /tmp # cat /proc/mdstat
Personalities : [raid5]
md1 : active raid5 etherd/e0.9[4] etherd/e0.8[3] etherd/e0.7[2] 
etherd/e0.6[1] etherd/e0.5[0]
      586082688 blocks level 5, 32k chunk, algorithm 0 [4/4] [UUUU]

unused devices: <none>
hazel /tmp # mdadm -E /dev/etherd/e0.[01234]
/dev/etherd/e0.0:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : ec0bdbb3:f625880f:dbf65130:057d069c
  Creation Time : Fri Apr 21 22:56:18 2006
     Raid Level : raid5
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Fri Apr 21 22:56:18 2006
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 1742f65 - correct
         Events : 0.3493634

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1     152        0        1      active sync   /dev/etherd/e0.0

   0     0       0        0        0      removed
   1     1     152        0        1      active sync   /dev/etherd/e0.0
   2     2     152       32        2      active sync   /dev/etherd/e0.2
   3     3     152       48        3      active sync   /dev/etherd/e0.3
/dev/etherd/e0.1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8fe1fe85:eeb90460:c525faab:cdaab792
  Creation Time : Mon Jan  3 03:16:48 2005
     Raid Level : raid5
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0

    Update Time : Fri Apr 21 14:03:12 2006
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 3
  Spare Devices : 1
       Checksum : 4cc991d7 - correct
         Events : 0.3493633

         Layout : left-asymmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     4     152       16        4      spare   /dev/etherd/e0.1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2     152       32        2      active sync   /dev/etherd/e0.2
   3     3     152       48        3      active sync   /dev/etherd/e0.3
   4     4     152       16        4      spare   /dev/etherd/e0.1
/dev/etherd/e0.2:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : ec0bdbb3:f625880f:dbf65130:057d069c
  Creation Time : Fri Apr 21 22:56:18 2006
     Raid Level : raid5
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Fri Apr 21 22:56:18 2006
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 1742f87 - correct
         Events : 0.3493634

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2     152       32        2      active sync   /dev/etherd/e0.2

   0     0       0        0        0      removed
   1     1     152        0        1      active sync   /dev/etherd/e0.0
   2     2     152       32        2      active sync   /dev/etherd/e0.2
   3     3     152       48        3      active sync   /dev/etherd/e0.3
/dev/etherd/e0.3:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : ec0bdbb3:f625880f:dbf65130:057d069c
  Creation Time : Fri Apr 21 22:56:18 2006
     Raid Level : raid5
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Fri Apr 21 22:56:18 2006
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 1742f99 - correct
         Events : 0.3493634

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3     152       48        3      active sync   /dev/etherd/e0.3

   0     0       0        0        0      removed
   1     1     152        0        1      active sync   /dev/etherd/e0.0
   2     2     152       32        2      active sync   /dev/etherd/e0.2
   3     3     152       48        3      active sync   /dev/etherd/e0.3
/dev/etherd/e0.4:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8fe1fe85:eeb90460:c525faab:cdaab792
  Creation Time : Mon Jan  3 03:16:48 2005
     Raid Level : raid5
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0

    Update Time : Thu Apr 20 21:07:50 2006
          State : clean
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 4cc84d59 - correct
         Events : 0.3482550

         Layout : left-asymmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     0     152       64        0      active sync   /dev/etherd/e0.4

   0     0     152       64        0      active sync   /dev/etherd/e0.4
   1     1     152        0        1      active sync   /dev/etherd/e0.0
   2     2     152       32        2      active sync   /dev/etherd/e0.2
   3     3     152       48        3      active sync   /dev/etherd/e0.3
   4     4     152       16        4      spare   /dev/etherd/e0.1


