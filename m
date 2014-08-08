From: NeilBrown <neilb@suse.de>
Subject: Re: need expert advice for growing raid10-array
Date: Fri, 8 Aug 2014 12:32:25 +1000
Message-ID: <20140808123225.02de1b5f@notabene.brown>
References: <201408060912.s769Cj3l024338@portal.naev.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/WJp8sJ1ox1sg2TlOEgDxBev"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201408060912.s769Cj3l024338@portal.naev.de>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Koch <mdraid.pkoch@dfgh.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WJp8sJ1ox1sg2TlOEgDxBev
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Aug 2014 11:12:45 +0200 mdraid.pkoch@dfgh.net (Peter Koch) wrote:

> Dear md experts,
>=20
> I was running a linux box with with a 16 slot SATA enclosure. The
> first two disks (sda + sdb, 160GB each) were used as a raid0-array
> (root, swap, etc.). The remaining 14 disks (2TB each) were used as
> a 13 disk raid10-array (sdc, sdd, ..., sdo) with one hotspare disk (sdp)
>=20
> No we needed more space and I upgraded my kernel to a newer version,
> replaced mdadm 3.2 with version 3.3, bought a second sata box with
> another 16 slots and 4 more 2TB disks.
>=20
> Since I now have 2 separate enclosures I wanted to separate the disks
> such that mirroring happens between the two enclosures.
>=20
> Now both enclosures contain 9 disks, sda to sdi in the first box
> and sdj to sdr in the second box.
>=20
> The former sda and sdb now is sda and sdj. And here are the positions
> of the 14 raid10-disks plus 2 new disks:
>=20
> disk00 (formerly /dev/sdc) moved to box1, now sdb
> disk01 (formerly /dev/sdd) moved to box2, now sdk
> disk02 (formerly /dev/sde) moved to box1, now sdc
> disk03 (formerly /dev/sdf) moved to box2, now sdl
> disk04 (formerly /dev/sdg) moved to box1, now sdd
> disk05 (formerly /dev/sdh) moved to box2, now sdm
> disk06 (formerly /dev/sdi) moved to box1, now sde
> disk07 (formerly /dev/sdj) moved to box2, now sdn
> disk08 (formerly /dev/sdk) moved to box1, now sdf
> disk09 (formerly /dev/sdl) moved to box2, now sdo
> disk10 (formerly /dev/sdm) moved to box1, now sdg
> disk11 (formerly /dev/sdn) moved to box2, now sdp
> disk12 (formerly /dev/sdo) moved to box1, now sdh
> spare0 (formerly /dev/sdp) moved to box2, now sdq
> new disk in box1, now sdi
> new disk in box2, now sdr
>=20
> I wanted to grow the the raid10-array to 16 disks and
> then add to two hot spares (one in each box)
>=20
> I therefore added /dev/sdi and /dev/sdr with the follwowing
> command:
>=20
> mdadm /dev/md5 --add /dev/sdi /dev/sdr
>=20
> After that my raid10-array had 3 hot spares. I did not check
> the order of the hot spares but assumed it was sdq sdi sdr
>=20
> I then did
>=20
> mdadm --grow /dev/md5 --raid-devices=3D16
>=20
> And here's what the situation is now:
>=20
> Info from /proc/mdstat:
> md5 : active raid10 sdb[0] sdi[14] sdq[13] sdr[15] sdh[12] sdp[11] sdg[10=
] sdo[9] sdf[8] sdn[7] sde[6] sdm[5] sdd[4] sdl[3] sdc[2] sdk[1]
>       12696988672 blocks super 1.2 512K chunks 2 near-copies [16/16] [UUU=
UUUUUUUUUUUUU]
>       [=3D=3D>..................]  reshape =3D 13.1% (1663374208/12696988=
672) finish=3D892.4min speed=3D206060K/sec
>=20
> Output from mdadm -D:
> /dev/md5:
>         Version : 1.2
>   Creation Time : Sun Feb 10 16:58:10 2013
>      Raid Level : raid10
>      Array Size : 12696988672 (12108.79 GiB 13001.72 GB)
>   Used Dev Size : 1953382912 (1862.89 GiB 2000.26 GB)
>    Raid Devices : 16
>   Total Devices : 16
>     Persistence : Superblock is persistent
>=20
>     Update Time : Tue Aug  5 19:03:46 2014
>           State : clean, reshaping
>  Active Devices : 16
> Working Devices : 16
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : near=3D2
>      Chunk Size : 512K
>=20
>  Reshape Status : 13% complete
>   Delta Devices : 3, (13->16)
>=20
>            Name : backup:5  (local to host backup)
>            UUID : 9030ff07:6a292a3c:26589a26:8c92a488
>          Events : 787
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       16        0      active sync set-A   /dev/sdb
>        1       8      160        1      active sync set-B   /dev/sdk
>        2       8       32        2      active sync set-A   /dev/sdc
>        3       8      176        3      active sync set-B   /dev/sdl
>        4       8       48        4      active sync set-A   /dev/sdd
>        5       8      192        5      active sync set-B   /dev/sdm
>        6       8       64        6      active sync set-A   /dev/sde
>        7       8      208        7      active sync set-B   /dev/sdn
>        8       8       80        8      active sync set-A   /dev/sdf
>        9       8      224        9      active sync set-B   /dev/sdo
>       10       8       96       10      active sync set-A   /dev/sdg
>       11       8      240       11      active sync set-B   /dev/sdp
>       12       8      112       12      active sync set-A   /dev/sdh
>       14       8      128       13      active sync set-B   /dev/sdi
>       13      65        0       14      active sync set-A   /dev/sdq
>       15      65       16       15      active sync set-B   /dev/sdr
>=20
> Now here are my questions: What's the meaning of sync set-A
> and sync set-B. Seems like set-B contains the mirrors of set-A.

