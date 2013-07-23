From: NeilBrown <neilb@suse.de>
Subject: Re: shown disk sizes
Date: Wed, 24 Jul 2013 08:27:01 +1000
Message-ID: <20130724082701.006f5fab@notabene.brown>
References: <1374071867.25339.14.camel@heisenberg.scientia.net>
	<20130718094327.7d46949e@notabene.brown>
	<1374596770.8463.23.camel@heisenberg.scientia.net>
	<alpine.DEB.2.00.1307231911380.8891@uplift.swm.pp.se>
	<1374600126.8463.24.camel@heisenberg.scientia.net>
	<20130724065723.3a0d52b3@notabene.brown>
	<1374617431.5348.21.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.bGLCtiCNotstH/ADMMtw88"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374617431.5348.21.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.bGLCtiCNotstH/ADMMtw88
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Jul 2013 00:10:31 +0200 Christoph Anton Mitterer
<calestyo@scientia.net> wrote:

> On Wed, 2013-07-24 at 06:57 +1000, NeilBrown wrote:
> > New feature in 3.3 is that when you reshape (e.g.) a RAID5 to a RAID6 i=
t can
> > do so without using a "backup file" - which is are a pain to work with =
and
> > slow things down a lot.
> > What it does instead is move the "data_offset" towards the start of the
> > device.  That way it is never writing onto live data, and so no backup =
is
> > needed.
> So you are stealing my precious space, which I was paying soo much money
> for?! ;-)
>=20
> Seriously,... sounds like a good idea... :)
> But why does it also increase the "gap" at the end? Guess the whole
> "gap" at the end thingy is something we will never ever really get rid
> of, will we? I mean it's no problem because of some missing sectors...
> it just makes like more complicated when doing manual geometry
> calculations...

The "gap at the end" is due to clumsy coding that I indicated earlier that I
would try to find time to tidy up.

>=20
>=20
> While talking about data_offset... is it planned to implement a way to
> add a way to specify the data_offset manually  and/or specify a
> data_offset_offset (i.e. a additional offset to what mdadm would have
> autodetected... similar as LVM allows?

You mean like a "--data-offset" option to --create and --grow?  Yes mdadm
3.3 has that.

>=20
> I mean the practical relevance is probably not that much... but manual
> specification would probably needed whenever you have some more complex
> block layer (e.g. LVM), another MD or a hardware RAID below MD... and
> you want to align to the stripes... or unusual large chunk sizes...
>=20
> I've seen that you have some branch where you can specify the offset for
> each device... but... guess that was only for some guys to do recovery
> works?!

It is now part of mainline.

NeilBrown


--Sig_/.bGLCtiCNotstH/ADMMtw88
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUe8DNTnsnt1WYoG5AQKBCg/7BJVvkZnln1KEM6l0Btl04fqtVqRmucwS
/HvpN0N7jFLvuKKay+3fmF2nwz8b8eTsCM4SF3UHr0VvyHab0YS1bfAnzLZj25eQ
b4ZUnBPUUtxdd/EWCv37gSg8tIa2YwZMOA3N/hxRGUuVTexlwwDLGu86WuNEAPac
y2fu2CQx8DmrMhnAM1/zx8Ogrom/7d4UdxupFMRe9QUXP8J5K/cXJOGP2appxHZb
uTy6f1dV864mib34RwuAsGdd4JCnf8qblqDy9EcsGLQ9ogm/f2dyQOlc+QwEl9e7
rUuGiwLpJf+m7G/nC5DpQNt4zq0sd+X73INyRzPJLaA9DLnFuweZU8t5COqv3DH0
Lom18cueDT6PKv8hwhy5eku7aoZ3IH3bb7mbGShPgwQQPoTlWYJDF7T+RLI5vqZa
GNMggh/lQ9T8UCqKa+1+7UgeYJdp8+tcI51a1HPtVwX/aVBdK1yhOdhvhenXO/Oo
pyg1GZX0H0iwnpQO8PH1OXQUKTJ1tOow80VC33kKtHsG7EHQBpSSX9QHMSGXbo+W
Eh78bIniwURo2d/9qFo7Mjzx54XmDPXrXtph9oEYBhHRbpMvA50dKxB3JF3OyZLJ
vG2pEKm+N31tW7rdjUM6huiORgCfOiDCLVTlE5oB0ytiS2mcXANNltbJKuVJ/ScZ
cVax3iVQI08=
=nVSc
-----END PGP SIGNATURE-----

--Sig_/.bGLCtiCNotstH/ADMMtw88--
