From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID Class Drives`
Date: Mon, 22 Mar 2010 01:55:07 -0500
Message-ID: <38.31.05956.E4417AB4@cdptpa-omtalb.mail.rr.com>
References: <7c2a12e21003190943t546ade49u2294310ed7d9921e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7c2a12e21003190943t546ade49u2294310ed7d9921e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Aryeh Gregor' <Simetrical+list@gmail.com>, 'John Robinson' <john.robinson@anonymous.org.uk>
Cc: 'Joachim Otahal' <Jou@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Aryeh Gregor
> Sent: Friday, March 19, 2010 11:43 AM
> To: John Robinson
> Cc: Joachim Otahal; linux-raid@vger.kernel.org
> Subject: Re: RAID Class Drives`
>=20
> On Fri, Mar 19, 2010 at 4:15 AM, John Robinson
> <john.robinson@anonymous.org.uk> wrote:
> > Do you have a reference for this? Most drives' operating temperatur=
e
> range
> > is specified up to 55=B0C, sometimes higher for enterprise drives, =
without
> any
> > indication (apart from common sense perhaps) that running them this=
 hot
> > reduces lifespan.
>=20
> Google's study of >100,000 disks over 9 months or so
> <http://labs.google.com/papers/disk_failures.html> suggests that
> hotter drives don't fail much more often:
>=20
> ". . . failures do not increase when the average temperature
> increases. In fact, there is a clear trend showing that lower
> temperatures are associated with higher failure rates.  Only at very
> high temperatures is there a slight reversal of this trend." (page 5
> of PDF)
>=20
> "We can conclude that at moderate temperature ranges it is likely tha=
t
> there are other effects which affect failure rates much more strongly
> than temperatures do." (page 6)
>=20
> They were using SATA and PATA consumer drives, 5400 RPM to 7200 RPM,
> 80 to 400 GB, put into production in or after 2001 (from page 3).

	First of all, not what they call "high" temperatures in the paper
are not really very high.  Eighty C is roughly the boiling point of Eth=
yl
Alcohol, and in human terms this is considered quite hot.  Immersion of=
 body
tissues in a large volume of 80C water for several seconds will result =
in
moderately severe burns.  For most mechanical systems however, 80C is n=
ot
particularly hot.  Many solid state electronics systems can withstand 8=
0C
internal temperatures indefinitely.  An average healthy adult human bei=
ng
has a body core temperature of 37C, and a device with a 40C surface
temperature is barely warm to the touch.  It is not hot. Unless one emp=
loys
a refrigerated fluid cooling system or a Peltier junction to actively c=
ool
it, no drive system is ever going to be less than 30C if the room
temperature is anything other than uncomfortably cold.  It's rather col=
d in
my house right now, because I have the heat shut off to save money, yet=
 the
coolest drive in my arrays - which have very effective forced air syste=
ms
built in to them - are 31C.  Most are over 33C by a wide margin.  Come
summer, all of them will be over 40C.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
