From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: Impact of missing parameter during mdadm create
Date: Mon, 28 Feb 2011 22:59:23 -0500
Message-ID: <BAY148-w177B77DAE8CED363B4EBBFEFC10@phx.gbl>
References: <BAY148-w3BBDF9F7CC665C5870D23EFC10@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w3BBDF9F7CC665C5870D23EFC10@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Manual re-assembly outputs as follows:


mdadm -Ss

mdadm: stopped /dev/md0

---

mdadm -Asvvv

mdadm: looking for devices for /dev/md/0
mdadm: no RAID superblock on /dev/dm-6
mdadm: /dev/dm-6 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-5
mdadm: /dev/dm-5 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-4
mdadm: /dev/dm-4 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-3
mdadm: /dev/dm-3 has wrong uuid.
mdadm: cannot open device /dev/dm-2: Device or resource busy
mdadm: /dev/dm-2 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-1
mdadm: /dev/dm-1 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-0
mdadm: /dev/dm-0 has wrong uuid.
mdadm: no RAID superblock on /dev/sde
mdadm: /dev/sde has wrong uuid.
mdadm: no RAID superblock on /dev/sdd
mdadm: /dev/sdd has wrong uuid.
mdadm: cannot open device /dev/sdc7: Device or resource busy
mdadm: /dev/sdc7 has wrong uuid.
mdadm: cannot open device /dev/sdc6: Device or resource busy
mdadm: /dev/sdc6 has wrong uuid.
mdadm: cannot open device /dev/sdc5: Device or resource busy
mdadm: /dev/sdc5 has wrong uuid.
mdadm: no RAID superblock on /dev/sdc2
mdadm: /dev/sdc2 has wrong uuid.
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: /dev/sdc1 has wrong uuid.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/sdc has wrong uuid.
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sda has wrong uuid.
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdb has wrong uuid.
mdadm: /dev/sdd1 is identified as a member of /dev/md/0, slot 2.
mdadm: /dev/sda1 is identified as a member of /dev/md/0, slot 0.
mdadm: /dev/sdb1 is identified as a member of /dev/md/0, slot 1.
mdadm: added /dev/sdb1 to /dev/md/0 as 1
mdadm: added /dev/sdd1 to /dev/md/0 as 2
mdadm: looking for devices for /dev/md/0
mdadm: no RAID superblock on /dev/dm-6
mdadm: /dev/dm-6 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-5
mdadm: /dev/dm-5 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-4
mdadm: /dev/dm-4 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-3
mdadm: /dev/dm-3 has wrong uuid.
mdadm: cannot open device /dev/dm-2: Device or resource busy
mdadm: /dev/dm-2 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-1
mdadm: /dev/dm-1 has wrong uuid.
mdadm: no RAID superblock on /dev/dm-0
mdadm: /dev/dm-0 has wrong uuid.
mdadm: no RAID superblock on /dev/sde
mdadm: /dev/sde has wrong uuid.
mdadm: no RAID superblock on /dev/sdd
mdadm: /dev/sdd has wrong uuid.
mdadm: cannot open device /dev/sdc7: Device or resource busy
mdadm: /dev/sdc7 has wrong uuid.
mdadm: cannot open device /dev/sdc6: Device or resource busy
mdadm: /dev/sdc6 has wrong uuid.
mdadm: cannot open device /dev/sdc5: Device or resource busy
mdadm: /dev/sdc5 has wrong uuid.
mdadm: no RAID superblock on /dev/sdc2
mdadm: /dev/sdc2 has wrong uuid.
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: /dev/sdc1 has wrong uuid.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/sdc has wrong uuid.
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sda has wrong uuid.
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdb has wrong uuid.
mdadm: /dev/sdd1 is identified as a member of /dev/md/0, slot 2.
mdadm: /dev/sda1 is identified as a member of /dev/md/0, slot 0.
mdadm: /dev/sdb1 is identified as a member of /dev/md/0, slot 1.
mdadm: added /dev/sdb1 to /dev/md/0 as 1
mdadm: added /dev/sdd1 to /dev/md/0 as 2
mdadm: added /dev/sda1 to /dev/md/0 as 0
mdadm: /dev/md/0 has been started with 2 drives (out of 3).

---

mdadm --examine /dev/sd{a,b,d}1

/dev/sda1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x0
=A0=A0=A0=A0 Array UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : XEN-HOST:0=A0 (local to host XEN-=
HOST)
=A0 Creation Time : Mon Dec 20 09:48:07 2010
=A0=A0=A0=A0 Raid Level : raid5
=A0=A0 Raid Devices : 3

=A0Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)
=A0=A0=A0=A0 Array Size : 3907035136 (1863.02 GiB 2000.40 GB)
=A0 Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
=A0=A0=A0 Data Offset : 2048 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : 25f4baf0:9a378d2c:16a87f0c:ff89b2c8

=A0=A0=A0 Update Time : Mon Feb 28 23:35:20 2011
=A0=A0=A0=A0=A0=A0 Checksum : 3745d2b9 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 33374

=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 512K

=A0=A0 Device Role : Active device 0
=A0=A0 Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdb1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x0
=A0=A0=A0=A0 Array UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : XEN-HOST:0=A0 (local to host XEN-=
HOST)
=A0 Creation Time : Mon Dec 20 09:48:07 2010
=A0=A0=A0=A0 Raid Level : raid5
=A0=A0 Raid Devices : 3

