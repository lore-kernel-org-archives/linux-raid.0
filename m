From: Nagilum <nagilum@nagilum.org>
Subject: safe mode for grow?
Date: Sun, 27 Jan 2008 11:02:11 +0100
Message-ID: <20080127110211.yu9dgmhe08kc8ksc@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_4ka5ti2ufd6o";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_4ka5ti2ufd6o
Content-Type: text/plain;
	charset=ISO-8859-2;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

After having been through a few ups and downs with md and mdadm I =20
think it would be a good idea if mdadm had a safe mode for growing =20
raid5.
Safe mode would entail several things:
1. It would kick off a resync.
2. It would write to the spare drive to ensure it is ok. (we have to =20
wait for the resync anyway)
3. It would make a backup file mandatory.
4. It would only allow to grow the raid by one device. (because if =20
more than one of the new drives go bad, we have a big problem)

I know it would probably result in a bit of a deviation of the usual =20
mdadm behaviour but I think its worth it.
Kind regards,
Alex.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_4ka5ti2ufd6o
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (FreeBSD)

iEYEABECAAYFAkecVqEACgkQAKWN2UY+sLyTkwCgppGkBK7z55i3HBvHPQcRdY9h
7CcAn2NqZOQfZ4fjnFRCfs0kGGYAf4Xh
=KTix
-----END PGP SIGNATURE-----

--=_4ka5ti2ufd6o--
