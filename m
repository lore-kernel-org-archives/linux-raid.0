From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --assemble considers event count for spares
Date: Tue, 28 May 2013 19:15:00 +1000
Message-ID: <20130528191500.2a5bb83a@notabene.brown>
References: <CAGRgLy6fc8fF8KWoO7EEG6Uo8d4jUPPLcucwX-fNw9O5qKMJgg@mail.gmail.com>
	<20130528111633.0ba7bed5@notabene.brown>
	<CAGRgLy5-ACTy1SyQdNO4mbCY0MXzFueGmRsYhQ7tS=BqQRWrCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PRTW8YszuAzsgeHg=s/M+C1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5-ACTy1SyQdNO4mbCY0MXzFueGmRsYhQ7tS=BqQRWrCw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/PRTW8YszuAzsgeHg=s/M+C1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 May 2013 11:56:26 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> can you please let me know what have you decided after/whether you had
> time to think about this issue.

I don't actually plan to think about the issue, at least not in the short
term.
If you would like to propose a concrete solution, then I would probably be
motivated to think about that and give you some feedback.

NeilBrown

>=20
> Thanks,
> Alex.
>=20
>=20
>=20
>=20
> On Tue, May 28, 2013 at 4:16 AM, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 27 May 2013 13:05:34 +0300 Alexander Lyakas <alex.bolshoy@gmail=
.com>
> > wrote:
> >
> >> Hi Neil,
> >> It can happen that a spare has a higher event count than a in-array dr=
ive.
> >> For exampe: RAID1 with two drives is rebuilding one of the drives.
> >> Then the "good" drive fails. As a result, MD stops the rebuild and
> >> ejects the rebuilding drive from the array. The failed drive stays in
> >> the array, because RAID1 never ejects the last drive. However, the
> >> "good" drive fails all IOs, so the ejected drive has a larger event
> >> count now.
> >> Now if MD is stopped and re-assembled, mdadm considers the spare drive
> >> as the chosen one:
> >>
> >> root@vc:/mnt/work/alex/mdadm-neil# ./mdadm --assemble /dev/md200
> >> --name=3Dalex --config=3Dnone --homehost=3Dvc --run --auto=3Dmd --meta=
data=3D1.2
> >> --verbose --verbose /dev/sdc2 /dev/sdd2
> >> mdadm: looking for devices for /dev/md200
> >> mdadm: /dev/sdc2 is identified as a member of /dev/md200, slot 0.
> >> mdadm: /dev/sdd2 is identified as a member of /dev/md200, slot -1.
> >> mdadm: added /dev/sdc2 to /dev/md200 as 0 (possibly out of date)
> >> mdadm: no uptodate device for slot 2 of /dev/md200
> >> mdadm: added /dev/sdd2 to /dev/md200 as -1
> >> mdadm: failed to RUN_ARRAY /dev/md200: Input/output error
> >> mdadm: Not enough devices to start the array.
> >>
> >> Kernel doesn't accept the non-spare drive considering it as non-fresh:
> >> May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.679396] md: md200 st=
opped.
> >> May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.686870] md: bind<sdc=
2>
> >> May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.687623] md: bind<sdd=
2>
> >> May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.687675] md: kicking
> >> non-fresh sdc2 from array!
> >> May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.687680] md: unbind<s=
dc2>
> >> May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.687683] md: export_r=
dev(sdc2)
> >> May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.693574]
> >> md/raid1:md200: active with 0 out of 2 mirrors
> >> May 27 12:42:28 vsa-00000505-vc-0 kernel: [343203.693583] md200:
> >> failed to create bitmap (-5)
> >>
> >> This happens with the latest mdadm from git, and kernel 3.8.2.
> >>
> >> Is this the expected behavior?
> >
> > I hadn't thought about it.
> >
> >> Maybe mdadm should not consider spares at all for its "chosen_drive"
> >> logic, and perhaps not try to add them to the kernel?
> >
> > Probably not, no.
> >
> > NeilBrown
> >
> >
> >
> >>
> >> Superblocks of both drives:
> >> sdc2 - the "good" drive:
> >> /dev/sdc2:
> >>           Magic : a92b4efc
> >>         Version : 1.2
> >>     Feature Map : 0x1
> >>      Array UUID : 8e051cc5:c536d16e:72b413fa:e7049d4b
> >>            Name : zadara_vc:alex
> >>   Creation Time : Mon May 27 11:33:50 2013
> >>      Raid Level : raid1
> >>    Raid Devices : 2
> >>
> >>  Avail Dev Size : 975063127 (464.95 GiB 499.23 GB)
> >>      Array Size : 209715200 (200.00 GiB 214.75 GB)
> >>   Used Dev Size : 419430400 (200.00 GiB 214.75 GB)
> >>     Data Offset : 2048 sectors
> >>    Super Offset : 8 sectors
> >>    Unused Space : before=3D1968 sectors, after=3D555632727 sectors
> >>           State : clean
> >>     Device UUID : 1f661ca3:fdc8b887:8d3638ab:f2cc0a40
> >>
> >> Internal Bitmap : 8 sectors from superblock
> >>     Update Time : Mon May 27 11:34:57 2013
> >>        Checksum : 72a97357 - correct
> >>          Events : 9
> >>
> >> sdd2 - the "rebuilding" drive:
> >> /dev/sdd2:
> >>           Magic : a92b4efc
> >>         Version : 1.2
> >>     Feature Map : 0x1
> >>      Array UUID : 8e051cc5:c536d16e:72b413fa:e7049d4b
> >>            Name : zadara_vc:alex
> >>   Creation Time : Mon May 27 11:33:50 2013
> >>      Raid Level : raid1
> >>    Raid Devices : 2
> >>
> >>  Avail Dev Size : 976123417 (465.45 GiB 499.78 GB)
> >>      Array Size : 209715200 (200.00 GiB 214.75 GB)
> >>   Used Dev Size : 419430400 (200.00 GiB 214.75 GB)
> >>     Data Offset : 2048 sectors
> >>    Super Offset : 8 sectors
> >>    Unused Space : before=3D1968 sectors, after=3D556693017 sectors
> >>           State : clean
> >>     Device UUID : 9abc7fa9:6bf95a51:51f2cd65:14232e81
> >>
> >> Internal Bitmap : 8 sectors from superblock
> >>     Update Time : Mon May 27 11:35:56 2013
> >>        Checksum : 3e793a34 - correct
> >>          Events : 26
> >>
> >>
> >>    Device Role : spare
> >>    Array State : A. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> >>
> >>
> >> Thanks,
> >> Alex.
> >


