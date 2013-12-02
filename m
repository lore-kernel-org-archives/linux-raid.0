From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm No md superblock detected
Date: Mon, 2 Dec 2013 17:18:39 +1100
Message-ID: <20131202171839.125c378d@notabene.brown>
References: <6A48F5BB-7F74-4898-9C25-BC8E5B05AB31@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1a0Z2YQN3VClAT+x.xZZBmT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6A48F5BB-7F74-4898-9C25-BC8E5B05AB31@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Teitur Ingi Sigurdsson <teitso@gmail.com>
Cc: david@dgreaves.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1a0Z2YQN3VClAT+x.xZZBmT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 30 Nov 2013 02:33:24 +0000 Teitur Ingi Sigurdsson <teitso@gmail.com>
wrote:

> Hi there
>=20
> I tried sending to linux-raid@vger.kernel.org about 10 days ago but got n=
o answer, your guys are probably just busy but incase you did not get the e=
mail i=E2=80=99m sending it here as well.
>=20
> Hi there and thanks for your service
>=20
> I=E2=80=99m having a problem with my 4x 2tb raid 5 mdadm array.
>=20
> After an unexpected shutdown my machine booted into dos busybox, when i t=
yped exit I got the ubuntu(12.04) logo and a message telling me it could no=
t mount my raid drive so I pressed S to skip it.
>=20
> The first thing I did was to do a complete long test with seagate sea too=
ls to check all my hard drives for errors and all the drives are ok.
>=20
> I found out that 2 of my drives where not assembling into the array.
>=20
> When I tried to assemble the array it told me on these two drives there w=
ere no md superblocks detected.
>=20
> I started googling around and trying to find a solution to the problem , =
found lots of forums and people with similar problems,
>=20
> When I tried : sudo mdadm =E2=80=94assemble =E2=80=94scan in the first pl=
ace it responded that i had duplicate UUID in my mdadm config file. So I lo=
oked at the config file and found these 2 UUID :
> ARRAY /dev/md0 level=3Draid5 num-devices=3D3 UUID=3Df7783df2:bc896dcc:9c7=
29cd1:10366cce
> ARRAY /dev/md0 level=3Draid5 num-devices=3D3 UUID=3D48877e00:48c5e221:9c7=
29cd1:10366cce
>=20
> the weird thing here is that the number of devices here are 3 not 4 like =
I have always been using, at least I=E2=80=99ve been using 4 2 tb drives to=
 get about 6 tb of space in an array in raid 5, not that it really matters =
anyways, tried changing it but nothing happens when i execute the command :=
 sudo mdadm =E2=80=94assemble =E2=80=94scan , don=E2=80=99t know why that i=
s, maybe there is another config file I don=E2=80=99t know about
>=20
> anyways=E2=80=99 i got this command from somebody with a similar problem =
: sudo mdadm =E2=80=93examine =E2=80=93scan =E2=80=93config=3Dmdadm.conf >>=
 /etc/mdadm/mdadm.conf
