From: Kasper Sandberg <postmaster@metanurb.dk>
Subject: Re: System hangs on raid md recovery/resync - revisit
Date: Sun, 01 Mar 2009 15:14:51 +0100
Message-ID: <1235916891.11077.3.camel@localhost>
References: <da290bd50902271732m54a32ad6r5797f618f5af7d7@mail.gmail.com>
	 <alpine.DEB.2.00.0902280407520.17966@p34.internal.lan>
	 <da290bd50902280241y4102d5c3p73ce506b4195e5e9@mail.gmail.com>
	 <alpine.DEB.2.00.0902280654110.29132@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0902280654110.29132@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Brad <brad46526@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2009-02-28 at 07:04 -0500, Justin Piszcz wrote:
> 
> On Sat, 28 Feb 2009, Brad wrote:
> 
> > On Sat, Feb 28, 2009 at 7:08 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> >>
> >> On Sat, 28 Feb 2009, Brad wrote:
> >>
> >>> Hi.  I'd like to revisit a problem I put to the mailing list on the
<snip>
> > I've had another problem with the Realtek network driver ... under network
> > load it seemed to miss interrupts and/or pass them to the IDE driver, which
> > would print out errors about unexpected/unknown interrupts.  I had to take
> > IDE out of my kernel.
> Correct, buy an Intel 1GBPS PCI-e card, I do for all of my main machines
> that do not have Intel NICs, solves the problem.  They are $30-40 and then
> all of your network issues will be solved.
> 
> >
I have a gigabyte X48 board with two of those realtek NICs, and apart
from some driver troubles which the r8169 maintainer fixed for me, i've
had no issues with it.

I suggest contacting the maintainer if you really believe its the NIC
and/or driver

<snip>
> Justin.

