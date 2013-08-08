From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Advice for recovering array containing LUKS encrypted LVM volumes
Date: Thu, 08 Aug 2013 15:17:16 -0500
Message-ID: <5203FCCC.7020600@hardwarefreak.com>
References: <CAC38o7ScozDqspEH-FSyoa_W5W8s+VfYd1RTAitz574wMYqhkA@mail.gmail.com> <51FE529C.6000502@hardwarefreak.com> <CAC38o7TqO9m=6LDHxDiV=XYcfAdbnpa=GZuft-TAqFDvdqvJ4A@mail.gmail.com> <52015093.3040100@hardwarefreak.com> <CAC38o7S3BvM0t2Q24z1FjnEDwk7-nimQPBGKQRxfEAPqyg1=dw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC38o7S3BvM0t2Q24z1FjnEDwk7-nimQPBGKQRxfEAPqyg1=dw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: P Orrifolius <porrifolius@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/6/2013 9:22 PM, P Orrifolius wrote:

> Thanks for taking the time to make these recommendations, I will
> certainly reassess that style of solution.

You bet.

> Just to give a little economic context, so as not to appear heedless
> of your advice, the relative prices of things are a bit different
> here.
> A Vantec costs about USD125, the LSI about USD360.  

You're probably looking at the retail "KIT".  Note I previously
specified the OEM model and separate cables because it's significantly
cheaper, by about $60, roughly 20%, here anyway.

> Anything vaguely
> enterprise-y or unusual tends to attract a larger markup.  And if you
> take purchasing power into account that LSI probably equates to about
> USD650 of beer/groceries... not directly relevant but it does mean the
> incremental cost is harder to bear.

Widen your search to every online seller in the EU and I'd think you can
find what you want at a price you can afford.  Worth noting, nearly
every piece of personal electronics I buy comes from Newegg which ships
from 3 locations to here.

Los Angeles	2550 km
Newark		2027 km
Memphis		1020 km

In essence from Bremen, Brussels, and Bordeaux, to Lisbon.  I'm buying
from a company 5 states away, equivalent to 3 or 4 *countries* away in
Europe.

> All that said data loss is grim and, by the sounds of your email, just
> switching to eSATA won't help me much in terms of reliability.

I simply would not take a chance on the Vantecs long term.  Even if the
eSATA and PMP work reliably, the transformer and airflow are very weak
links.  If a transformer fails you lose 4 drives as you just did and you
have to wait on a replacement or find a suitable unit at the EU
equivalent of Radio Shack.  The poor airflow will cause 1 or even 2
drives to fail possibly simultaneously.

The simply question is:  Are your data, the cost of replacement drives,
and the rebuild hassle, worth the risk?

> Putting cost aside, and the convenience of having occasionally just
> taken the two enclosures elsewhere for a few days, my biggest problem
> is an adequately sized and ventilated case.

Such chassis abound on this side of the pond.  Surely there are almost
as many on that side.  Try to locate one of these Chenbro SR112 server
chassis w/fixed drive cage option, to reduce cost vs hot swap.  It'll
hold your 10 drives and cool them very well.  This chassis has far
better cooling than any stock consumer case at any price--3x92mm quality
PWM hot swap fans mid chassis.  Their Euro website only shows a model
with hot swap drive bays but you should be able to find a distributor
carrying the fixed bay model.

http://usa.chenbro.com/corporatesite/products_detail.php?sku=201
http://www.chenbro.eu/corporatesite/products_detail.php?sku=162

Chenbro is in the top 3 of channel chassis makers.  I've had one of
their SR103 dual chamber "cube" chassis, in the rare two tone blue
finish, for 13 years now.  I don't have any pics of mine but I found
this one with tons of ugly stickers:

http://coolenjoy.net/bbs/data/gallery/%EC%82%AC%EC%A7%84120408_007.jpg

All angle shots of a black model showing the layout & features.  Looks
like he did some cutting on the back panel.  There were a couple of
panel knock outs there for VHDCI SCSI cables.

http://www.2cpu.co.kr/data/file/sell/1893365098_c17d5ebf_EB84B7EC849CEBB284.jpg

This is the best pedestal chassis I've ever owned, by far, maybe the
best period.  Then again it should be given the $300 I paid for it.  Top
shelf quality.  If you can find one of these old SR103s for sale it
would be nearly perfect.  Or the SR102 or 101 for that matter, both of
which are progressively larger with more bays.

