From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spares and partitioning huge disks
Date: Sun, 9 Jan 2005 18:20:18 -0500
Message-ID: <200501092320.j09NKQ918671@www.watkins-home.com>
References: <200501092226.25910.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501092226.25910.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'maarten' <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It was said:
"> I think RAID6 but especially RAID1 is safer.

Well, duh :)  At the expense of buying everything twice, sure it's safer
:))"

Guy says:
I disagree with the above.

True, RAID6 can lose 2 disks without data loss.
But, RAID1 and RAID5 can only lose 1 disk without data loss.

If RAID1 or RAID5 had a read error during a re-sync, both would die.

Now, RAID5 has more disks, so the odds are increased that a read error could
occur.  But you can improve those odds by partitioning the disks and
creating sub arrays, then combining them.  Per Maarten's plan.

Of course, having a bad sector should not cause a disk to be kicked out!
The RAID software should handle this.  Most hardware based RAID systems can
handle bad blocks.  But this is another issue. 

Why is RAID1 preferred over RAID5?
RAID1 is considered faster than RAID5.  Most systems tend to read much more
than they write.  So, having 2 disks to read from (RAID1) can double your
read rate.  RAID5 tends to have better seek time in a multi threaded
environment (more then 1 seek attempted concurrently).  If you test with
bonnie++, try 10 bonnies at the same time and note the sum of the seek times
(you must add them yourself).  With RAID1 it should about double, with
RAID5, it depends on the number of disks in the array.  Most home systems
tend to only do 1 thing at a time.  So, most people don't focus on seek
time, they tent to focus on sequential read or write rates.  In a multi
user/process/thread environment, you don't do much sequential I/O, it tends
to be random.

But, assuming you need the extra space RAID5 yields, if you choose RAID1
instead, you would have many more disks than just 2, in a RAID10 environment
you would have the improved seek rates of RAID5 (times ~2) and about double
the overall read rate of RAID5.  This is why some large systems tend to use
RAID1 over RAID5.  The largest system I worked on had over 300 disks,
configured as RAID1.  I think it was over kill on performance, RAID5 would
have been just fine!  But it was not my choice, also not my money.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of maarten
Sent: Sunday, January 09, 2005 4:26 PM
To: linux-raid@vger.kernel.org
Subject: Re: Spares and partitioning huge disks

On Sunday 09 January 2005 20:33, Frank van Maarseveen wrote:
> On Sat, Jan 08, 2005 at 05:49:32PM +0100, maarten wrote:

> > However, IF during that
> > resync one other drive has a read error, it gets kicked too and the
array
> > dies.  The chances of that happening are not very small;
>
> Ouch! never considered this. So, RAID5 will actually decrease reliability
> in a significant number of cases because:

> -	>1 read errors can cause a total break-down whereas it used
> 	to cause only a few userland I/O errors, disruptive but not foobar.

Well, yes and no.  You can decide to do a full backup in case you hadn't, 
prior to changing drives. And if it is _just_ a bad sector, you can
'assemble 
--force' yielding what you would've had in a non-raid setup; some file 
somewhere that's got corrupted. No big deal, ie. the same trouble as was 
caused without raid-5.

> -	disk replacement is quite risky. This is totally unexpected to me
> 	but it should have been obvious: there's no bad block list in MD
> 	so if we would postpone I/O errors during reconstruction then
> 	1:	it might cause silent data corruption when I/O error
> 		unexpectedly disappears.
> 	2:	we might silently loose redundancy in a number of places.

Not sure if I understood all of that, but I think you're saying that md 
_could_ disregard read errors _when_already_running_in_degraded_mode_ so as 
to preserve the array at all cost.  Hum.  That choice should be left to the 
user if it happens, he probably knows best what to choose in the 
circumstances.

No really, what would be best is that md made a difference between total
media 
failure and sector failure.  If one sector is bad on one drive [and it gets 
kicked therefore] it should be possible when a further read error occurs on 
other media, to try and read the missing sector data from the kicked drive, 
who may well have the data there waiting, intact and all.

Don't know how hard that is really, but one could maybe think of pushing a 
disk in an intermediate state between "failed" and "good" like "in_disgrace"

what signals to the end user "Don't remove this disk as yet; we may still 
need it, but add and resync a spare at your earliest convenience as we're 
running in degraded mode as of now".
Hmm.  Complicated stuff. :-)

This kind of error will get more and more predominant with growing media and

decreasing disk quality. Statistically there is not a huge chance of getting

a read failure on a 18GB scsi disk, but on a cheap(ish) 500 GB ATA disk that

is an entrirely different ballpark. 

> I think RAID6 but especially RAID1 is safer.

Well, duh :)  At the expense of buying everything twice, sure it's safer :))

> A small side note on disk behavior:
> If it becomes possible to do block remapping at any level (MD, DM/LVM,
> FS) then we might not want to write to sectors with read errors at all
> but just remap the corresponding blocks by software as long as we have
> free blocks: save disk-internal spare sectors so the disk firmware can
> pre-emptively remap degraded but ECC correctable sectors upon read.

Well I dunno.  In ancient times, the OS was charged with remapping bad
sectors 
back when disk drives had no intelligence.  Now we delegated that task to
the 
disk.  I'm not sure reverting back to the old behaviour is a smart move.
But with raid, who knows...

And as it is I don't think you get the chance to save the disk-internal
spare 
sectors; the disk handles that transparently so any higher layer cannot only

not prevent that, but is even kept completely ignorant to it happening. 

Maarten


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

