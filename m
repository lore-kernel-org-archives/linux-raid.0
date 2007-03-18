From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Data corruption on software raid.
Date: Sun, 18 Mar 2007 12:09:44 -0500
Message-ID: <45FD7258.1040208@tmr.com>
References: <20070318131606.GJ6063@freshdot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070318131606.GJ6063@freshdot.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: ssmeenk@freshdot.net, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

(relativelySander Smeenk wrote:
> Hello!  Long story. Get some coke.
>
> I'm having an odd problem with using software raid on two Western
> Digital disks type WD2500JD-00F (250gb) connected to a Silicon Image
> Sil3112 PCI SATA conroller running with Linux 2.6.20, mdadm 2.5.6
>
> When these disks are in a raid1 set, downloading data to the raid1 set
> using scp or ftp causes some blocks of the data to corrupt on disk. Only
> the data downloaded gets corrupted, not the data that already was on the
> set. But when the data is first downloaded to another disk and locally
> moved to the raid1 set, the data stays just fine.
>   

This may be due to a characteristic of RAID1, which I believe Neil 
described when discussing "check" failures in using RAID1 for swap. In 
some cases, the data is being written from a user buffer, which is 
changing. and the RAID software does two write, one to each device, 
resulting in the data in the buffer changing as the write occurs. More 
on this at the end.

So when you copy from a file already on disk, the data is NOT changing, 
and no problem occurs. I assume that you have tried doing slow downloads 
to the md0 PATA device, and that this problem doesn't occur there. I 
have ideas why that would be, but I don't want to speculate.

Do you have some non-RAID partitions on one of those drives, such that 
the seek time might be markedly different on one or the other due to 
activity in that partition? That would increase the possible time 
between writes and therefore the possibility of differences in what's 
written.
> This alone is weird enough.
>
> But i decided to dig deeper and switched off the raid1 set, mounted both
> disks directly. Writing data to the disks directly works perfectly fine.
> No corruption anymore. The data written to the disks before using raid
> is still corrupted, so the corruption is really on disk.
>
> Then i decided to 'mke2fs -c -c' (read/write badblock check) both disks
> which returned null errors on the disks themselves. I stored ~240gb data
> on disk1 and verify-copied it to disk2. The contents stay the same.
>
> I also tried simultaneously writing data to disk1 and disk2 to 'emulate'
> raid1 disk activity, but no corruption occurred. I even moved the SATA
> PCI controller to a different slot to isolate IRQ problems. This made
> no change to the whole situation.
>
> So for all i know, the disks are fine, the controller is fine, it must
> be something in the software raid code, right?
>
> Wrong. My system is also running a raid1 set on IDE disks. This set is
> working just perfectly normal. No corruption when downloading data, no
> corruption when moving data about, no problems at all...
>
> My /proc/mdstat is one pool op happiness. It now reads:
>
> | Personalities : [raid1] 
> | md0 : active raid1 hda2[0] hdb1[1]
> |       120060736 blocks [2/2] [UU]
> |       
> | unused devices: <none>
>
> With the SATA set active it also has:
>
> | md1 : active raid1 sdb1[0] sda1[1]
> |       244198584 blocks [2/2] [UU]
> (NOTE: sdb1 is first, sda1 is second, this should not cause problems,
> i've had this in other setups before?)
>
> No problems are reported while rebuilding the md1 SATA set, although i
> think the disk-to-disk speed is rather slow with ~17MiB/sec measured by
> /proc/mdstat's output while rebuilding.
>
> | md: data-check of RAID array md1
> | md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> | md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) 
> | md: using 128k window, over a total of 244195904 blocks.
> | md: md1: data-check done.
> | RAID1 conf printout:
> |  --- wd:2 rd:2
> |  disk 0, wo:0, o:1, dev:sdb1
> |  disk 1, wo:0, o:1, dev:sda1
>
> When /using/ the disks in raid1 set, my dmesg did show signs of badness:
>
> | ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> | ata2.00: (BMDMA2 stat 0xc0009)
> | ata2.00: cmd c8/00:00:3f:43:47/00:00:00:00:00/e2 tag 0 cdb 0x0 data 131072 in
> |          res 51/40:00:86:43:47/00:00:00:00:00/e2 Emask 0x9 (media error)
> | ata2.00: configured for UDMA/100
> | ata2: EH complete
> | ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> | ata2.00: (BMDMA2 stat 0xc0009)
> | ata2.00: cmd c8/00:00:3f:43:47/00:00:00:00:00/e2 tag 0 cdb 0x0 data 131072 in
> |          res 51/40:00:86:43:47/00:00:00:00:00/e2 Emask 0x9 (media error)
> | ata2.00: configured for UDMA/100
> | ata2: EH complete
> | ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> | ata2.00: (BMDMA2 stat 0xc0009)
> | ata2.00: cmd c8/00:00:3f:43:47/00:00:00:00:00/e2 tag 0 cdb 0x0 data 131072 in
> |          res 51/40:00:86:43:47/00:00:00:00:00/e2 Emask 0x9 (media error)
> | ata2.00: configured for UDMA/100
> | ata2: EH complete
>
> But what amazes me is that no media errors can be detected by doing a
> write/read check on every sector of the disk with mke2fs, and no data
> corruption occurs when moving data to the set locally!
>
> Can anyone shed some light on what i can try next to isolate what is
> causing all this?  It's not the software raid code, the IDE set is
> working fine.  It's not the SATA controller, the disks are okay when
> used separately.  It's not the disks themselves, they show no errors
> with extensive testing.
>
> Weird 'eh?  Any comments appreciated!

I do have a thought which MIGHT address this issue in a general way, 
perhaps Neil will share he opinion. When writing to any array with 
multiple copies which are written from user buffers, perhaps the code 
could set the page(s) as copy on write. Then if the program tried to 
modify the data it could be done safely. When the write to all drives 
was complete, the COW could be cleared, and if the page had not been 
modified very little overhead would be generated. If the page had been 
modified, then the original would no longer be mapped to a process and 
could be released.

Neil, what think you? This would be e general solution to the mismatched 
multiple copies issue, assuming that it could be done at all.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

