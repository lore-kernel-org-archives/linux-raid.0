From: NeilBrown <neilb@suse.de>
Subject: Re: Please Help! RAID5 -> 6 reshapre gone bad
Date: Tue, 7 Feb 2012 16:16:16 +1100
Message-ID: <20120207161616.1951a682@notabene.brown>
References: <CAOANJV-V8ZTXBvQxxMnEnv24p8A-fAas-6x65ifW5yp35ZqHnA@mail.gmail.com>
	<20120207133947.5c4b9a59@notabene.brown>
	<20120207141023.22cce706@notabene.brown>
	<CAOANJV_jC_jvUuNuB96ARwJDyg1KAR1ind6uvjTFb4pfuyaHag@mail.gmail.com>
	<20120207143941.58c3ccb6@notabene.brown>
	<CAOANJV_giURCH_yi8fMyKGpQ-uRSzF9iwOoV-_qO5sAASvYWwA@mail.gmail.com>
	<20120207152501.5541d379@notabene.brown>
	<CAOANJV8kQ2U3LaZiH0QXtaPGeEh5wQ110B9d_CU_77E5Kwit7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WqN4s0/PuqAJmPdR9ENuBU+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOANJV8kQ2U3LaZiH0QXtaPGeEh5wQ110B9d_CU_77E5Kwit7Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Herd <2001oddity@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WqN4s0/PuqAJmPdR9ENuBU+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Feb 2012 16:02:27 +1100 Richard Herd <2001oddity@gmail.com> wrote:

> Hi Neil,
>=20
> Hmm - see you're point about the kernel...
>=20
> Kernel updated.  I'm now running 2.6.38.
>=20
> I went to work on it a bit more under 2.6.38 - I'm not sure here, it
> wouldn't take all the disks as before, but this time seems to have
> assembled (with --force) using 4 of the disks.
>=20
> Trying to re-add the 5th and 6th didn't throw the same warning as
> before (failed to re-add and not adding as spare), it said ''re-added
> /dev/xxx to /dev/md0' but when checking detail we can see they were
> added as spares not as part of the array.

That is expected. "--force" just gets you enough to keep going and that is
what you have.  Hopefully no more errors (keep the air-con ?? or maybe just
keep the doors open, depending where you are :-)

>=20
> Anyway, with the array assembled and running, I have got the
> filesystem mounted and am quickly smashing an rsync to mirror what I
> can (8TB, how long could it take? lol).

Good news.

>=20
> Thanks so much for your help guys - once I got the hint on the kernel
> it wasn't too hard to get the array assembled again.  Now it's just a
> waiting game I guess to see how much of the data is intact.  Also, at
> what point would those two disks now marked as spare be re-synced into
> the array?  After the reshape completes?

Yes.  When the reshape completes, both the spares will get included into the
array and recovered together.


>=20
> Really appreciate your help :-)

And I appreciate nice detailed bug reports - they tend to get more
attention.  Thanks!

NeilBrown



