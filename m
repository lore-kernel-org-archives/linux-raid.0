From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: Software RAID-5 attempt to access beyond end of device...
Date: Sun, 29 Aug 2004 11:27:50 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41322026.6010107@nsr500.net>
References: <1093621033.13979.49.camel@slurp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1093621033.13979.49.camel@slurp>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Two performance suggestions.

1. Consider two RAID-1 arrays: hde+hdg (41MB) and hdi+hdk (80MB) which 
would give much better performance over RAID-5 and lower failure 
probability without giving up any storage capacity.

2. Set the P2B BIOS to have both promise controllers on IRQ 14 which is 
unused in your system (remember to disable the primary motherboard IDE and 
you may have to rearrange PCI slot positions).  This will give much better 
interrupt performance than having the controllers sharing USB and mouse 
interrupt cycles.

Rgds,
tim

Sebastian Utz wrote:
> Hello,
> 
> I have a problem with an Software RAID-5 at the top of 4 IDE-Drives
> connected via 2 Promise UltraTX2 (20268) IDE controller.
> 
> FS is EXT3.
> Kernel 2.6.8.1	(problem occured with 2.6.7, update didn't helped)
> CPU: Pentium II 400
> Mainboard: Asus P2B-S
> 
> After 29% usage, I've got an Kernel oops and system stalls:
> -------- snip start -------------
> ---------------- snip end -----------
> 
> 2 Disks are around 40 GB, 2 are around 80GB.
> All 4 disk are different size and manufacturer, maybe this is the
> problem?
> 
> more info about my system:
> raidtab:
> raiddev /dev/md0
>         raid-level      5
>         nr-raid-disks   4
>         nr-spare-disks  0
>         persistent-superblock 1
>         parity-algorithm        left-symmetric
>         chunk-size      32
>         device          /dev/hde1
>         raid-disk       0
>         device          /dev/hdg1
>         raid-disk       1
>         device          /dev/hdi1
>         raid-disk       2
>         device          /dev/hdk1
>         raid-disk       3
> 
> gharb:~# df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda3             7.9G  1.6G  6.0G  21% /
> /dev/sda1              47M   20M   25M  46% /boot
> /dev/md0              114G   31G   78G  29% /data
> 
> 

-- 
  | for direct mail add "private_" in front of user name
