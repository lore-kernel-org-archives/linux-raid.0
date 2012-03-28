From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid5:Fix recover/replace stop if handle stipe failed
Date: Wed, 28 Mar 2012 13:14:49 +1100
Message-ID: <20120328131449.2ad9896f@notabene.brown>
References: <201203141507458909278@gmail.com>
	<201203141727412189832@gmail.com>
	<20120327142642.3e40547d@notabene.brown>
	<201203271533149067900@gmail.com>
	<201203280945342813684@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eArN5_KZDIy/KnajmW+b64r"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203280945342813684@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/eArN5_KZDIy/KnajmW+b64r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Mar 2012 09:45:40 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >>However I don't agree that we need to set 'abort =3D 1' in the non-RECO=
VERY
> >>case.
> But the origial code is:
> md_done_sync(conf->mddev, STRIPE_SECTORS, 0)
> This mean you will interrunt the resync.

Correct.  But I now think the original code was wrong - or at least
unnecessary and addition of known-bad-blocks has made it wrong.

Thanks,
NeilBrown


>=20
> ------------------				=20
> majianpeng
> 2012-03-28
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/eArN5_KZDIy/KnajmW+b64r
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3J0GTnsnt1WYoG5AQJzThAAoxTCwMxRBqQ1mRM5UPWohyCxZoFbPgwC
T3WTo3dklR+9Pexf2tiWGfVhTL2p0aK/xHJgIUY2AzlzlwdefvjZLUkHOBPdqWXS
GOBCRHUOQNz0GFr3OGQ8krnxzkQz2HXGk2y+AC0Go5Ly/Lr/uktUdJN7MgqOgAxr
vynxI0/cuaecMeYrQmbHbKwi/IRM0WQJaWsjELOwdstfClXa+Tyu11VXU9KJD1tt
k6OcCREsmrUzdc4fscm4k94XAD7iAgjj/55+fMGOps1ub7q4UeV1bVXnYKrcMckw
58SspTlDpgrnVDJ1jkKduHoBmBxsPbnfPUOef1OGU7Oqo0/RIt9YEVsNmsZVANGb
ca0yTlYdfC/ofbwB3/bIITJuLU+cNJXWNqXwv8E7XEzy80s6PFmC6P8tgnuD+2TL
YWFxJ6uSTnhaK2y3jT1tCJfgVz/XV8qkkPHm9HjscyCmCfvR+rX7YcMY1/lw6jcB
kNzHqv6BaonQLCs3lx0glVdu3i6Wnl1AprRCOlG2rZddJAMJDd6yL2WO4xmy/LZV
T3jdZ6/SSHJSSu3YhYmyj8mTMnVdpg4HGYlJ6Zp2BAcTTdoANFJWOhKIPGNPn/wM
Kr4w39PQ2FoFzisRBdqjF7fihD/4uYFrrmV+M7PXBa/Gf0d50UTcRLx9nmLGBjbU
WjHsve1F4kw=
=UjyF
-----END PGP SIGNATURE-----

--Sig_/eArN5_KZDIy/KnajmW+b64r--
