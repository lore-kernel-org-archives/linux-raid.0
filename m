From: Steven Ihde <x-linux-raid@hamachi.dyndns.org>
Subject: Re: Looking for the cause of poor I/O performance - a test script
Date: Mon, 27 Dec 2004 16:13:39 -0800
Message-ID: <20041228001339.GA5614@hamachi.us>
References: <200412082241.iB8Mfo915469@www.watkins-home.com> <41BC07C2.5020303@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41BC07C2.5020303@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids



I found strange behavior with this script.  You may recall my setup
has a three disk RAID5, kernel 2.6.8, lvm2.

While I can achieve 80MB/s reading from /dev/md1 (my RAID5 device), I
can't get better than 60MB/s from any of the logical volumes which
exist on that array.  (/dev/md1 is the only PV in that VG.)
Furthermore, the readahead settings on /dev/md1 don't seem to make any
difference, only the readahead setting on /dev/vg0/lvol0 (for example)
matters.  This doesn't make any sense to me.  I didn't think LVM was
supposed to impose any significant overhead.  

Is the LVM2/DM layer doing its own readahead through to the PV,
regardless of the settings I'm doing with blockdev --setra?

Finally, when trying to test throughput reading from an actual file on
a filesystem, I couldn't figure out how to flush the cache reliably.
"blockdev --flushbufs" works great when the test is reading straight
from the block device but has no effect when reading from a file on a
filesystem.  Any advice here?  A pointer to an up-to-date in-depth
description (for 2.6) of how the whole cache/buffer thing works would
be very much appreciated.

Thanks!

-Steve



On Sun, 12 Dec 2004 08:56:34 +0000, David Greaves wrote:
> I hacked up a quick script to test permutations of readahead - it's not 
> exactly bonnie+++ but it may be useful.
> I wish I'd bothered with mdadm stripe sizes too - but the array is 
> pretty full now and I'll live with what it delivers.
> 
> Essentially I found the best performance on *my* system with all low 
> level devices and the md device set to a 0 readahead and the lvm device 
> set to 4096.
> I'm only interested in video streaming big (1+Gb) files. Your needs (and 
> hence test) may differ.
> 
> my system is 2.6.10-rc2, xfs, lvm2, raid5, sata disks.
> 
> cc'ed the lvm group since this often seems to come up in conjunction 
> with you guys :)
> 
> For your entertainment...
> 
> #!/bin/bash
> RAW_DEVS="/dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/hdb"
> MD_DEVS=/dev/md0
> LV_DEVS=/dev/huge_vg/huge_lv
> 
> LV_RAS="0 128 256 1024 4096 8192"
> MD_RAS="0 128 256 1024 4096 8192"
> RAW_RAS="0 128 256 1024 4096 8192"
> 
> function show_ra()
> {
> for i in $RAW_DEVS $MD_DEVS $LV_DEVS
> do echo -n "$i `blockdev --getra $i`  ::  "
> done
> echo
> }
> 
> function set_ra()
> {
>  RA=$1
>  shift
>  for dev in $@
>  do
>    blockdev --setra $RA $dev
>  done
> }
> 
> function show_performance()
> {
>  COUNT=4000000
>  dd if=/dev/huge_vg/huge_lv of=/dev/null count=$COUNT 2>&1 | grep seconds
> }
> 
> for RAW_RA in $RAW_RAS
>  do
>  set_ra $RAW_RA $RAW_DEVS
>  for MD_RA in $MD_RAS
>    do
>    set_ra $MD_RA $MD_DEVS
>    for LV_RA in $LV_RAS
>      do
>      set_ra $LV_RA $LV_DEVS
>      show_ra
>      show_performance
>      done
>    done
>  done
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

