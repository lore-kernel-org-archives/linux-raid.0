From: Thomas Andrews <tandrews@grok.co.za>
Subject: invalid (zero) superblock magic upon creation of a new RAID-1 array
Date: Sun, 5 Nov 2006 10:57:02 +0200
Message-ID: <20061105085702.GD20184@grok.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

Why would the superblock magic be zero on a newly created RAID-1 set?

I get this error when the kernel (2.6.17.7) boots:

    md: Autodetecting RAID arrays.
    md: invalid raid superblock magic on sda1, found 0x0 not 0xa92b4efc
    md: sda1 has invalid sb, not importing!
    md: invalid raid superblock magic on sda2, found 0x0 not 0xa92b4efc
    md: sda2 has invalid sb, not importing!
    md: invalid raid superblock magic on sdb1, found 0x0 not 0xa92b4efc
    md: sdb1 has invalid sb, not importing!
    md: invalid raid superblock magic on sdb2, found 0x0 not 0xa92b4efc
    md: sdb2 has invalid sb, not importing!
    md: autorun ...
    md: ... autorun DONE.

(I modified md.c so that it prints out "found xxxx not 0xa92b4efc")

I have a monolithic kernel, compiled for RAID-1.

Once the system is up and running, mdadm brings up the RAID arrays fine:

    # cat /proc/mdstat
    Personalities : [raid1] 
    md1 : active raid1 sda2[0] sdb2[1]
          506036 blocks super 1.0 [2/2] [UU]
          
    md0 : active raid1 sda1[0]
          312062456 blocks super 1.0 [2/1] [U_]
          
    unused devices: <none>

It is deliberately degraded, so that I can boot until I fix this problem.

    # dpkg -l mdadm | grep mdadm
    ii  mdadm  2.5.3.git200608202239-7 tool to administer Linux MD arrays (software RAID)

I've re-created the RAID set a couple of times just to make sure that I
did it correctly. Here's how:

    mdadm -C /dev/md0 --level=raid1 --raid-devices=2  /dev/sda1 missing

As I understand it, this can't be an issue with my config files, because
the error occurs *before* the filesystem is mounted.

    # fdisk -l /dev/sd[a-z]

    Disk /dev/sda: 320.0 GB, 320072933376 bytes
    255 heads, 63 sectors/track, 38913 cylinders
    Units = cylinders of 16065 * 512 = 8225280 bytes

       Device Boot      Start         End      Blocks   Id  System
    /dev/sda1   *           1       38850   312062593+  fd  Linux raid autodetect
    /dev/sda2           38851       38913      506047+  fd  Linux raid autodetect

    Disk /dev/sdb: 320.0 GB, 320072933376 bytes
    255 heads, 63 sectors/track, 38913 cylinders
    Units = cylinders of 16065 * 512 = 8225280 bytes

       Device Boot      Start         End      Blocks   Id  System
    /dev/sdb1   *           1       38850   312062593+  fd  Linux raid autodetect
    /dev/sdb2           38851       38913      506047+  fd  Linux raid autodetect

Some info about the (brand new) disks:

    # hdparm -I /dev/sda

    ATA device, with non-removable media
            Model Number:       WDC WD3200YS-01PGB0                     
            Serial Number:      WD-WCAPD2664999
            Firmware Revision:  21.00M21
    Standards:
            Supported: 7 6 5 4 
            Likely used: 7
    Configuration:
            Logical         max     current
            cylinders       16383   16383
            heads           16      16
            sectors/track   63      63
            --
            CHS current addressable sectors:   16514064
            LBA    user addressable sectors:  268435455
            LBA48  user addressable sectors:  625142448
            device size with M = 1024*1024:      305245 MBytes
            device size with M = 1000*1000:      320072 MBytes (320 GB)


Many thanks,
Thomas
