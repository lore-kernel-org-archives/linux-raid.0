From: Brad Campbell <brad@wasp.net.au>
Subject: Re: raid5 code ok with 2TB + ?
Date: Sun, 28 Nov 2004 15:28:25 +0400
Message-ID: <41A9B659.2080703@wasp.net.au>
References: <Pine.LNX.4.61.0411281146490.17548@adsl.a2000.nu> <41A9AF2C.5010706@wasp.net.au> <Pine.LNX.4.61.0411281215310.17548@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0411281215310.17548@adsl.a2000.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Stephan van Hienen <raid@a2000.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stephan van Hienen wrote:
> On Sun, 28 Nov 2004, Brad Campbell wrote:
> 
>> I hope so, I have been using it on a 2.2TB raid-5 for months now. (I 
>> have completely filled the partition and e2fsck it monthly so I would 
>> hope any glitches should have surfaced by now)
> 
> 
> ok looks ok
> when i tried 2.3TB last year it failed within a few days (data written 
> to the 2TB+ was written to the first part (0-0.3TB)
> 
> btw which filesystem are you using ?
> (and which stripesize?)

Ext3 and ...

brad@srv:~$ sudo mdadm --misc --detail /dev/md0
/dev/md0:
         Version : 00.90.01
   Creation Time : Sun May  2 18:02:14 2004
      Raid Level : raid5
      Array Size : 2206003968 (2103.81 GiB 2258.95 GB)
     Device Size : 245111552 (233.76 GiB 250.99 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Sun Nov 28 06:44:04 2004
           State : clean
  Active Devices : 10
Working Devices : 10
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-asymmetric
      Chunk Size : 128K

            UUID : 05cc3f43:de1ecfa4:83a51293:78015f1e
          Events : 0.1031147

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/devfs/scsi/host0/bus0/target0/lun0/part1
        1       8       17        1      active sync   /dev/devfs/scsi/host1/bus0/target0/lun0/part1
        2       8       33        2      active sync   /dev/devfs/scsi/host2/bus0/target0/lun0/part1
        3       8       49        3      active sync   /dev/devfs/scsi/host3/bus0/target0/lun0/part1
        4       8       65        4      active sync   /dev/devfs/scsi/host4/bus0/target0/lun0/part1
        5       8       81        5      active sync   /dev/devfs/scsi/host5/bus0/target0/lun0/part1
        6       8       97        6      active sync   /dev/devfs/scsi/host6/bus0/target0/lun0/part1
        7       8      113        7      active sync   /dev/devfs/scsi/host7/bus0/target0/lun0/part1
        8       8      129        8      active sync   /dev/sdi1
        9       8      145        9      active sync   /dev/sdj1

-- 
Brad
                    /"\
Save the Forests   \ /     ASCII RIBBON CAMPAIGN
Burn a Greenie.     X      AGAINST HTML MAIL
                    / \
