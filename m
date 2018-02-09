From: Phil Turmel <philip@turmel.org>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Fri, 9 Feb 2018 15:44:56 -0500
Message-ID: <5947e803-b1e8-b530-4935-df126f867213@turmel.org>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org>
 <aedfc1ac-a95f-b20f-2713-87cf412afdf4@uni-konstanz.de>
 <20180209192928.vliiwkv6q76jf6jp@merlins.org>
 <1227ce39-31af-22f2-f4fa-de85466f05c7@turmel.org>
 <20180209202958.6mieeomu5of45rjf@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180209202958.6mieeomu5of45rjf@merlins.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Kay Diederichs <kay.diederichs@uni-konstanz.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/09/2018 03:29 PM, Marc MERLIN wrote:
> On Fri, Feb 09, 2018 at 03:13:26PM -0500, Phil Turmel wrote:
>>> The pending sectors should have been re-written and become
>>> Reallocated_Event_Count, no?
>>
>> Yes, and not necessarily.  Pending sectors can be non-permanent errors
>> -- the drive firmware will test a pending sector immediately after write
>> to see if the write is readable.  If not, it will re-allocate while it
>> still has the write data in its buffers.  Otherwise, it'll clear the
>> pending sector.
> 
> This shows the sector is still bad though, right? 
> 
> myth:~# hdparm --read-sector 1287409520 /dev/sdh
> /dev/sdh:
> reading sector 1287409520: SG_IO: bad/missing sense data, sb[]:  70 00 03 00 00 00 00 0a 40 51 e0 01 11 04 00 00 a0 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00 succeeded
> 7000 0b54 92c4 ffff 0000 0000 01fe 0000
> (...)
> 
> [ 2572.139404] ata5.04: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [ 2572.139419] ata5.04: failed command: READ SECTOR(S) EXT
> [ 2572.139427] ata5.04: cmd 24/00:01:70:4f:bc/00:00:4c:00:00/e0 tag 28 pio 512 in
> [ 2572.139427]          res 51/40:01:70:4f:bc/00:00:4c:00:00/e0 Emask 0x9 (media error)
> [ 2572.139431] ata5.04: status: { DRDY ERR }
> [ 2572.139435] ata5.04: error: { UNC }
> [ 2572.162369] ata5.04: configured for UDMA/133
> [ 2572.162414] ata5: EH complete

Yes.  Those sectors are still pending.

> mdadm also said it found 6 bad sectors and rewrote them (or something like that)
> and it's happy. So alledgely it did something, but smart does not agree (yet?)

Like I said, mdadm "check" won't fix sectors that it has recorded as
bad, and doesn't even look at sectors outside its data area.

> I'm now running a long smart test on all drives, will see if numbers change.

Self tests in the drives don't fix pending sectors, as they don't have
the correct data to write.  That's why they can only be fixed by an
upper layer providing the data (during write).

> Mmmh, and I just ran 
> myth:~# badblocks -fsvnb512 /dev/sdh 1287409599 1287409400
> below, and I don't quite understand what's going on.

I'm not talking about the badblocks command.  I'm talking about the bad
block logging feature of MD.

> This means I dont have bad block lists?
> myth:~# mdadm -E /dev/sdd e f g h all return
> /dev/sdd:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)

This means nothing.  Please run mdadm -E on the *member devices*.  That
means include the partition number if you are using partitions.  See the
output of mdadm -D /dev/mdX for an array's list of *members*.

>> Well, non-permanent read errors are not considered warranty failures.
>> They are in the drive specs.  When pending is zero and actual
>> re-allocations are climbing (my threshold is double digits), *then* it's
>> time to replace.
> 
> I think it's worse here. Read errors are not being cleared by block rewrites?
> Those are brand "new" (but really remanufactured) drives. 
> So far I'm not liking what I'm seeing and I'm very close to just
> returning them all and getting some less dodgy ones.

How do you know that these sectors have been re-written?  Let me repeat:
MD will *not* write to blocks that it has recorded as bad in *its* bad
block list, and doesn't even read non-data-area blocks during a check.

> Sad because the last set of 5 I got from a similar source, have worked
> beautifully.

I'm not convinced these drives aren't working beautifully.

> Let's see what a full smart scan does.
> I may also use hdparm --write-sector to just fill those bad blocks with 0's
> now that it seems that mdadm isn't caring about/using them anymore?
> 
> Now, badblocks perplexes me even more. Shouldn't -n re-write blocks?
> 
> myth:~# badblocks -fsvnb512 /dev/sdh 1287409599 1287409400
> /dev/sdh is apparently in use by the system; badblocks forced anyway.

This should have been a hint that you shouldn't be using the badblocks
utility on a running array's devices.

> Badblocks found 8 bad blocks, but didn't rewrite them, or failed to, or
> succeeded but that did nothing anyway?
> 
> Do I understand that
> 1) badblocks got read errors

Yes.

> 2) it's supposed to rewrite the blocks with new data (or not?)

No.

> 3) auto reallocate failed

Don't know.  You haven't provided the information needed to say.

Phil

