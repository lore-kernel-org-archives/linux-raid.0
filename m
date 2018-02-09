From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Fri, 9 Feb 2018 14:02:53 -0600
Message-ID: <CAAMCDeeQwD2i7cgpVPtv7DJkfbSkuQkRhzaSMHeWbo74D9tsmA@mail.gmail.com>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org> <aedfc1ac-a95f-b20f-2713-87cf412afdf4@uni-konstanz.de>
 <20180209192928.vliiwkv6q76jf6jp@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180209192928.vliiwkv6q76jf6jp@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Kay Diederichs <kay.diederichs@uni-konstanz.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I would not count on it with the WD's.   I have several only one has
bad blocks, but some of the blocks have been re-written many times and
the disk firmware  still won't relocate.

Some of mine I can read and get a failure, and force a rewrite, and
then it will fail on the next read pass a few hours later, and again
get re-written to the same block that will again go bad shortly.

Whatever the firmware is doing it has too high of a threshhold or is
too stupid to reliably relocate sectors even when they are obviously
bad.

On Fri, Feb 9, 2018 at 1:29 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Wed, Feb 07, 2018 at 10:42:39AM +0100, Kay Diederichs wrote:
>> I've adjusted the last-block and first-block numbers in the command
>> above so that they
>> a) encompass the known bad blocks
>> b) start and end on 4k-boundaries
>>
>> This command leaves those blocks intact that still can be read.
>>
>> After that, use a destructive-write badblocks e.g.
>>
>> badblocks -sfvwb512 /dev/sdh <x> <y>
>> You'll have to adjust x and y to match just those blocks that cannot be
>> read, based on the output of the first badblocks run.
>
> I will try this next, thanks (still, for learning purposes).
>
> But, I'm confused by what happened. The md check ran to completion.
> It found things and supposedly fixed them:
> [240351.053406] md/raid:md7: read error corrected (8 sectors at 9159374528 on sdf1)
>
> Strangely, it did nothing with this:
> [287271.959779] sd 4:4:0:0: [sdh] tag#6 Add. Sense: Unrecovered read error - auto reallocate failed
>
> The full resync/check is here:
> [89601.694910] md: data-check of RAID array md7
> [240342.514062] ata5.02: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x0
> [240342.514073] ata5.02: failed command: READ FPDMA QUEUED
> [240342.514081] ata5.02: cmd 60/60:30:70:fc:f0/02:00:21:02:00/40 tag 6 ncq dma 311296 in
> [240342.514086] ata5.02: status: { DRDY ERR }
> [240342.514089] ata5.02: error: { UNC }
> [240342.515351] ata5.02: configured for UDMA/133
> [240342.515470] ata5.02: exception Emask 0x1 SAct 0x0 SErr 0x0 action 0x0 t4
> [240342.515578] sd 4:2:0:0: [sdf] tag#6 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [240342.515585] sd 4:2:0:0: [sdf] tag#6 Sense Key : Medium Error [current]
> [240342.515590] sd 4:2:0:0: [sdf] tag#6 Add. Sense: Unrecovered read error - auto reallocate failed
> [240342.515596] sd 4:2:0:0: [sdf] tag#6 CDB: Read(16) 88 00 00 00 00 02 21 f0 fc 70 00 00 02 60 00 00
> [240342.515600] print_req_error: I/O error, dev sdf, sector 9159375984
> [240342.515726] ata5: EH complete
> [240350.486141] ata5.02: exception Emask 0x0 SAct 0x30 SErr 0x0 action 0x0
> [240350.486153] ata5.02: failed command: READ FPDMA QUEUED
> [240350.486160] ata5.02: cmd 60/08:20:c0:fe:f0/00:00:21:02:00/40 tag 4 ncq dma 4096 in
> [240350.486166] ata5.02: status: { DRDY ERR }
> [240350.486169] ata5.02: error: { UNC }
> [240350.487403] ata5.02: configured for UDMA/133
> [240350.487450] sd 4:2:0:0: [sdf] tag#4 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [240350.487454] sd 4:2:0:0: [sdf] tag#4 Sense Key : Medium Error [current]
> [240350.487458] sd 4:2:0:0: [sdf] tag#4 Add. Sense: Unrecovered read error - auto reallocate failed
> [240350.487462] sd 4:2:0:0: [sdf] tag#4 CDB: Read(16) 88 00 00 00 00 02 21 f0 fe c0 00 00 00 08 00 00
> [240350.487466] print_req_error: I/O error, dev sdf, sector 9159376576
> [240350.487493] ata5: EH complete
> [240351.053406] md/raid:md7: read error corrected (8 sectors at 9159374528 on sdf1)
> [287271.958430] ata5.04: exception Emask 0x0 SAct 0xffc0 SErr 0x0 action 0x0
> [287271.958442] ata5.04: failed command: READ FPDMA QUEUED
> [287271.958449] ata5.04: cmd 60/40:30:f0:d7:64/05:00:86:02:00/40 tag 6 ncq dma 688128 in
> [287271.958454] ata5.04: status: { DRDY ERR }
> [287271.958457] ata5.04: error: { UNC }
> [287271.959691] ata5.04: configured for UDMA/133
> [287271.959770] sd 4:4:0:0: [sdh] tag#6 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [287271.959775] sd 4:4:0:0: [sdh] tag#6 Sense Key : Medium Error [current]
> [287271.959779] sd 4:4:0:0: [sdh] tag#6 Add. Sense: Unrecovered read error - auto reallocate failed
> [287271.959783] sd 4:4:0:0: [sdh] tag#6 CDB: Read(16) 88 00 00 00 00 02 86 64 d7 f0 00 00 05 40 00 00
> [287271.959785] print_req_error: I/O error, dev sdh, sector 10844690416
> [287271.959889] ata5: EH complete
> [315132.651910] md: md7: data-check done.
>
> Now, the sync is comnplete, and my bad blocks are still there?
> myth:~# smartctl -A /dev/sdh
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       2
>
> myth:~# smartctl -A /dev/sdf
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       7
>
> The pending sectors should have been re-written and become Reallocated_Event_Count, no?
>
> Reading
> myth:~# hdparm --read-sector 287409520 /dev/sdh
> still gives me what looks like non garbage data (but it could be) and
> [315411.087451] ata5.04: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [315411.087462] ata5.04: failed command: READ SECTOR(S) EXT
> [315411.087469] ata5.04: cmd 24/00:01:70:4f:bc/00:00:4c:00:00/e0 tag 0 pio 512 in
> [315411.087469]          res 51/40:01:70:4f:bc/00:00:4c:00:00/e0 Emask 0x9 (media error)
> [315411.087474] ata5.04: status: { DRDY ERR }
> [315411.087478] ata5.04: error: { UNC }
> [315411.108028] ata5.04: configured for UDMA/133
> [315411.108075] ata5: EH complete
>
> So, mdadm is happy allegedly, but my drives still have the same bad sectors they had
> (more or less).
>
> Yes, I know I should trash (return) those drives, but I still want to
> understand why I can't get basic block remapping working
> Any idea what went wrong?
>
> Thanks,
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
