From: spam@streefland.xs4all.nl (Dick Streefland)
Subject: RAID1 recovery fails with 2.6 kernel
Date: Sun, 19 Oct 2003 14:27:58 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <7da.3f929f6e.d36f3@altium.nl>
Reply-To: dick.streefland@xs4all.nl (Dick Streefland)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When I mark one of the devices in a RAID1 array faulty, remove it, and
re-add it, recovery starts, but stops too early, leaving the array in
degraded mode. I'me seeing this in the latest 2.6.0 kernels, including
2.6.0-test8. The 2.4.22 kernel works OK, although the array is marked
"dirty" (?). Below is a script to reproduce the problem, followed by
the output of the script. I'm using mdadm-1.3.0.

# cat raid-recovery
#!/bin/sh

dd bs=1024k count=20 if=/dev/zero of=/tmp/img1 2> /dev/null
dd bs=1024k count=20 if=/dev/zero of=/tmp/img2 2> /dev/null
sync
losetup /dev/loop1 /tmp/img1
losetup /dev/loop2 /tmp/img2
sync
mdadm -C -n 2 -l 1 /dev/md0 /dev/loop1 /dev/loop2
sleep 1
while grep resync /proc/mdstat; do sleep 1; done
sleep 1
cat /proc/mdstat
mdadm -QD /dev/md0

mdadm /dev/md0 -f /dev/loop2
mdadm /dev/md0 -r /dev/loop2
mdadm -QD /dev/md0

mdadm /dev/md0 -a /dev/loop2
while grep recovery /proc/mdstat; do sleep 1; done
sleep 1
cat /proc/mdstat
mdadm -QD /dev/md0

mdadm -S /dev/md0
losetup -d /dev/loop1
losetup -d /dev/loop2
rm /tmp/img1
rm /tmp/img2
# ./raid-recovery 
mdadm: array /dev/md0 started.
      [=>...................]  resync =  5.0% (1280/20416) finish=0.2min speed=1280K/sec
      [==>..................]  resync = 10.0% (2176/20416) finish=0.2min speed=1088K/sec
      [===>.................]  resync = 15.0% (3200/20416) finish=0.2min speed=1066K/sec
      [====>................]  resync = 20.0% (4224/20416) finish=0.2min speed=1056K/sec
      [=====>...............]  resync = 25.0% (5248/20416) finish=0.2min speed=1049K/sec
      [======>..............]  resync = 30.0% (6144/20416) finish=0.2min speed=1024K/sec
      [=======>.............]  resync = 35.0% (8064/20416) finish=0.1min speed=1152K/sec
      [========>............]  resync = 40.0% (9088/20416) finish=0.1min speed=1136K/sec
      [=========>...........]  resync = 45.0% (10112/20416) finish=0.1min speed=1123K/sec
      [==========>..........]  resync = 50.0% (11008/20416) finish=0.1min speed=1100K/sec
      [===========>.........]  resync = 55.0% (12032/20416) finish=0.1min speed=1093K/sec
      [============>........]  resync = 60.0% (13056/20416) finish=0.1min speed=1088K/sec
      [=============>.......]  resync = 65.0% (14080/20416) finish=0.0min speed=1083K/sec
      [==============>......]  resync = 70.0% (15104/20416) finish=0.0min speed=1078K/sec
      [===============>.....]  resync = 75.0% (16000/20416) finish=0.0min speed=1066K/sec
      [================>....]  resync = 80.0% (17024/20416) finish=0.0min speed=1064K/sec
      [=================>...]  resync = 85.0% (18048/20416) finish=0.0min speed=1061K/sec
      [==================>..]  resync = 90.0% (19072/20416) finish=0.0min speed=1059K/sec
      [===================>.]  resync = 95.0% (20096/20416) finish=0.0min speed=1057K/sec
Personalities : [raid1] 
md0 : active raid1 loop2[1] loop1[0]
      20416 blocks [2/2] [UU]
      
unused devices: <none>
/dev/md0:
        Version : 00.90.01
  Creation Time : Sun Oct 19 15:53:13 2003
     Raid Level : raid1
     Array Size : 20416 (19.94 MiB 20.91 MB)
    Device Size : 20416 (19.94 MiB 20.91 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Oct 19 15:53:34 2003
          State : clean, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       7        1        0      active sync   /dev/loop1
       1       7        2        1      active sync   /dev/loop2
           UUID : 102b76c8:1af754b8:5c8d47a0:fe849836
         Events : 0.1
mdadm: set device faulty failed for /dev/loop2:  Success
mdadm: hot removed /dev/loop2
/dev/md0:
        Version : 00.90.01
  Creation Time : Sun Oct 19 15:53:13 2003
     Raid Level : raid1
     Array Size : 20416 (19.94 MiB 20.91 MB)
    Device Size : 20416 (19.94 MiB 20.91 MB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Oct 19 15:53:35 2003
          State : clean, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       7        1        0      active sync   /dev/loop1
       1       0        0       -1      removed
           UUID : 102b76c8:1af754b8:5c8d47a0:fe849836
         Events : 0.3
mdadm: hot added /dev/loop2
      [=>...................]  recovery =  5.0% (1024/20416) finish=0.2min speed=1024K/sec
      [==>..................]  recovery = 10.0% (2048/20416) finish=0.1min speed=2048K/sec
Personalities : [raid1] 
md0 : active raid1 loop2[2] loop1[0]
      20416 blocks [2/1] [U_]
      
unused devices: <none>
/dev/md0:
        Version : 00.90.01
  Creation Time : Sun Oct 19 15:53:13 2003
     Raid Level : raid1
     Array Size : 20416 (19.94 MiB 20.91 MB)
    Device Size : 20416 (19.94 MiB 20.91 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Oct 19 15:53:37 2003
          State : clean, no-errors
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1


    Number   Major   Minor   RaidDevice State
       0       7        1        0      active sync   /dev/loop1
       1       0        0       -1      removed
       2       7        2        1      spare   /dev/loop2
           UUID : 102b76c8:1af754b8:5c8d47a0:fe849836
         Events : 0.5

-- 
Dick Streefland                    ////               De Bilt
dick.streefland@xs4all.nl         (@ @)       The Netherlands
------------------------------oOO--(_)--OOo------------------

