From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID Class Drives`
Date: Fri, 2 Apr 2010 00:43:15 -0500
Message-ID: <79.85.28131.DE385BB4@cdptpa-omtalb.mail.rr.com>
References: <hoaunl$uvk$2@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hoaunl$uvk$2@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Eric Shubert' <ejs@shubes.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Eric Shubert
> Sent: Tuesday, March 23, 2010 12:45 PM
> To: linux-raid@vger.kernel.org
> Subject: Re: RAID Class Drives`
> 
> Brad Campbell wrote:
> > Eric Shubert wrote:
> >
> >> I had a few drives running at about 55C for a couple years, with no
> >> failures (knock wood). These were used drives before being put into
> >> that environment, so they arguably had already survived the "infant
> >> mortality syndrome" that the google study identified. Would I
> >> recommend running drives at 55C? No, but I wouldn't be too concerned
> >> about it either.
> >
> > I know of at least one manufacturer who voids the warranty if the drive
> > exceeds 55 Degrees.
> 
> Care to name names? (Inquiring minds want to know!)
> 
> > I have a couple of drives here that have the
> > "Exceeded 55 degrees" mark permanently recorded in their SMART data now.
> > Having said that, I've not had issues with them yet (they only have
> > about 14,000 hours on them).
> >
> > I'd wager that extended running at elevated temperatures has the
> > potential to affect the bearing lubricant, but it's just an hunch. I've
> > never killed a drive from overtemp (and in a couple of cases I actually
> > tried).
> 
> That would be my guess as well, although I'm sure that there are high
> temp lubes available. Just depends on what the mfr uses.

	I would not expect a hard drive to use any fluid lubricant at all in
its bearings, although it is possible.  Nonetheless, 55C is *NOT* a high
temperature for any industrial lubricant, dry or fluid.  Most petroleum
based and organic lubricants can easily withstand temperatures well in
excess of 140C indefinitely.  The motor oil in your car's engine is
subjected to much higher temperatures than that daily, and if it were not
for the blow-by of hot gases laden with graphite particles and un-burned
gasoline from the engine cylinders, the oil would last for many years.  I
would expect the drives to use delron or teflon bearings, or possibly
aluminum on brass, without any fluid lubricant at all.  Any of these can
easily withstand close to or more than 200C.

	The main source of failure of the drive is going to be its thin film
metallic oxide coating, whose life will be significantly reduced as the
temperature increases.  The next most heat-sensitive part of the drive is
going to be the electronics.  This is especially true since some of the
electronic components (which are generating most of the heat in the drive
other than the head actuator servo) may not be very well thermally coupled
with the aluminum housing.  This means their temperature is going to be much
higher than the temperature of the aluminum case of the drive.  Most Silicon
and Metal Oxide semiconductors will start to fail more rapidly over 80C, but
below 80C, most semiconductors have lifetimes in the dozens of years.

