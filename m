From: Nagilum <nagilum@nagilum.org>
Subject: Re: raid5 reshape/resync
Date: Tue, 11 Dec 2007 22:56:13 +0100
Message-ID: <20071211225613.5tybri2ickcgk0s4@cakebox.homeunix.net>
References: <20071124120209.0t70rfkfswkcww0g@cakebox.homeunix.net>
	<20071125200431.2wbk051yoso4owsk@cakebox.homeunix.net>
	<18254.21183.807123.642613@notabene.brown>
	<20071201154817.5uwtck6ask0ksw8s@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_5dt5qilv2qw4";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071201154817.5uwtck6ask0ksw8s@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_5dt5qilv2qw4
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from nagilum@nagilum.org ---------
     Date: Sat, 01 Dec 2007 15:48:17 +0100
     From: Nagilum <nagilum@nagilum.org>
Reply-To: Nagilum <nagilum@nagilum.org>
  Subject: Re: raid5 reshape/resync
       To: Neil Brown <neilb@suse.de>
       Cc: linux-raid@vger.kernel.org


> I'm not sure how to reorder things so it will be ok again, I'll ponder
> about that while I try to recreate the situation using files and
> losetup.

----- End message from nagilum@nagilum.org -----

Ok, I've recreated the problem in form of a semiautomatic testcase.
All necessary files (plus the old xfs_repair output) are at:
  http://www.nagilum.de/md/

I also added a readme: http://www.nagilum.de/md/readme.txt

After running the test.sh the created xfs filesystem on the raid =20
device is broken and (at last in my case) cannot be mounted anymore.

I hope this will help finding the problem.

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


--=_5dt5qilv2qw4
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHXwd8AKWN2UY+sLwRAl3fAKCstYW9mfWwov6GEbgbNZIjFcmcAgCfT1wq
Bczd0rkoM4nwMnvnZGx9lW8=
=mfSD
-----END PGP SIGNATURE-----

--=_5dt5qilv2qw4--
