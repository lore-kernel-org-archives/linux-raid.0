From: Roman Mamedov <rm@romanrm.net>
Subject: Re: mdstat reporting (superblock & status side-by-side). Can it be
 changed ?
Date: Sun, 13 Sep 2015 23:09:27 +0500
Message-ID: <20150913230927.15cfa36a@natsu>
References: <55F5B941.8050107@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oAfowAUxWOj8zSrpByyZr3P"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55F5B941.8050107@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/oAfowAUxWOj8zSrpByyZr3P
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 13 Sep 2015 12:58:25 -0500
"David C. Rankin" <drankinatty@suddenlinkmail.com> wrote:

>    After looking at the output of /proc/mdstat many times, there is one '=
human=20
> factors' (human nature) bit of difficulty with the order of the output=20
> (especially with a standard 2-disk raid1 array and 1.2 superblock:
>=20
> md1 : active raid1 sda7[2] sdb7[1]
>        52396032 blocks super 1.2 [2/2] [UU]
>                              ^^^^^^^^^
>=20
>    When scanning the information quickly to insure you do NOT have 1/2 di=
sks=20
> active in the array, you run into the version and disk information side-b=
y-side.
>=20
>    "1.2 [2/2]"
>=20
>    Which naturally causes a short "huh?..., OK" double-take.

For me it does not. 1.2 is clearly different from 1/2, and the actual 2/2
that you have is even enclosed in brackets to stand out more prominently.

>    Is there any way from a user standpoint (short of "read a b c d e f"; =
echo=20
> "$c $d $a $b $e $f"), to rearrange the order the information is reported =
as:
>=20
> md1 : active raid1 sda7[2] sdb7[1]
>        super 1.2 52396032 blocks [2/2] [UU]
>=20
>    That simple change makes glancing down the right-side of the informati=
on much=20
> easier on the brain....

If you want to simplify the mental processing, just look for any "_"s in the
string of "U"s which is also conveniently placed at the end of the line. In=
 a
partially down RAID1 you'd have [U_] or [_U] there, which is very noticeable
compared to the usual [UU].

>    I don't think this was ever a concern prior to the 1.2 superbock and I=
'm not=20
> sure it warrants any brainpower now. However, it was something that stood=
 out to=20
> me, so I thought I would pass it along.

I don't think it's justified to randomly change things around which many sh=
ell
scripts and the like are quite likely to depend on, just out of a personal
preference.

--=20
With respect,
Roman

--Sig_/oAfowAUxWOj8zSrpByyZr3P
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlX1u9cACgkQTLKSvz+PZwiEdQCeJnDtXKmbH9bb3mlt/3x+SHv/
AV8AoISTl/36Y/lnAtgn/3ZLFaLnkhn2
=ufYA
-----END PGP SIGNATURE-----

--Sig_/oAfowAUxWOj8zSrpByyZr3P--
