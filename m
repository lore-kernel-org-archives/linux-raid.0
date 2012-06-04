From: NeilBrown <neilb@suse.de>
Subject: Re: Using a newer mdadm version just for re-adding a device
Date: Mon, 4 Jun 2012 14:15:50 +1000
Message-ID: <20120604141550.7db5cd4e@notabene.brown>
References: <20120530.193815.809240125288589880.hartrumpf@gmx.net>
	<20120531.192414.2085541500628127947.hartrumpf@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JDvfPi4pmKDKRL9KykhBaVH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120531.192414.2085541500628127947.hartrumpf@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Sven Hartrumpf <hartrumpf@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/JDvfPi4pmKDKRL9KykhBaVH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 31 May 2012 19:24:14 +0200 (CEST) Sven Hartrumpf <hartrumpf@gmx.net>
wrote:

> To answer my own question (about a RAID-1):
>=20
> Wed, 30 May 2012 19:38:15 +0200 (CEST), I wrote:
> > Is it safe to mix mdadm versions in the following scenario?
> ...
> > Now my question is:
> > Can I safely use the resulting binary (renamed to mdadm325 to avoid con=
fusion)
> > to re-add the device and then continue to use the 3.2.2 package from op=
enSUSE?
>=20
> I made a backup and tried the above: it worked perfectly.

I like it when people work out the answer themselves :-)

The only possible issue is that when 3.2.5 adds a new device it will try to
give it a larger "Data Offset".  This won't confuse md, but it might confuse
you in later life.

About the only time you need to ensure you have a consistent version of mda=
dm
is when re-creating an array that died in some way and you want to recover
the data off it, but "-assemble --force" doesn't work.

NeilBrown


--Sig_/JDvfPi4pmKDKRL9KykhBaVH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8w2djnsnt1WYoG5AQJ6zg/+PILolA06/ENCVlVubv/c/zA9ZMA9fgMM
jpXwbosp8F2YyJTqtOQbg/11B7Ar4SwthQtYJUlGxfNLnGLK2tSyt1AWLCJTpDYg
97GnX7lgF49EiyzllK4dt2R3Ro6efFEUklKMRcDoYovjpohxxJr6htIoMTOnvYIP
pOKnPsKN4ogD+0WwiHJbMTAZq15A6bO1AMqKNGo4TIIv8oCwYs6dABFya5ocgTXo
5650Vfu6EBPoWu68H7qYopeRF7QQAOqVuIqStLYZ8oY7/qIQPP+DMVY5A67ExdCw
IekNDpwZD6sejc+LWI+Vjxbilx9Gsay0rvUzzhKwP+epytQp9WuRTp6RDPWSrvNy
7fU1K2jYcMqf1/PjhTz1O54q0u/42Pqk4Y1gW3w9DMTTciUWw/phm5ZHgEA6+b8o
NoWCI+y8zLXsUnltbb7y2y5AXjsKHMNiKgwD+mV4G35SqMC5ZWCk0AiYSCqzOiE4
tzcXUUrYCs4PbZSsUlDkratj0N22b5CNxeK9MKQVQtSRnF8LHb1o5MEFum/9cnGY
SMn7AmJN8xYfpN/jSQhUas9WkzatEG6aoKvVuNLACA+3ixdtzvEKG8HvUFYajQi7
Mkv4f3hqJ5yotyFMeu7w7G3AQ//2TtsZEw2WdxsNSh0oFrmX0sRiQjLm44XYhoXQ
zpvj8WysTN8=
=cHRA
-----END PGP SIGNATURE-----

--Sig_/JDvfPi4pmKDKRL9KykhBaVH--
