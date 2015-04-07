From: NeilBrown <neilb@suse.de>
Subject: Re: Help recovering an interrupted raid0 reshape
Date: Wed, 8 Apr 2015 08:56:35 +1000
Message-ID: <20150408085635.64fa7101@notabene.brown>
References: <CAC_83AFDEijn-7gNmnWNNabzcuPRMabNwr8xfRFt0xacsvZfog@mail.gmail.com>
	<20150407094608.4a9dd142@notabene.brown>
	<20150407115033.1d63b65c@notabene.brown>
	<CAC_83AFo47Zfe7rMqro7_k8dR-xpMcfiwQA7a9DTKpKPuHr=fA@mail.gmail.com>
	<20150407163004.7550da77@notabene.brown>
	<CAC_83AEtgtiN-WD-U8OG_nzsoRWQmrn6mxKMhKk6cxK4ZD5yaQ@mail.gmail.com>
	<20150408071339.3295567b@notabene.brown>
	<CAC_83AGk2MK8=qy2CL-WN-ewfVzgA2D-WRkefpriXrdHSEjU-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/dKnZQWq_FBNCq0utOW=RaXL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC_83AGk2MK8=qy2CL-WN-ewfVzgA2D-WRkefpriXrdHSEjU-Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Jonathan Harker (Jesusaurus)" <jesusaurus@gentlydownthe.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dKnZQWq_FBNCq0utOW=RaXL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Apr 2015 15:31:32 -0700 "Jonathan Harker (Jesusaurus)"
<jesusaurus@gentlydownthe.net> wrote:

> On Tue, Apr 7, 2015 at 2:13 PM, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 7 Apr 2015 10:02:13 -0700 "Jonathan Harker (Jesusaurus)"
> > <jesusaurus@gentlydownthe.net> wrote:
> >
> >> On Mon, Apr 6, 2015 at 11:30 PM, NeilBrown <neilb@suse.de> wrote:
> >> >
> >> > Try:
> >> >   mdadm -S /dev/md124
> >> >   mdadm -A /dev/md124 --update=3Drevert-reshape /dev/md/alpha /dev/m=
d/beta
> >> >   mdadm -S /dev/md124
> >> >   mdadm -A /dev/md124 -vvv /dev/md/alpha /dev/md/beta /dev/md/gamma
> >> >
> >> > What does that report?
> >> >
> >> > NeilBrown
> >> >
> >>
> >> # mdadm --stop /dev/md124
> >> mdadm: stopped /dev/md124
> >> # mdadm -A /dev/md124 --update=3Drevert-reshape /dev/md/alpha /dev/md/=
beta
> >> mdadm: /dev/md124 assembled from 2 drives - not enough to start the ar=
ray.
> >> # cat /proc/mdstat
> >> Personalities : [raid6] [raid5] [raid4] [raid1] [raid10] [raid0]
> >> [linear] [multipath]
> >> md124 : inactive md126[0](S) md127[1](S)
> >>       3907022200 blocks super 1.2
> >>
> >> md0 : active raid1 sda5[0] sdb2[1]
> >>       107652416 blocks [2/2] [UU]
> >>       bitmap: 1/1 pages [4KB], 65536KB chunk
> >>
> >> md125 : active raid1 sdh1[0] sdg1[1]
> >>       2930134016 blocks super 1.2 [2/2] [UU]
> >>       bitmap: 0/22 pages [0KB], 65536KB chunk
> >>
> >> md126 : active raid1 sdc1[0] sdd1[1]
> >>       1953512312 blocks super 1.2 [2/2] [UU]
> >>
> >> md127 : active raid1 sde1[2] sdf1[1]
> >>       1953512312 blocks super 1.2 [2/2] [UU]
> >>
> >> unused devices: <none>
> >> # mdadm --stop /dev/md124
> >> mdadm: stopped /dev/md124
> >> # mdadm -A /dev/md124 -vvv /dev/md/alpha /dev/md/beta /dev/md/gamma
> >> mdadm: looking for devices for /dev/md124
> >> mdadm: UUID differs from /dev/md0.
> >> mdadm: UUID differs from /dev/md/alpha.
> >> mdadm: UUID differs from /dev/md/beta.
> >> mdadm: UUID differs from /dev/md/gamma.
> >> mdadm: UUID differs from /dev/md0.
> >> mdadm: UUID differs from /dev/md/alpha.
> >> mdadm: UUID differs from /dev/md/beta.
> >> mdadm: UUID differs from /dev/md/gamma.
> >> mdadm: UUID differs from /dev/md0.
> >> mdadm: UUID differs from /dev/md/alpha.
> >> mdadm: UUID differs from /dev/md/beta.
> >> mdadm: UUID differs from /dev/md/gamma.
> >> mdadm: /dev/md/alpha is identified as a member of /dev/md124, slot 1.
> >> mdadm: /dev/md/beta is identified as a member of /dev/md124, slot 0.
> >> mdadm: /dev/md/gamma is identified as a member of /dev/md124, slot 2.
> >> mdadm: :/dev/md124 has an active reshape - checking if critical
> >> section needs to be restored
> >> mdadm: added /dev/md/alpha to /dev/md124 as 1
> >> mdadm: added /dev/md/gamma to /dev/md124 as 2 (possibly out of date)
> >> mdadm: no uptodate device for slot 6 of /dev/md124
> >> mdadm: added /dev/md/beta to /dev/md124 as 0
> >> mdadm: /dev/md124 assembled from 2 drives - not enough to start the ar=
ray.
> >> # cat /proc/mdstat
> >> Personalities : [raid6] [raid5] [raid4] [raid1] [raid10] [raid0]
> >> [linear] [multipath]
> >> md124 : inactive md125[3](S) md127[1](S) md126[0](S)
> >>       6837155192 blocks super 1.2
> >>
> >> md0 : active raid1 sda5[0] sdb2[1]
> >>       107652416 blocks [2/2] [UU]
> >>       bitmap: 0/1 pages [0KB], 65536KB chunk
> >>
> >> md125 : active raid1 sdh1[0] sdg1[1]
> >>       2930134016 blocks super 1.2 [2/2] [UU]
> >>       bitmap: 0/22 pages [0KB], 65536KB chunk
> >>
> >> md126 : active raid1 sdc1[0] sdd1[1]
> >>       1953512312 blocks super 1.2 [2/2] [UU]
> >>
> >> md127 : active raid1 sde1[2] sdf1[1]
> >>       1953512312 blocks super 1.2 [2/2] [UU]
> >>
> >> unused devices: <none>
> >>
> >> # mdadm --examine /dev/md/alpha
> >> /dev/md/alpha:
> >>           Magic : a92b4efc
> >>         Version : 1.2
> >>     Feature Map : 0x4
> >>      Array UUID : 1f4979ba:c49a77c0:59e689c2:bcc21c0a
> >>            Name : hordern:hordern1  (local to host hordern)
> >>   Creation Time : Fri Jan  2 09:59:40 2009
> >>      Raid Level : raid4
> >>    Raid Devices : 4
> >>
> >>  Avail Dev Size : 3907021824 (1863.01 GiB 2000.40 GB)
> >>      Array Size : 5860532736 (5589.04 GiB 6001.19 GB)
> >>     Data Offset : 2048 sectors
> >>    Super Offset : 8 sectors
> >>    Unused Space : before=3D1968 sectors, after=3D752 sectors
> >>           State : active
> >>     Device UUID : 63aaa2e4:2a09f495:8372c7f9:eb2f2773
> >>
> >>   Reshape pos'n : 129067008 (123.09 GiB 132.16 GB)
> >>   Delta Devices : 1 (3->4)
> >>
> >>     Update Time : Sun Mar 29 15:11:35 2015
> >>        Checksum : 8be5e0e8 - correct
> >>          Events : 14013
> >>
> >>      Chunk Size : 512K
> >>
> >>    Device Role : Active device 1
> >>    Array State : AA.. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
> >>
> >> # mdadm --examine /dev/md/beta
> >> /dev/md/beta:
> >>           Magic : a92b4efc
> >>         Version : 1.2
> >>     Feature Map : 0x4
> >>      Array UUID : 1f4979ba:c49a77c0:59e689c2:bcc21c0a
> >>            Name : hordern:hordern1  (local to host hordern)
> >>   Creation Time : Fri Jan  2 09:59:40 2009
> >>      Raid Level : raid4
> >>    Raid Devices : 4
> >>
> >>  Avail Dev Size : 3907022576 (1863.01 GiB 2000.40 GB)
> >>      Array Size : 5860532736 (5589.04 GiB 6001.19 GB)
> >>   Used Dev Size : 3907021824 (1863.01 GiB 2000.40 GB)
> >>     Data Offset : 2048 sectors
> >>    Super Offset : 8 sectors
> >>    Unused Space : before=3D1968 sectors, after=3D752 sectors
> >>           State : clean
> >>     Device UUID : 6e6dce14:3ebb2bb5:187aa292:403a55f6
> >>
> >>   Reshape pos'n : 129067008 (123.09 GiB 132.16 GB)
> >>   Delta Devices : 1 (3->4)
> >>
> >>     Update Time : Sun Mar 29 15:11:35 2015
> >>        Checksum : f7526adf - correct
> >>          Events : 14013
> >>
> >>      Chunk Size : 512K
> >>
> >>    Device Role : Active device 0
> >>    Array State : AA.. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
> >>
> >> # mdadm --examine /dev/md/gamma
> >> /dev/md/gamma:
> >>           Magic : a92b4efc
> >>         Version : 1.2
> >>     Feature Map : 0x6
> >>      Array UUID : 1f4979ba:c49a77c0:59e689c2:bcc21c0a
> >>            Name : hordern:hordern1  (local to host hordern)
> >>   Creation Time : Fri Jan  2 09:59:40 2009
> >>      Raid Level : raid4
> >>    Raid Devices : 4
> >>
> >>  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
> >>      Array Size : 5860532736 (5589.04 GiB 6001.19 GB)
> >>   Used Dev Size : 3907021824 (1863.01 GiB 2000.40 GB)
> >>     Data Offset : 2048 sectors
> >>    Super Offset : 8 sectors
> >> Recovery Offset : 86403072 sectors
> >>    Unused Space : before=3D1960 sectors, after=3D1953244160 sectors
> >>           State : active
> >>     Device UUID : 782873ea:e265ecd4:5cc80ddf:035ba2b4
> >>
> >>   Reshape pos'n : 129067008 (123.09 GiB 132.16 GB)
> >>   Delta Devices : 1 (3->4)
> >>
> >>     Update Time : Sun Mar 29 00:05:29 2015
> >>   Bad Block Log : 512 entries available at offset 72 sectors
> >>        Checksum : 710dc078 - correct
> >>          Events : 673
> >>
> >>      Chunk Size : 512K
> >>
> >>    Device Role : Active device 2
> >>    Array State : AAA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
> >>
> >> # mdadm --detail /dev/md124
> >> /dev/md124:
> >>         Version : 1.2
> >>      Raid Level : raid0
> >>   Total Devices : 3
> >>     Persistence : Superblock is persistent
> >>
> >>           State : inactive
> >>
> >>   Delta Devices : 1, (-1->0)
> >>       New Level : raid4
> >>   New Chunksize : 512K
> >>
> >>            Name : hordern:hordern1  (local to host hordern)
> >>            UUID : 1f4979ba:c49a77c0:59e689c2:bcc21c0a
> >>          Events : 673
> >>
> >>     Number   Major   Minor   RaidDevice
> >>
> >>        -       9      125        -        /dev/md/gamma
> >>        -       9      126        -        /dev/md/beta
> >>        -       9      127        -        /dev/md/alpha
> >>
> >> So it looks like all three component devices have consistent
> >> superblocks now, awesome! But the raid0 array is still inactive with
> >> all three components listed as spares. It looks like /dev/md/gamma has
> >> a much lower event count, I'm guessing that is what causes the disk to
> >> be marked as possibly out of date.
> >>
> >> Is an "uptodate device" a specific thing, or does that simply mean
> >> that some component devices are out of date? The lack of spaces makes
> >> me think that uptodate is some keyword I'm not recognizing.
> >>
> >
> > Looks good.  Nearly there.
> >
> > The difference in event counts is probably due to you trying lots of th=
ings
> > out, and them only affecting two devices.
> >
> > If you
> >  # mdadm --stop /dev/md124
> >  # mdadm -A --force /dev/md124 -vvv /dev/md/alpha /dev/md/beta /dev/md/=
gamma
> >
> > i.e. just add --force, it should ignored the difference in event count =
and
> > assemble the array.
> > For RAID0, the event count isn't really relevant to the data as there i=
s no
> > possibility for inconsistency between data and parity on different devi=
ces.
> > As the reshape position is the same on all devices, I don't think there=
 is
