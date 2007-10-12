From: Nagilum <nagilum@nagilum.org>
Subject: Re: RAID6 recover problem
Date: Fri, 12 Oct 2007 17:51:39 +0200
Message-ID: <20071012175139.o7gz7ka934s0s0gw@cakebox.homeunix.net>
References: <8F1D6256-0F63-4B79-8D66-87EFB96DFD6A@bj-ig.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_3bk48goyy08w";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8F1D6256-0F63-4B79-8D66-87EFB96DFD6A@bj-ig.de>
Sender: linux-raid-owner@vger.kernel.org
To: Ralf =?utf-8?b?TcO8bGxlcg==?= <ralf@bj-ig.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_3bk48goyy08w
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

You may be able to temporary revive one of your dead disks by putting =20
them in a fridge (properly wrapped and protected against condensation =20
water!!, search the net on how to do that).
Then you can mark them as bad and linux will sync to a spare.
As for your sdc, I'd test it outside of the raid (dd if=3D/dev/sdc =20
of=3D/dev/null) to see if this is a real defect or 'just' a checksum =20
error.
Then you might also try the fridge (if it's a real defect) or just =20
ignore the error.
I think there is a special "dd" version which will not abort on a read =20
error. With that you could also clone that drive (except the failing =20
sectors ofcourse).
I hope that helps.

----- Message from ralf@bj-ig.de ---------
     Date: Fri, 12 Oct 2007 16:42:07 +0200
     From: Ralf M=C3=BCller <ralf@bj-ig.de>
Reply-To: Ralf M=C3=BCller <ralf@bj-ig.de>
  Subject: RAID6 recover problem
       To: linux-raid@vger.kernel.org


> I have a 10 disk raid6 with internal write intent bitmap here
> (softraid, build and managed via mdadm). For whatever reason one of the
> 3 promise SATA 300 TX controllers went offline and took 4 of these 10
> disks with it. After reboot the array was assembled with 8 out of 10
> disks - sda2 and sdb2 missing. When I tried to re-add sda2 sdc - which
> is one of the "active" disks - reported a read error on sector 54631.
> Ok - seems I have a problem.
>
> I stopped all activities at this point to ask here what I can do to
> reassemble the array with a minimum loss of data.
>
> Except the offline disks sda2 and sdb2 all other disks report 19 dirty
> chunks (mdadm -X). The offline disks report 7 dirty chunks.
>
> If one needs any further data - just ask.
>
> Hoping for assistance
> Ralf M=C3=BCller
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


----- End message from ralf@bj-ig.de -----



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


--=_3bk48goyy08w
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHD5gKAKWN2UY+sLwRAgHNAJ9HfTbKmmCQXDJId73lEaQ/aJfHegCfVtwk
ZGEsKkhpN83xl7m7Iyp09ME=
=5u6e
-----END PGP SIGNATURE-----

--=_3bk48goyy08w--