It's not "sync set-A", it is "active" and "sync" and  "set-A".
When you have a RAID10 that can be seen as two sets of devices where one set
is mirrored to the other, they are labels as "set-A" and  "set-B", just like
you assumed.

> But if this was true then disk-13 and disk-14 somehow were
> swapped.

Probably.

>=20
> What's the difference between column 1 and column 4 in
> mdadm -D output?

column 1 identified the device.  column 4 give the role that the device pla=
ys
in the array.
This seemed to make sense once, but it could be more confusing than helpful.


>=20
> Should I have done:
>=20
> mdadm /dev/md5 --add /dev/sdi
> mdadm /dev/md5 --add /dev/sdr
>=20
> instead of:
>=20
> mdadm /dev/md5 --add /dev/sdi /dev/sdr

That would have had the safe effect.  If you have given them in a different
order it might have behaved differently.


>=20
> If one of my disk-enclosures will completely fail - will my raid10
> array still be usable? Or must I swap disk 13 with disk 14 to
> correctly separate the mirrors.

Physically swapping '13' and '14' is probably a good idea.


I should probably add some 'policy' construct so you can associate 'sets'
with controllers, but it hasn't happened yet.

NeilBrown

>=20
> Kind regards
>=20
> Peter Koch
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/WJp8sJ1ox1sg2TlOEgDxBev
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+Q2uTnsnt1WYoG5AQLW0A//f3YpeiDKDRzmsA6OjCl6DIhT99sV3N14
rV2gotD/9gX7T+k13OlzEHyq/wH58y2/ckfzg0/FHBBgNgphmNfO2x8uqJvEXlA8
hJUYm0DFBd5cynz+hrxc5ixUr9yeeRe3C8su06VEDsrkJyFMgCQqMmpJESdS3NJB
83QzEL3RWenp6uan7J2m98iXGLXR0HN4wF32cv0H/uz7mvuCqaR3NOxqSi33RTXx
iY9oHtKR/bnpxrQzKTwtYPBoN+k4jYD5zYPK/FZaDVCFma9Fj2qZCGKjdihCkPtP
PmV6fuED/jmHNN1vOpHYa0M7HA9wp3KbuHb9H2Wj17aB5Hw9gcZBh3vX2OdfYdWp
+tdu+3FkkGuyRYCRR3HtHx2J0Ooi8aJ4RiO3jDXIrq+ot96XxbJ4yVsaFVED91N1
rgH1n2SwuPoLvtUuttQU0DYZkE1nvdUxYi2m6774m59taIa4k/xyQ2GpIPc7WA0T
6UTtKnBDL9liF9eiXPhGDkYURxrqeFhCb2fFeuZKhGxi5VSNrcxEiVojardRyv5U
TUHWdfb8adUg4N3kHc0lFBC0tddxi1LbtLbsg4Pu0IS8gyAOnkmgGUTJefpznyT5
qKU0HNCeRUQJ6oowmdpuFKm6vgEGdm4gx96Y8gOCazQ5ODMUuXt/V7l34DNWtfJP
/BPmyI1zyGI=
=THWd
-----END PGP SIGNATURE-----

--Sig_/WJp8sJ1ox1sg2TlOEgDxBev--
