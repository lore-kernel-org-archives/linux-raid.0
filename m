From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Mon, 3 Jan 2005 16:36:11 -0500
Message-ID: <200501032136.j03LaJ915438@www.watkins-home.com>
References: <200501031846.42950.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501031846.42950.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'maarten' <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maarten said:
"Doing the math, the outcome is still (200% divided by four)= 50%.
Ergo: the same as with a single disk.  No change."

Guy said:
"I bet a non-mirror disk has similar risk as a RAID1."

Guy and Maarten agree, but Maarten does a better job of explaining it!  :)

I also agree with most of what Maarten said below, but not mirroring swap???

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of maarten
Sent: Monday, January 03, 2005 12:47 PM
To: linux-raid@vger.kernel.org
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
crashing repeatedly and hard)

On Monday 03 January 2005 12:31, Peter T. Breuer wrote:
> Guy <bugzilla@watkins-home.com> wrote:
> > "Also sprach Guy:"


>    1) lightning strikes rails, or a/c goes out and room full of servers
>       overheats. All lights go off.
>
>    2) when sysadmin arrives to sort out the smoking wrecks, he finds
>       that 1 in 3 random disks are fried - they're simply the points
>       of failure that died first, and they took down the hardware with
>       them.
>
>    3) sysadmin buys or jury-rigs enough pieces of nonsmoking hardware
>       to piece together the raid arrays from the surviving disks, and
>       hastily does a copy to somewhere very safe and distant, while
>       an assistant holds off howling hordes outside the door with
>       a shutgun.
>
> In this scenario, a disk simply acts as the weakest link in a fuse
> chain, and the whole chain goes down.  But despite my dramatisation it
> is likely that a hardware failure will take out or damage your hardware!
> Ide disks live on an electric bus conected to other hardware.  Try a
> shortcircuit and see what happens.  You can't even yank them out while
> the bus is operating if you want to keep your insurance policy.

The chance of a PSU blowing up or lightning striking is, reasonably, much
less 
than an isolated disk failure.  If this simple fact is not true for you 
personally, you really ought to reevaluate the quality of your PSU (et al) 
and / or the buildings' defenses against a lightning strike...

> However, I don't see how you can expect to replace a failed disk
> without taking down the system. For that reason you are expected to be
> running "spare disks" that you can virtually insert hot into the array
> (caveat, it is possible with scsi, but you will need to rescan the bus,
> which will take it out of commission for some seconds, which may
> require you to take the bus offline first, and it MAY be possible with
> recent IDE buses that purport to support hotswap - I don't know).

I think the point is not what actions one has to take at time T+1 to replace

the disk, but rather whether at time T, when the failure first occurs, the 
system survives the failure or not.

> (1) how likely is it that a disk will fail without taking down the system
> (2) how likely is it that a disk will fail
> (3) how likely is it that a whole system will fail
>
> I would say that (2) is about 10% per year. I would say that (3) is
> about 1200% per year. It is therefore difficult to calculate (1), which
> is your protection scenario, since it doesn't show up very often in the
> stats!

I don't understand your math.  For one, percentage is measured from 0 to
100, 
not from 0 to 1200.  What is that, 12 twelve times 'absolute certainty' that

something will occur ?
But besides that, I'd wager that from your list number (3) has, by far, the 
smallest chance of occurring. Choosing between (1) and (2) is more
difficult, 
my experiences with IDE disks are definitely that it will take the system 
down, but that is very biased since I always used non-mirrored swap.
I sure can understand a system dying if it loses part of its memory...

> > ** A disk failing is the most common failure a system can have (IMO).

I fully agree.

> Not in my experience. See above. I'd say each disk has about a 10%
> failure expectation per year. Whereas I can guarantee that an
> unexpected  system failure will occur about once a month, on every
> important system.

Whoa !  What are you running, windows perhaps ?!? ;-)
No but seriously, joking aside, you have 12 system failures per year ?
I would not be alone in thinking that figure is VERY high.  My uptimes 
generally are in the three-digit range, and most *certainly* not in the low 
2-digit range. 

> If you think about it that is quite likely, since a system is by
> definition a complicated thing. And then it is subject to all kinds of
> horrible outside influences, like people rewiring the server room in
> order to reroute cables under the floor instead of through he ceiling,
> and the maintenance people spraying the building with insecticide,
> everywhere, or just "turning off the electricity in order to test it"
> (that happens about four times a year here - hey, I remember when they
> tested the giant UPS by turning off the electricity! Wrong switch.
> Bummer).

