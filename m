From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: recommended 4port SATA controller ?
Date: Thu, 17 Sep 2009 16:52:40 -0500
Message-ID: <20090917215240.GA418@sewage>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at> <87f94c370909170549v156f9b23ie19f7204e21819f1@mail.gmail.com> <4AB24BFC.6070800@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AB24BFC.6070800@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 17, 2009 at 04:47:24PM +0200, Rainer Fuegenstein wrote:
> the plan is to replace this board with a more power-saving one as
> soon  as the new intel atom plattfrom (pinewood? pinetrail?) comes
> out in  2010/Q1 (hard to tell which  expansion slots the boards
> will have then,  but I bet on PCI).  speed isn't an issue, but low
> power consumption would be nice (but not  easy to find in
> datasheets etc.) since the server is supposed to be  powered by
> photovoltaic panels.

As others have mentioned, when doing SATA over PCI, the bottleneck
will be the PCI bus.  IIRC, SATA2 spec supports up to 300 MB/s, and
PCI is 133 (or 150) MB/s.  Realistically, modern spinning hard
drives usually max out around 100 MB/s, so just two drives can
saturate your PCI bus.  I think those numbers are reasonably close.

But, if, for example, you are serving the data strictly over the
network (i.e. a NAS box), a single Gigabit ethernet connection tops
out at rougly 125 MB/s.  So in this case the network performance
would shadow the reduced performance of the drives on the PCI bus.
(Unless your network controller is also on the PCI bus, then you're
hosed!  It's always good to check the block diagram of the
motherboard.)

Anyway, you asked for four ports, but how about eight?  I'm
surprised no one has mentioned this yet---I'd consider it a bit of a
"classic": Supermicro AOC-SAT2-MV8.

    http://www.newegg.com/Product/Product.aspx?Item=N82E16815121009

Eight SATA ports.  It's PCI-X, but I've used mine in regular 32-bit
PCI slots on several different motherboards without any problems.
Plenty of anecdotal evidence on the net as well of people using this
card in 32-bit PCI slots.  Linux support is good (personal
experience plus anecdotal).

I can't speak to its power consumption; there are no heatsinks on
the board, that should mean something.  I don't know, but I would
guess that the PCI bus wasn't designed to provide a lot of power
anyway.

Hope that helps!
Matt

