From: Gilbert Kowarzyk <kowarzyk@grm.polymtl.ca>
Subject: Renaming MD devices (metadata=1.1)
Date: Tue, 10 Jan 2012 01:12:58 -0500
Message-ID: <4F0BD6EA.8010007@grm.polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,   - Jan 10, 2012

I am having problems renaming a few md devices and I've been trying
out different things, but none of them seem to work.

The md devices were created with metadata=1.1.

Some sites talk about changing the preferred minor, but I haven't even
found that entry for these devices.

This is all on CentOS 6.2.

Below is the info for one of these devices I am having trouble with. I
would like to name it /dev/md9 but after a reboot it renames itself
/dev/md126.

# mdadm --detail /dev/md127
=================================>
/dev/md127:
        Version : 1.1
  Creation Time : Sun Jan  8 04:58:25 2012
     Raid Level : raid1
     Array Size : 1843198844 (1757.81 GiB 1887.44 GB)
  Used Dev Size : 1843198844 (1757.81 GiB 1887.44 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Jan  9 23:47:52 2012
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : xyz.homelinux.com:9  (local to host xyz.homelinux.com)
           UUID : 0fa7f737:7806ca61:fb89edd6:14aa351a
         Events : 20

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
<=================================


# mdadm --examine /dev/sdc1
=================================>
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 0fa7f737:7806ca61:fb89edd6:14aa351a
           Name : xyz.homelinux.com:9  (local to host xyz.homelinux.com)
  Creation Time : Sun Jan  8 04:58:25 2012
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 3686397952 (1757.81 GiB 1887.44 GB)
     Array Size : 3686397688 (1757.81 GiB 1887.44 GB)
  Used Dev Size : 3686397688 (1757.81 GiB 1887.44 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 73fb0ea3:e08fd3c6:b3e41f50:c1e3a2ac

Internal Bitmap : 2 sectors from superblock
    Update Time : Tue Jan 10 00:04:29 2012
       Checksum : e6bfee2 - correct
         Events : 20


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)
<=================================


# mdadm --examine /dev/sdd1
=================================>
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 0fa7f737:7806ca61:fb89edd6:14aa351a
           Name : xyz.homelinux.com:9  (local to host xyz.homelinux.com)
  Creation Time : Sun Jan  8 04:58:25 2012
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 3686397952 (1757.81 GiB 1887.44 GB)
     Array Size : 3686397688 (1757.81 GiB 1887.44 GB)
  Used Dev Size : 3686397688 (1757.81 GiB 1887.44 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : e6cec1cb:40cab8c8:d1cb2a07:af3f2517

Internal Bitmap : 2 sectors from superblock
    Update Time : Tue Jan 10 00:04:29 2012
       Checksum : 5a914fc1 - correct
         Events : 20


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)
=================================


# mdadm --examine --scan /dev/sdc1
=================================>
ARRAY /dev/md/9 metadata=1.1 UUID=0fa7f737:7806ca61:fb89edd6:14aa351a
name=xyz.homelinux.com:9
<=================================


# mdadm --examine --scan /dev/sdd1
=================================>
ARRAY /dev/md/9 metadata=1.1 UUID=0fa7f737:7806ca61:fb89edd6:14aa351a
name=xyz.homelinux.com:9
<=================================


# mdadm --detail --scan
=================================>
ARRAY /dev/md/xyz.homelinux.com:9 metadata=1.1
name=xyz.homelinux.com:9 UUID=0fa7f737:7806ca61:fb89edd6:14aa351a
<=================================

# blkid
=================================>
/dev/md127: UUID="c301cf13-cfaf-4f56-887e-c648caf5a931" TYPE="ext4"
<=================================

in /etc/fstab I have:
=================================>
UUID=c301cf13-cfaf-4f56-887e-c648caf5a931 /DATA    ext4  defaults 1 2
<=================================

and in /etc/mdadm.conf I have:
=================================>
ARRAY /dev/md/xyz.homelinux.com:9 metadata=1.1
name=xyz.homelinux.com:9 UUID=0fa7f737:7806ca61:fb89edd6:14aa351a
<=================================


To me, the line that looks suspicious is the one we get from "mdadm
- --detail --scan". All the devices that "look right" say "ARRAY
/dev/md/X" where X is a number.

I fixed this temporarily by stopping the array and re-assembling it with:

mdadm --assemble /dev/md9 --name=9 --update=name /dev/sdc1 /dev/sdd1


Then the mdadm --detail --scan line says:
ARRAY /dev/md/9 metadata=1.1 name=xyz.homelinux.com:9
UUID=0fa7f737:7806ca61:fb89edd6:14aa351a

... which makes more sense to me (it looks like the other ones.

Yet, when I reboot the computer this "temporarily fixed" array returns
to /dev/md127.

I have since redone these steps saving the changes in the
/etc/mdadm.conf file, but after a reboot the same thing happens
(despite the /etc/mdadm.conf file saying otherwise).

So, I've run out of ideas... help?

Thanks in advance!

Gilbert

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (Darwin)
Comment: digital signature
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8L1ugACgkQOYVp1RpLsmUeIwCfa2zFkMzq9UtxrFtl6Qr4U9Qs
kT4AniCJDeJHS2DxOD1G3vYGJ1O+8oNK
=QpQl
-----END PGP SIGNATURE-----