> > any risk at all in just using --force.
> > Of course, perform an fsck afterwards just to build confidence.
> >
> > NeilBrown
> >
>=20
> Unfortunately, adding --force didn't seem to make any difference:
>=20
> # mdadm --stop /dev/md124
> mdadm: stopped /dev/md124
> # mdadm -A --force /dev/md124 -vvv /dev/md/alpha /dev/md/beta /dev/md/gam=
ma
> mdadm: looking for devices for /dev/md124
> mdadm: UUID differs from /dev/md0.
> mdadm: UUID differs from /dev/md/alpha.
> mdadm: UUID differs from /dev/md/beta.
> mdadm: UUID differs from /dev/md/gamma.
> mdadm: UUID differs from /dev/md0.
> mdadm: UUID differs from /dev/md/alpha.
> mdadm: UUID differs from /dev/md/beta.
> mdadm: UUID differs from /dev/md/gamma.
> mdadm: UUID differs from /dev/md0.
> mdadm: UUID differs from /dev/md/alpha.
> mdadm: UUID differs from /dev/md/beta.
> mdadm: UUID differs from /dev/md/gamma.
> mdadm: /dev/md/alpha is identified as a member of /dev/md124, slot 1.
> mdadm: /dev/md/beta is identified as a member of /dev/md124, slot 0.
> mdadm: /dev/md/gamma is identified as a member of /dev/md124, slot 2.
> mdadm: :/dev/md124 has an active reshape - checking if critical
> section needs to be restored
> mdadm: added /dev/md/alpha to /dev/md124 as 1
> mdadm: added /dev/md/gamma to /dev/md124 as 2 (possibly out of date)
> mdadm: no uptodate device for slot 6 of /dev/md124
> mdadm: added /dev/md/beta to /dev/md124 as 0
> mdadm: /dev/md124 assembled from 2 drives - not enough to start the array.
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid1] [raid10] [raid0]
> [linear] [multipath]
> md124 : inactive md125[3](S) md127[1](S) md126[0](S)
>       6837155192 blocks super 1.2
>=20
> md0 : active raid1 sda5[0] sdb2[1]
>       107652416 blocks [2/2] [UU]
>       bitmap: 0/1 pages [0KB], 65536KB chunk
>=20
> md125 : active raid1 sdh1[0] sdg1[1]
>       2930134016 blocks super 1.2 [2/2] [UU]
>       bitmap: 0/22 pages [0KB], 65536KB chunk
>=20
> md126 : active raid1 sdc1[0] sdd1[1]
>       1953512312 blocks super 1.2 [2/2] [UU]
>=20
> md127 : active raid1 sde1[2] sdf1[1]
>       1953512312 blocks super 1.2 [2/2] [UU]
>=20
> unused devices: <none>


