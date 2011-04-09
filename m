From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Couple of questions.
Date: Sun, 10 Apr 2011 05:17:28 +0600
Message-ID: <20110410051728.59d61e1a@natsu>
References: <4DA08600.5020604@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.Jbxa4FXAZ0GDdJsHFfGBFV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA08600.5020604@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.Jbxa4FXAZ0GDdJsHFfGBFV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Apr 2011 00:14:56 +0800
Brad Campbell <lists2009@fnarfbargle.com> wrote:

> 2 - If a drive disappears how do I remove it from an array.
>   Let's say I have a 10 drive RAID-6 that has an odd error on a disk.=20
> The disk goes away (sdl), the disk comes back as sdq as md is still=20
> hanging on to the name sdl. I add sdq to the array, but I can't remove=20
> sdl as it physically no longer exists. udev has removed the device node=20
> and mdadm can't remove it from the array as it can't tell what it was.

Hello,

See man mdadm and search for "detached". Just noticed that today while look=
ing
for something else.

--=20
With respect,
Roman

--Sig_/.Jbxa4FXAZ0GDdJsHFfGBFV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2g6QgACgkQTLKSvz+PZwgYsQCeKxR1ts6EyhLWDrwObbOjOBKd
vlgAn2HUbgD4OA4jl98itvNaBgk6k8Rr
=aQYR
-----END PGP SIGNATURE-----

--Sig_/.Jbxa4FXAZ0GDdJsHFfGBFV--
