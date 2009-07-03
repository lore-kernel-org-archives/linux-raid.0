From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Adding a smaller drive
Date: Fri, 3 Jul 2009 11:12:03 -0500
Message-ID: <20090703161151277.OOAZ19903@cdptpa-omta03.mail.rr.com>
References: <87eit31hgq.fsf@frosties.localdomain>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87eit31hgq.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Leslie> I may have to rethink my position on using raw drives.  If I
> > Leslie> partition the drives, I can make the partition a bit smaller
> > Leslie> than the whole drive, allowing for the addition of a future
> > Leslie> drive whose size is a bit off.  I hate to waste space, but being
> > Leslie> stuck with an undersized or limping array is worse.
> >
> > This is not nearly as big a problem as it used to be.  Drive
> > manufacturers need to adhere to an IDEMA standard which requires them to
> > use a specific LBA count for each capacity class.
> >
> > I.e. a 500GB Seagate drive must have exactly the same number of sectors
> > as a 500GB Western Digital or Hitachi.
> >
> > The IDEMA LBA standard applies to 3.5" form factor drives over 160GB as
> > well as 2.5" FF drives over 80 GB.
> 
> Is that realy exactly so many LBA sectors or at least as many?
> 
> I don't really see anything wrong with a 500G drive having a few more
> sectors. And I know my Maxtor 200G disk is 3G bigger than Seagates.

	'Excellent point.  If the spec calls for a minimum of sectors, then
it is quite possible a complaint drive might well have fewer sectors than
the ones I used to build the array.  OTOH, all of the 1T drives on my
systems  have precisely the same number of user available sectors, and all
the 1.5T drives have the same number.  Since the drives represent not only
different models from one manufacturer but also different manufacturers,
this suggests to me an adherence to a specific spec.  On yet the other hand,
it may merely mean they all have the same number of platters and similar
architectures.  The 1.5T drives are less than 1.5 times bigger than the 1T
drives, so I could not replace a 3 drive 1T triplet with a pair of 1.5T
drives.

