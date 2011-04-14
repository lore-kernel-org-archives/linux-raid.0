From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Recommended pci-e 1x SATA cards.
Date: Thu, 14 Apr 2011 18:02:39 +0600
Message-ID: <20110414180239.50b75036@natsu>
References: <4DA6CCFE.8020708@crc.id.au>
	<20110414165433.7a7d1cdc@natsu>
	<20110414110558.GD6876@baribal.tarvainen.info>
	<20110414172528.72122371@natsu>
	<20110414114118.GF6876@baribal.tarvainen.info>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6pwiOVX9kXdRcfCCeO3Ck4Q"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110414114118.GF6876@baribal.tarvainen.info>
Sender: linux-raid-owner@vger.kernel.org
To: Tapani Tarvainen <raid@tapanitarvainen.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6pwiOVX9kXdRcfCCeO3Ck4Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Apr 2011 14:41:18 +0300
Tapani Tarvainen <raid@tapanitarvainen.fi> wrote:

> On Thu, Apr 14, 2011 at 05:25:28PM +0600, Roman Mamedov (rm@romanrm.ru)
> wrote:
>=20
> > > > I suggest that you avoid Silicon Image 3132, they have data corrupt=
ion
> > > > issue (on some board designs?), triggered or amplified by transferr=
ing
> > > > via both ports at the same time, at full speed.
>=20
> > See this thread: http://comments.gmane.org/gmane.linux.raid/30629
>=20
> Thanks! Based on that, it'd seem it's not so much Sil3132 per se,
> but some (too cheaply?) boards built around it

Maybe, but in my opinion a chip design should be 'well-rugged' against this
kind of board-design blunders, under no circumstance it should pass silent
corruption of user data just like that. There are checksums built in into t=
he
SATA protocol, and parity in PCI-E, so the data path itself is protected qu=
ite
well against a flaky trace or solder or whatever. Silicon Image, on the oth=
er
hand, had multiple data corruption reports with 3112/3114/3124 in the past,
and many of those were fixable by turning off PCI performance optimizations,
i.e. likely logic-level chip design problems. So I suspect 3132 has some le=
ss
than ideal design decisions as well. And maybe some of those can be worked
around by adding more external components (e.g. bigger capacitors etc), whi=
ch
are not present on cheaper board designs. So to me this seems to be a split
blame, both the board designers and the chip designer are at fault.

> and the obvious conclusion is that they should only be bought with plan to
> test them before real use and return flakey ones.

That's a good idea at all times.

> On the other hand I've had similar trouble with a JMicron card
> and a Marvell-based card. So planning to test and return
> bad cards is probably a good idea with them as well.

I have one semi-bad JMicron based card - its problem is manifesting itself =
as
one SATA port at first throwing a lot of CRC errors then switching itself d=
own
to 1.5GBps from 3.0GBps, and continuing to work perfectly at the slower spe=
ed.
To me this is an example of error-handling done right.

--=20
With respect,
Roman

--Sig_/6pwiOVX9kXdRcfCCeO3Ck4Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2m4l8ACgkQTLKSvz+PZwhjVwCfUB11ACKYic4ydnFxivA1UtaH
0DAAn38CSsggb3xw3ZWHhtze1gKOrHaO
=fvTX
-----END PGP SIGNATURE-----

--Sig_/6pwiOVX9kXdRcfCCeO3Ck4Q--
