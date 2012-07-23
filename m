From: NeilBrown <neilb@suse.de>
Subject: Re: Problem recovering failed Intel Rapid Storage raid5 volume
Date: Tue, 24 Jul 2012 08:13:49 +1000
Message-ID: <20120724081349.41a30efa@notabene.brown>
References: <CAHijsZt-CZ4BhjLU2sdWaGRtDa6bXjz0Bx+RRqoGRzvD6N6yvA@mail.gmail.com>
	<CAHijsZvPb5PZLmKxUwV4iZ-UOUfpGP_Hf9afaWdX34iO86EHKw@mail.gmail.com>
	<20120723090856.2738a2fc@notabene.brown>
	<CAHijsZvUoXcoee6kj84M9mYj=J-+9kSd8Zox2JCWrW+yhR_j1g@mail.gmail.com>
	<CAHijsZthcioN7YEcR2RGQcdeXJBVXpT8hniGZDbMxtXhVGM3vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/I=bNMrvtVC.f942UiJnqXML"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHijsZthcioN7YEcR2RGQcdeXJBVXpT8hniGZDbMxtXhVGM3vQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Khurram Hassan <kfhassan@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/I=bNMrvtVC.f942UiJnqXML
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jul 2012 21:54:24 +0500 Khurram Hassan <kfhassan@gmail.com> wrot=
e:

> raid.status contents:
>=20
> /dev/sdb:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.2.02
>     Orig Family : 00000000
>          Family : 6eb404da
>      Generation : 002308e9
>      Attributes : All supported
>            UUID : 51c75501:a307676f:d2d6e547:dfcb2476
>        Checksum : 06cf5ff9 correct
>     MPB Sectors : 2
>           Disks : 3
>    RAID Devices : 1
>=20
>   Disk01 Serial : 5VMLEGC6
>           State : active
>              Id : 00030000
>     Usable Size : 976768264 (465.76 GiB 500.11 GB)
>=20
> [VolumeData500:1]:
>            UUID : a0865f28:57b7246b:ff43fa76:5531f5ca
>      RAID Level : 5
>         Members : 3
>           Slots : [___]
>     Failed disk : 1
>       This Slot : 1 (out-of-sync)
>      Array Size : 1953536000 (931.52 GiB 1000.21 GB)
>    Per Dev Size : 976768264 (465.76 GiB 500.11 GB)
>   Sector Offset : 0
>     Num Stripes : 3815500
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : failed
>     Dirty State : clean
>=20
>   Disk00 Serial : 9VM1GGJK:1
>           State : active failed
>              Id : ffffffff
>     Usable Size : 976768264 (465.76 GiB 500.11 GB)
>=20
>   Disk02 Serial : 6VM4EGHC
>           State : active
>              Id : 00040000
>     Usable Size : 976768264 (465.76 GiB 500.11 GB)

You'll need to start out with=20

   echo 1 > /sys/module/md_mod/parameters/start_dirty_degraded=20

otherwise creating the degraded raid5 won't work - I need to fix that.
Then

 mdadm -C /dev/md/imsm -e imsm -n 2 /dev/sdb /dev/sdc
 mdadm -C /dev/md0 -l5 -n3 -c 128 missing /dev/sdb /dev/sdc

so you create an IMSM container, then create the RAID5 inside that.

You should then check the filesystem to make sure it looks right.
If not, you might need to stop the arrays  and start again, using a differe=
nt
order of devices in the second command.

Good luck,

NeilBrown




