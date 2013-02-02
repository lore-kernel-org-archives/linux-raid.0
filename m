From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: raid1 read balance with write mostly
Date: Sun, 3 Feb 2013 04:07:58 +0600
Message-ID: <20130203040758.5e2e7f3c@natsu>
References: <36edd03089332985af9a97eeaf719cd3@mail1.volny.cz>
	<510D8A8C.5090505@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Kzv4wA3ji5o9eF+nGCQ2zwD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <510D8A8C.5090505@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: tomas.hodek@volny.cz, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Kzv4wA3ji5o9eF+nGCQ2zwD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 02 Feb 2013 15:52:12 -0600
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> So under heavy read load, in this case we'd probably want the slow 3TB dr=
ive
> to contribute to the workload.

No, it should behave as documented.

       -W, --write-mostly
              subsequent devices listed in a --build, --create, or --add  c=
om=E2=80=90
              mand will be flagged as 'write-mostly'.  This is valid for RA=
ID1
              only and means that the 'md'  driver  will  avoid  reading  f=
rom
              these devices if at all possible.=20

if at all possible =3D if there is any other mirror still alive, do not rea=
d from
this one.

BTW I also run an SSD+HDD array, and after a brief testing today I did noti=
ce
some reads from the HDD on reading from the array showing up in iostat. So I
can confirm the bug.

--=20
With respect,
Roman

--Sig_/Kzv4wA3ji5o9eF+nGCQ2zwD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlENjj4ACgkQTLKSvz+PZwgrsACePNLAyBW/J8V0mQZYMm22nElH
nYIAnA3ql32kN0R3DQrHyctFQdyzN+OE
=lBgX
-----END PGP SIGNATURE-----

--Sig_/Kzv4wA3ji5o9eF+nGCQ2zwD--
