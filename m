From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Advice for recovering array containing LUKS encrypted LVM volumes
Date: Sat, 10 Aug 2013 09:02:52 -0500
Message-ID: <5206480C.4060604@hardwarefreak.com>
References: <CAC38o7ScozDqspEH-FSyoa_W5W8s+VfYd1RTAitz574wMYqhkA@mail.gmail.com> <51FE529C.6000502@hardwarefreak.com> <CAC38o7TqO9m=6LDHxDiV=XYcfAdbnpa=GZuft-TAqFDvdqvJ4A@mail.gmail.com> <52015093.3040100@hardwarefreak.com> <CAC38o7SZ=mGnKCOTrhi7zny3ajOF3BEmfouthN0XqVgXXANe4g@mail.gmail.com> <52042545.7020500@hardwarefreak.com> <CAC38o7SgLO_jDmO7VPqOYRJbtJDeN_i8Nmf_fCv4=u7w1CWLSQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC38o7SgLO_jDmO7VPqOYRJbtJDeN_i8Nmf_fCv4=u7w1CWLSQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: P Orrifolius <porrifolius@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/10/2013 3:44 AM, P Orrifolius wrote:
...
> No, definitely the bare card (LSI00194).  The kit (LSI00195) is about
> 30% more.
...
> Actually the other side, I'm in NZ.  It's not just the tyranny of
> physical distance, I'm probably closer than almost everyone in the USA
> to the producers of this stuff, it's also market scale.  And an
> effective Customs enforcement.

My bad, assumed you were in Europe for some reason.  And dang, PC
components -are- expensive down there.

...
> It's hard to get a good case here, at all or at a price close to eg

The Shinobi isn't horrible.  And you'll see below I found something
that'll make it work well, from a thermal standpoint anyway. ;)

...
> How does the 9240 differ from the 9211?  The only obvious difference
> that I can see is that the 9240 supports _less_ connected drives
> (unraided).  And yet it's 20-25% more expensive here retail.

The 9240 has hardware RAID5/50 in addition to all modes of the 9211.
That's the difference in price.  The RAID5 performance is abysmal though.

> The number of devices connected won't be a problem but the 2TB limit may
> force me into an upgrade earlier.

The 9211/9240 have the 2008 chip and both support >2TB drives.  It's the
older cards with the 1068 chip that are limited to 2TB drives.

...
> Hmmmm... I was going to just leave the front panel off on the assumption
> that there are dust filters on the fan intakes, and that the panel can

No need to leave the front panel off the Shinobi.

> actually be removed.  Neither of which may be true in which case those
> little slits would be a serious problem.

With cheap low speed/pressure fans the intakes don't look sufficient.
With the NMB I've mentioned or similar high pressure fans you'd be fine.
 It simply takes more pressure, thus RPM, thus noise, to flow sufficient
air to the drives through smaller intake openings.  Again, see below.

> And, as you suggest, I was going to block up all the other inlets.
> 
> And I'll take a look at better fans.

Surplus stores are great places to find good quality fans at low prices,
both DC and AC.  For instance, in the US:

http://www.surpluscenter.com/item.asp?item=16-1445&catname=electric

Wow!  I hadn't checked their inventory in a while.  $5 for San Ace
120x38 102CFM .26" H2O.  2500+ units in stock.  Specs sound familiar?
They're identical to the NMB I've mentioned in detail several times.
Every bit as good as the NMB, some would say better.  Intel has shipped
only Sanyo Denki fans in their products (CPU coolers, chassis, etc) for
20+ years.  Surplus Center is an hour drive from here.  Next time I'm in
town I gotta pick up a half dozen of these.  Price for the same unit at
Frozen CPU is $22.99:

http://www.frozencpu.com/products/17230/fan-1060/Sanyo_Denki_120mm_x_38mm_High-Speed_Fan_-_2600_RPM_109R1212H1071.html?tl=c15s562b113

If you recall from my previous post, a single one of these 102 CFM high
pressure fans mounted in the back of that Shinobi should easily cool
everything if run at full RPM.  Just in case buy 3, and if the drives
are toasty with just the one, add the other two up front.  International
shipping should be little more for 3 than 1.  Or maybe you can find a
place in New Zealand or Australia for better overall price.  I have no
idea what shipping cost on a ~3 lb small box is from Nebraska USA is to
your location.  I can tell you that 3 of these 120x38 San Ace fans for
$15 USD is a steal.

-- 
Stan

