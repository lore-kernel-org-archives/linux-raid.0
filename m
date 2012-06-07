From: NeilBrown <neilb@suse.de>
Subject: Re: degraded raid 6 (1 bad drive) showing up inactive, only spares
Date: Thu, 7 Jun 2012 22:29:33 +1000
Message-ID: <20120607222933.14ec3cd5@notabene.brown>
References: <B5902F16-9C82-4072-BD67-FC6D6488ADB7@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LluiLMUXORbpoHBh4gRdYVV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B5902F16-9C82-4072-BD67-FC6D6488ADB7@googlemail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Ziler <martin.ziler@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/LluiLMUXORbpoHBh4gRdYVV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Jun 2012 13:55:32 +0200 Martin Ziler <martin.ziler@googlemail.com>
wrote:

> Hello everybody,
>=20
> I am running a 9-disk raid6 without hot spares. I already had one drive g=
o bad, which I could replace and continue using the array without any degra=
ded raid messages. Recently I had another drive going bad by the smart-info=
. As it wasn't quite dead I left the array as was without really using it a=
ll that much waiting for a replacement drive I ordered. As I booted the mac=
hine up in order to replace the drive I was greeted by an inactive array wi=
th all devices showing up as spares.
>=20
> md0 : inactive sdh2[0](S) sdi2[7](S) sde2[6](S) sdd2[5](S) sdf2[1](S) sdg=
2[2](S) sdc1[9](S) sdb2[3](S)
>       15579088439 blocks super 1.2
>=20
> mdadm --examine confirms that. I already searched the web quite a bit and=
 found this mailing list. Maybe someone in here can give me some input. Nor=
mally a degraded raid should still be active. So I am quite surprised that =
my array with only one drive missing goes inactive. I appended the info mda=
dm --examine puts out for all the drives. However the first two should prob=
ably suffice as only /dev/sdk differs from the rest. The faulty drive - sdk=
 - is still recognized as a raid6 member, wheres all the others show up as =
spares. With lots of bad sectors sdk isn't accessible anymore.=20

You must be running 3.2.1 or 3.3 (I think).

You've been bitten by a rather nasty bug.

You can get your data back, but it will require a bit of care, so don't rush
it.

The metadata on almost all the devices have been seriously corrupted.  The
only way to repair it is to recreate the array.
Doing this just writes new metadata and assembles the array.  It doesn't to=
uch
the data so if we get the --create command right, all your data will be
available again.
If we get it wrong, you won't be able to see your data, but we can easily s=
top
the array and create again with different parameters until we get it right.

First thing to do it to get a newer kernel.  I would recommend the latest in
the 3.3.y series.

Then you need to:
 - make sure you have a version of mdadm which gets the data offset to 1M
   (2048 sectors).  I think 3.2.3 or earlier does that - don't upgrade to
   3.2.5.
 - find the chunk size - looks like it is 4M, as sdk2 isn't corrupt.
 - find the order of devices.  This should be in your kernel logs in=20
    "RAID conf printout".  Hopefully device names haven't changed.

 Then (with new kernel running)

  mdadm --create /dev/md0 -l6 -n9 -c 4M -e 1.2 /dev/sdb2 /dev/sdc2 /dev/sdd=
2 \
     /dev/sde2 /dev/sdf2 /dev/sdg2 /dev/sdh2 /dev/sdi2 missing \
     --assume-clean

 Make double-sure you add that --assume-clean.

 Note the last device is 'missing'. That corresponds to sdk2 (which we=20
 know is device 8 - the last of 9 (0..8)).  It fails so it not part of the
 array any more.  The others I just guessed the order.  You should try to
 verify it before you proceed (see RAID conf printout in kernel logs).

 After the 'create' use "mdadm -E" to look at one device and make sure
 the Data Offset, Avail Dev Size and Array Size are the same as we saw
 on sdk2.
 If it is, try "fsck -n /dev/md0". That assumes ext3 or ext4.  If you had
 something else on the array some other command might be needed.

 If that looks bad, "mdadm -S /dev/md0" and try again with a different orde=
r.
 If it looks good, "echo check > /sys/block/md0/md/sync_action" and watch
  "mismatch_cnt" in the same directory.  If it says low (few hundred at mos=
t)=20
 all is good.  If it goes up to thousands something is wrong - try another
 order.

 Once you have the array working again,
    "echo repair > /sys/block/md0/md/sync_action"
 then add your new device to be rebuilt.

Good luck.
Please ask if you are unsure about anything.

NeilBrown

