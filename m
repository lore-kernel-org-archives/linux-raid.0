From: NeilBrown <neilb@suse.de>
Subject: Re: How to free devices held captive by failed arrays
Date: Sat, 22 Oct 2011 10:04:57 +1100
Message-ID: <20111022100457.0f5133f3@notabene.brown>
References: <20111021202736.GA10682@moo.nac.uci.edu>
	<20111022094156.1a2c42ae@notabene.brown>
	<20111021224556.GA11429@moo.nac.uci.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IeOyk9Ae9u8fy+jK/k7f0DW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111021224556.GA11429@moo.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Harry Mangalam <hjm@moo.nac.uci.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/IeOyk9Ae9u8fy+jK/k7f0DW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Oct 2011 15:45:56 -0700 Harry Mangalam <hjm@moo.nac.uci.edu> wro=
te:

> [continues at bottom]
>=20
> On Sat, Oct 22, 2011 at 09:41:56AM +1100, NeilBrown wrote:
> > >=20
> > > In doing some tests with an 8-port Supermicro/Marvell-based SATA cont=
roller
> > > (works fine so far) and some Hitachi 3TB disks, I've run into an odd
> > > problem.  One of the disks failed in burn-in, so the RAID5 went into
> > > degraded mode.  In replacing the failed disk, I managed to bugger it =
up; not
> > > so awful since it's a test rig and I needed to create 2 smaller array=
s for
> > > some testing.=20
> > >=20
> > >=20
> > > In trying to do that, I was able to create the first 4-disk RAID5 fin=
e and
> > > it's now initializing, but the second fails with the following error:
> > >=20
> > >=20
> > > $ mdadm --create  --verbose /dev/md1 --level=3D5 --raid-devices=3D4
> > > /dev/sd[fghi]1
> > > mdadm: layout defaults to left-symmetric
> > > mdadm: layout defaults to left-symmetric
> > > mdadm: chunk size defaults to 512K
> > > mdadm: /dev/sdf1 appears to be part of a raid array:
> > >     level=3Draid5 devices=3D7 ctime=3DFri Sep 30 17:47:19 2011
> > > mdadm: layout defaults to left-symmetric
> > > mdadm: super1.x cannot open /dev/sdg1: Device or resource busy
> > > mdadm: /dev/sdg1 is not suitable for this array.
> > > mdadm: layout defaults to left-symmetric
> > > mdadm: /dev/sdh1 appears to be part of a raid array:
> > >     level=3Draid5 devices=3D7 ctime=3DFri Sep 30 17:47:19 2011
> > > mdadm: layout defaults to left-symmetric
> > > mdadm: create aborted
> > >=20
> > >=20
> > > mdstat implies that one of the disks still belongs to the previous RA=
ID5:
> > >=20
> > >=20
> > > $ cat /proc/mdstat=20
> > > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4]
> > > [raid10]=20
> > > md0 : active raid5 sde1[4] sdd1[2] sdc1[1] sdb1[0]
> > >       6442438656 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4=
/3]
> > > [UUU_]
> > >       [=3D=3D=3D=3D=3D=3D=3D=3D>............]  recovery =3D 40.1% (86=
1382528/2147479552)
> > > finish=3D292.9min speed=3D73167K/sec
> > >      =20
> > > md_d0 : inactive sdg1[5](S)
> > >       2147480704 blocks
> > >       =20
> > > unused devices: <none>
> > >=20
> > >=20
> > >=20
> > >=20
> > > but I can't seem to convince md_d0 to surrender this device.  This be=
havior
> > > survives a reboot.
> > >=20
> > >=20
> > > One wrinkle is that the original RAID was made with the default mdadm=
 from
> > > Ubuntu 10.04.3 (2.6.7.1) and the smaller RAID5 above was created with=
 the
> > > latest mdadm (v3.2.2). =20
> > >=20
> > >=20
> > > What do I have to do to free this device?
> >=20
> > Doesn't
> > =20
> >    mdadm --stop /dev/md_d0
> >=20
> > release sdg1 ??
> >=20
> > NeilBrown
>=20
> No, it doesn't.
>=20
> $ mdadm --stop /dev/md_d0
> mdadm: error opening /dev/md_d0: No such file or directory
>=20
> In fact, that's sort of odd:
>=20
>  $ ls -l /dev/md*
> brw-rw---- 1 root disk 9, 0 2011-10-20 17:18 /dev/md0
> lrwxrwxrwx 1 root root    7 2011-10-20 17:05 /dev/md_d0p1 -> md/d0p1
> lrwxrwxrwx 1 root root    7 2011-10-20 17:05 /dev/md_d0p2 -> md/d0p2
> lrwxrwxrwx 1 root root    7 2011-10-20 17:05 /dev/md_d0p3 -> md/d0p3
> lrwxrwxrwx 1 root root    7 2011-10-20 17:05 /dev/md_d0p4 -> md/d0p4
>=20
> /dev/md:
> total 0
> brw------- 1 root root 254, 0 2011-10-20 17:05 d0
> brw------- 1 root root 254, 1 2011-10-20 17:05 d0p1
> brw------- 1 root root 254, 2 2011-10-20 17:05 d0p2
> brw------- 1 root root 254, 3 2011-10-20 17:05 d0p3
> brw------- 1 root root 254, 4 2011-10-20 17:05 d0p4
>=20
> [no record of /dev/md_d0] ...?
>=20
> hjm
>=20

md_d0 is another name for md/d0.  The former probably only gets created when
the array becomes active.
So use
   mdadm --stop /dev/md/d0

NeilBrown


--Sig_/IeOyk9Ae9u8fy+jK/k7f0DW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqH6mTnsnt1WYoG5AQI1Bg/+Pztvd8jhszWvr44F3C6eXpxd2j9sNlTY
JC8bBT7RN29qMi+td9F908Tvq1Iau2gjGzYlcFGxNYfmyS4Ce2uTQIke/RfMStiy
W45uIWe0CMAzSWm+mmWY+3nrwf4DUlC/Ae9pnysPTVYcE5XX0Pbe1beYbFHi9fJP
mAPe3gNQIEK2gAOjdm5h3PC3zdjWPnG6WJTcuotH61FvD37BYC+iQYpPWVjUqJxw
j0sFF0F+An54DNJphjPricKkYUxwdz+vzGArb1FRTifZLNZN3cAydbzyxrYf9gYV
gscR8xWvGgHUiyamX1tTKqp9VwlRLYnsCljZodigTn+WDaFnkMrMDBIo9sTGLt+M
7umkzguRjGRtrBUncCrOAccv2YGEPaknhVC+Alw2OMZdvfc7GDnHKKNVfz8brHZq
d0wdDkzi9mNpWmCijgEmZHOWJOYzvtaCVNkbY/Y8lF5uc/9UFKCuQ9X35XayPwSk
mDRzxTTWeFaFN6V20rxZKZUnp8v+3vU//FwncPC61p3a+sy0htOuCj88x3x2PoJQ
KJDYPcCOAeHx8PCoHUIghuiyuQIdlTfBELkhM6t7YsTbTMF8kG8nZfbeGW1lK8/Q
mI4payRymS22o6LVZShOM2QuShQ9o0KGjINZYeZIG3DGtHj4pxVIAMSb5RkI4rNR
aci6AzCjel8=
=pfd0
-----END PGP SIGNATURE-----

--Sig_/IeOyk9Ae9u8fy+jK/k7f0DW--
