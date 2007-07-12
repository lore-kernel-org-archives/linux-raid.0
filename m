From: "Johny Mail list" <maillist.johny@gmail.com>
Subject: Re: Linux Software RAID is really RAID?
Date: Thu, 12 Jul 2007 18:27:11 +0200
Message-ID: <cd98e0260707120927l3c7663f2j61024cd56a5207d2@mail.gmail.com>
References: <cd98e0260706261043t32fe6609ye1e4e252c722358c@mail.gmail.com>
	 <46815C3F.6090204@wasp.net.au> <468A05A4.60006@gmail.com>
	 <cd98e0260707030517y1fbb60ban29063439f2665834@mail.gmail.com>
	 <468AD708.2010806@rtr.ca> <468AF5F8.9060703@gmail.com>
	 <468BED49.2030301@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <468BED49.2030301@rtr.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <htejun@gmail.com>, Brad Campbell <brad@wasp.net.au>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

2007/7/4, Mark Lord <liml@rtr.ca>:
> Tejun Heo wrote:
> > Mark Lord wrote:
> >> I believe he said it was ICH5 (different post/thread).
> >>
> >> My observation on ICH5 is that if one unplugs a drive,
> >> then the chipset/cpu locks up hard when toggling SRST
> >> in the EH code.
> >>
> >> Specifically, it locks up at the instruction
> >> which restores SRST back to the non-asserted state,
> >> which likely corresponds to the chipset finally actually
> >> sending a FIS to the drive.
> >>
> >> A hard(ware) lockup, not software.
> >> That's why Intel says ICH5 doesn't do hotplug.
> >
> > OIC.  I don't think there's much left to do from the driver side then.
> > Or is there any workaround?
>
> The workaround I have, for 2.6.18.8, is to provide an "offline()" method
> for ICH5 that polls for device present before attempting SRST.
>
> I hope to eventually clean this up and submit it for you,
> after your existing polling-hp code goes upstream.
>
> Here's my present hack (below).  Feel free to use/ignore.
>
> ***
>
> Implement ICH5 chipset handling for drive hot insertion/removal.
> This cannot go upstream, as it conflicts with a more generic
> polled-hotplug framework that is currently in development.
>
> Hot-inserted drives are automatically detected within a second or two,
> and are ready-to-use within 30 seconds or so.
>
> Hot-removed drives are *not* noticed by the kernel until the next
> time they are accessed.  If you want this to happen quickly,
> then just launch a script like this from /etc/inittab at boot time:
>
>    #!/bin/bash
>    ( while ( /bin/true ) ; do /sbin/hdparm -C /dev/sd[a-z] ; sleep 5 ; done ) &>/dev/null &
>
> Signed-off-by: Mark Lord <mlord@pobox.com>
> ---
>

Hello,
Thanks this patch work in my case after unplug-in my hard drive.
But the situation is strange.
The first time it functioned fine and i get this messages :
[  290.452296] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[  290.452378] ata2.00: tag 0 cmd 0xea Emask 0x4 stat 0x40 err 0x0 (timeout)
[  290.452635] ata2 (port 1): status=d0 pcs=0x0013 offline=1 delay=100 usecs
[  290.452697] ata2: soft resetting port
[  290.452787] ata2: SATA link down (SStatus 0 SControl 0)
[  290.463065] ATA: abnormal status 0x7F on port 0xCCA7
[  290.463154] ata2: EH complete
[  290.463224] sd 1:0:0:0: SCSI error: return code = 0x00040000
[  290.463286] end_request: I/O error, dev sdb, sector 156248058
[  290.463362] raid1: Disk failure on sdb2, disabling device.
[  290.463365]  Operation continuing on 1 devices
[  290.465590] RAID1 conf printout:
[  290.465651]  --- wd:1 rd:2
[  290.465710]  disk 0, wo:0, o:1, dev:sda3
[  290.465767]  disk 1, wo:1, o:0, dev:sdb2
[  290.480225] RAID1 conf printout:
[  290.480281]  --- wd:1 rd:2
[  290.480370]  disk 0, wo:0, o:1, dev:sda3
[  290.619960] ata2: pcs_hotplug_poll: old=0033 new=0013
[  290.620045] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x2 frozen
[  290.620114] ata2: (hotplug event)
[  290.620178] ata2: soft resetting port
[  290.620242] ata2: SATA link down (SStatus 0 SControl 0)
[  290.630518] ATA: abnormal status 0x7F on port 0xCCA7
[  290.630588] ata2: EH complete
[  290.630652] ata2.00: detaching (SCSI 1:0:0:0)

But with a second try when i unplug the disk (with the while loop in
background task) the unplug function wad not started, i need to change
the partition table with fdisk to get the disk offline :
[  397.764666] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[  397.770229] ata2.00: (BMDMA stat 0x21)
[  397.775771] ata2.00: tag 0 cmd 0xc8 Emask 0x4 stat 0x40 err 0x0 (timeout)
[  397.781502] ata2 (port 1): status=d0 pcs=0x0013 offline=1 delay=100 usecs
[  397.787046] ata2: soft resetting port
[  397.792614] ata2: SATA link up <unknown> (SStatus 0 SControl 0)
[  397.808327] ATA: abnormal status 0x7F on port 0xCCA7
[  397.813910] ata2: EH complete
[  397.819501] sd 1:0:0:0: SCSI error: return code = 0x00040000
[  397.825049] end_request: I/O error, dev sdb, sector 32
[  397.830613] Buffer I/O error on device sdb, logical block 4
[  397.836177] Buffer I/O error on device sdb, logical block 5
[  397.841748] Buffer I/O error on device sdb, logical block 6
[  397.847315] Buffer I/O error on device sdb, logical block 7
[  397.852874] Buffer I/O error on device sdb, logical block 8
[  397.858440] Buffer I/O error on device sdb, logical block 9
[  397.864021] Buffer I/O error on device sdb, logical block 10
[  397.869579] Buffer I/O error on device sdb, logical block 11
[  397.875177] sd 1:0:0:0: SCSI error: return code = 0x00040000
[  397.880734] end_request: I/O error, dev sdb, sector 0
[  397.886312] Buffer I/O error on device sdb, logical block 0
[  397.891889] lost page write due to I/O error on sdb
[  398.283654] ata2: pcs_hotplug_poll: old=0033 new=0013
[  398.289250] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x2 frozen
[  398.294843] ata2: (hotplug event)
[  398.300433] ata2: soft resetting port
[  398.305997] ata2: SATA link up <unknown> (SStatus 0 SControl 0)
[  398.321732] ATA: abnormal status 0x7F on port 0xCCA7
[  398.327329] ata2: EH complete
[  398.332904] ata2.00: detaching (SCSI 1:0:0:0)

Before i do the change in the partition table my system was normal,
and a fdisk -l /dev/sdb give me the right table (but my disk was
disconnected ...).

Thanks for paying attention of my problem :)
