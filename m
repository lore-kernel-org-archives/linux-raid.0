From: Farkas Levente <lfarkas@bnap.hu>
Subject: mdadm never notify, grub cause fault
Date: Fri, 16 May 2003 11:21:30 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EC4AD9A.6090104@bnap.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

hi,
we've got an raid1 arroy with two 120Gb maxtor hd (hda, hdc) runs rh9. 
very ofter hdc faild (although it seems there is no physical error). in
/etc/mdadm.conf:
--------------------------
DEVICE /dev/hd[ac]1
ARRAY /dev/md0 UUID=a64f771d:9934a60a:39c1483d:2f4a9138
MAILADDR root@bnap.hu
--------------------------
we assume if we run:
/sbin/mdadm --monitor --scan --daemonise > /var/run/mdadm
than we'll get a notification in this case. unfortunately we didn't get 
any notice! even when I stop this monitor and start it again we still 
didn't got any email. do mdadm periodicaly send the notification? or it 
send only once and if it fails for some reason we never get notified?
I'd like to get notification about it! even in every minutes. or is 
there any other way to check the state in every hour?

another important question why we loose one of out hd? I assume grub 
cause it. since yesterday I upgrade the kernel and after that I've to 
manualy install grub (root device is on md0). so I run
--------------------------
grub
 > root (hd0,0)
 > setup (hd0)
 > root (hd1,0)
 > setup (hd1)
--------------------------
during the next boot:
--------------------------
hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdc: dma_intr: error=0x40 { UncorrectableError }, LBAsect=23072927, 
sector=23072864
end_request: I/O error, dev 16:01 (hdc), sector 23072864
raid1: Disk failure on hdc1, disabling device.
         Operation continuing on 1 devices
raid1: hdc1: rescheduling block 23072864
md: updating md0 RAID superblock on device
md: hda1 [events: 00000013]<6>(write) hda1's sb offset: 117949120
md: recovery thread got woken up ...
md0: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...
md: (skipping faulty hdc1 )
raid1: hda1: redirecting sector 23072864 to another mirror
--------------------------
currently
--------------------------
cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 hda1[0] hdc1[1](F)
       117949120 blocks [2/1] [U_]

unused devices: <none>
--------------------------
and
--------------------------
mdadm --detail /dev/md0
/dev/md0:
         Version : 00.90.00
   Creation Time : Sun May  4 12:12:40 2003
      Raid Level : raid1
      Array Size : 117949120 (112.49 GiB 120.78 GB)
     Device Size : 117949120 (112.49 GiB 120.78 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Thu May 15 23:57:06 2003
           State : dirty, no-errors
  Active Devices : 1
Working Devices : 1
  Failed Devices : 1
   Spare Devices : 0


     Number   Major   Minor   RaidDevice State
        0       3        1        0      active sync   /dev/hda1
        1      22        1        1      faulty   /dev/hdc1
            UUID : a64f771d:9934a60a:39c1483d:2f4a9138
          Events : 0.19
--------------------------
what is the prefered reconstruction in this case?:
mdadm /dev/md0 -f /dev/hdc1 -r /dev/hdc1 -a /dev/hdc1
or?
thanks for any help in advance.

-- 
   Levente                               "Si vis pacem para bellum!"


