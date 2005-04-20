From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: remove resyncing disk
Date: Wed, 20 Apr 2005 20:54:48 +0200
Message-ID: <o4lij2-19q.ln1@news.it.uc3m.es>
References: <426688EA.80802@dynsysgroup.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robbie Hughes <spam@dynsysgroup.com> wrote:
>     Number   Major   Minor   RaidDevice State
>        0       0        0       -1      removed
>        1      22       66        1      active sync   /dev/hdd2
>        2       3        3        0      spare   /dev/hda3

> The main problem i have now is that this output is a day and a half 
> hence. It has been continually resyncing since I added the drive and 
> when it gets to 100%, it starts over.
> 
> I thought this was odd so i checked dmesg to find 8 messages like this:
> 
> hdd: dma_intr: status=0x51 { DriveReady SeekComplete Error }
> hdd: dma_intr: error=0x40 { UncorrectableError }, LBAsect=76658506, 
> sector=76658504
> end_request: I/O error, dev hdd, sector 76658504

Interesting. Write zeros to that sector on hdd and try again.


> finishing in a
> raid1: hdd: unrecoverable I/O read error for block 76052608
> md: md0: sync done.
> md: syncing RAID array md0
> md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
> md: using maximum available idle IO bandwith (but not more than 200000 
> KB/sec) for reconstruction.
> md: using 128k window, over a total of 39843648 blocks.
> 
> so i ran badblocks and discovered 8 bad blocks right at the tail end of 

You don't really care. You want to cause the drive to replace them with
good blocks, so write to them.

> my /dev/hdd2 drive that is the no (1) drive in the array, not the spare.

Peter

