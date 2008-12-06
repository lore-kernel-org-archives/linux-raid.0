From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Have the velociraptors in a test system now, checkout the errors.
Date: Sun, 07 Dec 2008 02:22:10 +0300
Message-ID: <493B0922.2080606@msgid.tls.msk.ru>
References: <alpine.DEB.1.10.0812060426280.3494@p34.internal.lan> <493A5E62.1020508@msgid.tls.msk.ru> <alpine.DEB.1.10.0812060709280.8516@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812060709280.8516@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, smartmontools-support@lists.sourceforge.net
List-Id: linux-raid.ids

Justin Piszcz wrote:

[big skip..]
> Very interesting story there, what OS(') were you using at the time?
> Windows? Linux? UNIX?

It is linux.  Since 2.2 or 2.0, I don't remember for sure.
With software raid since the day one (was an external patch
in a few first years).

> As far the PSU, just btw/FYI, Velociraptors consume ~4-5 watts a piece,
> my entire system used ~100-120watts with all 12 velociraptors on a 650
> watt PSU (now moved into a test system).

Well.  Others already commented on this, -- different rail can draw
different max power.  But it's a bit more complex still.  Those 4..5
watts is a sustained power consumption, not peak.  When moving heads,
starting/stopping the motor etc, the drive briefly consumes much more
power.  From my choice of cheap PSUs, not all of them can do the work
even when theoretical load is below the capacity.  I.e., the voltage
becomes.. unstable (insufficient filtering/capacitors, bad output
cirquits, too thin wires etc yadda).  And some parts of the system
may "translate" those instabilities into ones and zeros..

It's more: when the drives are in some RAID configuration (esp. raid1
and the like), usually more than one drive works in parallel, at exactly
the same moment (think writes to a raid1).  So it is more possible to
have bad results in raid config than without...

But again: I'm not at all suggesting your problem is in PSU.  It
*might* be here, but I hope your PSU can do the work fine.  And
in my case there were other failures too, more "mysterious".

And by the way, some modern PSUs, especially more powerful ones,
has more than one separate rails for 12v and sometimes 5v.  I.e.
two or more independent (to some extent anyway) 12v circuits.
With obvious advantages.

/mjt
