From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Joys of spare disks!
Date: Wed, 2 Mar 2005 11:16:55 -0500
Message-ID: <200503021617.j22GH0516373@www.watkins-home.com>
References: <62b0912f05030204054b1ab8ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <62b0912f05030204054b1ab8ae@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Molle Bestefich' <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is what you said:
"A more consistent and risk-free way of doing it would probably be to
do the above partial resync in a background thread or so?.."

This sounded like Neil's current plan.  But if I understand the plan, the
drive would be kicked out of the array.  A log would track which stripes
were effected by the bad block and other writes to the array.  A partial
re-sync would be done and the disk put back into the array.  I think the
array would be degraded during the re-sync.  This is why I made my comments.
On a related subject, I don't like Neil's plan if it causes the array to be
degraded, since while degraded, if another disk has a bad block the array
then goes off-line.  Not a good plan IMO.

I also never said a full re-sync, I was referring to correcting the bad
block(s).  And 1000 bad blocks!  I have never had 2 on the same disk at the
same time.  AFAIK.  I would agree that 1000 would put a strain on the
system!  Normally only 1 block is bad at a time IMO.  However, I guess it is
possible to have a full track go bad.  Sometime in the past I have said
there should be a threshold on the number of bad blocks allowed.  Once the
threshold is reached, the disk should be assumed bad, or at least failing,
and should be replaced.  I would also say the bad block repair should have a
speed limit so the effect on the overall system is minimized.  Maybe only
allow it to repair 1 bad block per minute.  (a configurable parameter).  But
your 1000 bad block example would take almost 17 hours.

I think 1000 bad blocks at one time is an indication you have a head
failure.  In that case, the disk is bad.

Does anyone know how many spare blocks are on a disk?
My worse disk has 28 relocated bad blocks.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Molle Bestefich
Sent: Wednesday, March 02, 2005 7:05 AM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: Re: Joys of spare disks!

Hm..  I said partial resync, because a full resync would be a waste of
time if it's just a thousand sectors or so that needs to be relocated.
 Anyhow.

There's no overhead to the application with the (theoretically
"partial") degraded mode, since it happens in parallel.

The latency of doing it while the read operation is ongoing would be,
say, 3 seconds or so per bad sector on a standard disk?  Imagine a
thousand bad sectors, and any sane person would quickly pull the plug
from the dead box and have it resync when it boots instead of staring
at a hung system.  When that happens there's even the risk that the
resync fails completely, if md decides to pull one of the disks other
than the one with bad blocks on it from the array before it resyncs.

I prefer the first scenario (the system keeps running, the array isn't
potentially destroyed), even if it means a slightly lower I/O rate and
thus a minor overhead if and only if running applications utilize the
I/O subsystem 100%..

Am I wrong?

Guy wrote:
> I think the overhead related to fixing the bad blocks would be
insignificant
> compared to the overhead of degraded mode.
> 
> Guy
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Molle Bestefich
> Sent: Tuesday, March 01, 2005 10:51 PM
> To: linux-raid@vger.kernel.org
> Subject: Re: Joys of spare disks!
> 
> Robin Bowes wrote:
> > I envisage something like:
> >
> > md attempts read
> > one disk/partition fails with a bad block
> > md re-calculates correct data from other disks
> > md writes correct data to "bad" disk
> >   - disk will re-locate the bad block
> 
> Probably not that simple, since some times multiple blocks will go
> bad, and you wouldn't want the entire system to come to a screeching
> halt whenever that happens.
> 
> A more consistent and risk-free way of doing it would probably be to
> do the above partial resync in a background thread or so?..
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
>
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

