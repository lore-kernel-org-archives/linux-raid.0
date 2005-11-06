From: Forrest Taylor <ftaylor@redhat.com>
Subject: Re: Weird fdisk -l output
Date: Sun, 06 Nov 2005 06:31:32 -0700
Message-ID: <1131283892.18407.53.camel@maddy.taylor.com>
References: <Pine.LNX.4.61.0511051820570.10541@gpu.utcc>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0511051820570.10541@gpu.utcc>
Sender: linux-raid-owner@vger.kernel.org
To: Derek Yeung <dky@utcc.utoronto.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2005-11-05 at 18:29 -0500, Derek Yeung wrote:
> 
> Hello!
> 
> I'm running RedHat Linux and kernel version 2.4.21-37.ELsmp, with 
> raidtools: raidtools-1.00.3-8
> and mdadm-1.5.0-9
> 
> At the moment I have 4 disks - sda, sdb, sdc, sdd.  They're all the same 
> size (36G).  I have 3 software raid devices; md0, md1 and md9.
> 
> For some reason, fdisk -l shows the /dev/md* "doesn't contain a valid 
> partition table".
> 
> /proc/mdstat says:
>    md1 : active raid1 sdb1[1] sda1[0]
>          104320 blocks [2/2] [UU]
> 
>    md0 : active raid1 sdb2[1] sda2[0]
>          35736512 blocks [2/2] [UU]
> 
>    md9 : active raid1 sdd1[1] sdc1[0]
>          35840896 blocks [2/2] [UU]
> 
> However, fdisk -l says:
>    Disk /dev/md1: 36.7 GB, 36701077504 bytes
>    2 heads, 4 sectors/track, 8960224 cylinders
>    Units = cylinders of 8 * 512 = 4096 bytes
> 
>    Disk /dev/md1 doesn't contain a valid partition table
> 
> And this is the case only for the software raid (md*) devices.
> 
> 
> but, fdisk -l /dev/sda says:
>    Disk /dev/sda: 36.7 GB, 36703934464 bytes
>    255 heads, 63 sectors/track, 4462 cylinders
>    Units = cylinders of 16065 * 512 = 8225280 bytes
> 
>       Device Boot    Start       End    Blocks   Id  System
>    /dev/sda1   *         1        13    104391   fd  Linux raid autodetect
>    /dev/sda2            14      4462  35736592+  fd  Linux raid autodetect
> 
> 
> 
> The system runs fine..  I don't see any impairment because of this... Any 
> ideas why, and how this can be fixed?  Is this a disaster waiting to 
> happen?

No, this is not a disaster waiting to happen--it is expected behavior.
Your md devices have no partition table, and they usually do not.  Your
sdX devices do, so that you can create multiple md devices from them.
fdisk, in fact, is simply used to manipulate the partition table on your
physical disks.  Once you have partitions on sdX, you can combine them
into your md devices.

Forrest

