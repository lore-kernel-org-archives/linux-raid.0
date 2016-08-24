From: travis+ml-linux-raid@subspacefield.org
Subject: Re: bootsect replicated in p1, RAID enclosure suggestions?
Date: Tue, 23 Aug 2016 19:14:13 -0700
Message-ID: <20160824021413.GM32250@subspacefield.org>
References: <20160823050947.GL32250@subspacefield.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160823050947.GL32250@subspacefield.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

$ mdadm --version
mdadm - v3.2.5 - 18th May 2012
$ uname -a
Linux hostname 3.2.0-107-generic #148-Ubuntu SMP Mon Jul 18 20:22:08 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
$ cat /etc/lsb-release 
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=12.04
DISTRIB_CODENAME=precise
DISTRIB_DESCRIPTION="Ubuntu 12.04.5 LTS"

And I think there must be a bug in referencing the beginning of a
partition vs the beginning of the disk which leads to this.  Back when
I was using raw disk devices I had corruption in the first cylinders
which also held the mdlabel and I thought the lack of a partition
table was the problem... obviously not.

Could very well be a bug in USB enclosure firmware too.  Hard to know
how to proceed.

On Mon, Aug 22, 2016 at 10:09:47PM -0700, travis+ml-linux-raid@subspacefield.org wrote:
> Hello all,
> 
> So I have an Intel NUC (for low power Linux) plugged via USB into a 4
> bay enclosure doing linear (yeah I know; it's the backup server, the
> primary is raid10).
> 
> And every once in a while, this happens (*see end).  The partition 1
> that would normally contain a MD slice ends up being a replica of the
> boot cylinder.  I can't tell if it's the mdraid linear impl, the
> kernel doing something weird, the USB drivers, the enclosure firmware,
> or what.
> 
> Anyway, this happened while I was restoring a Windows machine whose
> root drive suddenly took a nosedive, and it happens every 6 months
> or so.  Today it happened while I was in the middle of recovering
> a Windows machine whose 1TB SSD threw up on C: and totally nuked
> the data.
> 
> The last low-power option I tried was an OpenRD Ultimate based around
> ARMv5TE which was basically unsupported by debian by the time I got
> it, and subsequently became ultra-flaky due to what seemed to be RAM
> problems - it was crashing every 3 days with kernel panics, and every
> once in a while would do something worse.
> 
> Any recommendations on a low power hardware with a well-supported
> distro, that matches up well with a real backplane and SATA
> connections instead of USB.  The only caveat is that I want to encrypt
> raw disks and it has to not be very noisy - so no rackmount gear
> with 65dB 1" dog whistle fans.  Obviously, whatever backplane must
> be well-supported by the distro.
> 
> Also, does anyone have experience with cryptsetup on multiple
> partitions?  I can do that but get prompted multiple times and I was
> wondering if anyone knew an easy way to fix the boot time scripts to
> avoid that, only prompting once per unique underlying crypttab.
> 
> And finally, I have a story about buggy drive firmware that you
> might enjoy, especially if you were doing this sort of stuff in
> the 90s as well.  Cheers:
> 
> http://www.subspacefield.org/security/hard_drives_of_doom/
> 
> 
> [*]
> 
> # parted /dev/sde
> GNU Parted 2.3
> Using /dev/sde
> Welcome to GNU Parted! Type 'help' to view a list of commands.
> (parted) p                                                                
> Model: WDC WD40 EFRX-68WT0N0 (scsi)
> Disk /dev/sde: 4001GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> 
> Number  Start   End     Size    File system  Name        Flags
>  1      1049kB  4001GB  4001GB               Linux RAID  raid
> 
> (parted) q                                                                
> # parted /dev/sdd1
> GNU Parted 2.3
> Using /dev/sdd1
> Welcome to GNU Parted! Type 'help' to view a list of commands.
> (parted) p                                                                
> Model: Unknown (unknown)
> Disk /dev/sdd1: 4001GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> 
> Number  Start   End     Size    File system  Name        Flags
>  1      1049kB  4001GB  4001GB               Linux RAID  raid
> 
> -- 
> http://www.subspacefield.org/~travis/ | if spammer then john@subspacefield.org
> "Computer crime, the glamor crime of the 1970s, will become in the
> 1980s one of the greatest sources of preventable business loss."
> John M. Carroll, "Computer Security", first edition cover flap, 1977
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
http://www.subspacefield.org/~travis/ | if spammer then john@subspacefield.org
"Computer crime, the glamor crime of the 1970s, will become in the
1980s one of the greatest sources of preventable business loss."
John M. Carroll, "Computer Security", first edition cover flap, 1977
