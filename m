From: Neil Brown <neilb@suse.de>
Subject: Re: RAID mapper device size wrong after replacing drives
Date: Fri, 7 Dec 2007 17:40:20 +1100
Message-ID: <18264.60116.275727.744999@notabene.brown>
References: <14200241.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ian P on Thursday December 6
Sender: linux-raid-owner@vger.kernel.org
To: Ian P <ian@underpressuredivers.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I think you would have more luck posting this to
linux-lvm@redhat.com - I think that is where support for device mapper
happens.

NeilBrown


On Thursday December 6, ian@underpressuredivers.com wrote:
> 
> Hi,
> 
> I have a problem with my RAID array under Linux after upgrading to larger
> drives. I have a machine with Windows and Linux dual-boot which had a pair
> of 160GB drives in a RAID-1 mirror with 3 partitions: partiton 1 = Windows
> boot partition (FAT32), partiton 2 = Linux /boot (ext3), partiton 3 =
> Windows system (NTFS). The Linux /root is on a separate physical drive. The
> dual boot is via Grub installed on the /boot partiton, and this was all
> working fine.
> 
> But I just upgraded the drives in the RAID pair, replacing them with 500GB
> drives. I did this by replacing one of the 160s with a new 500 and letting
> the RAID copy the drive, splitting the drives out of the RAID array and
> increasing the size of the last partition of the 500 (which I did under
> Windows since its the Windows partiton) then replacing the last 160 with the
> other 500 and having the RAID controller create a new array with the two
> 500s, copying the drive that I'd copied from the 160. This worked great for
> Windows, and that now boots and sees a 500GB RAID drive with all the data
> intact.
> 
> However, Linux has a problem and will not now boot all the way. It reports
> that the RAID /dev/mapper volume failed - the partition is beyond the
> boundaries of the disk. Running fdisk shows that it is seeing the larger
> partiton, but still sees the size of the RAID /dev/mapper drive as 160GB.
> Here is the fdisk output for one of the physical drives and for the RAID
> mapper drive:
> 
> Disk /dev/sda: 500.1 GB, 500107862016 bytes
> 255 heads, 63 sectors/track, 60801 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1         625     5018624    b  W95 FAT32
> Partition 1 does not end on cylinder boundary.
> /dev/sda2             626         637       96390   83  Linux
> /dev/sda3   *         638       60802   483264512    7  HPFS/NTFS
> 
> 
> Disk /dev/mapper/isw_bcifcijdi_Raid-0: 163.9 GB, 163925983232 bytes
> 255 heads, 63 sectors/track, 19929 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
>                             Device Boot      Start         End      Blocks  
> Id  System
> /dev/mapper/isw_bcifcijdi_Raid-0p1               1         625     5018624   
> b  W95 FAT32
> Partition 1 does not end on cylinder boundary.
> /dev/mapper/isw_bcifcijdi_Raid-0p2             626         637       96390  
> 83  Linux
> /dev/mapper/isw_bcifcijdi_Raid-0p3   *         638       60802   483264512   
> 7  HPFS/NTFS
> 
> 
> They differ only in the drive capacity and number of cylinders.
> 
> I started to try to run a Linux reinstall, but it reports that the partiion
> table on the mapper drive is invalid, giving an option to re-initialize it
> but saying that doing so will lose all the data on the drive.
> 
> So questions:
> 
> 1. Where is the drive size information for the RAID mapper drive kept, and
> is there some way to patch it?
> 
> 2. Is there some way to re-initialize the RAID mapper drive without
> destroying the data on the drive?
> 
> Thanks,
> Ian
> -- 
> View this message in context: http://www.nabble.com/RAID-mapper-device-size-wrong-after-replacing-drives-tf4958354.html#a14200241
> Sent from the linux-raid mailing list archive at Nabble.com.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
