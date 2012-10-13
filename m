From: NeilBrown <neilb@suse.de>
Subject: Re: RAID-6 problem
Date: Sun, 14 Oct 2012 06:31:02 +1100
Message-ID: <20121014063102.0755820b@notabene.brown>
References: <20121013120328.GA23279@lazy.lzy>
	<alpine.DEB.2.00.1210131919230.21297@uplift.swm.pp.se>
	<mepok9xf4q.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KOsF9EV.p7IkWNhSz/EaJDq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <mepok9xf4q.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/KOsF9EV.p7IkWNhSz/EaJDq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 13 Oct 2012 11:45:10 -0700 Keith Keller
<kkeller@wombat.san-francisco.ca.us> wrote:

> On 2012-10-13, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> >
> > Re-creating a raid5/6 with --assume-clean is for me a disaster recovery=
,=20
> > something that should be performed when everything else fails. It's=20
> > extremely unfortunate that a lot of guides bring this in very early in =
the=20
> > fault finding process.
>=20
> Actually the RAID wiki suggests exactly this path, and suggests against
> --force, contrary to the advice I've gotten here from Neil and others.
>=20
> https://raid.wiki.kernel.org/index.php/RAID_Recovery#Restore_array_by_rec=
reating_.28after_multiple_device_failure.29
>=20
> I could update this, but not being expert all it'd say is "use
> --assemble --force; if it fails ask on the mailing list."  :)  Perhaps
> that's actually the best advice to give, but if there's something more
> useful to put on that page maybe someone with more expertise could
> update it?
>=20
> --keith
>=20


You should definitely try '--assemble --force' before trying to recreate the
array.  There is no question about that.

NeilBrown

--Sig_/KOsF9EV.p7IkWNhSz/EaJDq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUHnBdjnsnt1WYoG5AQIEAw//dqWRD0wfcyyM2hG1sbkNh6QfdV1uJDr3
1Bp7X18W/sUGr5iJvKZ/adKcF5rdAvXkbwzp+QDj+c12ZKbYtVPRtCTOARuWPeOb
WgQSGyblrIJEfjn9DC7RV295HrlM6G14e5vg+A2THHVJVKOix/UcpkiZ7fdAwHh1
H+8F6sPSioyfWp7JruHt1dkSfC8ffeXeV4iWF8G8xVFMjcFn3/MqyOYQpc2zpGh0
7oMLxVDqqY5e8wXDMGJ4n+Ju2PypEaKX+YvsMknmEax9PvU7L3w0p9r4ubXt8q1A
C9VIAkfYV70ul/o0L3KRSl4hwo0567NUHKd8j0F75cQLFNhF4aJXc/lI7cH/jFxx
H2ee1A2BPtWYlmTspbasyZNzVs6Zawf3P8ZebrMbneYOMIjhzFdjOz8tblSscv09
A95oWOMyLhy+T2Ag+m5UgEGNGLRJnaFkkMR58uGixeJPMYPzOUGaIiLa/d0yg1UJ
SO0nh68Pg2C+xpHZOE640QQ57GDsIEIt6qffZSTp7bIKGazTo3Hi33t+ReH6b/zc
5pxKz1hbqqkxoL3ahhBPjpRQVyB9rCaqW4b4cJrxk93Ka/U2L4tpzfHHH5Rwd8gH
ZemnzPYW3Squ6I4LnVtWLb6jWcYIqAD4BK6Jb/JA9DTKpQJnIqglJYyVc/gl4o6z
ZrJEAaerehs=
=wJnY
-----END PGP SIGNATURE-----

--Sig_/KOsF9EV.p7IkWNhSz/EaJDq--
