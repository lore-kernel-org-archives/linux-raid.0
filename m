From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: active/active vs active/passive?
Date: Wed, 08 Jun 2005 10:15:10 -0700
Message-ID: <1118250910.15459.132.camel@seki.nac.uci.edu>
References: <1118189397.15459.108.camel@seki.nac.uci.edu>
	 <42A641CC.9040905@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cS1bBWdPBHhiUubmMR88"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42A641CC.9040905@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: strombrg@dcs.nac.uci.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-cS1bBWdPBHhiUubmMR88
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2005-06-07 at 20:54 -0400, Paul Clements wrote:
> Dan Stromberg wrote:
> > The lecturer at the recent NG storage talk at Usenix in Anaheim,
> > indicated that it was best to avoid "active/active" and get
> > "active/passive" instead.
> >=20
> > Does anyone:
> >=20
> > 1) Know what these things mean?
>=20
> In the clustering world, active/active means 2 or more servers are=20
> active at a time, either operating on separate data (and thus acting as=20
> passive failover partners to each other), or operating on the same data=20
> (which requires the use of a cluster filesystem or other similar=20
> mechanism to allow coherent simultaneous access to the data).

This is probably what the lecturer intended.

> > 2) Know why active/passive might be preferred over active/active?
>=20
> Well, if you're talking about active/passive vs. active/active with a=20
> cluster filesystem or such, the active/passive is tons easier to=20
> implement and get right. Plus, depending on your application, the added=20
> complexity of a cluster filesystem might not actually buy you much more=20
> than you could get with, say, NFS or Samba (CIFS).

What it is about active/passive that is so much easier to implement than
active/active?

Thanks!


--=-cS1bBWdPBHhiUubmMR88
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCpyeeo0feVm00f/8RAhZ2AJ9pOfJ0lSW3/IzmNEx/K8SRv2uAsQCgm2wN
Vy0CB/cYavhKrWfzspj9UPs=
=f4y2
-----END PGP SIGNATURE-----

--=-cS1bBWdPBHhiUubmMR88--

