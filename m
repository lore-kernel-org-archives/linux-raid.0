From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: Boot fails from one of the drives cos it's not an ext4
 filesystem.
Date: Fri, 31 Jan 2014 09:52:46 +0000
Message-ID: <BLU0-SMTP249E446B64AB9D79F0AEAA098AE0@phx.gbl>
References: <52EABF3D.5060100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52EABF3D.5060100@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Gomes <rgomes.info@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2014-01-30 at 21:08 +0000, Richard Gomes wrote:
> [ 3rd time I'm trying to post this! :(  This Majordomo sucks :( ]
> 
> Hello,
> 
> I have /dev/sda and /dev/sdb in RAID1.
> 
> I've discovered that I can boot from partition /dev/sda1 but not from
> /dev/sdb1.
> 
> Apparently, both disks have equivalent partition tables:
> 
>     # sfdisk -l /dev/sda
> 
>     Disk /dev/sda: 121601 cylinders, 255 heads, 63 sectors/track
>     Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting
>     from 0
> 
>        Device Boot Start     End   #cyls    #blocks   Id  System
>     /dev/sda1   *      0+     60-     61-    487424   fd  Linux raid
>     autodetect
>     /dev/sda2         60+   7841-   7781-  62499840   fd  Linux raid
>     autodetect
>     /dev/sda3       7841+ 121601- 113760- 913773568   fd  Linux raid
>     autodetect
>     /dev/sda4          0       -       0          0    0  Empty
> 
> 
>     # sfdisk -l /dev/sdb
> 
>     Disk /dev/sdb: 121601 cylinders, 255 heads, 63 sectors/track
>     Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting
>     from 0
> 
>        Device Boot Start     End   #cyls    #blocks   Id  System
>     /dev/sdb1   *      0+     60-     61-    487424   fd  Linux raid
>     autodetect
>     /dev/sdb2         60+   7841-   7781-  62499840   fd  Linux raid
>     autodetect
>     /dev/sdb3       7841+ 121601- 113760- 913773568   fd  Linux raid
>     autodetect
>     /dev/sdb4          0       -       0          0    0  Empty
> 
> 
> 
> But /parted/ tells me a different story.
> This is the culprit: /dev/sdb1 is not known as ext4, as it should be.
> 
>     # parted -l
>     Model: ATA ST1000DM003-9YN1 (scsi)
>     Disk /dev/sda: 1000GB
>     Sector size (logical/physical): 512B/4096B
>     Partition Table: msdos
> 
>     Number  Start   End     Size    Type     File system  Flags
>      1      1049kB  500MB   499MB   primary  ext4         boot, raid
>      2      500MB   64.5GB  64.0GB  primary               raid
>      3      64.5GB  1000GB  936GB   primary               raid
> 
> 
>     Model: ATA ST1000DM003-9YN1 (scsi)
>     Disk /dev/sdb: 1000GB
>     Sector size (logical/physical): 512B/4096B
>     Partition Table: msdos
> 
>     Number  Start   End     Size    Type     File system  Flags
>      1      1049kB  500MB   499MB   primary               boot, raid
>      2      500MB   64.5GB  64.0GB  primary               raid
>      3      64.5GB  1000GB  936GB   primary               raid

As far as I know, the flags are redundant to a degree; although they
"may" be used as a hint.

Making a drive bootable requires a boot sector loader of some form (as
mentioned in Roberts post).

If you can output the result of  cat /proc/mdstat and also the mdadm
outputs as suggested by Robert then a more informed response can be
given.

> 
> 
> What would be a recommended way to fix this issue?
> 
> Thanks


