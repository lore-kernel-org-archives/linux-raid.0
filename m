From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm -E won't examine loop back device, works ok on source
 disk
Date: Mon, 23 Apr 2012 15:04:54 +1000
Message-ID: <20120423150454.1b46d01c@notabene.brown>
References: <CANb3qHeDF10CoRiteo_wwUSvGtpjcNWPh95xdatkFoY+GyAZJQ@mail.gmail.com>
	<20120423075816.6d21afe8@notabene.brown>
	<CANb3qHdLoaqp_N1awphoexuxpVgtnLSBewsGdGnP5NvUp=7BhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WVj2zfRvk9=Aj1UtVyKa.LB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANb3qHdLoaqp_N1awphoexuxpVgtnLSBewsGdGnP5NvUp=7BhQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Veedar Hokstadt <veedar@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WVj2zfRvk9=Aj1UtVyKa.LB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Apr 2012 00:46:16 -0400 Veedar Hokstadt <veedar@gmail.com> wrote:

> Thanks for your reply but setting IMSM_NO_PLATFORM seems to have no effec=
t...
>=20
> % export IMSM_NO_PLATFORM=3D1
> % echo $IMSM_NO_PLATFORM
> 1
>=20
> % mdadm -V
> mdadm - v3.2.3 - 23rd December 2011
>=20
> % mdadm -E -v /dev/loop2
> mdadm: No md superblock detected on /dev/loop2.

Hmmmm....

Looks like you need
    IMSM_DEVNAME_AS_SERIAL=3D1
as well.  IMSM like to know the 'serial number' of each device and gets
confused when there isn't once ... and loop doesn't have serial numbers.

I should see if I can fix that.

Thanks
NeilBrown


>=20
> % export IMSM_NO_PLATFORM=3D""
> % echo $IMSM_NO_PLATFORM
>=20
> % mdadm -E -v /dev/loop2
> mdadm: No md superblock detected on /dev/loop2.
>=20
> And trying to assemble fails...
> export IMSM_NO_PLATFORM=3D1
> % mdadm --assemble /dev/md0 /dev/loop1 /dev/loop2
> mdadm: Cannot assemble mbr metadata on /dev/loop1
> mdadm: /dev/loop1 has no superblock - assembly aborted
>=20
> Regards,
> V
>=20
> On Sun, Apr 22, 2012 at 5:58 PM, NeilBrown <neilb@suse.de> wrote:
> > On Sun, 22 Apr 2012 17:00:04 -0400 Veedar Hokstadt <veedar@gmail.com> w=
rote:
> >
> >> Consider a SATA drive /dev/sdb which is a member of an imsm RAID0 arra=
y...
> >>
> >> % sum /dev/sdb
> >> 25645 156290904
> >>
> >> The drive was imaged to a file without error and mounted as a loopback=
 device...
