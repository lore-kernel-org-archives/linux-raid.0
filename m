From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?=
	<phcoder@gmail.com>
Subject: 2 RAID devices with index 0 [Fwd: Re: Bug#597563: grub-common: grub-probe
 segfaults scanning lvm devices]
Date: Sat, 08 Jan 2011 23:44:27 +0100
Message-ID: <4D28E8CB.50003@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigC5D3158C22347D0D0C733F05"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC5D3158C22347D0D0C733F05
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



-------- Original Message --------
Subject: 	Re: Bug#597563: grub-common: grub-probe segfaults scanning lvm
devices
Date: 	Sat, 8 Jan 2011 17:39:09 -0500 (EST)
From: 	Matthew Gabeler-Lee <cheetah@cheetah.fastcat.org>
To: 	Vladimir '=CF=86-coder/phcoder' Serbinenko <phcoder@gmail.com>
CC: 	597563@bugs.debian.org



On Sat, 8 Jan 2011, Vladimir '=CF=86-coder/phcoder' Serbinenko wrote:

> There may be a problem in RAID assembling. Are any of the devices marke=
d
> as faulty or spare?

No (see below).

> it's ls -- -l / for now, will be fixed later.

$ sudo ./grub-fstest -c 4 /dev/sda3 /dev/sdb3 /dev/sdc3 /dev/sdd3 ls -- -=
l
Device raid5-grande: Not a known filesystem - Total size 15548416 sectors=

Device raid5-usr: Filesystem type reiserfs - Label "/usr", UUID 4fba6590-=
71f4-49cb-9e56-879b1ce80893 - Total size 20971520 sectors
Device raid5-home: Filesystem type reiserfs - Label "/home", UUID 214d66d=
c-77d8-4ba8-adba-aa03c44ae360 - Total size 8388608 sectors
Device raid5-tmp: Filesystem type ext2 - Label "/tmp" - Last modification=
 time 2011-01-03 22:45:38 Monday, UUID 10ebe510-49bc-4f33-87e5-f0b41594e2=
47 - Total size 2097152 sectors
Device raid5-var: Filesystem type reiserfs - Label "/var", UUID c39288ed-=
f6c2-467a-bd40-68ac3cabef7f - Total size 4194304 sectors
Device md2: Not a known filesystem - Total size 76366976 sectors
Device loop3: Not a known filesystem - Total size 1457111565 sectors
Device loop2: Not a known filesystem - Total size 1457111565 sectors
Device loop1: Not a known filesystem - Total size 1457111565 sectors
Device loop0: Not a known filesystem - Total size 1457111565 sectors
Device host: Filesystem type hostfs - Total size 0 sectors

> Is the size of md2 correctly 3 times the size of a single disk?

Yes:

$ cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md1 : active raid1 sdd2[3] sdc2[2] sdb2[1] sda2[0]
       2008000 blocks [4/4] [UUUU]

md2 : active raid5 sdd3[3] sdc3[0] sdb3[1] sda3[2]
       2185667136 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md0 : active raid1 sdd1[3] sdc1[1] sdb1[0] sda1[2]
       2008000 blocks [4/4] [UUUU]

unused devices: <none>
$ sudo fdisk -l /dev/sda

Disk /dev/sda: 750.2 GB, 750156374016 bytes
255 heads, 63 sectors/track, 91201 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xbb1ed82c

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1         250     2008093+  fd  Linux raid autode=
tect
/dev/sda2             251         500     2008125   fd  Linux raid autode=
tect
/dev/sda3             501       91201   728555782+  fd  Linux raid autode=
tect

--=20
 	-Matt
"Reality is that which, when you stop believing in it, doesn't go away".
                 -- Philip K. Dick
GPG pubkey fingerprint: A57F B354 FD30 A502 795B 9637 3EF1 3F22 A85E 2AD1=




--------------enigC5D3158C22347D0D0C733F05
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk0o6MsACgkQNak7dOguQgnaeQD/Y0R3VbDEhezHXJICCk1v+y/A
A0vgb1T9Y1TExNRew8MA+gOur8SVMMwcCdcTMatfqPTnBCwqXAa5U9bbc/vP7RiE
=hi22
-----END PGP SIGNATURE-----

--------------enigC5D3158C22347D0D0C733F05--