Hmm... I think I see the bug.  It should be easy enough to fix, but I'd like
to be able to test it.
Could you please:

 mkdir /tmp/md.metadata
 mdadm --dump /tmp/md.metadata /dev/md/alpha /dev/md/beta /dev/md/gamma
 tar czSf /tmp/md.tgz /tmp/md.metadata

and then send me /tmp/md.tgz, which should be tiny and contain just the
metadata from the array.

[[the patch which introduced the problem has a description which starts
    "This is a bit of a hack and ..."
  Never accept hacks!
]]

NeilBrown

--Sig_/dKnZQWq_FBNCq0utOW=RaXL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSRgoznsnt1WYoG5AQLk3Q/9H1qnJ/BH0FWM0aGOSZ93Y9gKk9AbWuEn
qh//FX3heUXt6wj99oOQGzany6HIc6Es3B9YPOUcbgJJIwxR7iv26yfwYSoJupS5
uvFE9iPrFor5BRq6acUuboSIfUL2E+fCJWfRqog+jkNAztvQVhl4acTN9usQFKwn
8IF/N561HzGlcrIUpKZM1l4qF24mQ7Z9nAGAeO/rJio2IrKx6ERvBclCgOTNll05
UeC/by0zf0ye4aq+rz/BIIyF6bUjUuK2JtwFtAM2nUBy6b7/7NgaIZo6GG921Jpv
FYSNGyDqGndoMQYqygTczsoGAlL6Y+1NH72vRHenhVq06iYs5p0xM7U9lkmXJ+GR
fPMBKe41OAbgoGXopg6NQq1AQ4Gq7Jo9ZyUiZuJSftZU4TqN6qaWeZ64aCPnHDx1
U9PRGPZAgCocjtDdmU2Jnel6qPvx5t2L8Q5eKChNWKCSMojZBTM5h4zf99oZA1FN
vv5Dsg16gk5ohBecTuNApwi3Kjq22owb3eqHxNdh6FIC0mw2Z+O0TeadQRPDwwB4
mJk8u3NkvuserNVaznJrSpeFB29P4xRrKmg7/BeJgEGSzSH00+HAkT8ZthsllsE6
S/RD0ZntXyH9/59Eu7j7kuj2F2762NjIVPF7htSCwtuxxQSvyv+CwCBaXVBTbA9T
Cd9Tgxne9Mk=
=d0D4
-----END PGP SIGNATURE-----

--Sig_/dKnZQWq_FBNCq0utOW=RaXL--
