From: NeilBrown <neilb@suse.de>
Subject: Re: Lose two disks during Raid 10 rebuild
Date: Fri, 24 Aug 2012 07:07:18 +1000
Message-ID: <20120824070718.25f5dd0a@notabene.brown>
References: <8E77BA43C8998042B05BB83386E8CF044CE0C8@SFO1EXC-MBXP06.nbttech.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/c/8a+n6tYZ_/jwYoENmt2ad"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8E77BA43C8998042B05BB83386E8CF044CE0C8@SFO1EXC-MBXP06.nbttech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steven La <Steven.La@riverbed.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/c/8a+n6tYZ_/jwYoENmt2ad
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Aug 2012 19:28:27 +0000 Steven La <Steven.La@riverbed.com> wrote:

> Hello all,
>=20
> Got the following messages from syslog during Raid 10 rebuild cycle.
>=20
> Aug  3 01:48:11 oak-sh283 kernel: sd 0:0:0:0: [sda] Unhandled sense code
> Aug  3 01:48:11 oak-sh283 kernel: sd 0:0:0:0: [sda] Result: hostbyte=3Din=
valid
> driverbyte=3DDRIVER_SENSE
> Aug  3 01:48:11 oak-sh283 kernel: sd 0:0:0:0: [sda] Sense Key : Medium Er=
ror
> [current]


"Medium Error" normally means that the recording medium (magnetic regions) =
is
corrupt in some way and a valid data block cannot be extracted.



> Aug  3 01:48:11 oak-sh283 kernel: Info fld=3D0x3ae0f43c
> Aug  3 01:48:11 oak-sh283 kernel: sd 0:0:0:0: [sda] Add. Sense: Unrecover=
ed
> read error
> Aug  3 01:48:11 oak-sh283 kernel: sd 0:0:0:0: [sda] CDB: Read(10): 28 00 =
3a e0
> f3 ab 00 01 00 00
> Aug  3 01:48:11 oak-sh283 kernel: end_request: I/O error, dev sda, sector
> 987821116
> Aug  3 01:48:11 oak-sh283 kernel: md/raid10:md7: Disk failure on sda8,
> disabling device.
> Aug  3 01:48:11 oak-sh283 kernel: md/raid10:md7: Operation continuing on 2
> devices.
> Aug  3 01:48:11 oak-sh283 kernel: md: md7: recovery done.
> Aug  3 01:48:11 oak-sh283 kernel: md/raid10:md7: Disk failure on sdc8,
> disabling device.

Presumably md7 was trying to recover sdc8 from sda8.  It got a data error on
sda8, so could not recover sda8 and so marked it as failed.

> Aug  3 01:48:11 oak-sh283 kernel: md/raid10:md7: Operation continuing on 2
> devices.
> Aug  3 01:48:14 oak-sh283 kernel: md: unbind<sdc8>
> Aug  3 01:48:14 oak-sh283 kernel: md: export_rdev(sdc8)
> Aug  3 01:48:14 oak-sh283 kernel: md: unbind<sda8>
> Aug  3 01:48:14 oak-sh283 kernel: md: export_rdev(sda8)
> Aug  3 01:48:16 oak-sh283 raid_rebuild: Sending sighup to hald[22152] for=
 event
> RebuildFinished for /dev/md7
>=20
>=20
> [admin@oak-sh283 ~]# cat /proc/mdstat
>=20
> Personalities : [linear] [raid0] [raid1] [raid10]
>=20
> md5 : active raid10 sdc9[1] sde9[2] sdg9[3] sda9[0]
>=20
>       562997760 blocks 64K chunks 2 near-copies [4/4] [UUUU]
>=20
>=20
>=20
> md7 : active raid10 sde8[2] sdg8[3]
>=20
>       562997760 blocks 64K chunks 2 near-copies [4/2] [__UU]
>=20
>=20
>=20
> md6 : active raid10 sdc7[1] sde7[2] sdg7[3] sda7[0]
>=20
>       562997760 blocks 64K chunks 2 near-copies [4/4] [UUUU]
>=20
>=20
>=20
> md3 : active raid10 sdc6[1] sde6[2] sdg6[3] sda6[0]
>=20
>       52435968 blocks 64K chunks 2 near-copies [4/4] [UUUU]
>=20
>=20
>=20
> md0 : active raid10 sdc2[1] sde2[2] sdg2[3] sda2[0]
>=20
>       10490240 blocks 64K chunks 2 near-copies [4/4] [UUUU]
>=20
>=20
>=20
> md4 : active raid10 sdb3[0] sdh3[3] sdf3[2] sdd3[1]
>=20
>       19518720 blocks 64K chunks 2 near-copies [4/4] [UUUU]
>=20
>=20
>=20
> md2 : active raid10 sdc3[1] sde3[2] sdg3[3] sda3[0]
>=20
>       67119360 blocks 64K chunks 2 near-copies [4/4] [UUUU]
>=20
>=20
>=20
> md1 : active raid10 sdc5[1] sde5[2] sdg5[3] sda5[0]
>=20
>       134222848 blocks 64K chunks 2 near-copies [4/4] [UUUU]
>=20
>=20
>=20
>=20
>=20
> >From the error message below (also shown above), the block that cannot b=
e read from sda
>=20
> has lba=3D0x3ae0f3ab.
>=20
>=20
>=20
> Aug  3 01:48:11 oak-sh283 kernel: sd 0:0:0:0: [sda] CDB: Read(10): 28 00 =
3a e0
>=20
> f3 ab 00 01 00 00
>=20
>=20
> [admin@oak-sh283 ~]# fdisk -s /dev/sda
>=20
> 976762584

