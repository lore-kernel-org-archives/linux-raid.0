From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: Why is sb->size set to 0 with raid0?
Date: Thu, 22 Jul 2010 18:50:54 +0600
Message-ID: <20100722185054.51930d15@natsu>
References: <slrni4e7bi.ced.Mario.Holbe@darkside.dyn.samba-tng.org>
	<20100722153456.04f751e7@notabene>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vduoJ+NHGHGOHXVo1FNAd20"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100722153456.04f751e7@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/vduoJ+NHGHGOHXVo1FNAd20
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Jul 2010 15:34:56 +1000
Neil Brown <neilb@suse.de> wrote:

> For RAID0 (and linear), there is no such number.  The devices can be of
> different sizes and in each case "all" of the available space is used.

That sounds a bit surprising, excuse my ignorance, but how a RAID0 of
differently-sized devices is laid out? Is the "tail" of the larger device
simply used in linear mode, adding space to the striped "heads"?

--=20
With respect,
Roman

--Sig_/vduoJ+NHGHGOHXVo1FNAd20
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxIPq4ACgkQTLKSvz+PZwiZugCfZmB2z98z9Nx2LmG+e0eFLU/9
2FUAn3JdELwKATwxFpJLetEoSzoATGx2
=EHgR
-----END PGP SIGNATURE-----

--Sig_/vduoJ+NHGHGOHXVo1FNAd20--
