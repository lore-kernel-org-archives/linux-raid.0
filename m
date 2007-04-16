From: mickg <mickg@mickg.net>
Subject: Raid5 performance question
Date: Mon, 16 Apr 2007 13:42:38 -0400
Message-ID: <4623B58E.9060503@mickg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


I have a raid5 array /dev/md1, being used as the pv of an LVM Volume Group.

I have a very peculiar problem with the array:

Writes to it happen at 40MB/sec or so.

But *reads* from it happen at 10MB/sec.

This, given how raid5 works, is a bit weird.


 dd if=/dev/md1 of=/disks/raid_backup/test_speed bs=10M
	gives 21MB/sec, which is, while not good, not bad for dd.

while:
 dd if=/dev/mapper/system-raid_lvm of=/disks/raid_backup/test_speed bs=10M
4+0 records in
3+0 records out
31457280 bytes (31 MB) copied, 8.75426 seconds, 3.6 MB/s
which is obviously bogus.


dd if=/dev/sdg of=/disks/raid_lvm/test.speed bs=10M
24+0 records in
23+0 records out
241172480 bytes (241 MB) copied, 11.6211 seconds, 20.8 MB/s
So, writes to the system VG happen at least 4xfaster than reads.

This to me seems insane.


Note that:
 pvs
  PV         VG     Fmt  Attr PSize PFree
  /dev/md0   backup lvm2 a-   1.46T 159.20G
  /dev/md1   system lvm2 a-   1.82T  63.04G

/disks/raid_backup/ is actually the backup VG.
/disks/raid_lvm/ is actually the system VG.

Any ideas on why this happens would be very appreciated.



mickg@mickg.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (MingW32)

iD8DBQFGI7WOoRaxTYdM/EwRAqWnAKDadOnzfPuzzoMILAsaddWwdK2XIgCgmGzm
dUlR7OPxasuKa1JwtUoR60E=
=8Vtw
-----END PGP SIGNATURE-----