>=20
>=20
> /dev/sdk2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
>            Name : server:0  (local to host server)
>   Creation Time : Mon Jul 25 23:40:50 2011
>      Raid Level : raid6
>    Raid Devices : 9
>=20
>  Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
>      Array Size : 27172970496 (12957.08 GiB 13912.56 GB)
>   Used Dev Size : 3881852928 (1851.01 GiB 1987.51 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 882eb11a:33b499a7:dd5856b7:165f916c
>=20
>     Update Time : Fri Jun  1 20:26:45 2012
>        Checksum : b8c58093 - correct
>          Events : 623119
>=20
>          Layout : left-symmetric
>      Chunk Size : 4096K
>=20
>    Device Role : Active device 8
>    Array State : AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
>=20
> /dev/sdh2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
>            Name : server:0  (local to host server)
>   Creation Time : Mon Jul 25 23:40:50 2011
>      Raid Level : -unknown-
>    Raid Devices : 0
>=20
>  Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 44008309:1dfb1408:cabfbd0a:64de3739
>=20
>     Update Time : Thu Jun  7 12:27:52 2012
>        Checksum : 27f93899 - correct
>          Events : 2
>=20
>    Device Role : spare
>    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> -------------------------------------------------------------------------=
--------------------------------------
>=20
> /dev/sdi2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
>            Name : server:0  (local to host server)
>   Creation Time : Mon Jul 25 23:40:50 2011
>      Raid Level : -unknown-
>    Raid Devices : 0
>=20
>  Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 135f196d:184f11a1:09207617:4022e1a5
>=20
>     Update Time : Thu Jun  7 12:27:52 2012
>        Checksum : 9ded8f86 - correct
>          Events : 2
>=20
>=20
>    Device Role : spare
>    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sde2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
>            Name : server:0  (local to host server)
>   Creation Time : Mon Jul 25 23:40:50 2011
>      Raid Level : -unknown-
>    Raid Devices : 0
>=20
>  Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 3517bcc4:2acb381f:f5006058:5bd5c831
>=20
>     Update Time : Thu Jun  7 12:27:52 2012
>        Checksum : 408957c0 - correct
>          Events : 2
>=20
>=20
>    Device Role : spare
>    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdd2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
>            Name : server:0  (local to host server)
>   Creation Time : Mon Jul 25 23:40:50 2011
>      Raid Level : -unknown-
>    Raid Devices : 0
>=20
>  Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 9e8b2d2c:844a009a:fd6914a2:390f10ac
>=20
>     Update Time : Thu Jun  7 12:27:52 2012
>        Checksum : e6bdee68 - correct
>          Events : 2
>=20
>=20
>    Device Role : spare
>    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdf2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
>            Name : server:0  (local to host server)
>   Creation Time : Mon Jul 25 23:40:50 2011
>      Raid Level : -unknown-
>    Raid Devices : 0
>=20
>  Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 87ad38ac:4ccbd831:ee5502cd:28dafaad
>=20
>     Update Time : Thu Jun  7 12:27:52 2012
>        Checksum : 2b7a47f6 - correct
>          Events : 2
>=20
>=20
>    Device Role : spare
>    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdg2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
>            Name : server:0  (local to host server)
>   Creation Time : Mon Jul 25 23:40:50 2011
>      Raid Level : -unknown-
>    Raid Devices : 0
>=20
>  Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : eef2f06f:28f881a5:da857a00:fb90e250
>=20
>     Update Time : Thu Jun  7 12:27:52 2012
>        Checksum : 393ba0f8 - correct
>          Events : 2
>=20
>=20
>    Device Role : spare
>    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
>            Name : server:0  (local to host server)
>   Creation Time : Mon Jul 25 23:40:50 2011
>      Raid Level : -unknown-
>    Raid Devices : 0
>=20
>  Avail Dev Size : 3985162143 (1900.27 GiB 2040.40 GB)
>   Used Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 4cf86fb0:6f334e2c:19e89c99:0532f557
>=20
>     Update Time : Thu Jun  7 12:27:52 2012
>        Checksum : a6e42bdc - correct
>          Events : 2
>=20
>=20
>    Device Role : spare
>    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdb2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
>            Name : server:0  (local to host server)
>   Creation Time : Mon Jul 25 23:40:50 2011
>      Raid Level : -unknown-
>    Raid Devices : 0
>=20
>  Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 4852882a:b8a3989f:aad747c5:25f20d47
>=20
>     Update Time : Thu Jun  7 12:27:52 2012
>        Checksum : a8e25edd - correct
>          Events : 2
>=20
>=20
>    Device Role : spare
>    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/LluiLMUXORbpoHBh4gRdYVV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9CerTnsnt1WYoG5AQKpfQ//X8MNSKLl0sRNavWPwtsWKG4fTWsJr6pc
/bUMEjGf5l8IYPfA+oUjERKbcIicehxAlQ21SB3vacAxnJ9xx+9+OEYfvTIKwbqS
0gWEAWyCdErPSkTLfM69JRwpNj8RXXxIIbP0GptOtQClZCPxdD9+wFp50yb+LqSH
DUrhFIvH0yhlOVTA9BVXAEJ9lNhlZwsFs/qRtL3BlTX9/vvHoeYcab4bD2QRknYF
Sqlo63sQFhdeFWEVWReB95tUeAv4NzpF4m7Uk1c2oa5mR40wTV1YD3wgZJjVxSRN
LxshUYaGdquFexz4ik5Gs5rn7zlJrbTQITyyThVl+KJq+QR+gr0BcctXLyiVFDue
iVqs4fxPm5J/HwAjGyWJC3EC/bsJvm7zpvYVDpHGINmw+c1wOoeXx18CJXI7MoN0
hTnsNvV97n+x0k3PLZRacSr++9MeRx26aI5iZYKIpz4t4+SuvwwNeXoMFz3B/eSt
fQG0+81TEQAojq6bje2+4OPY8+ZkGbfeTT6VZuwOvVA1/gUAMcKgqdY6ssJns46A
USxuhGL8XMp2iNV6t8EOGDu2koq0FFJJCVVPtQOR8WtMLrmxsskrZNTKg517HjeV
mCLNhOCe9TtLXkcudh3m2zTjhWzoI2FFFVARic++oCVChmUfSED6kr6ltxKTXXLs
LQM1gfvRGYQ=
=JiiB
-----END PGP SIGNATURE-----

--Sig_/LluiLMUXORbpoHBh4gRdYVV--
