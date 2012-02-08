From: NeilBrown <neilb@suse.de>
Subject: Re: imsm raid is always readonly on boot
Date: Wed, 8 Feb 2012 19:45:02 +1100
Message-ID: <20120208194502.05a9f7c6@notabene.brown>
References: <4F3111D9.2060303@profihost.ag>
	<20120208125729.5674f35d@notabene.brown>
	<4F3232B2.6010605@profihost.ag>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/G++qCv53w7cAXD7XeuM16AF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3232B2.6010605@profihost.ag>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/G++qCv53w7cAXD7XeuM16AF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 08 Feb 2012 09:30:42 +0100 Stefan Priebe - Profihost AG
<s.priebe@profihost.ag> wrote:

> Hi Neil,
>=20
> Am 08.02.2012 02:57, schrieb NeilBrown:
> > Probably mdmon isn't running for some reason.
> >=20
> > For these arrays the metadata is managed in user-space by mdmon.
> > Until it is ready to record failures the array must remain readonly.
> > On of the first things it does is switch the array to read-write, having
> > arranged to catch any failure notifications.
> >=20
> > If you=20
> >=20
> >  mdmon --all --takeover
> >=20
> > it might just start working.  However that doesn't explain why mdmon wa=
sn't
> > started at boot.  mdadm is meant to start it.
> > There are some concerns about mdmon starting this way being not "the ri=
ght
> > thing" from a systemd perspective and there might be some issues there =
that
> > are causing problems.
>=20
> You're correct the mdmon does not run as the root filesystem is readonly
> and it cannot create a pid file... and the root filesystem stays
> readonly as the mdmon is not running...

It should be configured to create it in a writable filesystem,
maybe /dev/.something or /var/run/something.

If it is configured to create it somewhere that isn't writeable when mdadm =
is
run, then that is a system integration error.

(not entirely surprising as we seem to keep changing our mind as to where
this stuff should go - I think /run is the flavour of the month).

NeilBrown

--Sig_/G++qCv53w7cAXD7XeuM16AF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzI2Djnsnt1WYoG5AQJRgw/8DLmtUDbtTvaEEvlV51WLPlDKuCOlE38Y
Ew3If0vOwH30aJ092pHowV2ScOr3jRh2B3z5HBJ843OIl2kuz0KlRzfcjM0WlSWT
fk5JAMrp38kYvIfKahdO0RxTF2esmjSJ/1yRo3E1/vM7ILUWSg98Juenedik++Zr
k+ohYX7EPsBI7MlTSxSSasHhqRtF2/dTYggG+e8VimSsx9h9ij6oMy4OJbWMaSOf
wG2jm/rzdPgR9UdZAkUflaiTue1zayYQZUNsSvTxY/7oEwqgo1fldZGDN9k0HjWl
JsfenIB44ix42G4r6nsuHnUGfQVsI70xaGFyPQMZ+DvAF5VIzHQ2VZRAwQgF6g5k
HMz7vbgLoqlRCpTOuFRnNUIrF44vIGmCAJew8ZOPAtyj15mhJl0kzkzQFcTGKfVe
1Dkahaa/5oPHkkzXk2uRs7P6tMLiN7fGSPoPfDVw/rQK6oyJTyf6+BzuLUEi2NX2
O6ls6PRIx8KK6DFY6W/u0Xg5K00E9gdpmQufQR459a+514stT+eI4VD+5YHu2H5R
3AbbtHk0X7nEFuobkJAmS0yeF0zcErLQjFsZqRtzi3BWzjJJQJ+QjZIzgkMIEXNV
mIfBLGMzYn2o3501c3kqfJz9+85P3KYtWCFMcAWmaRECI0/7Ns87S3h1hDLYYDkZ
3wEoyaVNP+g=
=UI7Q
-----END PGP SIGNATURE-----

--Sig_/G++qCv53w7cAXD7XeuM16AF--
