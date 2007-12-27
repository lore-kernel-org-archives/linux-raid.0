From: Nagilum <nagilum@nagilum.org>
Subject: Re: raid5 grow reshaping speed is unchangeable
Date: Thu, 27 Dec 2007 23:10:18 +0100
Message-ID: <20071227231018.vu20e31q80c80sw8@cakebox.homeunix.net>
References: <380-220071242752242883@mochamail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_38liqkydwk6c";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <380-220071242752242883@mochamail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Cody Yellan <cody@mochamail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_38liqkydwk6c
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from cody@mochamail.com ---------
     Date: Wed, 26 Dec 2007 21:22:42 -0800
     From: Cody Yellan <cody@mochamail.com>

> I had a 4x500GB SATA2 array, md0.  I added one 500GB drive and
> reshaping began at ~2500K/sec.  Changing
> /proc/sys/dev/raid/speed_limit_m{in,ax} or
> /sys/block/md0/md/sync_speed_m{in,ax} had no effect.  I shut down all
> unnecessary services and the array is offline (not mounted).  I have
> read that the throttling code is "fragile" (esp. with regard to
> raid5) but does this make sense?  I will wait (in)patiently for it to
> finish, but I do wonder why the configuration parameters have no
> effect.  This is a dual quad 2GHz Xeon machine with 8GB of memory
> running RHEL5.  Is this the maximum speed?
----- End message from cody@mochamail.com -----

Certainly not. I've personally used a similar setup with >80MB/s =20
reshape speeds.
There must be some other limiting factor.
Try simultanous dd's from the drives, if that doesn't work as fast as =20
it should there might be some bus contention?


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


--=_38liqkydwk6c
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHdCLJAKWN2UY+sLwRAo29AJ0U0rJUsLJBKbsDDO0k3bT3ZrZPlACfYiMA
Q3UXaEtShM3I8EPLz5u8o8w=
=XzvV
-----END PGP SIGNATURE-----

--=_38liqkydwk6c--
