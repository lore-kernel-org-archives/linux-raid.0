From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: power saving..
Date: Mon, 25 Aug 2003 09:52:36 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0308250941440.1277-100000@multivac.sdsc.edu>
References: <bWpzdHVtcGY=.a755c1b661ea4ce4056611076787574d@1061829354.cotse.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bWpzdHVtcGY=.a755c1b661ea4ce4056611076787574d@1061829354.cotse.net>
To: mjstumpf@pobox.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 25 Aug 2003, mjstumpf wrote:

> I have a relatively large (11 drive) server that operates 24/7.
>
> It really doesn't need to, though.  Use is sporadic at best; the purpose
> is mostly archiving.
>
> So what I'm wondering, is do we have auto-spin-down, power save features
> available & STABLE?  This thing sucks down a lot of power, giving me a
> bunch of heat in return :-)

The problem isn't the spin-down, but the spin-up.  When an I/O occurs, the
delay for the disks to spin up would be likely to cause the RAID card (if
you use one) to generate a timeout.  If you don't use a RAID card, it
might work (and it might not).

These disks probably draw around 10W each at idle.  This is a 110W load in
your system.  All things considered, I'd be more likely to want to put the
CPU into sleep mode.  This would probably save 60-80W per CPU (figure 80%
efficiency on the voltage conversion), with some small additional power
savings from the NorthBridge and memory.

If the power savings (or heat output) is REALLY important, you can leave
the entire system off, except when you need it.  This may decrease the
long-term reliability, especially of the power supply.

				Peter Ashford

