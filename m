From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Sun, 11 Feb 2018 14:52:25 -0600
Message-ID: <CAAMCDecS-W4T_uuSYQd+CzBOPjzOqKCtBhHh+JFvt-5FoKzQAQ@mail.gmail.com>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org> <aedfc1ac-a95f-b20f-2713-87cf412afdf4@uni-konstanz.de>
 <20180209192928.vliiwkv6q76jf6jp@merlins.org> <1227ce39-31af-22f2-f4fa-de85466f05c7@turmel.org>
 <20180209202958.6mieeomu5of45rjf@merlins.org> <59144df0-35b7-942f-22c8-754afd0f89c4@uni-konstanz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59144df0-35b7-942f-22c8-754afd0f89c4@uni-konstanz.de>
Sender: linux-raid-owner@vger.kernel.org
To: Kay Diederichs <kay.diederichs@uni-konstanz.de>
Cc: Marc MERLIN <marc@merlins.org>, Phil Turmel <philip@turmel.org>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On my wd I have some code that does a hdparm --read-sector  and if
that fails it does a hdparm --write-sector back once I know bad
sectors and where they are.  I started this after I get the drive
removed from mdraid, and I have had the write-sector successfully
write and verify the data and then minutes or hours later have the
--read-sector on that block fail again.

So from what I can tell my drive is useless trash because of the
firmware not being able to decide reasonably that the sector is not
recoverable, lucky this drive is still under warranty.

I have several other 3tb WD reds several of which are out of warranty
and have no issues as far as I can tell.  That is at least better luck
then I had with my 1.5 (about 80% of the drives replaced bad sectors
and ran out of spares, or where otherwise useless because of randomly
successfully reading bad blocks but pausing everything for less than
the 7second timeout).

