From: Richard Gomes <rgomes.info@gmail.com>
Subject: Boot fails from one of the drives cos it's not an ext4 filesystem.
Date: Thu, 30 Jan 2014 21:08:13 +0000
Message-ID: <52EABF3D.5060100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[ 3rd time I'm trying to post this! :(  This Majordomo sucks :( ]

Hello,

I have /dev/sda and /dev/sdb in RAID1.

I've discovered that I can boot from partition /dev/sda1 but not from
/dev/sdb1.

Apparently, both disks have equivalent partition tables:

    # sfdisk -l /dev/sda

    Disk /dev/sda: 121601 cylinders, 255 heads, 63 sectors/track
    Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting
    from 0

       Device Boot Start     End   #cyls    #blocks   Id  System
    /dev/sda1   *      0+     60-     61-    487424   fd  Linux raid
    autodetect
    /dev/sda2         60+   7841-   7781-  62499840   fd  Linux raid
    autodetect
    /dev/sda3       7841+ 121601- 113760- 913773568   fd  Linux raid
    autodetect
    /dev/sda4          0       -       0          0    0  Empty


    # sfdisk -l /dev/sdb

    Disk /dev/sdb: 121601 cylinders, 255 heads, 63 sectors/track
    Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting
    from 0

       Device Boot Start     End   #cyls    #blocks   Id  System
    /dev/sdb1   *      0+     60-     61-    487424   fd  Linux raid
    autodetect
    /dev/sdb2         60+   7841-   7781-  62499840   fd  Linux raid
    autodetect
    /dev/sdb3       7841+ 121601- 113760- 913773568   fd  Linux raid
    autodetect
    /dev/sdb4          0       -       0          0    0  Empty



But /parted/ tells me a different story.
This is the culprit: /dev/sdb1 is not known as ext4, as it should be.

    # parted -l
    Model: ATA ST1000DM003-9YN1 (scsi)
    Disk /dev/sda: 1000GB
    Sector size (logical/physical): 512B/4096B
    Partition Table: msdos

    Number  Start   End     Size    Type     File system  Flags
     1      1049kB  500MB   499MB   primary  ext4         boot, raid
     2      500MB   64.5GB  64.0GB  primary               raid
     3      64.5GB  1000GB  936GB   primary               raid


    Model: ATA ST1000DM003-9YN1 (scsi)
    Disk /dev/sdb: 1000GB
    Sector size (logical/physical): 512B/4096B
    Partition Table: msdos

    Number  Start   End     Size    Type     File system  Flags
     1      1049kB  500MB   499MB   primary               boot, raid
     2      500MB   64.5GB  64.0GB  primary               raid
     3      64.5GB  1000GB  936GB   primary               raid


What would be a recommended way to fix this issue?

Thanks
-- 
Richard Gomes
http://rgomes.info
http://www.linkedin.com/in/rgomes
mobile: +44(77)9955-6813
inum <http://www.inum.net/>: +883(5100)0800-9804
sip:rgomes@ippi.fr

