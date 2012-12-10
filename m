From: "Andris Berzins" <pkix@inbox.lv>
Subject: failed raid re-create changed dev size
Date: Tue, 11 Dec 2012 01:37:19 +0200
Message-ID: <1355182639.50c6722fe15b2@mail.inbox.lv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have raid5 with 6 devices. One drive died, however, I hot-removed the=
 wrong one, so raid failed.

I found on internet that this can be fixed if I re-create raid with the=
 same configuration, but with dead drive set as 'missing'.
I saved --examinate data for all drives, and re run raid creation:

mdadm --verbose --create /dev/md1 --level=3D5 --raid-devices=3D6 /dev/s=
db missing /dev/sdc /dev/sdg /dev/sdf /dev/sde

However, I can not mount md1 and looks like it contains random data. Th=
e order is correct. However, I noticed that new raid device size is dif=
ferent from old one.

Old working raid --examine:
/dev/sdc:
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a92b4efc
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.2
=C2=A0=C2=A0=C2=A0 Feature Map : 0x0
=C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : 39f653e1:515c53b4:a88a1588:0bf0fd=
07
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name : spi=
re:1=C2=A0 (local to host spire)
=C2=A0 Creation Time : Fri Jun 29 01:59:00 2012
=C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
=C2=A0=C2=A0 Raid Devices : 6

=C2=A0Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
=C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 14651325440 (13972.59 GiB 15002.9=
6 GB)
=C2=A0 Used Dev Size : 5860530176 (2794.52 GiB 3000.59 GB)
=C2=A0=C2=A0=C2=A0 Data Offset : 2048 sectors
=C2=A0=C2=A0 Super Offset : 8 sectors
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : clean
=C2=A0=C2=A0=C2=A0 Device UUID : 93e652d6:35c69c71:501601cd:7e640042

=C2=A0=C2=A0=C2=A0 Update Time : Sun Dec=C2=A0 9 19:50:50 2012
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : f30bd58d - correct
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 128287

=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-symmetri=
c
=C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 512K

=C2=A0=C2=A0 Device Role : Active device 2
=C2=A0=C2=A0 Array State : ..A.AA ('A' =3D=3D active, '.' =3D=3D missin=
g)


Re-created raid examine:
/dev/sdc:
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a92b4efc
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.2
=C2=A0=C2=A0=C2=A0 Feature Map : 0x0
=C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : 39f653e1:515c53b4:a88a1588:0bf0fd=
07
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name : spi=
re:1=C2=A0 (local to host spire)
=C2=A0 Creation Time : Mon Dec 10 21:04:01 2012
=C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
=C2=A0=C2=A0 Raid Devices : 6

=C2=A0Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
=C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 14650675200 (13971.97 GiB 15002.2=
9 GB)
=C2=A0 Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
=C2=A0=C2=A0=C2=A0 Data Offset : 262144 sectors
=C2=A0=C2=A0 Super Offset : 8 sectors
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : clean
=C2=A0=C2=A0=C2=A0 Device UUID : 4d0fe5bc:c05ec2c4:68805eab:bed7ef9c

=C2=A0=C2=A0=C2=A0 Update Time : Mon Dec 10 21:04:39 2012
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : 676939cb - correct
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 4

=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-symmetri=
c
=C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 512K

=C2=A0=C2=A0 Device Role : Active device 2
=C2=A0=C2=A0 Array State : A.AAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)


So "Avail Dev Size" differs with re-created one being smaller for ~100M=
B.
What could be the reason why I can't mount re-created raid?


Idea: smartctl on one of drives shows 17 reallocated sectors:
=C2=A0 5 Reallocated_Sector_Ct=C2=A0=C2=A0 0x0033=C2=A0=C2=A0 199=C2=A0=
=C2=A0 199=C2=A0=C2=A0 140=C2=A0=C2=A0=C2=A0 Pre-fail=C2=A0 Always=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 17

Could this be reason why re-created raid is smaller?

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
