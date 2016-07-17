From: Bhatia Amit <amitbhatia@rocketmail.com>
Subject: Cannot start array on disk
Date: Sun, 17 Jul 2016 19:59:52 +0000 (UTC)
Message-ID: <1124605843.526681.1468785592654.JavaMail.yahoo@mail.yahoo.com>
References: <1124605843.526681.1468785592654.JavaMail.yahoo.ref@mail.yahoo.com>
Reply-To: Bhatia Amit <amitbhatia@rocketmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi

I have a WD Live duo setup with two 3TB drives in RAID1. After a recent power surge etc, I could not access the enclosure data. I removed the drives out from the enclosure and connected them via esata cable to a Linux laptop. One of the drives had physical noise and failed to connect at all. The other drive was able to connect and showed up as /dev/sdc. Following some online search, I issued the following commands to get some results, but am unable to mount the drive to a linux laptop via esata. Questions:

* Ideally both sdc3 and sdc4 should have shown RAID=RAID1. If sdc4 is showing RAID=linear, is it because the other drive went totally bad, and software decided to reconfigure this drive from RAID1 to linear ?
* Given the one of the two drives is totally dead, is it still possible to reconfigure, mount and recover data from the single drive?
* I tried scanning the drive via r-linux and it does show files exist, but does not show any folder information. So data is there on the drive. Is there a way to recreate the setup with just this single drive, so that I can extract files with folder information?
* Looking at an online "derrick" script, the script seems to call mdadm create with the "missing" flag. Is that something I should be doing to be able to assemble and recover data from the drive ?
"mdadm --create $rootfsRaid --verbose --metadata=0.9 --raid-devices=2 --level=raid1 --run $diskRoot1 missing"

Thanks
Amit



Parted shows missing filesystem for sdc4 :
$ sudo parted -l
Model: ATA WDC WD30EZRX-00D (scsi)
Disk /dev/sdc: 3001GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
 3      15.7MB  528MB   513MB                primary  raid
 1      528MB   2576MB  2048MB  ext3         primary  raid
 2      2576MB  4624MB  2048MB  ext3         primary  raid
 4      4624MB  3001GB  2996GB               primary  raid


Mdstat shows only sdc3 as active, but sdc4 as inactive:
$ sudo cat /proc/mdstat
Personalities : [linear] [raid1]
md126 : active (auto-read-only) raid1 sdc3[2]
      500724 blocks super 1.0 [2/1] [_U]

md127 : inactive sdc4[0](S)
      2925750264 blocks super 1.0

unused devices: <none>


Trying to assemble and scan only shows /dev/sdc3 as active:
$ sudo mdadm --stop /dev/md12[567]
mdadm: stopped /dev/md126
mdadm: stopped /dev/md127
$ sudo cat /proc/mdstat
Personalities : [linear] [raid1]
unused devices: <none>
$ sudo mdadm --assemble --scan
mdadm: /dev/md/MyBookLiveDuo:3 assembled from 1 drive - not enough to start the array.
mdadm: /dev/md/MyBookLiveDuo:2 has been started with 1 drive (out of 2).
mdadm: /dev/md/MyBookLiveDuo:3 assembled from 1 drive - not enough to start the array.
$ sudo cat /proc/mdstat
Personalities : [linear] [raid1]
md127 : active raid1 sdc3[2]
      500724 blocks super 1.0 [2/1] [_U]

unused devices: <none>


Output from examine sdc3 is below, which mdstat says is active. It says RAID level = RAID1.
$ sudo mdadm --examine /dev/sdc3
/dev/sdc3:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 7c040c5e:9c30ac6d:e534a129:20457e22
           Name : MyBookLiveDuo:2
  Creation Time : Wed Dec 31 19:01:40 1969
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1001448 (489.07 MiB 512.74 MB)
     Array Size : 500724 (489.07 MiB 512.74 MB)
   Super Offset : 1001456 sectors
          State : clean
    Device UUID : 1d9fe3e3:d5ac7387:d9ededba:88ca24a5

    Update Time : Sun Jul  3 11:53:31 2016
       Checksum : 31589560 - correct
         Events : 101


   Device Role : Active device 1
   Array State : .A ('A' == active, '.' == missing)
$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md126 : active (auto-read-only) raid1 sdc3[2]
      500724 blocks super 1.0 [2/1] [_U]

md127 : inactive sdc4[0](S)
      2925750264 blocks super 1.0

unused devices: <none>



But, output from examine sdc4 is below, which says RAID level = linear.
$ sudo mdadm --examine /dev/sdc4
/dev/sdc4:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 374e689e:3bfd050c:ab0b0dce:2d50f5fd
           Name : MyBookLiveDuo:3
  Creation Time : Mon Sep 16 14:53:47 2013
     Raid Level : linear
   Raid Devices : 2

 Avail Dev Size : 5851500528 (2790.21 GiB 2995.97 GB)
  Used Dev Size : 0
   Super Offset : 5851500528 sectors
          State : clean
    Device UUID : 9096f74b:0a8f2b61:93347be3:6d3b6c1b

    Update Time : Mon Sep 16 14:53:47 2013
       Checksum : 77aa5963 - correct
         Events : 0

       Rounding : 0K

   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)


And partitions output is:
$ cat /proc/partitions
major minor  #blocks  name

   8        0 1953514584 sda
   8        1     102400 sda1
   8        2 1953411072 sda2
   8       16 1953514584 sdb
   8       17     248832 sdb1
   8       18          1 sdb2
   8       21 1953263616 sdb5
 252        0 1953261568 dm-0
 252        1 1919635456 dm-1
 252        2   33488896 dm-2
   8       32 2930266584 sdc
   8       33    1999872 sdc1
   8       34    1999872 sdc2
   8       35     500736 sdc3
   8       36 2925750272 sdc4

   9      126     500724 md126
