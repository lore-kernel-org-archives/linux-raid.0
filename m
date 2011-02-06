From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: What's the typical RAID10 setup?
Date: Sun, 6 Feb 2011 17:03:19 +0500
Message-ID: <20110206170319.66306ed5@natsu>
References: <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
	<4D475AB5.10600@hardwarefreak.com>
	<20110203110428.GA26762@www2.open-std.org>
	<4D4B3DAE.3070502@hardwarefreak.com>
	<20110204070613.GA3788@www2.open-std.org>
	<4D4BB87A.30800@hardwarefreak.com>
	<iigobc$n0n$2@dough.gmane.org>
	<20110204135343.GC4808@www2.open-std.org>
	<AANLkTikxybDGW3tOHvoy4tBTo1+OpLAUizno=VMp_exm@mail.gmail.com>
	<AANLkTimJaAXkWNDdjQ3E1fS01Cu9xx+=Vod7cx6DQKjp@mail.gmail.com>
	<20110206075816.GA32205@www2.open-std.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/z8zRyRZPT7o1TG6anEk5l7n"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110206075816.GA32205@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?UTF-8?B?SsO4cm4=?= Simonsen <keld@keldix.com>
Cc: Drew <drew.kay@gmail.com>, hansbkk@gmail.com, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/z8zRyRZPT7o1TG6anEk5l7n
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 6 Feb 2011 08:58:16 +0100
Keld J=C3=B8rn Simonsen <keld@keldix.com> wrote:

> On Sat, Feb 05, 2011 at 08:02:02PM -0800, Drew wrote:
> > > If you want to investigate further, here are the main brands, I
> > > imagine most are running on Linux/mdadm-based firmware:
> > >
> > > Thecus, Qnap, Synology, Dlink, Buffalo, NetGear (was Infrant)
> >=20
> > I can confirm Buffalo & QNAP are both Linux based. Neither support
> > RAID 10, just 0, 1, 5, and in the QNAP's case, 6.
>=20
> Do they have a ssh mode, where you can log in and do as you please?

Most likely not in the stock configuration, but on some devices you can
replace the original firmware with something more advanced. For example, I
have installed complete Debian Squeeze on my D-Link DNS-323 box, following
these instructions: http://www.cyrius.com/debian/orion/d-link/dns-323/
It has a 500 MHz ARM CPU and 64 MB of RAM.

--=20
With respect,
Roman

--Sig_/z8zRyRZPT7o1TG6anEk5l7n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1OjgcACgkQTLKSvz+PZwizrgCfXWWhsn7P2pyW1PuGCmPBJVPt
HscAnib8F7M69bLGvqfvDJ9paNtLEMoJ
=uEwH
-----END PGP SIGNATURE-----

--Sig_/z8zRyRZPT7o1TG6anEk5l7n--
