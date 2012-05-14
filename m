From: NeilBrown <neilb@suse.de>
Subject: Re: Failed, but "md: cannot remove active disk..."
Date: Mon, 14 May 2012 21:36:23 +1000
Message-ID: <20120514213623.3bc1bfa5@notabene.brown>
References: <1336933308.2831.4.camel@localhost>
	<20120514202220.5a164eb0@notabene.brown>
	<1336992780.6722.18.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/85WfT8UiH1xwptO9uWgYxXl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1336992780.6722.18.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/85WfT8UiH1xwptO9uWgYxXl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 14 May 2012 12:53:00 +0200 Micha=C5=82 Sawicz <michal@sawicz.net> w=
rote:

> Dnia 2012-05-14, pon o godzinie 20:22 +1000, NeilBrown pisze:
> > On Sun, 13 May 2012 20:21:48 +0200 Micha=C5=82 Sawicz <michal@sawicz.ne=
t> wrote:
> >=20
> > > Hey,
> > >=20
> > > I've a weird issue with a RAID6 setup, /proc/mdstat says:
> > >=20
> > > > md126 : active raid6 sda1[3] sdh1[6] sdg1[0](F) sdf1[5] sdi1[1] sdc=
[8] sdb[7]
> > > >       9767559680 blocks super 1.2 level 6, 512k chunk, algorithm 2 =
[7/6] [_UUUUUU]
> > >=20
> > > So sdg1 is (F)ailed, yet `mdadm --remove` yields:
> > >=20
> > > > md: cannot remove active disk sdg1 from md126 ...
> >=20
> > There is a period of time between when a device fails and when the raid=
456
> > module finally lets go of it so it can be removed.  You seem to be in t=
his
> > period of time.
> > Normally it is very short.  It needs to wait for any requests that have
> > already been sent to the device to complete (probably with failure) and
> > very shortly after that it should be released.  So this is normally muc=
h less
> > than one second but could be several seconds is some excessive retry is
> > happening.
> >=20
> > But I'm guessing you have waited more than a few seconds.
>=20
> Yup :)
>=20
> > I vaguely recall a bug in the not too distant past whereby RAID456 woul=
dn't
> > let go of a device quite as soon as it should.  Unfortunately I don't
> > remember the details.  You might be able to trigger it to release the d=
rive
> > by adding a spare - if you have one - or maybe by just
> >   echo sync > /sys/block/md126/md/sync_action
> > it won't actually do a sync, but it might check things enough to make
> > progress.
>=20
> # echo sync > /sys/block/md126/md/sync_action
> -bash: echo: write error: Device or resource busy

Hmmm....

Looks like MD_RECOVERY_NEEDED is already set.
But remove_and_add_spares() isn't removing the failed device
from the array.

I cannot find anything since 2.6.38 that looks like your symptoms.

Is the array still functioning?
Are there any interesting messages appearing in the kernel logs?

What does
  grep . /sys/block/md126/md/dev*/*
show?

NeilBrown


>=20
> eh?
>=20
> > What kernel are you using?
>=20
> # uname -a
> Linux media 2.6.38-gentoo-r6 #2 SMP Tue Sep 13 19:13:42 CEST 2011 x86_64
> AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD GNU/Linux
>=20
> Thanks,


--Sig_/85WfT8UiH1xwptO9uWgYxXl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7DuNznsnt1WYoG5AQK2xw//bLiIdIGWHE8XQox1lcWva8olIuxjuW6q
4LZhsNjl4VpOuu2rWfjrN9/5flBRgbl2k0VWEHVIx6bVFBV6fdKlUa5TP3KMInGr
mYPukVD2zzerYh8bqGOL4N12pPKLgjF5DVSdpptRyrejgaZRQLlSJryJeHsFPsI4
90E17iUgWcJtjv0Zatmsm+iiCjyHO0pkHAKjLxcjEbHCiBfEWS59uocFEQgBexZ7
I9WUY5zvSSPf5N4fi9yeFr+F8qE4eH+UY1/zuX2V7hZAh9i39omVb8UBAgBH5Zr3
ENxpUST5VgOH0S1owOM4gBDByzzqDggjFMsIW/vBKf75EFDYIWzegeGVFTAb6QHH
EfpJGzcuvoRrXDlFjH8VJGh8sEvieY+5bERAcxw28jNLPd7RzdP9cxNGvGDHLe52
0mDfbWtXvjC3+qBI+WFEFmXW0XLnJKudJ77N9Iq80SfAfoi7LLAoAF1SQNGtKQXA
XMKYXNjqqsOqyFUFY7lIW3H4H37zlJ1UYeamSiuJtQ/aqZhf9Cdiohf895SRP5Bz
vnef5YnPK93cTXfbUQysAbaqKMF8uRClUx8h16L4X5BtM9zV+/tDL0NsaSlUk1A+
2FRD3TgV1e2Xg3OwEo0/Fxr1euRBCGTYH3s/oghzTtMBTsD+q10VFdLTC2P3Zkus
lQOfuzLVPk8=
=efj6
-----END PGP SIGNATURE-----

--Sig_/85WfT8UiH1xwptO9uWgYxXl--
