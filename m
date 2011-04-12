From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Growing 6 HDD RAID5 to 7 HDD RAID5
Date: Tue, 12 Apr 2011 23:14:01 +0600
Message-ID: <20110412231401.5bb9065c@natsu>
References: <BANLkTi=yZkM464MbvEgAjEWPGrR+eieXCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uK_39il30GlX2G6T.fvMYWv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=yZkM464MbvEgAjEWPGrR+eieXCg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/uK_39il30GlX2G6T.fvMYWv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Apr 2011 17:56:05 +0100
Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:

> I'm approaching over 6.5TB of data, and with an array this large I'd
> like to migrate to RAID6 for a bit more safety.

That's a great decision (and I suppose you made a typo in the subject).
RAID5 is downright dangerous at that disk count, and with disks of that siz=
e.

> I'm just checking if I
> understand this correctly, this is how to do it:
>=20
> * Add a HDD to the array as a hot spare:
> mdadm --manage /dev/md0 --add /dev/sdh1
>=20
> * Migrate the array to RAID6:
> mdadm --grow /dev/md0 --raid-devices 7 --level 6

Looks correct to me...

The first command can be just "mdadm --add /dev/md0 /dev/sdh1".

If you'd rather avoid a reshape at this point, you can add
"--layout=3Dpreserve" to the second line. That way you will have just a reb=
uild
of the new drive, instead of a full reshape.

You will also need to "--grow --bitmap=3Dnone" first (you can re-add the bi=
tmap
later).

--=20
With respect,
Roman

--Sig_/uK_39il30GlX2G6T.fvMYWv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2kiFkACgkQTLKSvz+PZwjLGgCfXxmTsFm+jGZ1D/5XmysMq4rN
ifkAmgK8Iue40ikcLz+UfFX4ve+Qy9p0
=E1v7
-----END PGP SIGNATURE-----

--Sig_/uK_39il30GlX2G6T.fvMYWv--
