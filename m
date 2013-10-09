From: David Brown <david.brown@hesbynett.no>
Subject: Re: SSD reliability; was: Re: Multiple SSDs - RAID-1, -10, or stacked?
 TRIM?
Date: Wed, 09 Oct 2013 23:17:41 +0200
Message-ID: <5255C7F5.6080509@hesbynett.no>
References: <20131009123135.GT1779@bitfolk.com> <l33q8a$da4$1@ger.gmane.org> <5255827B.8090309@hesbynett.no> <l3440m$85s$1@ger.gmane.org> <5255A9A3.3040205@hesbynett.no> <20131009203510.GA22384@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131009203510.GA22384@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/10/13 22:35, Matt Garman wrote:
> 
> Regarding the SSD reliability discussion: this probably means
> nothing because sample size is so small, but anyway, FWIW: I've had
> two SSDs suddenly just die.  That is, they become completely
> ivisible to the OS/BIOS.  This is for my personal/home
> infrastructure, meaning the total number of SSDs I've had in my
> hands is less maybe a dozen or so.

That's the trouble with statistics on SSD's - /all/ the current sample
sizes are too small, or have run for too short a time.  Still, a single
failure is enough to remind us that SSD's are not infallible.

> 
> The two drives that died were cheapie Kingston drives, and very
> low-capacity at that.  (One was a 16 GB drive; Kingston sent me a 64
> GB drive for my warranty replacement.  I think the other was maybe
> 32 GB, but I don't remember.)  I don't recall their exact vintage,
> but they were old enough that their tiny capacity wasn't embarassing
> when purchased, but young enough to still be under warranty.

Warranties are perhaps the best judge we have of SSD reliability.  Some
devices are now sold with 5 year warranties.  When you consider the low
margins in a competitive market, and the high costs of returns and
warranty replacements, the manufacturer is expecting a very low number
of failed drives within that 5 year period.  Until we have the 5 year
large-sample history to learn from, manufacturer's expectations are a
reasonable guide.

> 
> At any rate, I have different but related question: does anyone have
> any thoughts with regards to using an SSD as a WORM (write-once,
> read-many) drive?  For example, a big media collection in a home
> server.

Ignoring cost, an SSD will do a fine job whether you write to it many
times or just once.  (But since it may die at any time, don't forget a
backup copy!)

> 
> Ignoring the cost aspect, the nice thing about SSDs are their small
> size and neglible power consumption (and therefore low heat
> production).  As mentioned previously in this thread, SSD at least
> removes the "mechanical" risks from a storage system.  So what
> happens if you completely fill up an SSD, then never modify it after
> that, i.e. mount it read-only?

What are you expecting to happen?  You will be able to read from it at
high speed.

I can't imagine this will have a significant effect on its lifetime,
since SSD failures are not write-related (unless you bump into a
firmware bug, I suppose).  It has been a long time since SSD's could
wear out - even with a fairly small and cheap drive, you can write 100
GB a day for a decade without suffering wear effects.

> 
> I understand that the set bits in NAND memory slowly degrade over
> time, so it's clearly not true WORM media.  But what kind of
> timescale might one expect before bit rot becomes a problem?  And
> what if one were to use some kind of parity scheme (raid5/6, zfs,
> snapraid) to ocassionaly "refresh" the NAND memory?

Most media degrades a little over time.  But I have never heard of flash
(NAND or NOR) actually /losing/ bits over time.  The cells get lower
margins as you repeatedly erase and re-write them, but as noted above
you will not see that on an SSD with any realistic usage.  It is normal
for the datasheets for the flash chips to have information about minimum
ages to retain data - but these figures are based on simulated ageing
(very high temperatures, very high or very low voltages, etc.),
specified for worst-case conditions (extremes of voltage ranges and
temperatures of typically 85 or 105 C), and given with wide margins.  I
think you can be fairly sure that anything you write to a NAND chip
today will be around for at least as long as you will.

The other electronics on the SSD is a different matter, of course.
Electrolytic capacitors dry out, oscillator crystals change frequency
from ageing, piezoelectric effects crack ceramic capacitors,
heating/cooling cycles stress chip pins, electromigration causes voids
and increased resistance on solder joints, etc.  (Anyone who things
SSD's have no moving parts has not studied semiconductors and material
sciences - lots of bits move and wear out, if you have a good enough
microscope.)

So your SSD will suddenly die one day, regardless of how much you write
to it.  "Refreshing" by forcing a raid re-build on the disk will not help.

> 
> FWIW, I also asked about this on the ServeTheHome forums[1].
> 
> In general, seems there's a market for true WORM storage (but at
> SOHO prices of course!).  Something like mdisc[2], but in modern
> mechanical-HDD capacities and prices.  :) 
> 
> [1] http://forums.servethehome.com/hard-drives-solid-state-drives/2453-ssd-worm.html
> 
> [2] http://www.mdisc.com/what-is-mdisc/
> 

I'm sure the m-disc will last longer than a normal DVD, but I'd take its
1000 year claims with a pinch of salt.  I'll be happy to be proved wrong
in 3013...

I agree that there is such a market for long-term digital storage.  At
the moment, it looks like cloud storage is the choice - then it is
somebody else's problem to rotate the data onto new hard disks as old
ones falter.  I've seen some articles about holographic storage in
quartz crystals, which should last a long time - but there is a way to
go before they reach HDD capacities and prices!

