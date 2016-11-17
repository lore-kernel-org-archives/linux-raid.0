From: NeilBrown <neilb@suse.com>
Subject: Re: Newly-created arrays don't auto-assemble - related to hostname change?
Date: Thu, 17 Nov 2016 17:09:28 +1100
Message-ID: <87lgwihc2v.fsf@notabene.neil.brown.name>
References: <20161117035230.GG21587@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161117035230.GG21587@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 17 2016, Andy Smith wrote:

> Hi,
>
> I feel I am missing something very simple here, as I usually don't
> have this issue, but here goes=E2=80=A6
>
> I've got a Debian jessie host on which I created four arrays during
> install (md{0,1,2,3}), using the Debian installer and partman. These
> auto-assemble fine.
>
> After install the name of the server was changed from "tbd" to
> "jfd". Another array was then created (md5), added to
> /etc/mdadm/mdadm.conf and the initramfs was rebuilt
> (update-initramfs -u).
>
> md5 does not auto-assemble. It can be started fine after boot with:
>
>     # mdadm --assemble /dev/md5
>
> or:
>
>     # mdadm --incremental /dev/sdc
>     # mdadm --incremental /dev/sdd

This is almost exactly what udev does when the devices are discovered,
so if it works here, it should work when udev does it.

My only guess is that maybe the "DEVICE /dev/sd*" line in the mdadm.conf
is causing confusion.  udev might be using a different name, though that
would be odd.

Can you try removing that line and see if it makes a difference?

NeilBrown