This number is in kilobytes. 1 TB.

>=20
>=20
>=20
> The last block on the drive is 0x3a3836d8

This is a sector number. 976762584 sectors or 500102443008 bytes into the
device.  About half way.


You can probably correct the bad sector by
 dd if=3D/dev/zero of=3D/dev/sda seek=3D976762584 count=3D1 oflag=3Ddirect

I would try to read from the address first yo make sure it is in error:

 dd of=3D/dev/null if=3D/dev/sda skip=3D976762584 count=3D1 oflag=3Ddirect

Then read the entire device to ensure there are no other media errors.
Then stop the array and re-assemble with --force.
Then try the recovery again.

NeilBrown





>=20
>=20
>=20
> (gdb) p/x 976762584
>=20
> $1 =3D 0x3a3836d8
>=20
> (gdb) p 0x3ae0f3ab
>=20
> $2 =3D 987820971
>=20
> So, it seems like the lba number used in the Read(10) command has exceede=
d the last block of the drive.
> Has anyone had this problem before? What else can I look at?
>=20
> Relevant info are shown below,
>=20
> [admin@oak-sh283 ~]# mdadm -V
> mdadm - v2.6.4 - 19th October 2007
>=20
> [admin@oak-sh283 ~]# uname -a
> Linux oak-sh283 2.6.32 #1 SMP Wed Aug 1 01:38:35 PDT 2012 x86_64 x86_64 x=
86_64 GNU/Linux
>=20
> Thanks and regards,
> --Steven
>=20
>=20
>=20
>=20
>=20


--Sig_/c/8a+n6tYZ_/jwYoENmt2ad
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUDabhjnsnt1WYoG5AQJoKQ//bJ1eXDwkW1dhr7BNG5Lfg1zuP3mqJ7lb
lYV7P2ZN+xUDatbaf+hltawUzwLjSBvdM4QeFv+2zKQkSbu/FHPhDSwlthFUOLWs
VKGkToSM5Ed0NaVte/jM413sXC4mR5jw15HoSPwo+GxHkZ3RZwXnaF9TdBx+e35M
njouz6LAEFlv12nZhwK5X4uGHm0xoxZDEawraUg466jPYM4VAzPCoCJ5d6DCCmz9
sTTDxG+tBZsEuawAlEPlLR14nkVAqJq6vdPD4els8iHPnkotPJJxFhaNcGHbj5en
vXQj7vruLKuN645NyRVSNElDM5J+cM82FWcp6Ai2POjKdulFLerWRLLUCoqtaZI6
9p0MKUvlW8UPmqwEb8sPv602OFzQ/WolMwTIO2ISF/9TP3BSgx8r24Gx/4mDasSp
Ifm2N34/0E/zg0pYFmQdxMXi0N7NhGB57lEQWPvNstXfs5r5ShaYMgoDIRLLW9PV
Xq8NQ0/5kSIM8qo7KjCxKc1EpsXb/U9Ns8/j+MJNND0wdilnuFfkAtp3rn8+EnVO
X8VC8vrMTE7ymXOU/XJKIiNMfuwxOSQGQsFFbuG0VCV0tR/UjA7ug+rTjWp+93kP
16PpiTKbqlQ+31PX2QfxJeV6aKYt3Nho3ayBFYOWbtX/fwUC5a3MZA49rjLTLQZR
SSDNs4dAEJs=
=/+An
-----END PGP SIGNATURE-----

--Sig_/c/8a+n6tYZ_/jwYoENmt2ad--