With 10 drives you'd want to acquire something like 3 of these
http://www.newegg.com/Product/Product.aspx?Item=N82E16817995073
for your 8 data array drives w/room for one more.  This leaves 2x 5.25"
bays for optical/tape/etc drives, and two 3.5" front access bays for
floppy, flash card reader, dual hot swap 2.5" cages for SSDs, etc.
There are four internal 3.5" bays in the back directly in front of the
120mm exhaust fan port for your 2 boot drives.  As I said, if you can
find one of these used all your problems would be solved, and cost
effectively.

> I know from having 6 drives in 6 bays with a single
> 120mm HDD cage fan in my existing case that some drives get very hot.

This is what happens when designers and consumers trend toward quiet
over cooling power.  Your 120 probably has a free air rated output of
~40 CFM, 800-1200 RPM, static pressure of ~.03" H2O.  Due to turbulence
through the drive cage and the ultra low pressure it's probably only
moving ~20 CFM or less over the drives.  The overall chassis airflow is
probably insufficient, and turbulent, so heat isn't evacuated at a
sufficient rate, causing Tcase to rise, making the cage fan even less
useful.  Each of the 6 drives are likely receiving

20/6 = ~3.3 CFM or less from the cage fan.

For comparison, a single NMB 120x38, model FBA12G 12H, spins 2500 RPM,
moves 103 CFM, .26" H2O static pressure, 41.5 dB SPL.

http://www.nmbtc.com/pdf/dcfans/fba12g.pdf

It's ~4 times louder than your 120.  However, it moves ~5x more air at
~8.7x higher static pressure.  The high static pressure allows this fan
to move air at rated flow even with the high resistance of a dense pack
of disk drives.  This one fan mounted on a chassis back panel is more
than capable of cooling any quality loaded dual socket server and/or
JBOD chassis containing 16 current drives of any brand, RPM, or power
dissipation.

This fan can provide ~6.4 CFM to each of 16 drives, ~2x that of your 120
across 6 drives.  And again this is one fan cooling the entire chassis.
 No other fans are required.  Many cases using the low noise fans employ
5-6 of them to get adequate aggregate flow.  Each additional unit adds 3
dB of SPL.  Using 6 of 25 dB yields a total SPL of 40 dB.  The human ear
can't discern differences of less than 2-3 dB SPL, so the total "noise"
output of the 6 cheap/quiet fan based system and the single high
quality, high pressure, high flow fan system is basically identical.
The cheap quiet LED fans are ~$5 each.  This NMB runs ~$22.  To employ
5-6 of the cheap 120mm fans requires mounting them on multiple exterior
panels in a manner that generates flow in at least 3 directions.  The
intersection of these flows creates turbulence, further decreasing their
performance.

This is why every quality server chassis you'll find has four sides
buttoned up, an open front, and fans only at the rear and/or in the
middle.  No side intake vent for CPUs, PCIe slots, etc.  Front to back
airflow only.  You don't find many well designed PC chassis because most
buyers are uneducated, and simply think "more fans is better, dude!".
This is also why cases with those ugly 8" side intake fans sell like hot
cakes.  The flow is horrible, but, "Dude, look how huge my fan is!".

> Anyway, thanks for prompting the reassessment.

In "life 1.25" or so I was a systems designer at a shop specializing in
custom servers and storage arrays.  One of my areas of expertise is
chassis thermal management.  Hardware is in my blood.  I like to pass
some of that knowledge and experience when the opportunity arises.  Note
my email address.  That's my 'vanity' domain of 10+ years now.  ;)

> I was imprecise... xfs_repair -n exited with 0 for each filesystem, so
> that was a good result.  'Seemingly' because I didn't believe that it
> had actually checked 8TB of data in the time it took... as you say the
> data may still be mangled.

xfs_repair checks only metadata and so in parallel using all CPUs/cores,
which is why it's so fast on seemingly large filesystems.  It uses tons
of memory with large filesystems as well--large in this context meaning
lots of inodes, not lots of very large files.  It doesn't look at files
at all.  So it didn't check your 8TB of data, only the few hundred MB or
so of directory metadata, superblocks, etc.

> OK.  They're not available locally but I'll consider something similar
> if I can find a suitable case to put them in.

I'd guess you're not going to find much of this stuff 'locally', even
without knowing where 'local' is.

> It has been, and not at all.  I appreciate you taking the time to
> help.  I'll keep looking to see if I can find the necessaries for an
> in-case solution, within budget.

As you can see above I'm trying to help you get there, and maybe
providing a little knowledge that you might use only 2-3 times in your
life.  But it's nice to have it for those few occasions. :)


> Thanks.

You're welcome.

-- 
Stan

