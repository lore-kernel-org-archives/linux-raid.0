From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: active/active vs active/passive?
Date: Wed, 08 Jun 2005 10:07:41 -0700
Message-ID: <1118250461.15459.127.camel@seki.nac.uci.edu>
References: <1118189397.15459.108.camel@seki.nac.uci.edu>
	 <17062.14554.533625.74567@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6QdhJTtIcvDmUng0Bxxe"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17062.14554.533625.74567@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: strombrg@dcs.nac.uci.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-6QdhJTtIcvDmUng0Bxxe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2005-06-08 at 10:16 +1000, Neil Brown wrote:
> On Tuesday June 7, strombrg@dcs.nac.uci.edu wrote:
> >=20
> > The lecturer at the recent NG storage talk at Usenix in Anaheim,
> > indicated that it was best to avoid "active/active" and get
> > "active/passive" instead.
> >=20
> > Does anyone:
> >=20
> > 1) Know what these things mean?
>=20
> There's not a lot of context, so it is hard to know.
> Could be talking about multi-path devices.
> e.g. you have two fibre-channel controllers which are each connected
> to the same drive (or set of drives).  data/commands can be sent down
> either channel to the drives.
>=20
> active/active is where both (all) channels are actively in use (load
> balancing?).
> active/passive is where one is a warm-spare waiting to take over if
> the active one fails.

So it's basically trunking for performance vs. failover?
=20
> >=20
> > 2) Know why active/passive might be preferred over active/active?
>=20
> No idea.

Gee, I sure wish I had more context on this.  I suspect it was something
he skipped past pretty quickly, and I was hard pressed to type
everything into my PDA.




--=-6QdhJTtIcvDmUng0Bxxe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCpyXdo0feVm00f/8RAo7CAJ0QMa12Yje9J6s9SKeqw+Y8VSKdEwCfedlr
yk38cmta7VCFbRjXC3cy5Ik=
=wvbd
-----END PGP SIGNATURE-----

--=-6QdhJTtIcvDmUng0Bxxe--

