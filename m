From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 6 May 2011 15:50:59 +0600
Message-ID: <20110506155059.6f82cbeb@natsu>
References: <20110506071752.GA22063@www2.open-std.org>
	<20110506133159.30c66519@natsu>
	<20110506090345.GA22245@www2.open-std.org>
	<4DC3BDD9.1060300@abpni.co.uk>
	<20110506094102.GC22245@www2.open-std.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Q=8NX3dn1t6pOwUNcO9Cj_W"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110506094102.GC22245@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?UTF-8?B?SsO4cm4=?= Simonsen <keld@keldix.com>
Cc: Jonathan Tripathy <jonnyt@abpni.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Q=8NX3dn1t6pOwUNcO9Cj_W
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 6 May 2011 11:41:02 +0200
Keld J=C3=B8rn Simonsen <keld@keldix.com> wrote:
  =20
> > RAID1 is traditionally a mirror only setup (ok, some RAID=20
> > implementations may do some load-balancing of some sort). So a RAID1=20
> > with 4 disks is one data set copied onto 4 disks. Bandwidth is roughly=
=20
> > the same as a single disk (ignoring any load balancing).
> > RAID10 is mirror and stripe. A RAID10 with 4 disks is similar to a 2=20
> > disk RAID0 (double bandwidth with data split in half across both disks)=
,=20
> > but with each disk having a mirror (which brings the total up to 4 driv=
es).
> >=20
> > Additionally, a RAID1 disk (at least using MD) can be accessed just lik=
e=20
> > a normal disk (good for recovery etc.) however a single disk out of a=20
> > RAID10 array is next to useless.
>=20
> I think you are demonstrating some of my points about general knowledge
> quite nicely. Don't worry, you are not alone.

So what is your proposal: people do not know they can do X, but commonly do=
 Y,
so let's rename X to Y so that both things are called Y and they 'know how =
to
do it'?

RAID10 is an established term and means "stripe of mirrors", period.
RAID1 means just a mirror. All the rest is just implementation details.
Trying to redefine 2x2 to be 5 as some 'educational project' is definitely
misguided.

--=20
With respect,
Roman

--Sig_/Q=8NX3dn1t6pOwUNcO9Cj_W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEUEARECAAYFAk3DxIMACgkQTLKSvz+PZwjZHgCfYGbfNcjIBLiaYThnYp6iUHuz
l4wAljHAtFX8gzE9eLcNcOJiG+wEL90=
=sVXK
-----END PGP SIGNATURE-----

--Sig_/Q=8NX3dn1t6pOwUNcO9Cj_W--
