From: Michael Ole Olsen <gnu@gmx.net>
Subject: Re: how to resize volume group lvm2?
Date: Fri, 12 Jun 2009 21:14:21 +0200
Message-ID: <20090612191421.GB14231@rlogin.dk>
References: <20090610215835.GA4936@clouds> <4A303178.5060208@anonymous.org.uk> <20090612183339.GB4936@clouds> <20090612185841.GA14231@rlogin.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090612185841.GA14231@rlogin.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guess I was too quick with that one..

pvresize /dev/md0 was all that was needed, no need for restart :-)


On Fri, 12 Jun 2009, Michael Ole Olsen wrote:

> How do I resize my volume group with lvm2?
> 
> vgextend needs new devices but I only have one device md0 for all my physical
> volumes.
> 
> I know how to resize my logical volumes under the volume group, but somehow
> the volume group st1500 did not extend after raid5 reshape with mdadm?
> 
> Is my only option backing up 8TB of data and creating a new volume group?
> 
> I dont want to add sd[ai] here with vgextend as lvm2 is on top of 
> mdadm so I guess I should have only one device for my VG?
> 
> /Michael Ole Olsen
> 
> mfs:~# fdisk -l /dev/md0
> 
> Disk /dev/md0: 12002.4 GB, 12002414559232 bytes
> 2 heads, 4 sectors/track, -1364690304 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
> Disk identifier: 0x00000000
> 
> Disk /dev/md0 doesn't contain a valid partition table
> 
> mfs:~# vgdisplay
>   --- Volume group ---
>   VG Name               st1500
>   System ID             
>   Format                lvm2
>   Metadata Areas        1
>   Metadata Sequence No  4
>   VG Access             read/write
>   VG Status             resizable
>   MAX LV                0
>   Cur LV                2
>   Open LV               1
>   Max PV                0
>   Cur PV                1
>   Act PV                1
>   VG Size               8,19 TB
>   PE Size               4,00 MB
>   Total PE              2146198
>   Alloc PE / Size       2104832 / 8,03 TB
>   Free  PE / Size       41366 / 161,59 GB
>   VG UUID               1Rl7ly-OguV-fEbS-TU8F-7tdM-9YH3-wKc9F6
> 
> lvm> help vgextend
>   vgextend: Add physical volumes to a volume group
> 
> vgextend
>         [-A|--autobackup y|n]
>         [-d|--debug]
>         [-h|--help]
>         [-t|--test]
>         [-v|--verbose]
>         [--version]
>         VolumeGroupName PhysicalDevicePath [PhysicalDevicePath...]
> 
>   Command failed with status code 0.
> lvm> vgextend st1500 /dev/md0
>   Physical volume '/dev/md0' is already in volume group 'st1500'
>   Unable to add physical volume '/dev/md0' to volume group 'st1500'.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
