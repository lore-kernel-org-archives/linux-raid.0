From: FRLinux <frlinux@frlinux.net>
Subject: raid device gone
Date: Wed, 07 Jul 2004 23:49:41 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1089240581.8641.4.camel@tux.power.users>
Reply-To: frlinux@frlinux.net
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-M26lPsEfMsNleF/KCbrq"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-M26lPsEfMsNleF/KCbrq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello,

I've posted a couple of days ago about a problem i have on my raid1
array. I used a Fedora Core 2 system to create a raid array using mkraid
at the time, and created /dev/md0 and /dev/md1. While /dev/md1 has been
nice to me, /dev/md0 keeps loosing a disk from the array and i don't
know why.

It is sitting on a silicon image (sil3112) raid card with two maxtor
s-ata 160GB drives. Here is the output of mdstat and mdadm -D /dev/md0

Personalities : [linear] [raid0] [raid1]
md1 : active raid1 sdb3[1]
      19542976 blocks [2/1] [_U]

md0 : active raid1 sdb2[1]
      97667072 blocks [2/1] [_U]

unused devices: <none>

/dev/md0:
        Version : 00.90.01
  Creation Time : Tue Jun  8 18:20:49 2004
     Raid Level : raid1
     Array Size : 97667072 (93.14 GiB 100.01 GB)
    Device Size : 97667072 (93.14 GiB 100.01 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jul  7 23:44:42 2004
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       0        0       -1      removed
       1       8       18        1      active sync =20
/dev/scsi/host1/bus0/target0/lun0/part2
           UUID : 65cb7868:653cf39d:816ca1ba:6fd40f35
         Events : 0.163183

I've kept on reattaching /dev/sda2 to /dev/md0, it then works for a
couple of days, freezes again and detaches itself. Has anyone
experienced this or could tell me how i could investigate this ? I'm
running a 2.6.7 kernel.

Thanks in advance,
Steph
--=20
This mail was sent under Gentoo 2004.1 - Gnome & Kernel 2.6nptl
http://frlinux.net - Site d'aide aux Debutants sous Linux
Public key : http://frlinux.net/files/frlinux_public_key.asc

--=-M26lPsEfMsNleF/KCbrq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBA7H4EplbM2wjOZgMRAtt5AJ0XCVqEHAzzpZv6FLHesNhrqnIRQACeM3ET
B5Eeyo1LQDYdHKtf398s3cI=
=ZA5O
-----END PGP SIGNATURE-----

--=-M26lPsEfMsNleF/KCbrq--

