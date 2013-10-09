From: Matt Garman <matthew.garman@gmail.com>
Subject: SSD reliability; was: Re: Multiple SSDs - RAID-1, -10, or stacked?
 TRIM?
Date: Wed, 9 Oct 2013 15:35:11 -0500
Message-ID: <20131009203510.GA22384@septictank.raw-sewage.fake>
References: <20131009123135.GT1779@bitfolk.com>
 <l33q8a$da4$1@ger.gmane.org>
 <5255827B.8090309@hesbynett.no>
 <l3440m$85s$1@ger.gmane.org>
 <5255A9A3.3040205@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5255A9A3.3040205@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Regarding the SSD reliability discussion: this probably means
nothing because sample size is so small, but anyway, FWIW: I've had
two SSDs suddenly just die.  That is, they become completely
ivisible to the OS/BIOS.  This is for my personal/home
infrastructure, meaning the total number of SSDs I've had in my
hands is less maybe a dozen or so.

The two drives that died were cheapie Kingston drives, and very
low-capacity at that.  (One was a 16 GB drive; Kingston sent me a 64
GB drive for my warranty replacement.  I think the other was maybe
32 GB, but I don't remember.)  I don't recall their exact vintage,
but they were old enough that their tiny capacity wasn't embarassing
when purchased, but young enough to still be under warranty.

At any rate, I have different but related question: does anyone have
any thoughts with regards to using an SSD as a WORM (write-once,
read-many) drive?  For example, a big media collection in a home
server.

Ignoring the cost aspect, the nice thing about SSDs are their small
size and neglible power consumption (and therefore low heat
production).  As mentioned previously in this thread, SSD at least
removes the "mechanical" risks from a storage system.  So what
happens if you completely fill up an SSD, then never modify it after
that, i.e. mount it read-only?

I understand that the set bits in NAND memory slowly degrade over
time, so it's clearly not true WORM media.  But what kind of
timescale might one expect before bit rot becomes a problem?  And
what if one were to use some kind of parity scheme (raid5/6, zfs,
snapraid) to ocassionaly "refresh" the NAND memory?

FWIW, I also asked about this on the ServeTheHome forums[1].

In general, seems there's a market for true WORM storage (but at
SOHO prices of course!).  Something like mdisc[2], but in modern
mechanical-HDD capacities and prices.  :) 

[1] http://forums.servethehome.com/hard-drives-solid-state-drives/2453-ssd-worm.html

[2] http://www.mdisc.com/what-is-mdisc/


