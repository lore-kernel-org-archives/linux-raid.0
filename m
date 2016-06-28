From: Roman Mamedov <rm@romanrm.net>
Subject: Re: RAID 10 / 2 Devices Layout question
Date: Tue, 28 Jun 2016 14:25:02 +0500
Message-ID: <20160628142502.7e69983d@natsu>
References: <CA+3OdkMoF7jZNwsNR282Hvq4qwsKUuPtXaXrKXNUPq_4YD6BDw@mail.gmail.com>
 <5770120D.9050809@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/2RLjwLt4GpyzOjXebTg5Aq4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5770120D.9050809@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Paul Roland <paulrolandw@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2RLjwLt4GpyzOjXebTg5Aq4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 26 Jun 2016 13:34:05 -0400
Phil Turmel <philip@turmel.org> wrote:

> On 06/26/2016 01:20 PM, Paul Roland wrote:
>=20
> > I have two SSDs, and I would like to use md/raid10 (2devices) for
> > performance reasons.
>=20
> Ok, that's reasonable.

Maybe I'm missing something, but how is a RAID10 of just two devices is
considered reasonable without any questions or explanation? What is the act=
ual
layout that is expected here, and what benefits (or even differences) does =
it
have compared to RAID0? I thought you need at least 3 devices (and h/w RAID
controllers might even require 4) for RAID10 to start making sense.

--=20
With respect,
Roman

--Sig_/2RLjwLt4GpyzOjXebTg5Aq4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAldyQnAACgkQTLKSvz+PZwgqSgCfW5kyJZd/99tIuyjH5Ks9RID4
EMEAnAheFlb9NIfd5JhyiGVBI40wece+
=xpQL
-----END PGP SIGNATURE-----

--Sig_/2RLjwLt4GpyzOjXebTg5Aq4--
