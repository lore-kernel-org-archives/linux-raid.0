From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 fail did not work properly with SSDs
Date: Thu, 5 Jan 2012 13:00:47 +1100
Message-ID: <20120105130047.6554e5f9@notabene.brown>
References: <CALvtuFRKjcttSghvvKqOMKSgmAw8yCNkAipVVZD1hR=+qgpvqQ@mail.gmail.com>
	<CALvtuFSc3BfFrEA8JPjPcWEkkqg71Ni7wzr_15F9YqDt+1OV4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xqiN+3XA9.TzaXy._9c+Ejq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALvtuFSc3BfFrEA8JPjPcWEkkqg71Ni7wzr_15F9YqDt+1OV4A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Cal Leeming [Simplicity Media Ltd]" <cal.leeming@simplicitymedialtd.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/xqiN+3XA9.TzaXy._9c+Ejq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Jan 2012 01:44:10 +0000 "Cal Leeming [Simplicity Media Ltd]"
<cal.leeming@simplicitymedialtd.co.uk> wrote:

> Hi all,
>=20
> My apologies if this is the wrong mailing list for this issue, but I
> figured my email would be lost in volume if I sent to 'linux-kernel'.

too true!!

>=20
> In short, I had 2 SSDs in RAID 1, allocated as a single physical
> volume, which had a LVM logical volume mounted as the root partition.
>=20
> Six months later, one of the SSDs dies, and causes all of hell to break l=
ose:
>=20
> [27087.234675] sd 0:0:0:0: [sda] Unhandled error code
> [27087.234686] sd 0:0:0:0: [sda] Result: hostbyte=3DDID_BAD_TARGET
> driverbyte=3DDRIVER_OK
> [27087.234688] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 68 53 88 00 00 0=
8 00
> [27087.234693] end_request: I/O error, dev sda, sector 6837128
                                         ^^^^^^^^

"sda".

> ^^ repeated over 9000 times
>=20
> Instead of the disk being marked as failed and removed, the root
> partition was instead remounted as read-only, mdadm showed no
> problems,=C2=A0and required a reboot.
>=20
> Upon rebooting, RAID still hadn't marked the dying disk as failed or
> removed, and began to re-sync!
>=20
> =C2=A0root@vicky [/var/log] > cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active (auto-read-only) raid1 sdb1[0] sdc1[1]
                                      ^^^^^^^^^^^^^^^

"sdb" and "sdc".

Something is missing in this picture.

NeilBrown


> =C2=A0 =C2=A0 =C2=A0 78122967 blocks super 1.2 [2/2] [UU]
>=20
> On top of this, even though it was read-only, it kept giving this
> error for everything:
>=20
> =C2=A0root@vicky [/var/log] > shutdown
> bash: /sbin/shutdown: Input/output error
>=20
> I'm not sure if what I'm seeing here is normal, but thought I should
> at least try and ask - I can provide lots more info if needed (got a
> huge text file and several screenshots).
>=20
> Any feedback would be very much appreciated.
>=20
> Cal Leeming
> Simplicity Media Ltd
>=20
> ----------------------------
>=20
> Here is the short smartctl dump of the disk:
>=20
> =C2=A0root@vicky [/home/foxx] > smartctl -a /dev/sda
> smartctl 5.40 2010-07-12 r3124 [x86_64-unknown-linux-gnu] (local build)
> Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net
>=20
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Device Model: =C2=A0 =C2=A0 M4-CT128M4SSD2
> Serial Number: =C2=A0 =C2=A000000000111603061D7B
> Firmware Version: 0001
> User Capacity: =C2=A0 =C2=A0128,035,676,160 bytes
> Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0Not in smartctl database [for detai=
ls use: -P showall]
> ATA Version is: =C2=A0 8
> ATA Standard is: =C2=A0ATA-8-ACS revision 6
> Local Time is: =C2=A0 =C2=A0Tue Jan =C2=A03 13:54:46 2012 GMT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/xqiN+3XA9.TzaXy._9c+Ejq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwUETznsnt1WYoG5AQL41g/+POwqLP2X3VDMitttY0rwEeNUoaEHjTyI
JbPCe+17tzDIo5J15FOfFRGXoI1hXIFfL2qU6ln9CCeEWMhQhEQ3AEvQSUYmmxOd
1ZkEo5JMAfnoEVSVfxKjCGj6MF9WX6h1lGW8zfWyEwS6cMAw2iLQwEEJYfGXrFJN
mFJpDAVpnpGtER71Z6lXrUAHcKOuV0K81uq7W8fMaEgHouaemidVT9BH8zskLxA1
ncyxzdDobOJqxPPXHRU84M5bY1wDppArIDR43kwt3lRsjZ6v6gD7K+1cDR31xG1V
Wnd20nCWTMjmelQnK+aNv7xK8eAXBtzsipk36E0F2mU0QvkQDBKXKoJVhyyPMe8q
My6HNvEw7mtqasvbUGjghUdQ8463Q9TelZOWkZBzlF8MDGFgI26s9bc6j+8PomkU
MixorwxIPTkx9L8QhVi77nYLTpygO8J//06ii7/Bo40ZpyMRi/8roagnvukrev7T
3gzl5oa5uMsGaEEVy3bwFtxB6ZNWKlVeQKaI9Zt5r7FA6YYdFziewFJuLDuMkad2
MSyyz5Qfc5F9TCLC5MealAx50TGsULhpWdQwp2MGcUQM7Ao2ahoSjgq9oHi0mG4F
Dm3SGIZKUhMfz/xE3GcBG1rQFGAFP/qMwJ1Mz2YJWE9btSVOEvd6z5FLYJJO3X4f
sD60OhGxaCI=
=wXKq
-----END PGP SIGNATURE-----

--Sig_/xqiN+3XA9.TzaXy._9c+Ejq--
