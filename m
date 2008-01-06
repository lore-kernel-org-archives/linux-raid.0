From: Nagilum <nagilum@nagilum.org>
Subject: Re: Raid 1, can't get the second disk added back in.
Date: Sun, 06 Jan 2008 17:31:06 +0100
Message-ID: <20080106173106.x7wngh3ccgwwsk00@cakebox.homeunix.net>
References: <477FAAAC.2090107@fayettedigital.com>
	<20080105210002.t5syxhjahwocks4g@cakebox.homeunix.net>
	<4780B7C2.3030909@fayettedigital.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_1o6dvee9tbvo";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4780B7C2.3030909@fayettedigital.com>
Sender: linux-raid-owner@vger.kernel.org
To: jim@fayettedigital.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_1o6dvee9tbvo
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

----- Message from jim@fayettedigital.com ---------
     Date: Sun, 06 Jan 2008 06:13:06 -0500
     From: Jim <jim@fayettedigital.com>

> root@chinaberry:~# mdadm  /dev/md0 --re-add /dev/hdb5
> mdadm: Cannot open /dev/hdb5: Device or resource busy

Have you tried stopping (-S) /dev/md0 and then re-assemble the array (-A)?


========================================================================
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
========================================================================


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_1o6dvee9tbvo
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHgQJJAKWN2UY+sLwRAn50AKC73pxks3IgQHk1FG7OlQHbJfZQYgCfWu/g
sF/zIDioGim5O+HoxxVrJe4=
=t6v3
-----END PGP SIGNATURE-----

--=_1o6dvee9tbvo--
