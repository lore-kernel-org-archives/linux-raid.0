From: P Orrifolius <porrifolius@gmail.com>
Subject: Re: Advice for recovering array containing LUKS encrypted LVM volumes
Date: Sat, 10 Aug 2013 20:44:32 +1200
Message-ID: <CAC38o7SgLO_jDmO7VPqOYRJbtJDeN_i8Nmf_fCv4=u7w1CWLSQ@mail.gmail.com>
References: <CAC38o7ScozDqspEH-FSyoa_W5W8s+VfYd1RTAitz574wMYqhkA@mail.gmail.com>
	<51FE529C.6000502@hardwarefreak.com>
	<CAC38o7TqO9m=6LDHxDiV=XYcfAdbnpa=GZuft-TAqFDvdqvJ4A@mail.gmail.com>
	<52015093.3040100@hardwarefreak.com>
	<CAC38o7SZ=mGnKCOTrhi7zny3ajOF3BEmfouthN0XqVgXXANe4g@mail.gmail.com>
	<52042545.7020500@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52042545.7020500@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9 August 2013 08:17, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 8/6/2013 9:22 PM, P Orrifolius wrote:
>
>> Just to give a little economic context, so as not to appear
>> heedless of your advice, the relative prices of things are a bit
>> different here. A Vantec costs about USD125, the LSI about USD360.
>
> You're probably looking at the retail "KIT".  Note I previously
> specified the OEM model and separate cables because it's
> significantly cheaper, by about $60, roughly 20%, here anyway.

No, definitely the bare card (LSI00194).  The kit (LSI00195) is about
30% more.

>
>> Anything vaguely enterprise-y or unusual tends to attract a larger
>> markup.  And if you take purchasing power into account that LSI
>> probably equates to about USD650 of beer/groceries... not directly
>> relevant but it does mean the incremental cost is harder to bear.
>
> Widen your search to every online seller in the EU and I'd think you
> can find what you want at a price you can afford.  Worth noting,
> nearly every piece of personal electronics I buy comes from Newegg
> which ships from 3 locations to here.

Actually the other side, I'm in NZ.  It's not just the tyranny of
physical distance, I'm probably closer than almost everyone in the USA
to the producers of this stuff, it's also market scale.  And an
effective Customs enforcement.

>> Putting cost aside, and the convenience of having occasionally just
>> taken the two enclosures elsewhere for a few days, my biggest
>> problem is an adequately sized and ventilated case.
>
> Such chassis abound on this side of the pond.  Surely there are
> almost as many on that side.

It's hard to get a good case here, at all or at a price close to eg
Newegg.  It's mostly just 'pimped out' mid towers.  And the weight of
the item makes one-off imports prohibitive.

> Try to locate one of these Chenbro SR112 server chassis w/fixed
> drive cage option,

Pretty hard to source Chenbro cases here, could get a SR107 shipped in
for about 3x the cost of the Shinobi.


> With 10 drives you'd want to acquire something like 3 of these
> http://www.newegg.com/Product/Product.aspx?Item=N82E16817995073 for
> your 8 data array drives w/room for one more.

Even plain drive cages are few and far between.  About USD38 for a
http://www.lian-li.com/en/dt_portfolio/ex-36a2/ or USD30 for a
http://www.thermaltake.com/products-model.aspx?id=C_00000235

Sticks in my craw to pay a third of the cost of the Shinobi case for one
of those.

There are lots of backplaned cages, for more money, but I'm excluding
those anyway on your warnings about cheap backplanes.


>> I know from having 6 drives in 6 bays with a single 120mm HDD cage
>> fan in my existing case that some drives get very hot.
>
> This is what happens when designers and consumers trend toward quiet
>  over cooling power.  Your 120 probably has a free air rated output
> of ~40 CFM, 800-1200 RPM, static pressure of ~.03" H2O.  Due to
> turbulence through the drive cage and the ultra low pressure it's
> probably only moving ~20 CFM or less over the drives.  The overall
> chassis airflow is probably insufficient, and turbulent, so heat
> isn't evacuated at a sufficient rate, causing Tcase to rise, making
> the cage fan even less useful.  Each of the 6 drives are likely
> receiving
>
> 20/6 = ~3.3 CFM or less from the cage fan.
>
> For comparison, a single NMB 120x38, model FBA12G 12H, spins 2500
> RPM, moves 103 CFM, .26" H2O static pressure, 41.5 dB SPL.
>
> http://www.nmbtc.com/pdf/dcfans/fba12g.pdf
>
> It's ~4 times louder than your 120.  However, it moves ~5x more air
> at ~8.7x higher static pressure.
[snip]
> This is why every quality server chassis you'll find has four sides
> buttoned up, an open front, and fans only at the rear and/or in the
> middle.  No side intake vent for CPUs, PCIe slots, etc.  Front to
> back airflow only.  You don't find many well designed PC chassis
> because most buyers are uneducated, and simply think "more fans is
> better, dude!". This is also why cases with those ugly 8" side
> intake fans sell like hot cakes.  The flow is horrible, but, "Dude,
> look how huge my fan is!".

And, in a small market, results in good cases being unobtainable/expensive.

I'm with you on airflow... my current case has removed side fans,
cardboard covering fan holes, duct tape over perforations and the front
plastic hacksawed out to open up where they'd only put 4 or 5 tiny
slits.  I'm not too picky about the ascetics.

>> Do you have any opinion on the suitability of a FUJITSU MEGARAID
>> LSI 2008 DUAL MINI SAS D2607-a21

> I have no experience with the Fujitsu models.
[snip]
> Too many unknowns, and not enough documentation available.  I'd
> steer clear.

Ok.

>
> This is probably your best current option, at 1/2 the Fujitsu price:
>
> This 3Gb/s Intel is/was a very popular LSISAS1068e based board, takes
> standard LSI firmware.

> The 1068 chip is limited to max individual drive capacity of 2TB.
>
> Here's an OEM Dell that I'm pretty sure is the 9240-8i and it already
> has the IT firmware, which is what you'd want.  Better card than the
> Intel above, but this sale ships to USA only apparently.

How does the 9240 differ from the 9211?  The only obvious difference
that I can see is that the 9240 supports _less_ connected drives
(unraided).  And yet it's 20-25% more expensive here retail.


The number of devices connected won't be a problem but the 2TB limit may
force me into an upgrade earlier.

For these lightweight items it will be feasible for me to use an
on-shipping service, as long as they're under a threshold for attracting
additional Customs charges... which these cards will be.
So I'll keep them in mind.


> I didn't recommend the Shinobi because it has restricted and
> unbalanced airflow characteristics.  The 2 front air intake slits
> are too small to optimally cool 8 drives in the cage without
> significant pressure

Hmmmm... I was going to just leave the front panel off on the assumption
that there are dust filters on the fan intakes, and that the panel can
actually be removed.  Neither of which may be true in which case those
little slits would be a serious problem.

And, as you suggest, I was going to block up all the other inlets.

And I'll take a look at better fans.


Thanks.
