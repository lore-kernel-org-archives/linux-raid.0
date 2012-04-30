From: =?ISO-8859-1?Q?H=E1kon_G=EDslason?= <hakon.gislason@gmail.com>
Subject: Failed drive while converting raid5 to raid6, then a hard reboot
Date: Mon, 30 Apr 2012 13:59:56 +0000
Message-ID: <CAFTzWnrQARaemDkMNe48zT8tipPmsVbt0ZFgfDTyrtUc9KjuZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,
I've been having frequent drive "failures", as in, they are reported
failed/bad and mdadm sends me an email telling me things went wrong,
etc... but after a reboot or two, they are perfectly fine again. I'm
not sure what it is, but this server is quite new and I think there
might be more behind it, bad memory or the motherboard (I've been
having other issues as well). I've had 4 drive "failures" in this
month, all different drives except for one, which "failed" twice, and
all have been fixed with a reboot or rebuild (all drives reported bad
by mdadm passed an extensive SMART test).
Due to this, I decided to convert my raid5 array to a raid6 array
while I find the root cause of the problem.

I started the conversion right after a drive failure & rebuild, but as
it had converted/reshaped aprox. 4%(if I remember correctly, and it
was going really slowly, ~7500 minutes to completion), it reported
another drive bad, and the conversion to raid6 stopped (it said
"rebuilding", but the speed was 0K/sec and the time left was a few
million minutes.
After that happened, I tried to stop the array and reboot the server,
as I had done previously to get the reportedly "bad" drive working
again, but It=A0wouldn't=A0stop the array or reboot, neither could I
unmount it, it just hung whenever I tried to do something with
/dev/md0. After trying to reboot a few times, I just killed the power
and re-started it.=A0Admittedly=A0this was probably not the best thing =
I
could have done at that point.

I have backup of ca. 80% of the data on there, it's been a month since
the last complete backup (because I ran out of backup disk space).

So, the big question, can the array be activated, and can it complete
the conversion to raid6? And will I get my data back?
I hope the data can be rescued, and any help I can get would be much
appreciated!

I'm fairly new to raid in general, and have been using mdadm for about
a month now.
Here's some data:

root@axiom:~# mdadm --examine --scan
ARRAY /dev/md/0 metadata=3D1.2 UUID=3Dcfedbfc1:feaee982:4e92ccf4:45e08e=
d1
name=3Daxiom.is:0


root@axiom:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : inactive sdc[6] sde[7] sdb[5] sda[4]
=A0 =A0 =A0 7814054240 blocks super 1.2

root@axiom:~# mdadm --assemble --scan --force --run /dev/md0
mdadm: /dev/md0 is already in use.

root@axiom:~# mdadm --stop /dev/md0
mdadm: stopped /dev/md0

root@axiom:~# mdadm --assemble --scan --force --run /dev/md0
mdadm: Failed to restore critical section for reshape, sorry.
=A0 =A0 =A0 Possibly you needed to specify the --backup-file

root@axiom:~# mdadm --assemble --scan --force --run /dev/md0
--backup-file=3D/root/mdadm-backup-file
mdadm: Failed to restore critical section for reshape, sorry.

root@axiom:~# fdisk -l | grep 2000
Disk /dev/sda doesn't contain a valid partition table
Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
Disk /dev/sde: 2000.4 GB, 2000398934016 bytes
Disk /dev/sdf: 2000.4 GB, 2000398934016 bytes

root@axiom:~# mdadm --examine /dev/sd{a,b,c,e,f}
/dev/sda:
=A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
=A0 =A0 =A0 =A0 Version : 1.2
=A0 =A0 Feature Map : 0x4
=A0 =A0 =A0Array UUID : cfedbfc1:feaee982:4e92ccf4:45e08ed1
=A0 =A0 =A0 =A0 =A0 =A0Name :=A0axiom.is:0

=A0=A0(local to host=A0axiom.is

)
=A0 Creation Time : Mon Apr =A09 01:05:20 2012
=A0 =A0 =A0Raid Level : raid6
=A0 =A0Raid Devices : 5

=A0Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
=A0 =A0 =A0Array Size : 11721080448 (5589.05 GiB 6001.19 GB)
=A0 Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
=A0 =A0 Data Offset : 2048 sectors
=A0 =A0Super Offset : 8 sectors
=A0 =A0 =A0 =A0 =A0 State : active
=A0 =A0 Device UUID : b11a7424:fc470ea7:51ba6ea0:158c0ce6

=A0 Reshape pos'n : 242343936 (231.12 GiB 248.16 GB)
=A0 =A0 =A0New Layout : left-symmetric

=A0 =A0 Update Time : Sun Oct 14 15:20:06 2012
=A0 =A0 =A0 =A0Checksum : 76ecd244 - correct
=A0 =A0 =A0 =A0 =A0Events : 138274

=A0 =A0 =A0 =A0 =A0Layout : left-symmetric-6
=A0 =A0 =A0Chunk Size : 32K

=A0 =A0Device Role : Active device 3
=A0 =A0Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdb:
=A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
=A0 =A0 =A0 =A0 Version : 1.2
=A0 =A0 Feature Map : 0x6
=A0 =A0 =A0Array UUID : cfedbfc1:feaee982:4e92ccf4:45e08ed1
=A0 =A0 =A0 =A0 =A0 =A0Name :=A0axiom.is:0

=A0=A0(local to host=A0axiom.is

)
=A0 Creation Time : Mon Apr =A09 01:05:20 2012
=A0 =A0 =A0Raid Level : raid6
=A0 =A0Raid Devices : 5

=A0Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
=A0 =A0 =A0Array Size : 11721080448 (5589.05 GiB 6001.19 GB)
=A0 Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
=A0 =A0 Data Offset : 2048 sectors
=A0 =A0Super Offset : 8 sectors
Recovery Offset : 161546240 sectors
=A0 =A0 =A0 =A0 =A0 State : active
=A0 =A0 Device UUID : 8389f39f:cc7fa027:f10cf717:1d41d40b

=A0 Reshape pos'n : 242343936 (231.12 GiB 248.16 GB)
=A0 =A0 =A0New Layout : left-symmetric

=A0 =A0 Update Time : Sun Oct 14 15:20:06 2012
=A0 =A0 =A0 =A0Checksum : 19ef8090 - correct
=A0 =A0 =A0 =A0 =A0Events : 138274

=A0 =A0 =A0 =A0 =A0Layout : left-symmetric-6
=A0 =A0 =A0Chunk Size : 32K

=A0 =A0Device Role : Active device 4
=A0 =A0Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdc:
=A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
=A0 =A0 =A0 =A0 Version : 1.2
=A0 =A0 Feature Map : 0x4
=A0 =A0 =A0Array UUID : cfedbfc1:feaee982:4e92ccf4:45e08ed1
=A0 =A0 =A0 =A0 =A0 =A0Name :=A0axiom.is:0

=A0=A0(local to host=A0axiom.is

)
=A0 Creation Time : Mon Apr =A09 01:05:20 2012
=A0 =A0 =A0Raid Level : raid6
=A0 =A0Raid Devices : 5

=A0Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
=A0 =A0 =A0Array Size : 11721080448 (5589.05 GiB 6001.19 GB)
=A0 Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
=A0 =A0 Data Offset : 2048 sectors
=A0 =A0Super Offset : 8 sectors
=A0 =A0 =A0 =A0 =A0 State : clean
=A0 =A0 Device UUID : b2cec17f:e526b42e:9e69e46b:23be5163

=A0 Reshape pos'n : 242343936 (231.12 GiB 248.16 GB)
=A0 =A0 =A0New Layout : left-symmetric

=A0 =A0 Update Time : Sun Oct 14 15:20:06 2012
=A0 =A0 =A0 =A0Checksum : a29b468a - correct
=A0 =A0 =A0 =A0 =A0Events : 138274

=A0 =A0 =A0 =A0 =A0Layout : left-symmetric-6
=A0 =A0 =A0Chunk Size : 32K

=A0 =A0Device Role : Active device 1
=A0 =A0Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sde:
=A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
=A0 =A0 =A0 =A0 Version : 1.2
=A0 =A0 Feature Map : 0x4
=A0 =A0 =A0Array UUID : cfedbfc1:feaee982:4e92ccf4:45e08ed1
=A0 =A0 =A0 =A0 =A0 =A0Name :=A0axiom.is:0

=A0=A0(local to host=A0axiom.is

)
=A0 Creation Time : Mon Apr =A09 01:05:20 2012
=A0 =A0 =A0Raid Level : raid6
=A0 =A0Raid Devices : 5

=A0Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
=A0 =A0 =A0Array Size : 11721080448 (5589.05 GiB 6001.19 GB)
=A0 Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
=A0 =A0 Data Offset : 2048 sectors
=A0 =A0Super Offset : 8 sectors
=A0 =A0 =A0 =A0 =A0 State : active
=A0 =A0 Device UUID : 21c799cd:58be3156:6830865b:fa984134

=A0 Reshape pos'n : 242343936 (231.12 GiB 248.16 GB)
=A0 =A0 =A0New Layout : left-symmetric

=A0 =A0 Update Time : Sun Oct 14 15:20:06 2012
=A0 =A0 =A0 =A0Checksum : d882780e - correct
=A0 =A0 =A0 =A0 =A0Events : 138274

=A0 =A0 =A0 =A0 =A0Layout : left-symmetric-6
=A0 =A0 =A0Chunk Size : 32K

=A0 =A0Device Role : Active device 2
=A0 =A0Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdf:
=A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
=A0 =A0 =A0 =A0 Version : 1.2
=A0 =A0 Feature Map : 0x4
=A0 =A0 =A0Array UUID : cfedbfc1:feaee982:4e92ccf4:45e08ed1
=A0 =A0 =A0 =A0 =A0 =A0Name :=A0axiom.is:0

=A0=A0(local to host=A0axiom.is

)
=A0 Creation Time : Mon Apr =A09 01:05:20 2012
=A0 =A0 =A0Raid Level : raid6
=A0 =A0Raid Devices : 5

=A0Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
=A0 =A0 =A0Array Size : 11721080448 (5589.05 GiB 6001.19 GB)
=A0 Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
=A0 =A0 Data Offset : 2048 sectors
=A0 =A0Super Offset : 8 sectors
=A0 =A0 =A0 =A0 =A0 State : active
=A0 =A0 Device UUID : 8b043488:8379f327:5f00e0fe:6a1e0bee

=A0 Reshape pos'n : 242343936 (231.12 GiB 248.16 GB)
=A0 =A0 =A0New Layout : left-symmetric

=A0 =A0 Update Time : Sat Apr 28 22:57:36 2012
=A0 =A0 =A0 =A0Checksum : c122639f - correct
=A0 =A0 =A0 =A0 =A0Events : 138241

=A0 =A0 =A0 =A0 =A0Layout : left-symmetric-6
=A0 =A0 =A0Chunk Size : 32K

=A0 =A0Device Role : Active device 0
=A0 =A0Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
--
H=E1kon G.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
