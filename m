From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/2] Fixes metadata while migrating from Raid 0 to Raid
 10
Date: Sat, 22 Oct 2011 11:50:19 +1100
Message-ID: <20111022115019.1aa1fc78@notabene.brown>
References: <20111021074643.14969.22068.stgit@gklab-128-192.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CbPxjARNGj4d_uerrsxCdSX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111021074643.14969.22068.stgit@gklab-128-192.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Orlowski <lukasz.orlowski@intel.com>
Cc: dan.j.williams@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CbPxjARNGj4d_uerrsxCdSX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Oct 2011 09:47:29 +0200 Lukasz Orlowski
<lukasz.orlowski@intel.com> wrote:

> The following series fixes metadata updates handling code after migration=
 from Raid 0 to Raid 10:
> Last disk is left as a spare instead of being activated and a missing dis=
k is a
> member of an array instead of being removed. The array status is degraded
> instead of normal.
>=20
> ---
>=20
> Lukasz Orlowski (1):
>       imsm: Moves metadata update code for spare activation to separate f=
unction
>=20
> Lukasz Orlowski (1):
>       imsm: fix: Fixes metadata after migration from Raid 0 to Raid 10
>=20
>=20
>  super-intel.c |  207 +++++++++++++++++++++++++++++++--------------------=
------
>  1 files changed, 114 insertions(+), 93 deletions(-)
>=20

Thanks.
I've applied this with some re-indenting (which suspect you only left that
way to it was easier to see exactly where the changes were).

Thanks,
NeilBrown

--Sig_/CbPxjARNGj4d_uerrsxCdSX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqITSznsnt1WYoG5AQLhUw/+LwehX3UwnWFVrDo8U5lSs9dBR1V4qVTI
yGaO1JQNTwLENF/xqLQbtrP3sFRtbe53ud7Wlf+YgwF2bNtmZ9kSfOh/67CRZ3Mq
SyIxmMchG+QhpiKDamvQEPgfBG7ZQPtRgPwgUjvFq7aKj3QSChN5UWCGzYwxnsP1
e5aXYOJppwX8wldbyYo1ysArEpekBiqKHA+j3SNzMq6fznYW1L/xszoFnFImjlD/
/tQHjHfSfP84fnpJaomgr8OC6/0+1Fjg4GICp7PqkHjBPiibSsODRAVEhWxpGa5+
stnakyIyUvTDUo6q3U4eaE6SnRAMshWzvULCPv5OXrPIHugTS6fw2G734TouzgLf
WhY9JaOXfKl6i/ZejlDjs9TDChy5rziKnqEo6X9MUkOQz/RIzvuE5FN2rumILpK0
i0TlvBJ+7Ztp9mRnraprUaZUSp3GjEh0u1y/MtKfGkJ+w4NIf2yb3mFJMaiPLVWG
wlD6Ch3jyyiJNAf011Z0ERFf4neUqanvihVCZvHSbZWtJcFD+fwsRPl2jLviA8G7
k3TPXqLPeYyObrYYYmhk2tGFYy1bhSkTgzT+nmFx09XiWGs8skV7o8kLlzVbkqOU
N1mr+syYED/8k1yppuv305aBoFhwo7VLlM7lOrOfDMO8drRn77fal+F7JNVFdZgd
l2OJvY3N4Ck=
=pnZl
-----END PGP SIGNATURE-----

--Sig_/CbPxjARNGj4d_uerrsxCdSX--
