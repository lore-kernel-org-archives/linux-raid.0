From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Interesting double failure
Date: Thu, 26 Nov 2009 04:25:46 -0500 (EST)
Message-ID: <alpine.DEB.2.00.0911260423500.30110@p34.internal.lan>
References: <4B0E0C37.1030605@neb.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B0E0C37.1030605@neb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tamas Vincze <vincze@neb.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 26 Nov 2009, Tamas Vincze wrote:

> sda3 and sdf3 are the two members of a RAID-1.
> Both disks are the same model (300GB WD velociraptors), have the same
> partition layout and are on two different controllers.
> This is what happened yesterday: the same sector failed on both disks at the
> same time. I have a feeling that it's a bug somewhere or perhaps a power
> spike? The box is on a UPS.
> Running CentOS 5.4 stock kernel: 2.6.18-164.6.1
> Any thoughts?
>
> Nov 24 08:08:12 sm kernel: sd 1:0:0:0: SCSI error: return code = 0x08000002
> Nov 24 08:08:12 sm kernel: sdf: Current: sense key: Medium Error
> Nov 24 08:08:12 sm kernel:     Add. Sense: Record not found
> Nov 24 08:08:12 sm kernel:
> Nov 24 08:08:12 sm kernel: Info fld=0x1f2d8240
> Nov 24 08:08:12 sm kernel: end_request: I/O error, dev sdf, sector 523076160
> Nov 24 08:08:12 sm kernel: raid1: Disk failure on sdf3, disabling device.
> Nov 24 08:08:12 sm kernel:      Operation continuing on 1 devices
> Nov 24 08:08:12 sm kernel: sd 0:0:0:0: SCSI error: return code = 0x08000002
> Nov 24 08:08:12 sm kernel: sda: Current: sense key: Medium Error
> Nov 24 08:08:12 sm kernel:     Add. Sense: Record not found
> Nov 24 08:08:12 sm kernel:
> Nov 24 08:08:12 sm kernel: Info fld=0x1f2d8240
> Nov 24 08:08:12 sm kernel: end_request: I/O error, dev sda, sector 523076160
> Nov 24 08:08:12 sm kernel: RAID1 conf printout:
> Nov 24 08:08:12 sm kernel:  --- wd:1 rd:2
> Nov 24 08:08:12 sm kernel:  disk 0, wo:0, o:1, dev:sda3
> Nov 24 08:08:12 sm kernel:  disk 1, wo:1, o:0, dev:sdf3
> Nov 24 08:08:12 sm kernel: RAID1 conf printout:
> Nov 24 08:08:12 sm kernel:  --- wd:1 rd:2
> Nov 24 08:08:12 sm kernel:  disk 0, wo:0, o:1, dev:sda3
>
> Disk /dev/sdf: 300.0 GB, 300069052416 bytes
> 255 heads, 63 sectors/track, 36481 cylinders, total 586072368 sectors
> Units = sectors of 1 * 512 = 512 bytes
>
>   Device Boot      Start         End      Blocks   Id  System
> /dev/sdf1   *          63      514079      257008+  fd  Linux raid autodetect
> /dev/sdf2          514080     1028159      257040   fd  Linux raid autodetect
> /dev/sdf3         1028160   523076399   261024120   fd  Linux raid autodetect
> /dev/sdf4       523076400   586067264    31495432+  fd  Linux raid autodetect
>
> The failed sector is near the end of the partition.
> There's LVM on top of the raid and only the first 30GB or so is allocated,
> so it wasn't any filesystem that made the request to that sector.
> It must have been either the LVM or raid metadata, but I'm not sure where
> they are allocated.
>
> Oh, and it continued to operate on sda3 even though that also seem to have
> failed.
>

Hi,

Do not use velociraptors in RAID, they do not work, I have confirmed this 
finding here:
http://forums.storagereview.net/index.php?showtopic=27303

In addition, just for the sake of it I tried a RAID with Windows 7 with 
four-drives and the same problem happened.

What you are seeing is completely normal, these drives are broken for a 
RAID configuration and WD will not replace them with other models.

Justin.


