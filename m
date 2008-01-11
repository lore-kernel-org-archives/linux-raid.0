From: Nagilum <nagilum@nagilum.org>
Subject: Re: The effects of multiple layers of block drivers
Date: Fri, 11 Jan 2008 09:38:58 +0100
Message-ID: <20080111093858.gu8fy501c880kogw@cakebox.homeunix.net>
References: <4786A329.90702@2inches.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_6qr30z5wxnwo";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4786A329.90702@2inches.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dennison Williams <evoltech@2inches.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_6qr30z5wxnwo
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from evoltech@2inches.com ---------
     Date: Thu, 10 Jan 2008 14:58:49 -0800
     From: Dennison Williams <evoltech@2inches.com>
Reply-To: Dennison Williams <evoltech@2inches.com>
  Subject: The effects of multiple layers of block drivers
       To: linux-raid@vger.kernel.org


> Hello,
>
> I am starting to dig into the Block subsystem to try and uncover the
> reason for some data I lost recently.  My situation is that I have
> multiple block drivers on top of each other and am wondering how the
> effectss of a raid 5 rebuild would affect the block devices above it.
>
> The layers are raid 5 -> lvm -> cryptoloop.  It seems that after the
> raid 5 device was rebuilt by adding in a new disk, that the cryptoloop
> doesn't have a valid ext3 partition on it.
>
> As a raid device re-builds is there ant rearranging of sectors or
> corresponding blocks that would effect another block device on top of it?
>
> Sincerely,
> Dennison Williams

----- End message from evoltech@2inches.com -----

If you add a disk and do a reshape the layer on top of the raid5 =20
should only notice that the device is larger now. But yes, there is a =20
rearranging of sectors going on. However this is transparent to layers =20
on top.
Did you have a disk failure during the reshape? If yes you probably =20
have been bitten by the same bug as me: =20
(http://marc.info/?l=3Dlinux-raid&m=3D119910305111460&w=3D2).
Kind regards,

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


--=_6qr30z5wxnwo
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHhyshAKWN2UY+sLwRAowIAJ0X+f4gjgYxeWk5dW5u9Q+Pk7ztDwCdEF79
D1hPLM6FG+GWP3WzAkN1M+g=
=TiYc
-----END PGP SIGNATURE-----

--=_6qr30z5wxnwo--
