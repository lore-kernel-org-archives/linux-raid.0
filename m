From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: active/active vs active/passive?
Date: Wed, 08 Jun 2005 11:00:57 -0700
Message-ID: <1118253658.15459.158.camel@seki.nac.uci.edu>
References: <1118189397.15459.108.camel@seki.nac.uci.edu>
	 <42A641CC.9040905@steeleye.com>
	 <1118250910.15459.132.camel@seki.nac.uci.edu>
	 <42A73007.6060102@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0hEdVHP8EJcjSwmekGtZ"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42A73007.6060102@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: strombrg@dcs.nac.uci.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-0hEdVHP8EJcjSwmekGtZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2005-06-08 at 13:51 -0400, Paul Clements wrote:
> Dan Stromberg wrote:
> > On Tue, 2005-06-07 at 20:54 -0400, Paul Clements wrote:
>=20
> > What it is about active/passive that is so much easier to implement tha=
n
> > active/active?
>=20
> There's nothing that difficult about active/active, assuming you're=20
> talking about the servers operating on separate (or static) data. What's=20
> difficult is the cluster filesystem. Those tend to be big pieces of=20
> low-level (read, kernel) code, and they require a distributed lock=20
> manager and a membership model, which are also generally implemented=20
> in-kernel.
>=20
> Of course, without knowing the context of the speaker's reference to=20
> this, it's hard to say exactly what he meant or if it's even remotely=20
> related to what I'm talking about... :)

Is the difficulty mostly stemming from keeping stateful sessions and
content consistent across replica servers?


--=-0hEdVHP8EJcjSwmekGtZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCpzJZo0feVm00f/8RAntsAKCddzdmtAfmeeiaFrBxUAJLFLuFXgCggK0+
JP0cFGhf+FWD1cuumIubr2A=
=9dtu
-----END PGP SIGNATURE-----

--=-0hEdVHP8EJcjSwmekGtZ--

