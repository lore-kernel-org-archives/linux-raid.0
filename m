From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Installing Linux directly onto RAID6 Array...........
Date: Tue, 12 May 2015 18:42:45 +0500
Message-ID: <20150512184245.10181656@natsu>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com>
	<5551D3F2.8020007@grumpydevil.homelinux.org>
	<5551F01A.4050705@turmel.org>
	<20150512173147.0d2c3363@natsu>
	<CAOS+5GHhUoYxTTYOWU7cdN6GSdffSMGrhWHU5ZtWEjc4jEm3eg@mail.gmail.com>
	<CAOS+5GE1DTzuARuPPRMvhzB46Ka5snF+MZqyM_tbLH7uY9_VuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AYQZiZIhrcYtQNLoQtW1cu4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GE1DTzuARuPPRMvhzB46Ka5snF+MZqyM_tbLH7uY9_VuQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/AYQZiZIhrcYtQNLoQtW1cu4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 12 May 2015 14:12:10 +0100
Another Sillyname <anothersname@googlemail.com> wrote:

> there's an interesting idea in there of effectively installing the
> bootloader onto every drive in the array......

Oh, sure you can install GRUB2 to every drive and also create a 6-member RA=
ID1
with metadata version 0.90 from first partition of each drive (256 MB is
enough) for /boot. That's another way of "booting from the same set drives =
as
the main storage". I do that on another machine :)

--=20
With respect,
Roman

--Sig_/AYQZiZIhrcYtQNLoQtW1cu4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlVSA1UACgkQTLKSvz+PZwhsSQCfXpfSekYkrtDbgSbQ6PBykmf8
hYMAmgK8p0GB5d/lBSZSdhxHOBcerj1p
=Ju0S
-----END PGP SIGNATURE-----

--Sig_/AYQZiZIhrcYtQNLoQtW1cu4--