--Sig_/PRTW8YszuAzsgeHg=s/M+C1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUaR1lDnsnt1WYoG5AQJucxAAnvKYv8Cn88iGGJkapC6E4IWi+mS69cTF
M5vPE2HvVylWnBRIuaG0I72F5XVmd25d+PPiq6WFYYFdgsN46iuFhqB3NSKaFhmb
FASSM6KVvC3rZjTWHBf/b8e2wHkXrrSOP9OMzn9/SYJesdCxyzbiyHsMp3dyKwCZ
8Cru5iRmq+6BwgXTfUNAeo3maj4lEKZFvnh8FUkWkDdNy4qGXcVSq8ySLLxa5wvL
rxR/AxXXPm5fijKaEGQ07AEUOYvpTmK7Fq9mzeIovypomaWeyIMNfqBfGBgK7WYI
GGIX/zlkhStE5NlUZc87cCXh+y3CYDg13c3Fksl9fO+r+Tg+ngSnT9i0cL2zPsmu
B7YOZW48gi3YVbcmCeBJw04KGOYNh5YDRR6QT61m3TxWn/ptMsLOvQwJWt5yq7yC
ZIyRkerajyBNCXwLJvNKmwqdkNVTJ893GXZ1e7Fru6ZQlyitZ/SAutWot12RXp6e
CLUOe+oVePKHMnmWRGzq3EKUpI6LZYSjpwdQoZInkUuqIOGh8q5+eFiI3KBr3nMq
XLFhlm5+opbD0TcCiAdG0zm2Id3ZHMjtpxrkXCArOvlvjoRKtY/bAo+kpKT85U1v
fpDykqGi2OiquNPtMC69naoVslB4hj+bhZt0t/P7KG25TkXwxTwcAyVZINh6orzj
/ZWMCssEKW8=
=IEJz
-----END PGP SIGNATURE-----

--Sig_/PRTW8YszuAzsgeHg=s/M+C1--
