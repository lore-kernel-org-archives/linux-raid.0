From: Redeeman <redeeman@metanurb.dk>
Subject: RE: upgrade advice
Date: Thu, 18 Dec 2008 08:36:47 +0100
Message-ID: <1229585807.22331.110.camel@localhost>
References: <d5fe39840812160310t45e822c1geb633f805cf5388e@mail.gmail.com>
	 <1229428184.22331.43.camel@localhost>
	 <alpine.DEB.1.10.0812160807200.725@p34.internal.lan>
	 <1229436950.22331.45.camel@localhost>
	 <cccedfc60812160757x2af73afbv4a69eac31d212062@mail.gmail.com>
	 <alpine.DEB.1.10.0812161829490.31132@p34.internal.lan>
	 <cccedfc60812161608y29e6c645n6ff7df5c87292374@mail.gmail.com>
	 <1229497160.22331.73.camel@localhost>
	 <cccedfc60812170526l43c661ddgff95c99ea883f362@mail.gmail.com>
	 <A20315AE59B5C34585629E258D76A97C030D4837@34093-C3-EVS3.exchange.rackspace.com>
	 <cccedfc60812170637j7eab2c4cyac88fc110b51755f@mail.gmail.com>
	 <A20315AE59B5C34585629E258D76A97C030D48CC@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C030D48CC@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2008-12-17 at 09:30 -0600, David Lethe wrote:
> > -----Original Message-----
> > From: Jon Nelson [mailto:jnelson-linux-raid@jamponi.net]
> > Sent: Wednesday, December 17, 2008 8:38 AM
> > To: David Lethe
> > Cc: Redeeman; Justin Piszcz; linux-raid@vger.kernel.org
> > Subject: Re: upgrade advice
> > 
> > On Wed, Dec 17, 2008 at 8:28 AM, David Lethe <david@santools.com>
> > wrote:
> > >> -----Original Message-----
> > >> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > >> owner@vger.kernel.org] On Behalf Of Jon Nelson
> > >> Sent: Wednesday, December 17, 2008 7:27 AM
> > >> To: Redeeman
> > >> Cc: Justin Piszcz; linux-raid@vger.kernel.org
> > >> Subject: Re: upgrade advice
> > >>
> > >> > What sort of volume of disks are you using, and what loads? (24/7
> > >> with
> > >> > high load?)
> > >>
> > >> It's a home server. It's up 24/7. Load probably 80% of the time is
> > >> low, the rest of the time it's bursty.
> > >>
> > 
> > > Read the specs on the disks.  Most consumer class drives are rated
> > for
> > > only 2400 hours annual duty cycle ... so I guess you turn the
> > computer
> > > off in April? :)
> > 
> > Yeah. Right. I typically get > 5 years out of the disks. I got almost
> > 9 years once, before bad sectors started showing up. Actually, I've
> > either gotten less than a week or more than 4 years out of every
> > single drive I've ever had, except a really bad batch of seagates I
> > got 8-10 years ago.
> > 
> > The current temp of the drives varies between 28C and 33C (the Hitach
> > is warmer by +4C than any other drive).
> > 
> > > Other differences include number of ECC correction bits, so you will
> > > absolutely get more grown bad blocks with cheap drives.
> > 
> > That's good to know.
> > 
> > > drives.   No wonder several fail within days of each other, they all
> > > have same model, I/O load, and generally same manufacturing batch.
> > 
> > I never have more than 1 of the same manuf. / model in a raid at a
> > time. I have a 3 drive raid10f2 with 3 different manuf.
> > 
> > > If you are hell-bent on getting cheap drives, then at least factor
> in
> > > cost of an additional drive so you can implement RAID6, and automate
> > a
> > > daemon to check/repair consistency often.
> > 
> > I will likely move to raid6 eventually.
> > Thanks for the advice.
> > 
> > --
> > Jon
> The duty cycle makes a difference now, but wasn't a design point until
> last few years ago when hardware RAID manufacturers reluctantly started
> supporting SATA disks. When you were buying disks 5-10 years ago, the
> enterprise class disks were SCSI & FC, and consumer drives were
> ATA/SATA. They had to charge more and make the ATA disks a little better
> to prevent losing too much money to warranty replacements.  The market
> now demands clear pricing and performance/reliability differences
> between enterprise and consumer class SATA devices.
> 
> As for drive temperature ... believe it or not, it is irrelevant when it
> comes to drive failures, unless you are pushing the operational
> temperature thresholds.  Google published a detailed analysis of drive
> failures in their storage farm that included average drive temperatures,
> and proved that increased drive temp did not affect failure rate.   (In
> fact, the drives running at the lowest temperatures actually had a
> slightly higher failure rate).
> 
> Anybody who thinks there are no difference between the specs haven't
> looked at them deeply enough.  ECC bits;  background media
> scanning/repair algorithms; and firmware make all the difference in the
> world.  Ask anybody who has worked as a storage architect for a RAID
> manufacturer or is a drive test engineer. 
> 
> To the untrained eye (or somebody who has never had opportunity to
> attend non-disclosure meetings with drive manufacturers), there isn't
> much of a difference because they get hung up on easy things like RPMs
> and amount of cache .. the stuff they put on the outside of the box.
> 
> Error detection, recovery algorithms, extensive log page reporting, and
> online/offline firmware diagnostics tend to be ignored. Not only do
> people not understand them, but some of the really good stuff isn't
> published in the manuals due to intellectual property concerns.  If you
> are in the 'biz, and buying thousands or tens of thousands of disks a
> month, you become well aware of these things.
> 
> "Well, I buy xyz brand disk drives because I had such-and-such
> experiences with abc brand disks".   How many times have people said
> that??  The same person wouldn't commoditize car, dishwashers, or wine
> like this.  People who don't understand a product say such things.   
Yeah i realize that this is really a useless thing. Im sure these people
have had the failures they speak of, but thats ofcourse totally useless
across series of disks, and ALL brands and series obviously will have
some disks that fail early, and someone is bound to get those..

> 
> I should touch on firmware as well.  NCQ, TCQ, severety-1 bugs that can
> result in disks locking up or having catastrophic data loss?   They
> exist.  I won't break any NDAs, but even a firmware upgrade can have
> profound differences in your storage farm.   The firmware update release
> notes for many drives would scare the heck out of you, and make you
> wonder what motivated ABC company to ever release something, or for that
> matter, what motivated ABC company to not make something public and have
> a massive recall when certain bugs were found.   We've seen this happen
> in industry before with things like Seagate's stiction problem, NCQ
> bugs, IBM "deathstars", Hitachi recalls and so on.
> 


Hmm.. you have kindof convinced me.. I should probably look at buying WD
RE2-GP then


> OK, off my soapbox ... back to work writing disk diagnostic software for
> my OEM customers 
> 
> David
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

