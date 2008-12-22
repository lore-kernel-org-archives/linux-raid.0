From: "David Lethe" <david@santools.com>
Subject: RE: Spread Spectrum (SSC) Enable or Disable?
Date: Mon, 22 Dec 2008 11:14:24 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C031B1E22@34093-C3-EVS3.exchange.rackspace.com>
References: <alpine.DEB.1.10.0812220857410.27615@p34.internal.lan> <A20315AE59B5C34585629E258D76A97C031B1D1F@34093-C3-EVS3.exchange.rackspace.com> <alpine.DEB.1.10.0812221122490.7231@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <alpine.DEB.1.10.0812221122490.7231@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, smartmontools-support@lists.sourceforge.net
List-Id: linux-raid.ids

> -----Original Message-----
> From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com]
> Sent: Monday, December 22, 2008 10:25 AM
> To: David Lethe
> Cc: linux-raid@vger.kernel.org; smartmontools-
> support@lists.sourceforge.net
> Subject: RE: Spread Spectrum (SSC) Enable or Disable?
> 
> 
> 
> On Mon, 22 Dec 2008, David Lethe wrote:
> 
> >
> >
> >> -----Original Message-----
> >> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> >> owner@vger.kernel.org] On Behalf Of Justin Piszcz
> >> Sent: Monday, December 22, 2008 7:59 AM
> >> To: linux-raid@vger.kernel.org
> >> Cc: smartmontools-support@lists.sourceforge.net
> >> Subject: Spread Spectrum (SSC) Enable or Disable?
> >>
> >> Besides the power supply/surge/etc with a lot of drives-- I have
> read:
> >>
> >> http://www.wrightthisway.com/Articles/cat_reviews.html
> >> "As I mentioned earlier, the enclosure will definitely handle
drives
> >> using Spread Spectrum Clocking (SSC), an increasingly common
feature
> >> that helps reduce electromagnetic interference, especially between
> >> drives in close proximity with each others, such as you might have
> in
> > a
> >> RAID setup, so that is a definite plus here."
> >>
> >> With 16-24 disks-- if they are close together, it sounds like a
good
> >> idea to use Spread Spectrum Clocking?
> >> Does anyone here with a large-ish raid array use this?
> >>
> >> Any enterprise-insiders care to comment?
> >>
> >> Justin.
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-
> raid"
> >> in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > I know for a fact that Xyratex supports SSC on SOME of their
> enclosures.
> > However,
> > there is a caveat to be aware of ... some RAID
> > controllers/firmware/enclosure combinations
> > have problems "seeing" disks that have SSC enabled.  Don't just turn
> > this on unless you
> > verify with the enclosure manufacturer that they support SSC for
your
> > desired combination.
> >
> > David
> 
> Dave, thanks for the reply, in my case (and most people on this list)
> use
> their arrays in a regular ATX/case.
> 
> The question I had was:
> 
> "especially between drives in close proximity with each others, such
as
> you might have in a RAID setup, so that is a definite plus here"
> 
> Besides the staggered spin-up functionality (which is enabled, at
> least with WD drives when you enable SSC, which is good for the PSU)
is
> there any other 'benefit' to using SSC in relation to the comment of
> drives being close to one another?
> 
> e.g., have studies been done looking at several raid arrays with ssc
> enabled vs. disabled and what / if any correlation can be made within
> respect to failure rates?
> 
> Justin.

I can't imagine it having any positive effect.

SSC has to do with reducing overall electromagnetic emissions (EMI) for
FCC cert by 
spreading around clock harmonics a few MHz. 

All the drive vendors run reliability testing in the more expensive,
heavy-gauge metal
enclosures for a reason.  Torque/Vibration kills data, so they know they
need rigidity.
I view SSC as a cheat code that enables them to pass the FCC tests by
removing shielding
which will save them some money, and make a less reliable, more
error-prone enclosure.

I avoid any enclosure/RAID vendor that advertizes SSC as a requirement
(compliance/support
is different). This lets them get away with selling something a little
more flimsy, 
therefore, less reliable, then  what they would normally have to sell to
meet FCC certs.  

If I was in market for low-cost enclosures, I would see if they ran
their FCC compliance
testing with SSC enabled.  If they did, don't buy their enclosure.

David




