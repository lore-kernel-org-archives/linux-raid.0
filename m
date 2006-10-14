From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Cannot create RAID5 - device or resource busy
Date: Sat, 14 Oct 2006 14:46:04 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0610141445490.13112@p34.internal.lan>
References: <b8j0j2p670ad9v56fiubtk3c8ej841mp2b@4ax.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b8j0j2p670ad9v56fiubtk3c8ej841mp2b@4ax.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ray Greene <raygr@es.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

See if its mounted/etc first, if not: mdadm -S /dev/md0 (stop it)

Then try again.


On Sat, 14 Oct 2006, Ray Greene wrote:

> I am having problems creating a RAID 5 array using 3x400GB SATA drives
> on a Dell SC430 running Xandros 4.
> 
> I created this once with Webmin and it worked OK but then I deleted it
> and started again as I believe the chunk size was too small at 4kb,
> the default size with Webmin.
> 
> I have repartitioned and formatted the drives. I have tried creating
> the array with Webmin and at the console but it always fails with the
> same error.
> 
> This is the command I use:
> mdadm --create --verbose /dev/md0 --level=raid5 --chunk=256 --run
> --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1
> 
> mdadm: layout defaults to left-symmetric
> mdadm: /dev/sdb1 appears to contain an ext2fs file system
>     size=390708800K  mtime=Wed Dec 31 19:00:00 1969
> mdadm: /dev/sdc1 appears to contain an ext2fs file system
>     size=390708800K  mtime=Wed Dec 31 19:00:00 1969
> mdadm: /dev/sdd1 appears to contain an ext2fs file system
>     size=390708800K  mtime=Wed Dec 31 19:00:00 1969
> mdadm: size set to 390708736K
> mdadm: creation continuing despite oddities due to --run
> mdadm: SET_ARRAY_INFO failed for /dev/md0: Device or resource busy
> 
> 
> This is the output from fdisk -l :
> Disk /dev/sdb: 400.0 GB, 400088457216 bytes
> 255 heads, 63 sectors/track, 48641 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
> Device  Boot Start End  Blocks    Id System
> /dev/sdb1     1   48641 390708801 fd Linux raid autodetect
> 
> Disk /dev/sdc: 400.0 GB, 400088457216 bytes
> 255 heads, 63 sectors/track, 48641 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
> Device  Boot Start End  Blocks    Id System
> /dev/sdc1     1   48641 390708801 fd Linux raid autodetect
> 
> Disk /dev/sdd: 400.0 GB, 400088457216 bytes
> 255 heads, 63 sectors/track, 48641 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
> Device  Boot Start End  Blocks    Id System
> /dev/sdd1     1   48641 390708801 fd Linux raid autodetect
> 
> 
> Why does it always give the error "Device or resource busy", and what
> can I do about it?
> 
> - 
> Ray Greene
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
