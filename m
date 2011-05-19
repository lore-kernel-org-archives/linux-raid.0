From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: HBA Adaptor advice
Date: Thu, 19 May 2011 18:36:08 +0600
Message-ID: <20110519183608.2c377538@natsu>
References: <4DD50C89.8060006@wildgooses.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cwM8rX_rfrMCiIU8W0g2DuP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD50C89.8060006@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/cwM8rX_rfrMCiIU8W0g2DuP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 May 2011 13:26:49 +0100
Ed W <lists@wildgooses.com> wrote:

> Hi, following on from a recent thread, can folks with decent multi-port
> HBA adaptors please chime in with some model numbers of known decent
> adaptors please?

Here is a useful link for you: http://blog.zorinaq.com/?e=3D10

> And to avoid:
> - Marvel controllers?

There are two kinds (families?) of Marvell SATA chips, and those using the
"sata_mv" module do work fine. It seems like all the complaints are directed
at the other kind, supported via "mvsas".

--=20
With respect,
Roman

--Sig_/cwM8rX_rfrMCiIU8W0g2DuP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEUEARECAAYFAk3VDrgACgkQTLKSvz+PZwgCnwCWPyIFRnUA/frlyVZCWsF6Rb2f
4gCeMyYexnmAUx0pwljCJDUaUb4Wl04=
=v5dy
-----END PGP SIGNATURE-----

--Sig_/cwM8rX_rfrMCiIU8W0g2DuP--
