From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 issues
Date: Tue, 13 Sep 2011 08:25:11 +0200
Message-ID: <20110913082511.3c34dec9@notabene.brown>
References: <CAGZH0-dz9y5=vH7PQr8VRy15i1WsuAxKjPPpmx8-1UqCaJnRxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Br3gJX32xI6SdYJUlx_toiz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGZH0-dz9y5=vH7PQr8VRy15i1WsuAxKjPPpmx8-1UqCaJnRxg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andriano <chief000@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Br3gJX32xI6SdYJUlx_toiz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Sep 2011 16:14:51 +1000 Andriano <chief000@gmail.com> wrote:

> Hello Linux-RAID mailing list,
>=20
> I have an issue with my RAID6 array.
> Here goes a short description of the system:
>=20
> opensuse 11.4
> Linux 3.0.4-2-desktop #1 SMP PREEMPT Wed Aug 31 09:30:44 UTC 2011
> (a432f18) x86_64 x86_64 x86_64 GNU/Linux
> Gigabyte EP35C-DS3 motherboard with 8 SATA ports + SuperMicro
> AOC-SASLP-MV8 based on Marvel 6480, firmware updated to 3.1.0.21
> running mdadm 3.2.2, single array consists of 10 2T disks, 8 of them
> connected to the HBA, 2 - motherboard ports
>=20
> I had some issues with one of the onboard connected disks, so tried to
> plug it to different ports, just to eliminate possibly faulty port.
> After reboot, suddenly other drives got kicked out from the array.
> Re-assembling them gives weird errors.
>=20
> --- some output ---
> [3:0:0:0]    disk    ATA      ST2000DL003-9VT1 CC32  /dev/sdb
> [5:0:0:0]    disk    ATA      ST2000DL003-9VT1 CC32  /dev/sdc
> [8:0:0:0]    disk    ATA      ST32000542AS     CC34  /dev/sdd
> [8:0:1:0]    disk    ATA      ST32000542AS     CC34  /dev/sde
> [8:0:2:0]    disk    ATA      ST32000542AS     CC34  /dev/sdf
> [8:0:3:0]    disk    ATA      ST32000542AS     CC34  /dev/sdg
> [8:0:4:0]    disk    ATA      ST32000542AS     CC34  /dev/sdh
> [8:0:5:0]    disk    ATA      ST2000DL003-9VT1 CC32  /dev/sdi
> [8:0:6:0]    disk    ATA      ST2000DL003-9VT1 CC32  /dev/sdj
> [8:0:7:0]    disk    ATA      ST2000DL003-9VT1 CC32  /dev/sdk
>=20
> #more /etc/mdadm.conf
> DEVICE partitions
> ARRAY /dev/md0 level=3Draid6 UUID=3D82ac7386:a854194d:81b795d1:76c9c9ff
>=20
> #mdadm --assemble --force --scan /dev/md0
> mdadm: failed to add /dev/sdc to /dev/md0: Invalid argument
> mdadm: failed to add /dev/sdb to /dev/md0: Invalid argument
> mdadm: failed to add /dev/sdh to /dev/md0: Invalid argument
> mdadm: /dev/md0 assembled from 7 drives - not enough to start the array.
>=20
> dmesg:
> [ 8215.651860] md: sdc does not have a valid v1.2 superblock, not importi=
ng!
> [ 8215.651865] md: md_import_device returned -22
> [ 8215.652384] md: sdb does not have a valid v1.2 superblock, not importi=
ng!
> [ 8215.652388] md: md_import_device returned -22
> [ 8215.653177] md: sdh does not have a valid v1.2 superblock, not importi=
ng!
> [ 8215.653182] md: md_import_device returned -22
>=20
> mdadm -E /dev/sd[b..k] gives exactly the same Magic number and Array
> UUID for every disk, all checksums are correct,
> the only difference is -  Avail Dev Size : 3907028896 is the same for
> 9 disks, and 3907028864 for sdc

Please provide that output so we can see it too - it might be helpful.

NeilBrown

>=20
> mdadm --assemble --force --update summaries /dev/sd.. - didn't improve an=
ything
>=20
>=20
> I would really appreciate if someone could point me to the right directio=
n.
>=20
> thanks
>=20
> Andrew
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Br3gJX32xI6SdYJUlx_toiz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iD8DBQFObvdHG5fc6gV+Wb0RAu05AJ9po9M+QKth/tCJbWXXDF5q8uW72ACeL28L
ZitybSSnv3QpH0w/0HxYhh4=
=48q6
-----END PGP SIGNATURE-----

--Sig_/Br3gJX32xI6SdYJUlx_toiz--