>=20
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active raid6 sde1[6](S) sdg1[7](S) sdc1[1] sdf1[4] sdd1[3] sdb1[2]
>       7814047744 blocks super 0.91 level 6, 64k chunk, algorithm 18
> [6/4] [_UUUU_]
>       [>....................]  reshape =3D  3.9% (78086144/1953511936)
> finish=3D11710.7min speed=3D2668K/sec
>=20
> unused devices: <none>
>=20
>=20
> root@raven:~# mdadm --detail /dev/md0
> /dev/md0:
>         Version : 0.91
>   Creation Time : Tue Jul 12 23:05:01 2011
>      Raid Level : raid6
>      Array Size : 7814047744 (7452.06 GiB 8001.58 GB)
>   Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>=20
>     Update Time : Tue Feb  7 15:52:10 2012
>           State : clean, degraded, reshaping
>  Active Devices : 4
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 2
>=20
>          Layout : left-symmetric-6
>      Chunk Size : 64K
>=20
>  Reshape Status : 3% complete
>      New Layout : left-symmetric
>=20
>            UUID : 9a76d1bd:2aabd685:1fc5fe0e:7751cfd7 (local to host rave=
n)
>          Events : 0.1850269
>=20
>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1       8       33        1      active sync   /dev/sdc1
>        2       8       17        2      active sync   /dev/sdb1
>        3       8       49        3      active sync   /dev/sdd1
>        4       8       81        4      active sync   /dev/sdf1
>        5       0        0        5      removed
>=20
>        6       8       65        -      spare   /dev/sde1
>        7       8       97        -      spare   /dev/sdg1
>=20
>=20
>=20
>=20
> On Tue, Feb 7, 2012 at 3:25 PM, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 7 Feb 2012 14:50:57 +1100 Richard Herd <2001oddity@gmail.com> w=
rote:
> >
> >> Hi Neil,
> >>
> >> OK, git head is: mdadm-3.2.3-21-gda8fe5a
> >>
> >> I have 8 disks. =C2=A0They get muddled about each boot (an issue I have
> >> never addressed). =C2=A0 Ignore sde (esata HD) and sdh (usb boot).
> >>
> >> It seems even with --force, dmesg always reports 'kicking non-fresh
> >> sdc/g1 from array!'. =C2=A0Leaving sdg out as suggested by Phil doesn't
> >> help unfortunately.
> >>
> >> root@raven:/neil/mdadm# ./mdadm -Avvv --force
> >> --backup-file=3D/usb/md0.backup /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1
> >> /dev/sdd1 /dev/sdf1 /dev/sdg1
> >> mdadm: looking for devices for /dev/md0
> >> mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 2.
> >> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
> >> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 3.
> >> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 5.
> >> mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 4.
> >> mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 0.
> >> mdadm:/dev/md0 has an active reshape - checking if critical section
> >> needs to be restored
> >> mdadm: accepting backup with timestamp 1328559119 for array with
> >> timestamp 1328567549
> >> mdadm: restoring critical section
> >> mdadm: added /dev/sdg1 to /dev/md0 as 0
> >> mdadm: added /dev/sda1 to /dev/md0 as 2
> >> mdadm: added /dev/sdc1 to /dev/md0 as 3
> >> mdadm: added /dev/sdf1 to /dev/md0 as 4
> >> mdadm: added /dev/sdd1 to /dev/md0 as 5
> >> mdadm: added /dev/sdb1 to /dev/md0 as 1
> >> mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
> >
> >
> > Hmmm.... maybe your kernel isn't quite doing the right thing.
> > =C2=A0commit 674806d62fb02a22eea948c9f1b5e58e0947b728 is important.
> > It is in 2.6.35. =C2=A0What kernel are you running?
> > Definitely something older given the "1: w=3D1 pa=3D18...." messages. =
=C2=A0They
> > disappear in 2.6.34.
> >
> > So I'm afraid you're going to need a new kernel.
> >
> > NeilBrown
> >
> >
> >
> >
> >>
> >> and dmesg:
> >> [13964.591801] md: bind<sdg1>
> >> [13964.595371] md: bind<sda1>
> >> [13964.595668] md: bind<sdc1>
> >> [13964.595900] md: bind<sdf1>
> >> [13964.599084] md: bind<sdd1>
> >> [13964.599652] md: bind<sdb1>
> >> [13964.600478] md: kicking non-fresh sdc1 from array!
> >> [13964.600493] md: unbind<sdc1>
> >> [13964.612138] md: export_rdev(sdc1)
> >> [13964.612163] md: kicking non-fresh sdg1 from array!
> >> [13964.612183] md: unbind<sdg1>
> >> [13964.624077] md: export_rdev(sdg1)
> >> [13964.628203] raid5: reshape will continue
> >> [13964.628243] raid5: device sdb1 operational as raid disk 1
> >> [13964.628252] raid5: device sdf1 operational as raid disk 4
> >> [13964.628260] raid5: device sda1 operational as raid disk 2
> >> [13964.629614] raid5: allocated 6308kB for md0
> >> [13964.629731] 1: w=3D1 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=
=3D0
> >> [13964.629742] 5: w=3D1 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D1 op2=
=3D0
> >> [13964.629751] 4: w=3D2 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=
=3D0
> >> [13964.629760] 2: w=3D3 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=
=3D0
> >> [13964.629767] raid5: not enough operational devices for md0 (3/6 fail=
ed)
> >> [13964.640403] RAID5 conf printout:
> >> [13964.640409] =C2=A0--- rd:6 wd:3
> >> [13964.640416] =C2=A0disk 1, o:1, dev:sdb1
> >> [13964.640423] =C2=A0disk 2, o:1, dev:sda1
> >> [13964.640429] =C2=A0disk 4, o:1, dev:sdf1
> >> [13964.640436] =C2=A0disk 5, o:1, dev:sdd1
> >> [13964.641621] raid5: failed to run raid set md0
> >> [13964.649886] md: pers->run() failed ...


--Sig_/WqN4s0/PuqAJmPdR9ENuBU+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzCzoDnsnt1WYoG5AQLkRA//af3pqW1NHZweR3tZN0ljXenlz95RcUdE
Imu7GDyZDRcbAEupfdSc4+nb2BUKfGQFVrimu75u/MXt5unuOCD9BCKq7kWtxm6D
zHgxDqNDtSVubJ84P0lZlseQyztVtUs/q7RdE3beUVSPq8jYVtg00YI5h4PVyenL
Kz9wys6mioYpQtAQ3gwk/nU9FUUMY2rgU6EZsbQ7T61epUJcoTIXz7U5o0Vxx6ee
1952sZ+W9mzPcYnX20Piv4DCMbFsulQUPTqc4rvoDB1qo+vtTGJtWjbY+aiT4IVb
b13QnQ1h/Oz7MYi+mMpKaSCUVva2whjSjM3N/LpeIKMpj0KED4nA9ygnjVEVzQcp
pxc+ZYX4MGx2Tfs2LL3PbljbmY8Pbfzmes6e6abNjYToX2emJUwM0w9nRbidWDhD
DCVpK8r2ec75xVTEUT/Ki9c8aSow1AbyuGQBX9RY+3+nuRxdp7vklvs49QkFEha4
GcxNazv2q1m80KIrbTYQXgXMs/Ppv3++3qOWJ6IAZEx+7NS43evWG/vi/SL0lFuU
hbFsj0KWDtAtGJyZUmSXaTsUKiLlj4cQ1eFgXQ/4EZhaB8aZNgBpGX3yQ9k0GSDF
xOTqXKY4XFxrf8tj10Op7Zn3aHvqYIabWZx16uvJto3pn9+2hW5F7KojvM+4+GH9
pW7LZo72ORM=
=TPrC
-----END PGP SIGNATURE-----

--Sig_/WqN4s0/PuqAJmPdR9ENuBU+--