> /dev/sdc:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.2.02
>     Orig Family : 00000000
>          Family : 6eb404da
>      Generation : 002308e9
>      Attributes : All supported
>            UUID : 51c75501:a307676f:d2d6e547:dfcb2476
>        Checksum : 06cf5ff9 correct
>     MPB Sectors : 2
>           Disks : 3
>    RAID Devices : 1
>=20
>   Disk02 Serial : 6VM4EGHC
>           State : active
>              Id : 00040000
>     Usable Size : 976768264 (465.76 GiB 500.11 GB)
>=20
> [VolumeData500:1]:
>            UUID : a0865f28:57b7246b:ff43fa76:5531f5ca
>      RAID Level : 5
>         Members : 3
>           Slots : [___]
>     Failed disk : 1
>       This Slot : 2 (out-of-sync)
>      Array Size : 1953536000 (931.52 GiB 1000.21 GB)
>    Per Dev Size : 976768264 (465.76 GiB 500.11 GB)
>   Sector Offset : 0
>     Num Stripes : 3815500
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : failed
>     Dirty State : clean
>=20
>   Disk00 Serial : 9VM1GGJK:1
>           State : active failed
>              Id : ffffffff
>     Usable Size : 976768264 (465.76 GiB 500.11 GB)
>=20
>   Disk01 Serial : 5VMLEGC6
>           State : active
>              Id : 00030000
>     Usable Size : 976768264 (465.76 GiB 500.11 GB)
>=20
>=20
> I hope you can figure it out as I am quite lost here.
>=20
> Thanks,
> Khurram
>=20
>=20
> On Mon, Jul 23, 2012 at 4:31 PM, Khurram Hassan <kfhassan@gmail.com> wrot=
e:
> > raid.status contents:
> >
> > /dev/sdb:
> >           Magic : Intel Raid ISM Cfg Sig.
> >         Version : 1.2.02
> >     Orig Family : 00000000
> >          Family : 6eb404da
> >      Generation : 002308e9
> >      Attributes : All supported
> >            UUID : 51c75501:a307676f:d2d6e547:dfcb2476
> >        Checksum : 06cf5ff9 correct
> >     MPB Sectors : 2
> >           Disks : 3
> >    RAID Devices : 1
> >
> >   Disk01 Serial : 5VMLEGC6
> >           State : active
> >              Id : 00030000
> >     Usable Size : 976768264 (465.76 GiB 500.11 GB)
> >
> > [VolumeData500:1]:
> >            UUID : a0865f28:57b7246b:ff43fa76:5531f5ca
> >      RAID Level : 5
> >         Members : 3
> >           Slots : [___]
> >     Failed disk : 1
> >       This Slot : 1 (out-of-sync)
> >      Array Size : 1953536000 (931.52 GiB 1000.21 GB)
> >    Per Dev Size : 976768264 (465.76 GiB 500.11 GB)
> >   Sector Offset : 0
> >     Num Stripes : 3815500
> >      Chunk Size : 128 KiB
> >        Reserved : 0
> >   Migrate State : idle
> >       Map State : failed
> >     Dirty State : clean
> >
> >   Disk00 Serial : 9VM1GGJK:1
> >           State : active failed
> >              Id : ffffffff
> >     Usable Size : 976768264 (465.76 GiB 500.11 GB)
> >
> >   Disk02 Serial : 6VM4EGHC
> >           State : active
> >              Id : 00040000
> >     Usable Size : 976768264 (465.76 GiB 500.11 GB)
> > /dev/sdc:
> >           Magic : Intel Raid ISM Cfg Sig.
> >         Version : 1.2.02
> >     Orig Family : 00000000
> >          Family : 6eb404da
> >      Generation : 002308e9
> >      Attributes : All supported
> >            UUID : 51c75501:a307676f:d2d6e547:dfcb2476
> >        Checksum : 06cf5ff9 correct
> >     MPB Sectors : 2
> >           Disks : 3
> >    RAID Devices : 1
> >
> >   Disk02 Serial : 6VM4EGHC
> >           State : active
> >              Id : 00040000
> >     Usable Size : 976768264 (465.76 GiB 500.11 GB)
> >
> > [VolumeData500:1]:
> >            UUID : a0865f28:57b7246b:ff43fa76:5531f5ca
> >      RAID Level : 5
> >         Members : 3
> >           Slots : [___]
> >     Failed disk : 1
> >       This Slot : 2 (out-of-sync)
> >      Array Size : 1953536000 (931.52 GiB 1000.21 GB)
> >    Per Dev Size : 976768264 (465.76 GiB 500.11 GB)
> >   Sector Offset : 0
> >     Num Stripes : 3815500
> >      Chunk Size : 128 KiB
> >        Reserved : 0
> >   Migrate State : idle
> >       Map State : failed
> >     Dirty State : clean
> >
> >   Disk00 Serial : 9VM1GGJK:1
> >           State : active failed
> >              Id : ffffffff
> >     Usable Size : 976768264 (465.76 GiB 500.11 GB)
> >
> >   Disk01 Serial : 5VMLEGC6
> >           State : active
> >              Id : 00030000
> >     Usable Size : 976768264 (465.76 GiB 500.11 GB)
> >
> >
> > I hope you can figure it out as I am quite lost here.
> >
> > Thanks,
> > Khurram
> >
> > On Mon, Jul 23, 2012 at 4:08 AM, NeilBrown <neilb@suse.de> wrote:
> >> On Sat, 21 Jul 2012 21:00:19 +0500 Khurram Hassan <kfhassan@gmail.com>=
 wrote:
> >>
> >>> I have this 3 disk raid5 volumne on an Asus motherboard sporting an
> >>> Intel Rapid Storage chipset. The problem began when I noticed in
> >>> windows that one of the hard disks (the first one in the array) was
> >>> marked as failed in the Intel raid utility. I shutdown the system to
> >>> remove the hard disk and removed the cables for the faulty hard disk.
> >>> But I made a mistake and remove the cables for one of the working hard
> >>> disks. So when I booted, it showed the raid volume as failed. I
> >>> quickly shutdown the system and corrected the mistake. But it
> >>> completely hosed my raid volume. When I booted the system up again,
> >>> both of the remaining 2 hard disks were showed as offline.
> >>>
> >>> I read the raid recovery section in the wiki and installed ubuntu
> >>> 12.04 on a separate non-raid hard disk (after completely disconnecting
> >>> the offline raid5 volume). Then I reconnected the 2 hard disks and
> >>> booted ubuntu. Then I gave the following commands:
> >>>
> >>> 1) mdadm --examine /dev/sd[bc] > raid.status
> >>> 2) mdadm --create --assume-clean -c 128 --level=3D5 --raid-devices=3D3
> >>> /dev/md1 missing /dev/sdb /dev/sdc
> >>>
> >>> It gave the following output:
> >>>     mdadm: /dev/sdb appears to be part of a raid array:
> >>>         level=3Dcontainer devices=3D0 ctime=3DThu Jan  1 05:00:00 1970
> >>>     mdadm: /dev/sdc appears to be part of a raid array:
> >>>         level=3Dcontainer devices=3D0 ctime=3DThu Jan  1 05:00:00 1970
> >>>     Continue creating array? y
> >>>     mdadm: Defaulting to version 1.2 metadata
> >>>     mdadm: array /dev/md1 started.
> >>>
> >>> But the raid volume is not accessible. mdadm --examine /dev/md1 gives:
> >>>
> >>>     mdadm: No md superblock detected on /dev/md1.
> >>>
> >>> Worse, upon booting the system, the raid chipset message says the 2
> >>> hard disk are non-raid hard disks. Have I completely messed up the
> >>> raid volume? Is it not recoverable at all?
> >>
> >> Possibly :-(
> >>
> >> You had an array with Intel-specific metadata.  This metadata is store=
d at
> >> the end of the device.
> >>
> >> When you tried to "--create" the array, you did not ask for intel meta=
data so
> >> you got the default v1.2 metadata.  This metadata is stored at the beg=
inning
> >> of the device (a 1K block, 4K from the start).
> >> So this would have over-written a small amount of filesystem data.
> >>
> >> Also when you --create an array, mdadm erases any other metadata that =
it
> >> finds to avoid confusion.  So it will have erased the Intel metadata f=
rom the
> >> end.
> >>
> >> Your best hope is to recreate the array correctly with intel metadata.=
  The
> >> filesystem will quite possibly be corrupted, but you might get some or=
 even
> >> all of your data back.
> >>
> >> Can you post the "raid.status".  That would help be certain we are doi=
ng the
> >> right thing.
> >> Something like
> >>   mdadm --create /dev/md/imsm -e imsm -n 3 missing /dev/sdb /dev/sdc
> >>   mdadm --create /dev/md1 -c 128 -l 5 -n 3 /dev/md/imsm
> >>
> >> might do it  ... or might not.  I'm not sure about creating imsm array=
s with
> >> missing devices.  Maybe you still list the 3 devices rather than just =
the
> >> container.  I'd need to experiment.  If you post the raid.status I'll =
see if
> >> I can work out the best way forward.
> >>
> >> NeilBrown
> >>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/I=bNMrvtVC.f942UiJnqXML
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUA3Mnjnsnt1WYoG5AQLIYg//ZtHBOkpZVZOaWTPdKWqq6V76wbxOnm0B
wZZlAba+rHYnA9w9yRqM49NpL2Gps067bBPkyI72fFwXVKXbgqrZ3vjsWuhdLM1O
AexZrYekX0IAZfd0Z7BBonvyA/9w4bVeFjcUQRV2e3/KeS4Hn6oSqsNtdt9LU/jB
pxq1jAwAAhCYDYWdU73QmXTRUfXGOeNwdG6z7s431gLrtBlXvjRJuXhfqmF+eedC
i24BWXW/AzFdY5W+8hmjmekKIri2IN0H332tiW/nTYsAk56pvqYYnMgrIKYzJ1iD
E40Gkk3T72hkySCNC4uw4aCKmiSfg/wX8w89f8zQftSH1VqYJYCbwkQX1B52w96J
3TMhFbi3D7ZD1YwEikuIGiS+n1k13tk+UwD6rwG+/SLEXvwQFPrba8kem2eMYJJD
dMCBwuL+EvtDYVCLHGPG7s3+0yDOW178C7cQ/gHcrH5C35L626rdtxw8JD1C995C
CxPPOhR0NxFj7tK4KLZ/Aket1EYxM5nLx6JCgaJhkYCcVsv19nNtzoLkHtlcPrae
0X5+wkIjsvc5Dal3JiDrZQ+39h51GoR68g+x48faW64S6Msyy5RY8qKGadXz1zGj
OsWTetOanLjjVJ4ykZOJnW9xesptp9RcTfZs5sMEnbzeF2UhOK9gncRgbNGd//8P
bpbRBUjH8E4=
=aRps
-----END PGP SIGNATURE-----

--Sig_/I=bNMrvtVC.f942UiJnqXML--
