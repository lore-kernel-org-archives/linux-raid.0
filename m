From: Alexander =?utf-8?b?S8O8aG4=?= <alexander.kuehn@nagilum.de>
Subject: Re: RAID5 to RAID6 reshape?
Date: Wed, 20 Feb 2008 07:39:15 +0100
Message-ID: <20080220073915.a1f3s54ua8ckk8gk@cakebox.homeunix.net>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
	<18360.8065.335494.142060@tree.ty.sabi.co.UK>
	<20080217074526.29d3c5c5@hardcode42.net>
	<18361.55006.23018.546040@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_6wrzaunwvrwg";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18361.55006.23018.546040@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.to.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_6wrzaunwvrwg
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from pg_lxra@lxra.to.sabi.co.UK ---------
     Date: Mon, 18 Feb 2008 19:05:02 +0000
     From: Peter Grandi <pg_lxra@lxra.to.sabi.co.UK>
Reply-To: Peter Grandi <pg_lxra@lxra.to.sabi.co.UK>
  Subject: Re: RAID5 to RAID6 reshape?
       To: Linux RAID <linux-raid@vger.kernel.org>


>>>> On Sun, 17 Feb 2008 07:45:26 -0700, "Conway S. Smith"
>>>> <beolach@gmail.com> said:

> Consider for example the answers to these questions:
>
> * Suppose you have a 2+1 array which is full. Now you add a disk
>   and that means that almost all free space is on a single disk.
>   The MD subsystem has two options as to where to add that lump
>   of space, consider why neither is very pleasant.

No, only one, at the end of the md device and the "free space" will be =20
evenly distributed among the drives.

> * How fast is doing unaligned writes with a 13+1 or a 12+2
>   stripe? How often is that going to happen, especially on an
>   array that started as a 2+1?

They are all the same speed with raid5 no matter what you started =20
with. You read two blocks and you write two blocks. (not even chunks =20
mind you)

> * How long does it take to rebuild parity with a 13+1 array or a
>   12+2 array in case of s single disk failure? What happens if a
>   disk fails during rebuild?

Depends on how much data the controllers can push. But at least with =20
my hpt2320 the limiting factor is the disk speed and that doesn't =20
change whether I have 2 disks or 12.

> * When you have 13 drives and you add the 14th, how long does
>   that take? What happens if a disk fails during rebuild??

..again pretty much the same as adding a fourth drive to a three-drives raid=
5.
It will continue to be degraded..nothing special.

> beolach> Well, I was reading that LVM2 had a 20%-50% performance
> beolach> penalty, which in my mind is a really big penalty. But I
> beolach> think those numbers where from some time ago, has the
> beolach> situation improved?
>
> LVM2 relies on DM, which is not much slower than say 'loop', so
> it is almost insignificant for most people.

I agree.

> But even if the overhead may be very very low, DM/LVM2/EVMS seem
> to me to have very limited usefulness (e.g. Oracle tablespaces,
> and there are contrary opinions as to that too). In your stated
> applications it is hard to see why you'd want to split your
> arrays into very many block devices or why you'd want to resize
> them.

I think the idea is to be able to have more than just one device to =20
put a filesystem on. For example a / filesystem, swap and maybe =20
something like /storage comes to mind. Yes, one could to that with =20
partitioning but lvm was made for this so why not use it.

The situation looks different with Raid6, there the write penalty =20
becomes higher with more disks but not with raid5.
Regards,
Alex.

----- End message from pg_lxra@lxra.to.sabi.co.UK -----




- --
Alexander Kuehn

Cell phone: +49 (0)177 6461165
Cell fax:   +49 (0)177 6468001
Tel @Home:  +49 (0)711 6336140
Mail mailto:Alexander.Kuehn@nagilum.de


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_6wrzaunwvrwg
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (FreeBSD)

iEYEABECAAYFAke7yxIACgkQAKWN2UY+sLzmHQCgmVYG4I0Wt0ziQbOxgnHdUFL0
FmgAoJiCOsQgH3SVo9TnT6R830fhAeqN
=kO2v
-----END PGP SIGNATURE-----

--=_6wrzaunwvrwg--
