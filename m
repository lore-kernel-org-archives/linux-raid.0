From: LinuxRaid@Suykerbuyk.org
Subject: Re: Joys of spare disks!
Date: Mon, 7 Mar 2005 08:36:22 -0800 (PST)
Message-ID: <200503071636.j27GaMnD009839@newsguy.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With error correcting RAID, where the whole idea is to do everything possible
to maintain data reliability, it seems to me the correct behavior of the RAID
subsytem is to attempt to re-write ECC failed data blocks whenever possible.

This is especially true where Software Controlled Timeouts are being
implimented on ATA/SATA drives.

I'm running several RAID-5 arrays against mixed PATA/SATA systems, and I am
amazed at how fragile Linux Software RAID-5 really is.  It makes no sense to
me that one soft ECC errror would kick out an entire volume of data, cause a
rebuild or a run in "degraded" mode, and with the inherent risk of another
event happening on another disk resulting in the loss of all data on the
storage system.

And from what I can tell, Linux software RAID, never gives the drive the
chance to perform reallocation on "weak" sectors...

What should be happening:
1) Drive has a read error or does not deliver the data within the command
timeout parameters that have been issued to the drive.
2) RAID driver collects the blocks from the "working" drives, generates the
missing data from the problem drive.
3) RAID driver both returns the data to the calling process, and issues a
re-write of the bad block on the disk drive in question.
4) RAID drive generates a log message tracking the problem
5) When the number of "event messages" for block re-writes exceeds a certain
threshold, alert the sys-admin that a specific drive is unreliable.

I've been going through the MD driver source, and to tell the truth, can't
figure out where the read error is detected and how to "hook" that event and
force a re-write of the failing sector.  I would very much appreciate it if
someone out there could send me some some hints/tips/pointers on how to
impliment this.  I'm not a Linux / kernel hacker (yet), but this should not be
hard to fix....

John Suykerbuyk


At Wed, 2 Mar 2005 13:05:04 +0100, you wrote
>Hm..  I said partial resync, because a full resync would be a waste of
>time if it's just a thousand sectors or so that needs to be relocated.
> Anyhow.
>
>There's no overhead to the application with the (theoretically
>"partial") degraded mode, since it happens in parallel.
>
>The latency of doing it while the read operation is ongoing would be,
>say, 3 seconds or so per bad sector on a standard disk?  Imagine a
>thousand bad sectors, and any sane person would quickly pull the plug
>from the dead box and have it resync when it boots instead of staring
>at a hung system.  When that happens there's even the risk that the
>resync fails completely, if md decides to pull one of the disks other
>than the one with bad blocks on it from the array before it resyncs.
>
>I prefer the first scenario (the system keeps running, the array isn't
>potentially destroyed), even if it means a slightly lower I/O rate and
>thus a minor overhead if and only if running applications utilize the
>I/O subsystem 100%..
>
>Am I wrong?
>
>Guy wrote:
>>I think the overhead related to fixing the bad blocks would be insignificant
>> compared to the overhead of degraded mode.
>> >> Guy
>> >> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org
>> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Molle Bestefich
>> Sent: Tuesday, March 01, 2005 10:51 PM
>> To: linux-raid@vger.kernel.org
>> Subject: Re: Joys of spare disks!
>> >> Robin Bowes wrote:
>> > I envisage something like:
>> >
>> > md attempts read
>> > one disk/partition fails with a bad block
>> > md re-calculates correct data from other disks
>> > md writes correct data to "bad" disk
>> >   - disk will re-locate the bad block
>> >> Probably not that simple, since some times multiple blocks will go
>> bad, and you wouldn't want the entire system to come to a screeching
>> halt whenever that happens.
>> >> A more consistent and risk-free way of doing it would probably be to
>> do the above partial resync in a background thread or so?..
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

