From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: How do I tell which disk failed?
Date: Mon, 07 Jan 2013 23:59:56 -0800
Message-ID: <1357631996.16366.139.camel@corn.betterworld.us>
References: <1357610701.16366.13.camel@corn.betterworld.us>
	 <50EBAC5D.8080000@hardwarefreak.com>
	 <1357628351.16366.86.camel@corn.betterworld.us>
	 <02B6762C-3755-4CE3-9AB1-A48D3384CACB@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02B6762C-3755-4CE3-9AB1-A48D3384CACB@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: ross@biostat.ucsf.edu, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2013-01-08 at 00:17 -0700, Chris Murphy wrote:
> On Jan 7, 2013, at 11:59 PM, Ross Boylan <ross@biostat.ucsf.edu> wrote:
> >> 
> > Isn't it possible there's a hardware problem, e.g., leading to a
> > failure/retry cycle?
> 
> smartctl -a /dev/sda
> smartctl -a /dev/sdb
> smartctl -a /dev/sdc
> 
> Compare them. If there was a write failure reported by the drive, md would have marked the device faulty.
> 
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
In response to your other query about the locations of the partitions:
# parted /dev/sda unit s p select /dev/sdb p select /dev/sdc p
Model: ATA ST3750330NS (scsi)
Disk /dev/sda: 1465149168s
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start     End          Size         Type     File system  Flags
 1      63s       192779s      192717s      primary  ext3         boot, raid
 2      192780s   4096574s     3903795s     primary
 3      4096575s  1465144064s  1461047490s  primary               raid

Using /dev/sdb
Model: ATA WDC WD2003FYYS-0 (scsi)
Disk /dev/sdb: 3907029168s
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start     End          Size         File system  Name                   Flags
 1      34s       999999s      999966s                   extended boot loaders
 2      1000000s  2929687s     1929688s     ext3         /boot                  boot
 3      2929688s  6835937s     3906250s                  swap
 4      6835938s  3907029134s  3900193197s               main

Using /dev/sdc
Model: ATA WDC WD2003FYYS-0 (scsi)
Disk /dev/sdc: 3907029168s
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start     End          Size         File system  Name                   Flags
 1      34s       999999s      999966s                   extended boot loaders
 2      1000000s  2929687s     1929688s     ext3         boot                   boot
 3      2929688s  6835937s     3906250s                  swap
 4      6835938s  3907029134s  3900193197s               main

BTW the spec sheet for the WDC "red" drives says they use advanced
formatting (I may not have the buzzword quite right) with physical
sectors of 4k.  So the reported sector size is a fib.

Ross

P.S. I didn't explicitly respond to Stan's comment that I might have
tweaked my sync speed down.  I haven't deliberately, though I suppose
something could have done it behind my back.  The increased performance
as time passed does suggest something else was loading the io system,
though it seems odd that happened without noticeable cpu use.