On Fri, Feb 9, 2018 at 2:52 PM, Kay Diederichs
<kay.diederichs@uni-konstanz.de> wrote:
>
>
> Am 09/02/18 um 21:29 schrieb Marc MERLIN:
>> On Fri, Feb 09, 2018 at 03:13:26PM -0500, Phil Turmel wrote:
>>>> The pending sectors should have been re-written and become
>>>> Reallocated_Event_Count, no?
>>>
>>> Yes, and not necessarily.  Pending sectors can be non-permanent errors
>>> -- the drive firmware will test a pending sector immediately after write
>>> to see if the write is readable.  If not, it will re-allocate while it
>>> still has the write data in its buffers.  Otherwise, it'll clear the
>>> pending sector.
>>
>> This shows the sector is still bad though, right?
>>
>> myth:~# hdparm --read-sector 1287409520 /dev/sdh
>> /dev/sdh:
>> reading sector 1287409520: SG_IO: bad/missing sense data, sb[]:  70 00 03 00 00 00 00 0a 40 51 e0 01 11 04 00 00 a0 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00 succeeded
>> 7000 0b54 92c4 ffff 0000 0000 01fe 0000
>> (...)
>>
>> [ 2572.139404] ata5.04: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [ 2572.139419] ata5.04: failed command: READ SECTOR(S) EXT
>> [ 2572.139427] ata5.04: cmd 24/00:01:70:4f:bc/00:00:4c:00:00/e0 tag 28 pio 512 in
>> [ 2572.139427]          res 51/40:01:70:4f:bc/00:00:4c:00:00/e0 Emask 0x9 (media error)
>> [ 2572.139431] ata5.04: status: { DRDY ERR }
>> [ 2572.139435] ata5.04: error: { UNC }
>> [ 2572.162369] ata5.04: configured for UDMA/133
>> [ 2572.162414] ata5: EH complete
>>
>> mdadm also said it found 6 bad sectors and rewrote them (or something like that)
>> and it's happy. So alledgely it did something, but smart does not agree (yet?)
>>
>> I'm now running a long smart test on all drives, will see if numbers change.
>>
>> Mmmh, and I just ran
>> myth:~# badblocks -fsvnb512 /dev/sdh 1287409599 1287409400
>> below, and I don't quite understand what's going on.
>>
>>>> So, mdadm is happy allegedly, but my drives still have the same bad
>>>> sectors they had (more or less).
>>>
>>> If you have bad block lists enabled in your array, MD will *never* try
>>> to fix the underlying sectors.  Please show your mdadm -E reports for
>>> these devices.  If necessary, stop the array and re-assemble with the
>>> options to disable bad block lists.  { How this misfeature got into the
>>> kernel and enabled by default baffles me. }
>>
>> This means I dont have bad block lists?
>> myth:~# mdadm -E /dev/sdd e f g h all return
>> /dev/sdd:
>>    MBR Magic : aa55
>> Partition[0] :   4294967295 sectors at            1 (type ee)
>>
>>> Also, pending sectors that are in dead zones between metadata and array
>>> data will not be accessed by a check scrub, and will therefore persist.
>>
>> That's a good point, but then I would never have discovered those blocks
>> while initializing the array.
>>
>>>> Yes, I know I should trash (return) those drives,
>>>
>>> Well, non-permanent read errors are not considered warranty failures.
>>> They are in the drive specs.  When pending is zero and actual
>>> re-allocations are climbing (my threshold is double digits), *then* it's
>>> time to replace.
>>
>> I think it's worse here. Read errors are not being cleared by block rewrites?
>> Those are brand "new" (but really remanufactured) drives.
>> So far I'm not liking what I'm seeing and I'm very close to just
>> returning them all and getting some less dodgy ones.
>>
>> Sad because the last set of 5 I got from a similar source, have worked
>> beautifully.
>>
>> Let's see what a full smart scan does.
>> I may also use hdparm --write-sector to just fill those bad blocks with 0's
>> now that it seems that mdadm isn't caring about/using them anymore?
>>
>> Now, badblocks perplexes me even more. Shouldn't -n re-write blocks?
>>
>> myth:~# badblocks -fsvnb512 /dev/sdh 1287409599 1287409400
>> /dev/sdh is apparently in use by the system; badblocks forced anyway.
>> Checking for bad blocks in non-destructive read-write mode
>> From block 1287409400 to 1287409599
>> Checking for bad blocks (non-destructive read-write test)
>> Testing with random pattern: 1287409520ne, 0:14 elapsed. (0/0/0 errors)
>> 1287409521ne, 0:18 elapsed. (1/0/0 errors)
>> 1287409522ne, 0:23 elapsed. (2/0/0 errors)
>> 1287409523ne, 0:27 elapsed. (3/0/0 errors)
>> 1287409524ne, 0:31 elapsed. (4/0/0 errors)
>> 1287409525ne, 0:36 elapsed. (5/0/0 errors)
>> 1287409526ne, 0:40 elapsed. (6/0/0 errors)
>> 1287409527ne, 0:44 elapsed. (7/0/0 errors)
>> done
>> Pass completed, 8 bad blocks found. (8/0/0 errors)
>>
>> Badblocks found 8 bad blocks, but didn't rewrite them, or failed to, or
>> succeeded but that did nothing anyway?
>>
>> Do I understand that
>> 1) badblocks got read errors
>> 2) it's supposed to rewrite the blocks with new data (or not?)
>> 3) auto reallocate failed
>>
>>
>> [ 3171.717001] ata5.04: exception Emask 0x0 SAct 0x40 SErr 0x0 action 0x0
>> [ 3171.717012] ata5.04: failed command: READ FPDMA QUEUED
>> [ 3171.717019] ata5.04: cmd 60/08:30:70:4f:bc/00:00:4c:00:00/40 tag 6 ncq dma 4096 in
>> [ 3171.717019]          res 41/40:00:70:4f:bc/00:00:4c:00:00/00 Emask 0x409 (media error) <F>
>> [ 3171.717031] ata5.04: status: { DRDY ERR }
>> [ 3171.717034] ata5.04: error: { UNC }
>> [ 3171.718293] ata5.04: configured for UDMA/133
>> [ 3171.718342] sd 4:4:0:0: [sdh] tag#6 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> [ 3171.718349] sd 4:4:0:0: [sdh] tag#6 Sense Key : Medium Error [current]
>> [ 3171.718354] sd 4:4:0:0: [sdh] tag#6 Add. Sense: Unrecovered read error - auto reallocate failed
>> [ 3171.718360] sd 4:4:0:0: [sdh] tag#6 CDB: Read(16) 88 00 00 00 00 00 4c bc 4f 70 00 00 00 08 00 00
>> [ 3171.718364] print_req_error: I/O error, dev sdh, sector 1287409520
>> [ 3171.718369] Buffer I/O error on dev sdh, logical block 160926190, async page read
>> [ 3171.718393] ata5: EH complete
>> [ 3176.092946] ata5.04: exception Emask 0x0 SAct 0x400000 SErr 0x0 action 0x0
>> [ 3176.092958] ata5.04: failed command: READ FPDMA QUEUED
>> [ 3176.092973] ata5.04: cmd 60/08:b0:70:4f:bc/00:00:4c:00:00/40 tag 22 ncq dma 4096 in
>> [ 3176.092973]          res 41/40:00:70:4f:bc/00:00:4c:00:00/00 Emask 0x409 (media error) <F>
>> [ 3176.092978] ata5.04: status: { DRDY ERR }
>> [ 3176.092981] ata5.04: error: { UNC }
>> [ 3176.094237] ata5.04: configured for UDMA/133
>> [ 3176.094285] sd 4:4:0:0: [sdh] tag#22 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> [ 3176.094291] sd 4:4:0:0: [sdh] tag#22 Sense Key : Medium Error [current]
>> [ 3176.094296] sd 4:4:0:0: [sdh] tag#22 Add. Sense: Unrecovered read error - auto reallocate failed
>> [ 3176.094302] sd 4:4:0:0: [sdh] tag#22 CDB: Read(16) 88 00 00 00 00 00 4c bc 4f 70 00 00 00 08 00 00
>> [ 3176.094306] print_req_error: I/O error, dev sdh, sector 1287409520
>> [ 3176.094310] Buffer I/O error on dev sdh, logical block 160926190, async page read
>> [ 3176.094324] ata5: EH complete
>> [ 3180.488899] ata5.04: exception Emask 0x0 SAct 0x100 SErr 0x0 action 0x0
>> [ 3180.488909] ata5.04: failed command: READ FPDMA QUEUED
>> [ 3180.488916] ata5.04: cmd 60/08:40:70:4f:bc/00:00:4c:00:00/40 tag 8 ncq dma 4096 in
>> [ 3180.488916]          res 41/40:00:70:4f:bc/00:00:4c:00:00/00 Emask 0x409 (media error) <F>
>> [ 3180.488928] ata5.04: status: { DRDY ERR }
>> [ 3180.488931] ata5.04: error: { UNC }
>> [ 3180.490193] ata5.04: configured for UDMA/133
>> [ 3180.490243] sd 4:4:0:0: [sdh] tag#8 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> [ 3180.490249] sd 4:4:0:0: [sdh] tag#8 Sense Key : Medium Error [current]
>> [ 3180.490254] sd 4:4:0:0: [sdh] tag#8 Add. Sense: Unrecovered read error - auto reallocate failed
>> [ 3180.490259] sd 4:4:0:0: [sdh] tag#8 CDB: Read(16) 88 00 00 00 00 00 4c bc 4f 70 00 00 00 08 00 00
>> [ 3180.490263] print_req_error: I/O error, dev sdh, sector 1287409520
>> [ 3180.490268] Buffer I/O error on dev sdh, logical block 160926190, async page read
>> [ 3180.490290] ata5: EH complete
>> [ 3184.873146] ata5.04: exception Emask 0x0 SAct 0x1000000 SErr 0x0 action 0x0
>> [ 3184.873161] ata5.04: failed command: READ FPDMA QUEUED
>> [ 3184.873175] ata5.04: cmd 60/08:c0:70:4f:bc/00:00:4c:00:00/40 tag 24 ncq dma 4096 in
>> [ 3184.873175]          res 41/40:00:70:4f:bc/00:00:4c:00:00/00 Emask 0x409 (media error) <F>
>> [ 3184.873181] ata5.04: status: { DRDY ERR }
>> [ 3184.873184] ata5.04: error: { UNC }
>> [ 3184.874437] ata5.04: configured for UDMA/133
>> [ 3184.874488] sd 4:4:0:0: [sdh] tag#24 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> [ 3184.874495] sd 4:4:0:0: [sdh] tag#24 Sense Key : Medium Error [current]
>> [ 3184.874500] sd 4:4:0:0: [sdh] tag#24 Add. Sense: Unrecovered read error - auto reallocate failed
>> [ 3184.874506] sd 4:4:0:0: [sdh] tag#24 CDB: Read(16) 88 00 00 00 00 00 4c bc 4f 70 00 00 00 08 00 00
>> [ 3184.874510] print_req_error: I/O error, dev sdh, sector 1287409520
>> [ 3184.874515] Buffer I/O error on dev sdh, logical block 160926190, async page read
>> [ 3184.874555] ata5: EH complete
>>
>
> What you write about the result of
> badblocks -fsvnb512 /dev/sdh 1287409599 1287409400
> is the expected behavior. -n means that it will _not_ write sectors that
> it cannot read (because that would remove the possibility that data from
> these sectors could be recovered by more tries).
>
> As I wrote, you have to use the -w option instead of -n, and use x and y
> of 1287409527 1287409520
>
> HTH
> Kay
>
>
