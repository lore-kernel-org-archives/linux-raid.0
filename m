From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: mdadm freezes the system
Date: Fri, 11 Jun 2010 00:43:16 +0600
Message-ID: <20100611004316.7d8ad74d@natsu>
References: <20100608145913.187a69ca@natsu>
	<20100608222434.3f0fb637@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/F6+jfYrz=WSttb4ht3cmES6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100608222434.3f0fb637@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/F6+jfYrz=WSttb4ht3cmES6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello.

To provide some updates on my earlier questions (for future generations
googling through the archives).

> So, my question is, does anyone have an idea on what could cause this, and
> what would be the best way to diagnose/fix the lockup problem?  Thanks in
> advance.

Since then I have re-created the original 3-device RAID5, it synced without
lockups. Perhaps I should write them off as some hardware bug, especially
considering that the nForce chipsets aren't exactly known as the gold stand=
ard
of bug-free design.

> So why the same RAID5 to RAID6 conversion started so differently in these=
 two
> cases? And is it even possible to reshape RAID5 to RAID6 while simultaneo=
usly
> adding a disk, without overwriting all the other disks' contents (it sure=
ly
> looked like this is what was happening in the first case)?

Yes it is possible; I should have read about the --layout=3Dpreserve option=
 in
the mdadm man page.

--=20
With respect,
Roman

--Sig_/F6+jfYrz=WSttb4ht3cmES6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwRMkYACgkQTLKSvz+PZwj6DwCgjroKe55/EaYEtciKvef4Z5ox
GjMAoJNumq8u98YzBha90dlAFmVIEeco
=RxsS
-----END PGP SIGNATURE-----

--Sig_/F6+jfYrz=WSttb4ht3cmES6--
