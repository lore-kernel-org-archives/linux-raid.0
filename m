From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Joys of spare disks!
Date: Wed, 2 Mar 2005 13:05:04 +0100
Message-ID: <62b0912f05030204054b1ab8ae@mail.gmail.com>
References: <62b0912f050301195062c3afbe@mail.gmail.com>
	 <200503020552.j225qD513637@www.watkins-home.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <200503020552.j225qD513637@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
> I think the overhead related to fixing the bad blocks would be insignificant
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