>
> /etc/mdadm/mdadm.conf:
>
>     DEVICE /dev/sd*
>     CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
>     HOMEHOST <ignore>
>     MAILADDR root
>     ARRAY /dev/md/0  metadata=3D1.2 UUID=3D400bac1d:e2c5d6ef:fea3b8c8:bcb=
70f8f
>     ARRAY /dev/md/1  metadata=3D1.2 UUID=3De29c8b89:705f0116:d888f77e:2b6=
e32f5
>     ARRAY /dev/md/2  metadata=3D1.2 UUID=3D039b3427:4be5157a:6e2d53bd:fe8=
98803
>     ARRAY /dev/md/3  metadata=3D1.2 UUID=3D30f745ce:7ed41b53:4df72181:740=
6ea1d
>     ARRAY /dev/md/5  metadata=3D1.2 UUID=3D957030cf:c09f023d:ceaebb27:e54=
6f095
>
> I've unpacked the initramfs and looked at the mdadm.conf in there
> and it is identical.
>
> Initially HOMEHOST was set to <system> (the default), but I noticed
> when looking at --detail that md5 has:
>
>            Name : jfd:5  (local to host jfd)
>
> whereas the others have:
>
>            Name : tbd:0
>
> =E2=80=A6so I changed it to <ignore> to see if that would help. It didn't.
>
> So, I'd really appreciate any hints as to what I've missed here!
>
> Here follows --detail and --examine of md5 and its members, then the
> contents of /proc/mdstat after I have manually assembled md5.
>
> $ sudo mdadm --detail /dev/md5
> /dev/md5:
>         Version : 1.2
>   Creation Time : Thu Nov 17 02:35:15 2016
>      Raid Level : raid10
>      Array Size : 1875243008 (1788.37 GiB 1920.25 GB)
>   Used Dev Size : 1875243008 (1788.37 GiB 1920.25 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>
>   Intent Bitmap : Internal
>
>     Update Time : Thu Nov 17 02:35:15 2016
>           State : clean=20
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : far=3D2
>      Chunk Size : 512K
>
>            Name : jfd:5  (local to host jfd)
>            UUID : 957030cf:c09f023d:ceaebb27:e546f095
>          Events : 0
>
>     Number   Major   Minor   RaidDevice State
>        0       8       48        0      active sync   /dev/sdd
>        1       8       32        1      active sync   /dev/sdc
>
> $ sudo mdadm --examine /dev/sd{c,d}
> /dev/sdc:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 957030cf:c09f023d:ceaebb27:e546f095
>            Name : jfd:5  (local to host jfd)
>   Creation Time : Thu Nov 17 02:35:15 2016
>      Raid Level : raid10
>    Raid Devices : 2
>
>  Avail Dev Size : 3750486704 (1788.37 GiB 1920.25 GB)
>      Array Size : 1875243008 (1788.37 GiB 1920.25 GB)
>   Used Dev Size : 3750486016 (1788.37 GiB 1920.25 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D262056 sectors, after=3D688 sectors
>           State : clean
>     Device UUID : 4ac82c29:2d109465:7fff9b22:8c411c1e
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Thu Nov 17 02:35:15 2016
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 96d669f1 - correct
>          Events : 0
>
>          Layout : far=3D2
>      Chunk Size : 512K
>
>    Device Role : Active device 1
>    Array State : AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)
> /dev/sdd:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 957030cf:c09f023d:ceaebb27:e546f095
>            Name : jfd:5  (local to host jfd)
>   Creation Time : Thu Nov 17 02:35:15 2016
>      Raid Level : raid10
>    Raid Devices : 2
>  Avail Dev Size : 3750486704 (1788.37 GiB 1920.25 GB)
>      Array Size : 1875243008 (1788.37 GiB 1920.25 GB)
>   Used Dev Size : 3750486016 (1788.37 GiB 1920.25 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D262056 sectors, after=3D688 sectors
>           State : clean
>     Device UUID : 3a067652:6e88afae:82722342:0036bae0
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Thu Nov 17 02:35:15 2016
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : eb608799 - correct
>          Events : 0
>
>          Layout : far=3D2
>      Chunk Size : 512K
>
>    Device Role : Active device 0
>    Array State : AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)
>
> $ cat /proc/mdstat=20
> Personalities : [raid1] [raid10]=20
> md5 : active (auto-read-only) raid10 sdd[0] sdc[1]
>       1875243008 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
>       bitmap: 0/14 pages [0KB], 65536KB chunk
>
> md3 : active raid10 sda5[0] sdb5[1]
>       12199936 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
>=20=20=20=20=20=20=20
> md2 : active (auto-read-only) raid10 sda3[0] sdb3[1]
>       975872 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
>=20=20=20=20=20=20=20
> md1 : active raid10 sda2[0] sdb2[1]
>       1951744 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
>=20=20=20=20=20=20=20
> md0 : active raid1 sda1[0] sdb1[1]
>       498368 blocks super 1.2 [2/2] [UU]
>=20=20=20=20=20=20=20
> unused devices: <none>
>
> Cheers,
> Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLUmYAAoJEDnsnt1WYoG5zVYQALzf/t9USSc5AYB7YKbZ9SJa
e2uyLKc7otDVe8pB3dXlpbLJwNxugUitcfFvTqkRVVLywXsaU+PANv8GdpddOhGB
7fDxafDm4cg53gA+imQuswxmYEgHRpsknS3Sl0BnEmByqIFXB7gY3V8dYFa1i89X
cMkk1PteJem4y0jN86MFq23EQwZyFe2+PNLzxiLW6g9c8jw0ckNQ7/X64gVgAdVm
W2o3WjN7t4tJhlkxSr7T/tjF2Pan/6itsJkAJFa3wxbQ0IxW3ca34vPMegj5lSn/
y6Owvgp6jvfKRsrlGWfYsNTx+GT8zuZxXL4QmWc3Qi06v+ce0gAxypm0tTjl2kWY
IkHfpOP5bXDRsg3W5uPHpHHB282fXDxWqWC8G4cZO1HRFE8eiPW81K0yjgUuXk0D
sdLGT4WofhYHnWOt0AlGhfuWLwd/PJzthZjC7L/2HuDCJs6mIGpvyr6BW9+MEESJ
vfslSxhsJesp5vfTA8Wn2WH63U6kjsiFYFHChsdP5w0OfJGmu1Zlx2DLsQFu24OB
PU5nXh76K9kY4xg0A7MXn7yErUK/vNJnbl1xZYYdqGHzEXuJ3zUAW/l0FDuPUEmB
bqJUF1DXUppOkFlzynDtmL52qTWSyTdMqfKL+TJhc/Q0cnq+FHqj70aeseW5kM2y
sCyvMl4ZZJqV0NmWTg0X
=y4rw
-----END PGP SIGNATURE-----
--=-=-=--
