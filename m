From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 3/3] raid5: relieve lock contention in
 get_active_stripe()
Date: Wed, 28 Aug 2013 14:32:52 +1000
Message-ID: <20130828143252.1d48b04b@notabene.brown>
References: <20130812022434.507702228@kernel.org>
	<20130812022549.013010221@kernel.org>
	<20130827131752.4d5ba375@notabene.brown>
	<20130827085330.GA30133@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eUrdUSVhcxkt8ZYAjqVpjo."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130827085330.GA30133@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, djbw@fb.com
List-Id: linux-raid.ids

--Sig_/eUrdUSVhcxkt8ZYAjqVpjo.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Aug 2013 16:53:30 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Tue, Aug 27, 2013 at 01:17:52PM +1000, NeilBrown wrote:

>=20
> > Then get_active_stripe wouldn't need to worry about device_lock at all =
and
> > would only need to get the hash lock for the particular sector.  That s=
hould
> > make it a lot simpler.
>=20
> did you mean get_active_stripe() doesn't need device_lock for any code pa=
th?
> How could it be safe? device_lock still protects something like handle_li=
st,
> delayed_list, which release_stripe() will use while a get_active_stripe c=
an run
> concurrently.

Yes you will still need device_lock to protect list_del_init(&sh->lru),
as well as the hash lock.
Do you need device_lock anywhere else in there?

NeilBrown

--Sig_/eUrdUSVhcxkt8ZYAjqVpjo.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUh19dDnsnt1WYoG5AQJrPxAAq8hv19R3A2fS1pvlTO9Thr7fnA4XJn9u
KLfOR/m8MqlFjzj4NaLHDH7U8kPSNf1SlD6D5Nc3raInnD5dledIUcu15jFvMPRf
xvczkBwawx6ueMFBND2tiqytFdJvIWkiyBtVzeiXLo9uvxixP/3QBluXLxlNm1st
ziO+HWbjZnVKxjtMNh+8pqbq86z3Nld3HU35aY7hAOBBujrv3n6MvTWVuESMdE/z
ijlh3YbQYHc8PDLAPKqeamqxOi6yR2nRLuXW+e0mzYAT/RfUNrApegNdYagbUgyp
2IAB3FgJ/OrwTch/wLbQI3Z1nUb4HqzP5QYoxqtKsiJJVZmmtLw85FKpmZ2xXPBC
z3F2QSJGTfd+SM/nBXbij5ffWV6p8tmbPuKB8QN2ffXC68gU0ch+9YyVbpZiwJ7c
DoTWD0Nuo7apaDLKFTdR0Z56leed+zNKIdksefCA1kesSBXHCmJybbqprNu0QECv
SoRa5eVdZ6rbtt+C8FfCDEMxHb13T5td2dYzOoEhK4tZupQ9sdgGu2MDe5v8uyVi
Tmex5KMUY9KloXxGmf8AgeyreesuAJMQN2BrJshp2BRYpKPxKtu4oH1ZdYiVBJhQ
nteUEoJGWiuka8flX8hrbxdKAKh7biyMNU/c/ceJy/frV652pFa8pzmMAKM5oXF3
f0ERxp7hjew=
=qpRa
-----END PGP SIGNATURE-----

--Sig_/eUrdUSVhcxkt8ZYAjqVpjo.--
