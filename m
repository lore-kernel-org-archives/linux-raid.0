From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: Device kicked from raid too easilly
Date: Tue, 08 Jun 2010 07:56:07 +0200
Message-ID: <4C0DDB77.1070907@stud.tu-ilmenau.de>
References: <1275702714.3740.55.camel@sibyl.beware.dropbear.id.au>	 <4C09FB3E.1090302@stud.tu-ilmenau.de> <1275974154.4313.72.camel@sibyl.beware.dropbear.id.au>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1275974154.4313.72.camel@sibyl.beware.dropbear.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Dall <ian@beware.dropbear.id.au>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 08.06.2010 07:15, schrieb Ian Dall:
> On Sat, 2010-06-05 at 09:22 +0200, Stefan /*St0fF*/ H=FCbner wrote:
> [...]
>=20
> Puzzlingly, swapping the disks around in the backplane works so long =
as
> it is brand "A" in the first slot and not brand "B"! My current theor=
y
> is that there are transmission line effects (or maybe RFI) which make
> some slots fall outside the range of the brand "B" disks to compensat=
e!
>=20
> One might think that sata would be better, but I am simultaneously
> looking for a problem in another raid array which gives me sata CRC
> errors which I assume to be cable related. Interestingly the sata
> transport layer treats these CRC errors as soft (at least, there is n=
o
> corresponding action from md).

Weird, but on some Synology RackStations (RS407 and RS408) brand NAS
devices I had similar problems and what you wrote is exactly what I tol=
d
the customers what I think the problem might be.

The devices of mentioned make which failed, always failed slot #1.
Those that made problems, always kicked drive #1 sporadically.  But on
those problem-kids I could never find a real error.  Swapping another
disk into slot #1 made the problems disappear surprinsingly.  So I gues=
s
you thoughts are right, some disks may be able to compensate
transmission-noise better than others.

But I wouldn't want to subject it to the cabling, because (well, I'm no=
t
100% sure if that's right) slot #1's cable is the shortest.  I'd rather
think it might be not-so-well placed electronics on the board or
backplane.  Maybe a capacitor or a resistor (of which there should be
some for each port) are placed for port #1 that way, that they get a lo=
t
warmer than the others ports' passive elements.  Resistors increase
resistance if they're hotter, capacitors loose capacity when they're
hotter.  So this might change the signal levels to some noticeable exte=
nt.

>=20
>> P.S.: maybe you should check for firmware updates of the disks?
>=20
> No such luck. These (brand "B") are "Worldisk" (which I believe to be
> re-manufactured Fujitsu). The less troublesome disks (brand "A") are
> Hitachi.

That's too bad.  But actually, if our shared thoughts above are right, =
a
firmware update wouldn't help much...
>=20
> Thanks for your thoughts.
>=20
> Regards,
> Ian
>=20
Stefan
> [...]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