> and got some UUID copy-ed into my config file and tried the scan again bu=
t it did not work.
>=20
> I=E2=80=99ve tried so far : root@tserver:~# mdadm --create /dev/md0 --ver=
bose --level=3D5 --raid-devices=3D4 /dev/sdd missing /dev/sdc missing=20
> and got this response: mdadm: layout defaults to left-symmetric
> mdadm: layout defaults to left-symmetric
> mdadm: chunk size defaults to 512K
> mdadm: /dev/sdd appears to contain an ext2fs file system
>   size=3D1565576192K  mtime=3DSat Nov  9 20:54:11 2013
> mdadm: /dev/sdd appears to be part of a raid array:
>   level=3Draid5 devices=3D4 ctime=3DTue Jan 11 00:26:47 2011
> mdadm: /dev/sdc appears to be part of a raid array:
>   level=3Draid5 devices=3D4 ctime=3DTue Jan 11 00:26:47 2011
> mdadm: size set to 1953382912K
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: RUN_ARRAY failed: Input/output error
>=20
> i was afraid that the create command could erase my data but some people =
in the same position suggested it was okay.
>=20
> I=E2=80=99ve tried the UUID assemble command and nothing happens : mdadm =
--assemble /dev/md# --uuid=3D<UUID>
>=20
> here is my mdadm =E2=80=94examine :=20
> root@tserver:~# mdadm --examine /dev/sda
> mdadm: No md superblock detected on /dev/sda.
> root@tserver:~# mdadm --examine /dev/sda1
> mdadm: cannot open /dev/sda1: No such file or directory
> root@tserver:~# mdadm --examine /dev/sda
> mdadm: No md superblock detected on /dev/sda.
> root@tserver:~# mdadm --examine /dev/sdc
> /dev/sdc:
>         Magic : a92b4efc
>       Version : 1.2
>   Feature Map : 0x0
>    Array UUID : 3e74cf9b:b49ecf15:98722946:b19b30b6
>          Name : tserver:0  (local to host tserver)
> Creation Time : Mon Nov 18 23:05:33 2013
>    Raid Level : raid5
>  Raid Devices : 4
>=20
> Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>    Array Size : 5860148736 (5588.67 GiB 6000.79 GB)
> Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>   Data Offset : 262144 sectors
>  Super Offset : 8 sectors
>         State : clean
>   Device UUID : 3c5cb8d9:072a09df:72a9bf89:fa579762
>=20
>   Update Time : Mon Nov 18 23:05:33 2013
>      Checksum : 1fe51ccc - correct
>        Events : 0
>=20
>        Layout : left-symmetric
>    Chunk Size : 512K
>=20
>  Device Role : Active device 2
>  Array State : A.A. ('A' =3D=3D active, '.' =3D=3D missing)
> root@tserver:~# mdadm --examine /dev/sdd
> /dev/sdd:
>         Magic : a92b4efc
>       Version : 1.2
>   Feature Map : 0x0
>    Array UUID : 3e74cf9b:b49ecf15:98722946:b19b30b6
>          Name : tserver:0  (local to host tserver)
> Creation Time : Mon Nov 18 23:05:33 2013
>    Raid Level : raid5
>  Raid Devices : 4
>=20
> Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>    Array Size : 5860148736 (5588.67 GiB 6000.79 GB)
> Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>   Data Offset : 262144 sectors
>  Super Offset : 8 sectors
>         State : clean
>   Device UUID : 9a96576f:4fba1e25:7077591b:c9987f29
>=20
>   Update Time : Mon Nov 18 23:05:33 2013
>      Checksum : 541bf63b - correct
>        Events : 0
>=20
>        Layout : left-symmetric
>    Chunk Size : 512K
>=20
>  Device Role : Active device 0
>  Array State : A.A. ('A' =3D=3D active, '.' =3D=3D missing)
> root@tserver:~# mdadm --examine /dev/sde
> mdadm: No md superblock detected on /dev/sde.
>=20
>=20
> and sudo fdisk -l :=20
> sudo fdisk -l
>=20
>=20
> Disk /dev/sda: 2000.4 GB, 2000397852160 bytes
> 255 heads, 63 sectors/track, 243201 cylinders, total 3907027055 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>=20
> Disk /dev/sda doesn't contain a valid partition table
>=20
> Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>=20
> Disk /dev/sdc doesn't contain a valid partition table
>=20
> Disk /dev/sde: 2000.4 GB, 2000397852160 bytes
> 255 heads, 63 sectors/track, 243201 cylinders, total 3907027055 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>=20
> Disk /dev/sde doesn't contain a valid partition table
>=20
> Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>=20
> Disk /dev/sdd doesn't contain a valid partition table
>=20
> Disk /dev/sdb: 500.1 GB, 500107862016 bytes
> 255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00026ec6
>=20
>  Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1   *        2048   937164799   468581376   83  Linux
> /dev/sdb2       937166846   976771071    19802113    5  Extended
> /dev/sdb5       937166848   976771071    19802112   82  Linux swap / Sola=
ris
>=20
>=20
> can you suggest anything?
>=20
> My goal is to be able to re arrange my array without any data loss :)

Unfortunately you seem to have made a mess of things.
That --create command wasn't a very clever idea.  You list 2 devices as
'missing' which of course cannot work with RAID5, so it is no surprise that
it didn't work.

At a guess I'd say that you originally create the array on partitions, and
now you are working with the whole-disk devices, which just adds to the
confusion.

But maybe you used whole disks - I can't really tell.

I think your only option at this point is to try --creating the array in
various combinations with 3 devices and 1 'missing' and then look at the
content (maybe with 'fsck -n') until you find something that works.

Did you have any backups? :-(

NeilBrown

--Sig_/1a0Z2YQN3VClAT+x.xZZBmT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpwmPznsnt1WYoG5AQKHvg/+Mi+EvmXvmlsvCI1refqb4XQOXqq/ykm/
Bz/x9ZIkphx0YvEX+HVfmUA7O0Dxit7TaOXG3ofJhgPMFlCTVFO1zqcf3C2/MNhN
hRAw1uJLA4mmrTbSryoVRfsWn9XqADN0keiqv2UAuBp+uaoJs7/Z+pvKqR26waox
IMpWTGwjzuUhAaCfvQQpeC7ktiOzHxNS82VQF9864Z756H6Qi7E8kS8SgHybrWsw
q+XP1BAmqPEjTclL0h0rXUl6jQByReAE6HIVi0IqPCD1TZ4uRkXUBPWqagSPgfRc
dvnLt8W2joSqXbJo9Rwh3tsHJwUiLaQQB9ZIBCoyUavNrNrNqg5YhI1xl7JIhCul
lMzA2NU2u7K7cmIKRKhhM11ak/faLl7DfDKMaRF2U2gn7K4NkNfsmrbjirBzLioK
JGEqWhXEf2N6nHywSj0Cx+5VVEeL8rrK7D75KofyQwQEybc1p4c3QfU/IIxxMFuE
B8zwTirI2JzEzqrZNOwEXn5TJe2AxXMWS9mV1uscFK6uhL/6yuoFQBNpihWmiyLe
BkqGPaJC+T8rn/Q5L1qY/INSyV9R/jtHi4PSiUT7rudOrFtzEPXm1MN/Z6pR/9Q2
MFhSLpxdIfLMrwKCU48oBRmp/ReGFFSmKuSgUiAJOKXUDcwIaOfVm4e80QCuvFpG
ZM5KlryLSHA=
=OuhJ
-----END PGP SIGNATURE-----

--Sig_/1a0Z2YQN3VClAT+x.xZZBmT--