If you have building maintenance people and other random staff that can
access 
your server room unattended and unmonitored, you have far worse problems
than 
making decicions about raid lavels.  IMNSHO.   

By your description you could almost be the guy the joke with the recurring
7 
o'clock system crash is about (where the cleaning lady unplugs the server 
every morning in order to plug in her vacuum cleaner) ;-) 

> Yes, you can try and keep these systems out of harms way on a
> colocation site, or something, but by then you are at professional
> level paranoia. For "home systems", whole system failures are far more
> common than disk failures.

Don't agree.  Not only do disk failures occur more often than full system 
failures, disk failures are also much more time-consuming to recover from. 
Compare changing a system board or PSU with changing a drive and finding, 
copying and verifying a backup (if you even have one that's 100% up to date)


> > ** In a computer room with about 20 Unix systems, in 1 year I have seen
> > 10 or so disk failures and no other failures.
>
> Well, let's see. If each system has 2 disks, then that would be 25% per
> disk per year, which I would say indicates low quality IDE disks, but
> is about the level I would agree with as experiential.

The point here was, disk failures being more common than other failures...

> No way! I hate tapes. I backup to other disks.

Then for your sake, I hope they're kept offline, in a safe.

> > ** My computer room is for development and testing, no customer access.
>
> Unfortunately, the admins do most of the sabotage.

Change admins.  
I could understand an admin making typing errors and such, but then again
that 
would not usually lead to a total system failure.  Some daemon not working, 
sure.  Good admins review or test their changes, for one thing, and in most 
cases any such mistake is rectified much simpler and faster than a failed 
disk anyway. Except maybe for lilo errors with no boot media available. ;-\ 

> Yes you did. You can see from the quoting that you did.

Or the quoting got messed up.  That is known to happen in threads.

> > but it may be more current than 1 or
> > more of the other disks.  But this would be similar to what would happen
> > to a non-RAID disk (some data not written).
>
> No, it would not be similar. You don't seem to understand the
> mechanism. The mechanism for corruption is that there are two different
> versions of the data available when the system comes back up, and you
> and the raid system don't know which is more correct. Or even what it
> means to be "correct". Maybe the earlier written data is "correct"!

That is not the whole truth.  To be fair, the mechanism works like this:
With raid, you have a 50% chance the wrong, corrupted, data is used.
Without raid, thus only having a single disk, the chance of using the 
corrupted data is 100% (obviously, since there is only one source)

Or, much more elaborate:

Let's assume the chance of a disk corruption occurring is 50%, ie. 0.5

With raid, you always have a 50% chance of reading faultty data IF one of
the 
drives holds faulty data.  For the drives itself, the chance of both disks 
being wrong is 0.5x0.5=0.25(scenario A).  Similarly, 25 % chance both disks 
are good (scenario B). The chance of one of the disks being wrong is 50% 
(scenarios C & D together).  In scenarios A & B the outcome is certain. In 
scenarios C & D the chance of the raid choosing the false mirror is 50%.
Accumulating those chances one can say that the chance of reading false data

is:
in scenario A: 100%
in scenario B: 0%
scenario C: 50%
scenario D: 50%

Doing the math, the outcome is still (200% divided by four)= 50%.
Ergo: the same as with a single disk.  No change.

> > In contrast, on a single disk they have a 100% chance of detection (if
> > you look!) and a 100% chance of occuring, wrt normal rate.
> > ** Are you talking about the disk drive detecting the error?

No, you have a zero chance of detection, since there is nothing to compare
TO.
Raid-1 at least gives you a 50/50 chance to choose the right data.  With a 
single disk, the chance of reusing the corrupted data is 100% and there is
no 
mechanism to detect the odd 'tumbled bit' at all.

> > How?
> > ** Compare the 2 halves or the RAID1, or check the parity of RAID5.
>
> You wouldn't necesarily know  which of the two data sources was
> "correct".

No, but you have a theoretical choice, and a 50% chance of being right.
Not so without raid, where you get no choice, and a 100% chance of getting
the 
wrong data, in the case of a corruption.

Maarten

-- 


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

