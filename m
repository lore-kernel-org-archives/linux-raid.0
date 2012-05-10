From: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Subject: and again: broken RAID5
Date: Thu, 10 May 2012 10:07:21 +0200
Message-ID: <4FAB7739.9000907@cgv.tugraz.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!



I just want some tips on howto get two broken raid5 running again.

It contains of 4 drives, one was thrown out on saturday evening, and
the second drive threw read/write errors before I could replace the
first one.

Now I got all four drives running again, looks like some
controller/cable problem. Changed them.

But mdadm tells me, only 2 of 4 are available and could not start raid:

md2 : inactive sdh2[0](S) sdi2[4](S) sdf2[6](S) sdj2[5](S)
4251770144 blocks super 1.2

md1 : inactive sdh1[0](S) sdi1[4](S) sdf1[6](S) sdj1[5](S)
2097147904 blocks super 1.2

mdadm -E tells me e.g. for md1:

/dev/sdh1:
Magic : a92b4efc
Version : 1.2
=46eature Map : 0x0
Array UUID : a503cea9:eb613db1:c8909233:fd5415ce
Name : debian:1  (local to host debian)
Creation Time : Sat Feb 11 13:39:46 2012
Raid Level : raid5    Raid Devices : 4
Avail Dev Size : 1048573952 (500.00 GiB 536.87 GB)
Array Size : 3145720320 (1500.00 GiB 1610.61 GB)
Used Dev Size : 1048573440 (500.00 GiB 536.87 GB)
Data Offset : 2048 sectors
Super Offset : 8 sectors
State : clean
Device UUID : 710a2926:640bc675:7b5fe308:861d1883
Update Time : Sun May  6 13:57:22 2012
Checksum : e387e748 - correct
Events : 206286
Layout : left-symmetric
Chunk Size : 128K
Device Role : Active device 0
Array State : AA.. ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdf1:
Magic : a92b4efc
Version : 1.2
=46eature Map : 0x0
Array UUID : a503cea9:eb613db1:c8909233:fd5415ce
Name : debian:1  (local to host debian)
Creation Time : Sat Feb 11 13:39:46 2012
Raid Level : raid5
Raid Devices : 4
Avail Dev Size : 1048573952 (500.00 GiB 536.87 GB)
Array Size : 3145720320 (1500.00 GiB 1610.61 GB)
Used Dev Size : 1048573440 (500.00 GiB 536.87 GB)
Data Offset : 2048 sectors
Super Offset : 8 sectors
State : clean
Device UUID : f53b097c:9762f2a4:f2af9011:3fa7ced7
Update Time : Sun May  6 13:38:26 2012
Checksum : c5f745bd - correct
Events : 206273
Layout : left-symmetric
Chunk Size : 128K
Device Role : Active device 2
Array State : AAA. ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdi1:
Magic : a92b4efc
Version : 1.2
=46eature Map : 0x0
Array UUID : a503cea9:eb613db1:c8909233:fd5415ce
Name : debian:1  (local to host debian)
Creation Time : Sat Feb 11 13:39:46 2012
Raid Level : raid5
Raid Devices : 4
Avail Dev Size : 1048573952 (500.00 GiB 536.87 GB)
Array Size : 3145720320 (1500.00 GiB 1610.61 GB)
Used Dev Size : 1048573440 (500.00 GiB 536.87 GB)
Data Offset : 2048 sectors
Super Offset : 8 sectors
State : clean
Device UUID : 79eb5c0c:db73e2f8:21d9b7f8:97936da4
Update Time : Sun May  6 01:32:35 2012
Checksum : 5dff4e2a - correct
Events : 197114
Layout : left-symmetric
Chunk Size : 128K
Device Role : Active device 3
Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdj1:
Magic : a92b4efc
Version : 1.2
=46eature Map : 0x0
Array UUID : a503cea9:eb613db1:c8909233:fd5415ce
Name : debian:1  (local to host debian)
Creation Time : Sat Feb 11 13:39:46 2012
Raid Level : raid5
Raid Devices : 4
Avail Dev Size : 1048573952 (500.00 GiB 536.87 GB)
Array Size : 3145720320 (1500.00 GiB 1610.61 GB)
Used Dev Size : 1048573440 (500.00 GiB 536.87 GB)
Data Offset : 2048 sectors
Super Offset : 8 sectors
State : clean
Device UUID : e8055bca:0f3c9b54:421bc2c2:4a72359b
Update Time : Sun May  6 13:57:22 2012
Checksum : 388b23fc - correct
Events : 206286
Layout : left-symmetric
Chunk Size : 128K
Device Role : Active device 1
Array State : AA.. ('A' =3D=3D active, '.' =3D=3D missing)


So all 4 disks see some diff state. Any chance on getting raid5
running again and read some data from it?

Does the mdadm -C --assume-clean option help me in that case anyhow?


Thank you!

MfG,
Lars Schimmer
- --=20
- -------------------------------------------------------------
TU Graz, Institut f=FCr ComputerGraphik & WissensVisualisierung
Tel: +43 316 873-5405       E-Mail: l.schimmer@cgv.tugraz.at
=46ax: +43 316 873-5402       PGP-Key-ID: 0x4A9B1723


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+rdzgACgkQmWhuE0qbFyMvtgCfaoUiyHj2qFEvaCgo+azZoo3S
guUAnR+s0jZvyc2XL5HItCbT+81pLjwe
=3DkT0C
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
