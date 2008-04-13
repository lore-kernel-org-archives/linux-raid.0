From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Question: how to identify failing disk in a RAID1
Date: Sun, 13 Apr 2008 15:29:50 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0804131529300.11311@p34.internal.lan>
References: <48025B8D.2030803@harddata.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48025B8D.2030803@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 13 Apr 2008, Maurice Hilarius wrote:

> Hi there.
>
> Recently I have been frequently seeing a damaged filesystem on a RAID1 on 
> boot.
> a lengthy fsck does get it working, but I am seeing files disappearing as a 
> result.
>
> I am pretty sure that one of the drives has developed some issues and needs 
> to be replaced.
>
> How does one identify which of the 2 disks is the one that is failing?
>
> The system has 2 identical disks, and  / is on md0
>
> fstab:
> /dev/md0                /                       ext3    defaults        1 1
> LABEL=/boot1            /boot                   ext2    defaults        1 2
> tmpfs                   /dev/shm                tmpfs   defaults        0 0
> devpts                  /dev/pts                devpts  gid=5,mode=620  0 0
> sysfs                   /sys                    sysfs   defaults        0 0
> proc                    /proc                   proc    defaults        0 0
> LABEL=/boot11           /boot1                  ext2    defaults        1 2
> LABEL=SWAP-sdb3         swap                    swap    defaults        0 0
> LABEL=SWAP-sda2         swap                    swap    defaults        0 0
>
> fdisk -l shows me:
> Disk /dev/sda: 400.0 GB, 400088457216 bytes
> 255 heads, 63 sectors/track, 48641 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
>  Device Boot      Start         End      Blocks   Id  System
> /dev/sda1   *           1          13      104391   83  Linux
> /dev/sda2              14         535     4192965   82  Linux swap / Solaris
> /dev/sda3             536       48641   386411445   fd  Linux raid autodetect
>
> Disk /dev/sdb: 400.0 GB, 400088457216 bytes
> 255 heads, 63 sectors/track, 48641 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
>  Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1   *           1          13      104391   83  Linux
> /dev/sdb2              14       48118   386403412+  fd  Linux raid autodetect
> /dev/sdb3           48119       48640     4192965   82  Linux swap / Solaris
>
> Disk /dev/md0: 395.6 GB, 395677007872 bytes
> 2 heads, 4 sectors/track, 96600832 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
>
> Anyone have a suggestion, please?
> Responses off list are probably most appropriate.
>
> Thanks for any help.
>
> -- 
> Regards, Maurice
> mhilarius@gmail.com
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

smartctl -a /dev/sda
smartctl -a /dev/sdb

also, how come swap was not on the raid1?