> >>
> >> % sum /dev/loop2
> >> 25645 156290904
> >>
> >> The checksums match as expected. But I can not examine the loopback I =
get....
> >>
> >> % mdadm =A0-E -v /dev/loop2
> >> mdadm: No md superblock detected on /dev/loop2.
> >>
> >> But I can examine the physical source drive /dev/sdb...
> >>
> >> % mdadm =A0-E -v /dev/sdb
> >> /dev/sdb:
> >> =A0 =A0 =A0 =A0 =A0 Magic : Intel Raid ISM Cfg Sig.
> >> =A0 =A0 =A0 =A0 Version : 1.0.00
> >> =A0 =A0 Orig Family : e92a11d9
> >> =A0 =A0 =A0 =A0 =A0Family : e92a11d9
> >> =A0 =A0 =A0Generation : 00001608
> >> =A0 =A0 =A0 =A0 =A0 =A0UUID : 25137636:2ff64e75:10ae5444:4e8f609b
> >> =A0 =A0 =A0 =A0Checksum : e1237b20 correct
> >> =A0 =A0 MPB Sectors : 1
> >> =A0 =A0 =A0 =A0 =A0 Disks : 2
> >> =A0 =A0RAID Devices : 1
> >>
> >> =A0 Disk01 Serial : 8068C3QVT
> >> =A0 =A0 =A0 =A0 =A0 State : active
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0Id : 00010000
> >> =A0 =A0 Usable Size : 312577294 (149.05 GiB 160.04 GB)
> >>
> >> [Volume0]:
> >> =A0 =A0 =A0 =A0 =A0 =A0UUID : 72acd5fa:35c5a901:995af79b:83a29de1
> >> =A0 =A0 =A0RAID Level : 0
> >> =A0 =A0 =A0 =A0 Members : 2
> >> =A0 =A0 =A0 This Slot : 1
> >> =A0 =A0 =A0Array Size : 625154048 (298.10 GiB 320.08 GB)
> >> =A0 =A0Per Dev Size : 312577283 (149.05 GiB 160.04 GB)
> >> =A0 Sector Offset : 0
> >> =A0 =A0 Num Stripes : 1221004
> >> =A0 =A0 =A0Chunk Size : 128 KiB
> >> =A0 =A0 =A0 =A0Reserved : 0
> >> =A0 Migrate State : idle
> >> =A0 =A0 =A0 Map State : normal
> >> =A0 =A0 Dirty State : clean
> >>
> >> =A0 Disk00 Serial : 809BC541T
> >> =A0 =A0 =A0 =A0 =A0 State : active failed
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0Id : 00000000
> >> =A0 =A0 Usable Size : 312577294 (149.05 GiB 160.04 GB)
> >>
> >> I'm trying to recover data from a failed RAID0.
> >> I can successfully reassemble the RAID0 from the image files using
> >> other proprietary recovery software.
> >> But I would like to get it working with mdadm if at all possible.
> >> Any ideas?
> >>
> >
> > Try setting =A0IMSM_NO_PLATFORM in the environment:
> >
> > =A0IMSM_NO_PLATFORM=3D1 mdadm -E -v /dev/loop2
> >
> > or
> >
> > =A0export IMSM_NO_PLATFORM=3D1
> > =A0mdadm -E -v /dev/loop2
> >
> > I think this is fixed in more recent mdadm. =A0You still need IMSM_NO_P=
LATFORM
> > to create or assemble an array, but not just to look at it.
> >
> > NeilBrown
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/WVj2zfRvk9=Aj1UtVyKa.LB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5Ti9jnsnt1WYoG5AQL1yhAAwrYXlkw2n/wJBTeYIRDbNS1j4u5DG/dd
COIh8gblEM0sdbef54WIWmWlukBCm7XB86+JqVhR0mWQXgZmvc/S2Y29bBFQmJI8
mVQ/I6O1EdsULY2gAdvbA2j7MA3KTb4kMLL73XceYV3N+ZkFI+bis3L2Ha9Ef4Mc
3xxvumqMucfkudQpDTM8k0uu6ehTpkB/qG8FKDbRlmycrHwKA0mMq5sGEFSaw2zW
ScREK9YYR4zN1Cc19FNQQv4IR7NLrouRuhVBcJ7WJG6JJgqCnV7xVPcFl/B7ZkKI
KWMYWW9t11gAjAX3fM/e47B6pmr351cFP1nBDCj8MgmMnCnckJH8hXU3dkHIitJd
T+Nx2rpg/v3c5gvwsaJhs79XZTlKksiW3DAkH8MgTL93UdK4dDuATPu/YzCJfrgu
KoNNRVuk1fpl86CTYE4mcoOW/h9yh6YWUIXAge+F8u0gg7XVF3x9ie872oQdHjCb
1foR+iMAAGVDFHzkIX7cjqkre/QS5goibqpz3qux3OSdR2F8p1AI1iwi8wxwizTU
VyX87BOMj4gge8Oy4ZgjauqIVsWyiQkAlZ+sQEEK7D0lv2ioCg+cddV2TQ/OZiOS
FwMwXE4sbpmLk8NLyN0fDY2krrGThEr0ZmWnIBwPoUwo0t79RZp/X1MDllR397Rx
3JOzYuZ/6JQ=
=jMZg
-----END PGP SIGNATURE-----

--Sig_/WVj2zfRvk9=Aj1UtVyKa.LB--
