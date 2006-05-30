From: "Michael Theodoulou" <michael.theodoulou@gmail.com>
Subject: RAID 5 Whole Devices - Partition
Date: Tue, 30 May 2006 20:08:03 +0300
Message-ID: <4e40e93e0605301008x34bc03dekb9a35952668e7a14@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am trying to create a RAID5 array out of 3 160GB SATA drives. After
i create the array i want to partition the device into 2 partitions.

The system lies on a SCSI disk and the 2 partitions will be used for
data storage.
The SATA host is an HPT374 device with drivers compiled in the kernel.

These are the steps i followed

mdadm -Cv --auto=part /dev/md_d0 --chunk=64 -l 5 --raid-devices=3
/dev/hde /dev/hdi /dev/hdk

Running this command notifies me that there is an ext2 fs on one of
the drives even if i fdisked them before and removed all partititions.
Why is this happening?

In anycase i continue with the array creation

After initialization 5 new devices are created in /dev

/dev/md_d0
/dev/md_d0p1
/dev/md_d0_p1
/dev/md_d0_p2
/dev/md_d0_p3
/dev/md_d0_p4

The problems arise when i reboot.
A device /dev/md0 seems to keep the 3 disks busy and as a result when
the time comes
to assemble the array i get the error that the disks are busy.
When the system boots i cat /proc/mdstat and see that /dev/md0 is a
raid5 array made of the two disks and it comes up as degraded

I can then stop the array using mdadm -S /dev/md0 and restart it using
mdadm -As which uses the correct /dev/md_d0. Examining that shows its
clean and ok

/dev/md_d0:
        Version : 00.90.01
  Creation Time : Tue May 30 17:03:31 2006
     Raid Level : raid5
     Array Size : 312581632 (298.10 GiB 320.08 GB)
    Device Size : 156290816 (149.05 GiB 160.04 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue May 30 19:48:03 2006
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0      33        0        0      active sync   /dev/hde
       1      56        0        1      active sync   /dev/hdi
       2      57        0        2      active sync   /dev/hdk
           UUID : 9f520781:7f3c2052:1cb5078e:c3f3b95c
         Events : 0.2

Is this the expected behavior? Why doesnt the kernel ignore /dev/md0
and tries to use it? I tried using raid=noautodetect but it didnt help
I am using 2.6.9

This is my mdadm.conf
DEVICE /dev/hde /dev/hdi /dev/hdk
ARRAY /dev/md_d0 level=raid5 num-devices=3
UUID=9f520781:7f3c2052:1cb5078e:c3f3b95c
   devices=/dev/hde,/dev/hdi,/dev/hdk auto=partition
MAILADDR myemail@mydomain.tld

Furthermore when i fdisk the drives after all of this i can see the 2
partitions on /dev/hde and /dev/hdi but /dev/hdk shows that no
partition exists. Is this a sign of data corruption or drive failure?
Shouldnt all 3 drives show the same partition information?
fdisk /dev/hde
/dev/hde1               1       19457   156288352   fd  Linux raid autodetect

fdisk /dev/hdi
/dev/hdi1               1       19457   156288321   fd  Linux raid autodetect

And for fdisk /dev/hdk i get :
Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

So what am i doing wrong? How can i get the expected behavior? ie on
bootime a RAID5 array is created and available from /dev/md_d0

Thank you for your time
Michael Theodoulou