=A0Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)
=A0=A0=A0=A0 Array Size : 3907035136 (1863.02 GiB 2000.40 GB)
=A0 Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
=A0=A0=A0 Data Offset : 2048 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : f20ab5fd:1f141cae:e0547278:d6cf063e

=A0=A0=A0 Update Time : Mon Feb 28 23:35:20 2011
=A0=A0=A0=A0=A0=A0 Checksum : a715b8ad - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 33374

=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 512K

=A0=A0 Device Role : Active device 1
=A0=A0 Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdd1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x0
=A0=A0=A0=A0 Array UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : XEN-HOST:0=A0 (local to host XEN-=
HOST)
=A0 Creation Time : Mon Dec 20 09:48:07 2010
=A0=A0=A0=A0 Raid Level : raid5
=A0=A0 Raid Devices : 3

=A0Avail Dev Size : 1953521072 (931.51 GiB 1000.20 GB)
=A0=A0=A0=A0 Array Size : 3907035136 (1863.02 GiB 2000.40 GB)
=A0 Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
=A0=A0=A0 Data Offset : 2048 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : 33d70114:ffdc4fcc:2c8d65ba:ab50bab2

=A0=A0=A0 Update Time : Mon Feb 28 23:29:05 2011
=A0=A0=A0=A0=A0=A0 Checksum : 923d11a2 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 33368

=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 512K

=A0=A0 Device Role : Active device 2
=A0=A0 Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)

---


Any ideas or tips? I am considering this might be a bug, but I have onl=
y had this problem in my Debian Squeeze system.

Thanks in advance :)


-M


----------------------------------------
> Subject: Impact of missing parameter during mdadm create
> Date: Mon, 28 Feb 2011 22:19:58 -0500
>
>
> Hello mdadm hackers,
>
> I was wondering what (if any) impact would creating an array with the=
 missing parameter have on subsequent assemblies of a mdadm array?
>
> When the array was created, I used a command like:
>
> mdadm --create -l5 -n3 /dev/md0 /dev/sda1 missing /dev/sdb1
>
> And then loaded some initial data on the md0 array from /dev/sdd1, an=
d then I zeroed out /dev/sdd1 and added it to the md0 array.
>
> Details on each drive seem to show they all belong to the same Array =
UUID, but when the array is (re)assembled (on boot or manually), only /=
dev/sd{a,b}1 are added to mdadm array automatically, and /dev/sdd1 must=
 be re-added manually.
>
>
> > mdadm --examine /dev/sd{a,b,d}1
> > /dev/sda1:
> > Magic : a92b4efc
> > Version : 1.2
> > Feature Map : 0x0
> > Array UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
> > Name : XEN-HOST:0 (local to host XEN-HOST)
> > Creation Time : Mon Dec 20 09:48:07 2010
> > Raid Level : raid5
> > Raid Devices : 3
> >
> > Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)
> > Array Size : 3907035136 (1863.02 GiB 2000.40 GB)
> > Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
> > Data Offset : 2048 sectors
> > Super Offset : 8 sectors
> > State : clean
> > Device UUID : 25f4baf0:9a378d2c:16a87f0c:ff89b2c8
> >
> > Update Time : Fri Feb 18 16:32:19 2011
> > Checksum : 37383bee - correct
> > Events : 32184
> >
> > Layout : left-symmetric
> > Chunk Size : 512K
> >
> > Device Role : Active device 0
> > Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)
> > /dev/sdb1:
> > Magic : a92b4efc
> > Version : 1.2
> > Feature Map : 0x0
> > Array UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
> > Name : XEN-HOST:0 (local to host XEN-HOST)
> > Creation Time : Mon Dec 20 09:48:07 2010
> > Raid Level : raid5
> > Raid Devices : 3
> >
> > Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)
> > Array Size : 3907035136 (1863.02 GiB 2000.40 GB)
> > Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
> > Data Offset : 2048 sectors
> > Super Offset : 8 sectors
> > State : clean
> > Device UUID : f20ab5fd:1f141cae:e0547278:d6cf063e
> >
> > Update Time : Fri Feb 18 16:32:19 2011
> > Checksum : a70821e2 - correct
> > Events : 32184
> >
> > Layout : left-symmetric
> > Chunk Size : 512K
> >
> > Device Role : Active device 1
> > Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)
> > /dev/sdd1:
> > Magic : a92b4efc
> > Version : 1.2
> > Feature Map : 0x2
> > Array UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
> > Name : XEN-HOST:0 (local to host XEN-HOST)
> > Creation Time : Mon Dec 20 09:48:07 2010
> > Raid Level : raid5
> > Raid Devices : 3
> >
> > Avail Dev Size : 1953521072 (931.51 GiB 1000.20 GB)
> > Array Size : 3907035136 (1863.02 GiB 2000.40 GB)
> > Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
> > Data Offset : 2048 sectors
> > Super Offset : 8 sectors
> > Recovery Offset : 610474280 sectors
> > State : clean
> > Device UUID : 33d70114:ffdc4fcc:2c8d65ba:ab50bab2
> >
> > Update Time : Fri Feb 18 16:32:19 2011
> > Checksum : b692957e - correct
> > Events : 32184
> >
> > Layout : left-symmetric
> > Chunk Size : 512K
> >
> > Device Role : Active device 2
> > Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)
>
>
>
>
>
>
> -M
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
