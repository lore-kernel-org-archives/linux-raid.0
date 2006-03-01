From: Sandro Dentella <sandro@e-den.it>
Subject: when --add after a fail?
Date: Wed, 1 Mar 2006 10:18:57 +0100
Message-ID: <20060301091857.GA8817@casa.e-den.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

   i've been using raid1 sisnce quite a loto of time. Sporadiccaly an array
   fails a disk and in many situations I can just pull the device into the
   array with

      mdadm /dev/mdN --add failded_device

   I've never really understood what is the magic that resurrexes it. I
   thought something related to relocation of bad blocks, but I'm  not at
   all aware of what happens "there"...

   Is that a correct trial to do?

   Now I have a device that throuws an error:

srv-ornago:/tmp# mdadm /dev/md2 --add /dev/hdc6 
mdadm: hot add failed for /dev/hdc6: Invalid argument

the kernel complains:
Mar  1 09:34:29 srv-ornago kernel: md: could not bd_claim hdc6.
Mar  1 09:34:29 srv-ornago kernel: md: error, md_import_device() returned -16

   is this enought to say the disk (pretty new, 6 months) is to be changed?
   which checks should I do.

Thanks in advance
sandro
*:-)


srv-ornago:/tmp# mdadm  --detail /dev/md2
/dev/md2:
        Version : 00.90.01
  Creation Time : Mon Apr 29 02:29:18 2002
     Raid Level : raid1
     Array Size : 5116544 (4.88 GiB 5.24 GB)
    Device Size : 5116544 (4.88 GiB 5.24 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Wed Mar  1 10:18:15 2006
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

           UUID : c203673d:0444f961:50e95acb:fb5b89ba
         Events : 0.1392171

    Number   Major   Minor   RaidDevice State
       0       3        6        0      active sync   /dev/.static/dev/ide/host0/bus0/target0/lun0/part6
       1       0        0        -      removed

       2      22        6        -      faulty   /dev/.static/dev/ide/host0/bus1/target0/lun0/part6

   

-- 
Sandro Dentella  *:-)
e-mail: sandro@e-den.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
