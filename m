From: Roman Mamedov <rm@romanrm.ru>
Subject: Fw: RAID6 data-check took almost 2 hours, clicking sounds, system
 unresponsive
Date: Thu, 14 Apr 2011 11:15:24 +0600
Message-ID: <20110414111524.092a47df@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7LKL.1n4FMVpXaMMn3NaQ.f"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/7LKL.1n4FMVpXaMMn3NaQ.f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

@Gavin
Please learn to use your mail client properly, don't drop all CC: when
replying!!


Begin forwarded message:

Date: Wed, 13 Apr 2011 21:39:04 -0700 (PDT)
From: Gavin Flower <gavinflower@yahoo.com>
To: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system
unresponsive



--- On Thu, 14/4/11, Roman Mamedov <rm@romanrm.ru> wrote:

> From: Roman Mamedov <rm@romanrm.ru>
> Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system
> unresponsive To: "Gavin Flower" <gavinflower@yahoo.com>
> Cc: "Mathias Bur=C3=A9n" <mathias.buren@gmail.com>, neilb@suse.de,
> linux-raid@vger.kernel.org Date: Thursday, 14 April, 2011, 16:08
> On Wed, 13 Apr 2011 17:15:42 -0700
> (PDT)
> Gavin Flower <gavinflower@yahoo.com>
> wrote:
>=20
> > Note that smart reports no bad blocks.
>=20
> It reports 24 bad blocks:
>=20
> 183 Runtime_Bad_Block=C2=A0 =C2=A0
> =C2=A0=C2=A0=C2=A00x0032=C2=A0=C2=A0=C2=A0076=C2=A0=C2=A0=C2=A0076=C2=A0=
=C2=A0=C2=A0000=C2=A0
> =C2=A0 Old_age=C2=A0=C2=A0=C2=A0Always
> -=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A024

Hmm... I am so used to just looking at item #5 (which I had thought, was the
bad block count!):

5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always
-       0

>=20
> Try running a long SMART self test on the drive (smartctl
> -t long /dev/sdX).

Running now.

>=20
> Also for a bit of common sense - why not just try the disk
> on another PC. If it
> produces clicking sounds and "frozen" errors when running
> "badblocks" even
> there, then what else do you expect it to do, jump out of
> the PC and say "i'm
> broken please replace me"? :)

I thought that modern hardware was so smart that the first I should know of
it, is when the cost of the placement disk appeared on my credit card!!!

More seriously... with my eyesight (at about 400 mm from the screen, text
appears a little fuzzy, and that is on a good day), I don't trust myself
changing hardware like that.  I have friends that can do the hardware part,
but I try to do as much investigation myself before I ask them for help.

>=20
> --=20
> With respect,
> Roman
>=20

Hi Mathias,

Comments above.

I was not expecting help from this list on this matter, but it is appreciat=
ed.

The disk used for /dev/sdc was only replaced very recently, and I have a
strong suspicion it is a cable and/or connector problem.  I do have one spa=
re
hard disk I can use, but I had it earmarked to replace the one which is very
near its limit on reallocated sectors.


Thanks,
Gavin



--=20
With respect,
Roman

--Sig_/7LKL.1n4FMVpXaMMn3NaQ.f
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2mguwACgkQTLKSvz+PZwi+ywCeMxkknSEQU/GACXNpWMTwu7uc
UBsAnRCxtp5KVFOn/8EYI9TAUC36Cv47
=zzQy
-----END PGP SIGNATURE-----

--Sig_/7LKL.1n4FMVpXaMMn3NaQ.f--
