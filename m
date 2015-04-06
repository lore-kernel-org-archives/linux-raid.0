From: NeilBrown <neilb@suse.de>
Subject: Re: Help recovering an interrupted raid0 reshape
Date: Tue, 7 Apr 2015 09:46:08 +1000
Message-ID: <20150407094608.4a9dd142@notabene.brown>
References: <CAC_83AFDEijn-7gNmnWNNabzcuPRMabNwr8xfRFt0xacsvZfog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/l9neKBq507yqpLCwZhpUIdm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC_83AFDEijn-7gNmnWNNabzcuPRMabNwr8xfRFt0xacsvZfog@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Jonathan Harker (Jesusaurus)" <jesusaurus@gentlydownthe.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/l9neKBq507yqpLCwZhpUIdm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 3 Apr 2015 19:22:15 -0700 "Jonathan Harker (Jesusaurus)"
<jesusaurus@gentlydownthe.net> wrote:

> I have a raid0 array whose component devices are raid1 arrays. In an
> attempt to expand the pre-existing raid0 array, I created a new raid1
> device and then added it, growing the raid0 array.
> But then the system lost power shortly after the reshaping began.
>=20
> After rebooting the original two components are listed as spares in an
> inactive raid4 array and the new component is not listed in
> /proc/mdstat:
>=20
>=20
> Personalities : [raid6] [raid5] [raid4] [raid1] [raid10] [raid0]
> [linear] [multipath]
> md124 : inactive md126[0](S) md127[1](S)
>       3907022200 blocks super 1.2
>=20
> md0 : active raid1 sda5[0] sdb2[1]
>       107652416 blocks [2/2] [UU]
>       bitmap: 1/1 pages [4KB], 65536KB chunk
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
>=20
>=20
> Looking at the details of the inactive array shows that it is in a
> reshape between raid0 and raid4:
>=20
>=20
> /dev/md124:
>         Version : 1.2
>      Raid Level : raid0
>   Total Devices : 2
>     Persistence : Superblock is persistent
>=20
>           State : inactive
>=20
>   Delta Devices : -1, (1->0)
>       New Level : raid4
>   New Chunksize : 512K
>=20
>            Name : hordern:hordern1  (local to host hordern)
>            UUID : 1f4979ba:c49a77c0:59e689c2:bcc21c0a
>          Events : 14013
>=20
>     Number   Major   Minor   RaidDevice
>=20
>        -       9      126        -        /dev/md/beta
>        -       9      127        -        /dev/md/alpha
>=20
>=20
> And examining each component shows that they have a consistent view of
> where in that reshape they are (based on the reshape position), but
> not consistent in the size of the array:
>=20
> /dev/md/alpha:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : 1f4979ba:c49a77c0:59e689c2:bcc21c0a
>            Name : hordern:hordern1  (local to host hordern)
>   Creation Time : Fri Jan  2 09:59:40 2009
>      Raid Level : raid4
>    Raid Devices : 3
>=20
>  Avail Dev Size : 3907021824 (1863.01 GiB 2000.40 GB)
>      Array Size : 3907021824 (3726.03 GiB 4000.79 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D1968 sectors, after=3D752 sectors
>           State : active
>     Device UUID : 63aaa2e4:2a09f495:8372c7f9:eb2f2773
>=20
>   Reshape pos'n : 129067008 (123.09 GiB 132.16 GB)
>   Delta Devices : -1 (4->3)
>=20
>     Update Time : Sun Mar 29 15:11:35 2015
>        Checksum : 8be5e0e6 - correct
>          Events : 14013
>=20
>      Chunk Size : 512K
>=20
>    Device Role : Active device 1
>    Array State : AA.. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
> /dev/md/beta:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : 1f4979ba:c49a77c0:59e689c2:bcc21c0a
>            Name : hordern:hordern1  (local to host hordern)
>   Creation Time : Fri Jan  2 09:59:40 2009
>      Raid Level : raid4
>    Raid Devices : 3
>=20
>  Avail Dev Size : 3907022576 (1863.01 GiB 2000.40 GB)
>      Array Size : 3907021824 (3726.03 GiB 4000.79 GB)
>   Used Dev Size : 3907021824 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D1968 sectors, after=3D752 sectors
>           State : clean
>     Device UUID : 6e6dce14:3ebb2bb5:187aa292:403a55f6
>=20
>   Reshape pos'n : 129067008 (123.09 GiB 132.16 GB)
>   Delta Devices : -1 (4->3)
>=20
>     Update Time : Sun Mar 29 15:11:35 2015
>        Checksum : f7526add - correct
>          Events : 14013
>=20
>      Chunk Size : 512K
>=20
>    Device Role : Active device 0
>    Array State : AA.. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
> /dev/md/gamma:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x6
>      Array UUID : 1f4979ba:c49a77c0:59e689c2:bcc21c0a
>            Name : hordern:hordern1  (local to host hordern)
>   Creation Time : Fri Jan  2 09:59:40 2009
>      Raid Level : raid4
>    Raid Devices : 4
>=20
>  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
>      Array Size : 5860532736 (5589.04 GiB 6001.19 GB)
>   Used Dev Size : 3907021824 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
> Recovery Offset : 86403072 sectors
>    Unused Space : before=3D1960 sectors, after=3D1953244160 sectors
>           State : active
>     Device UUID : 782873ea:e265ecd4:5cc80ddf:035ba2b4
>=20
>   Reshape pos'n : 129067008 (123.09 GiB 132.16 GB)
>   Delta Devices : 1 (3->4)
>=20
>     Update Time : Sun Mar 29 00:05:29 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 710dc078 - correct
>          Events : 673
>=20
>      Chunk Size : 512K
>=20
>    Device Role : Active device 2
>    Array State : AAA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
>=20
>=20
> When I stop the inactive array and try to assemble it from all three
> components, I get an error about the superblock on the third component
> not matching the other two components (which makes sense since the
> array sizes are different):
>=20
> hordern ~ # mdadm --verbose --verbose --assemble /dev/md/hordern1
> /dev/md/alpha /dev/md/beta /dev/md/gamma
> mdadm: looking for devices for /dev/md/hordern1
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
> mdadm: superblock on /dev/md/gamma doesn't match others - assembly aborted
>=20
>=20
> First, what could cause the initial two components to have a different
> superblock than the newly added component? And can I convince them to
> be the same?

Good question.  The important difference is this line:

>   Delta Devices : -1 (4->3)

>   Delta Devices : 1 (3->4)

Also "Raid Devices" are different.  This is what leads to the array size
being reported differently.

I don't know why this happened.  I'll have to hunt through the code.

>=20
> Second, is there documentation anywhere about the internal process of
> growing a raid0 array? Why does it convert to a raid4 array? And what
> do the Delta Devices lines mean?

- no documentation like that
- the  "raid0" module does support reshape.  The "raid5" module does.
  So the array is converted to a RAID4 with a missing parity device, then
  reshaped, then converted back.  It is just an internal detail really.
- "Delta devices" means that there is reshape happening that is changing
  then number of devices  - "delta" is a difference.
  It is clearly confused.


>=20
> Third, is it possible to resume the reshape? If not, can it be reverted?
>=20

I'll have to get back to you on that.  Hopefully you can be patient a little
longer.

NeilBrown



--Sig_/l9neKBq507yqpLCwZhpUIdm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSMawDnsnt1WYoG5AQIZmg//ell878MnZsKSHlcaNAMAGw1lqw2SwWqH
GnXXBdy0PdDZR1IgX9s6aZacSxB1duql5e7YUYml5FUMBfxLlMh0oOE6KWimBO3g
DkdNfgrwNNO/rv3RWZUuxv01Dm9f6GMyp+srRKTxvGPUQ9niEtf2SBcwDVacTQGZ
ntei8HooRjIO05Vc1Ym8kZxNS4rfkfDBuWQUEV/XhPB+RH/m2kq6oUBXNqdq31y5
F9fb+L+w5lUlCv8efMD7uA4f3MeRCyJB18ffHataDzNspKKMSmEMo9Y1+cdFdFpg
xN0/gsLg9NIpuBj/dgzbumkeGRQHWwcyUzSAGr9ZPqboWrIk1vGuagX0Bfp1pyff
tjLWg3y6+QoFPWex8UIaErB7zXTWarbWUBBCl1dPe2Qr/+hR1ZUM/AeM8t2PJyIN
hfB004kmyCLOZGzZz5FkfVugwZCF7uMJzGHhjslW3sPILDGASZPc+nrmHlJzpqvd
m9BVzkK8VosBV0XhYCY+Qf3aL2Q7NSiMmr0DxUhus878btXJ+idGwl0WWbutFg1D
R7TXR5EJYsi7CoYjAQ8VKfRkvauQcFRfZuU6DfZd1sJM0hpl7+VAEK2VDCfJskaV
SofSvdH5JwkmrMcrMzYK60qOr5uFYZ4Pxdw1QqPWo8JoaI8Ju/0/FG29NEI7wEpv
KVBWO85JI4I=
=5dNu
-----END PGP SIGNATURE-----

--Sig_/l9neKBq507yqpLCwZhpUIdm--
