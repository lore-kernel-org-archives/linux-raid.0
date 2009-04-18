From: Prakash Punnoor <prakash@punnoor.de>
Subject: Re: Proposal: make RAID6 code optional
Date: Sat, 18 Apr 2009 11:16:57 +0200
Message-ID: <200904181117.03418.prakash@punnoor.de>
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3476140.tpsoIuz6W5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49E98AD2.8060601@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

--nextPart3476140.tpsoIuz6W5
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Samstag 18 April 2009 10:09:54 Michael Tokarev wrote:
> Prakash Punnoor wrote:
> > Hi,
> >
> > as I am using only RAID5 I wonder why the RAID6 code also needs to be
> > built. Here is a rough patch of making RAID6 optional (but depending on
> > raid456) without reording of functions to minimize ifdef scattering.
> > (I also haven't checked yet who needs ASYNC_MEMCPY and ASYNC_XOR...)
> > It would probably be nicer to make RAID4/5 and RAID6 independently
> > selectable of each other. But that requires more refactoring, as I can
> > see.
>
> Hm.  In "old good days" there were 3 independent kernel modules,
> named raid4, raid5 and raid6.  Later on, they got merged into one
> since they share quite alot of the code, and has only a few specific
> parts.  Now you're trying to separate them back somewhat....
>
> What's your goal?  What's the problem you're trying to solve?

Having duplicate code is not good, of course. But unused code is also not=20
good. As I said, I only use RAID5, so I don't need RAID6 support. The RAID6=
=20
support enlarges kernel (the built-in.o in drivers/md grows from 325kb to=20
414kb in my case), making boot time and compile time longer - admittedly no=
t=20
by a big margin. But then again I could argue: Why not put RAID0,1,10,4,5,6=
=20
into one big module? Makes no sense, huh? For me putting 5 and 6 into one=20
monolithic module makes no sense. A proper architecture would be to have so=
me=20
common shared code (in a separate module?), not a monolithic big one.

Regards,

Prakash

--nextPart3476140.tpsoIuz6W5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAknpmo8ACgkQxU2n/+9+t5gAjQCgnarwbnwbhh6vVIjh28N+tm03
k3MAnR1E4A2hO/bO3IOR/+10X9FLWOIY
=sFld
-----END PGP SIGNATURE-----

--nextPart3476140.tpsoIuz6W5--
