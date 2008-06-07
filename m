From: Ben Martin <monkeyiq@users.sourceforge.net>
Subject: RAID-5 and the mysterious disappearing drive
Date: Sun, 08 Jun 2008 01:39:05 +1000
Message-ID: <1212853145.22982.40.camel@sam.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ARjes5ZetTNqprxWPnUi"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-ARjes5ZetTNqprxWPnUi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,
  I recently constructed a RAID-5 using four 320Gb drives, moved the
system and other data across and everything was working nicely. I awoke
to find a degraded array email one day and on further investigation I
noticed the following in /var/log/messages. The RAID-5 array was running
in degraded mode and had evidently renoticed that /dev/sdm and sdm2 had
reappeared and listed them again as a failed spare in the --detail of
mdadm. I could not however see sdm with fdisk.

  I then rebooted the machine in the hopes that sdm would be able to be
seen via fdisk etc. As I suspected /dev/sdm did appear and the partition
table was valid in fdisk. The sdm1 array is a RAID-1 of size 4gb.
Perfect for expanding back onto sdm1 and seeing what happens. Adding
sdm1 to the smaller RAID-1 caused a resync and then the array was clean
again with 4 drives.

  So then I decided to re-add sdm2 to the large RAID-5. I initially
created this RAID-5 with an internal bitmap as a precaution against
worst cases like kernel oopses halting the machine uncleanly. Adding the
drive (/dev/sdm2) back to the large array only took a few seconds. mdadm
informed me that it was readding the drive sdm2 to the array and
performed some resync (of a few seconds) just after the readd. At this
stage everything seems to be functioning correctly but the RAID always
reports state:active. On another RAID-5 I have the state bounces between
active and clean depending on how my disk load is. I find it strange
that the RAID-5 that had the troubles never reports a state:clean even
when there is no disk IO for a while. Any thoughts or recommendations?

  The RAID-5 that had the issues is running off a SIL 3114 controller,
thus no NCQ issues possible.

/var/log/messages:
Jun  6 04:27:10 x kernel: ata13.00: exception Emask 0x0 SAct 0x0 SErr 0x0 a=
ction 0x2 frozen
Jun  6 04:29:13 x kernel: ata13.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0=
 tag 0 cdb 0x0 data 0=20
Jun  6 04:29:13 x kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 =
Emask 0x4 (timeout)
Jun  6 04:29:13 x kernel: ata13: port is slow to respond, please be patient=
 (Status 0xd0)
Jun  6 04:29:13 x kernel: ata13: device not ready (errno=3D-16), forcing ha=
rdreset
Jun  6 04:29:13 x kernel: ata13: hard resetting port
Jun  6 04:29:13 x kernel: ata13: SATA link up 1.5 Gbps (SStatus 113 SContro=
l 310)
Jun  6 04:29:13 x kernel: ata13.00: qc timeout (cmd 0xec)
Jun  6 04:29:13 x kernel: ata13.00: failed to IDENTIFY (I/O error, err_mask=
=3D0x4)
Jun  6 04:29:13 x kernel: ata13.00: revalidation failed (errno=3D-5)
Jun  6 04:29:13 x kernel: ata13: failed to recover some devices, retrying i=
n 5 secs
Jun  6 04:29:13 x kernel: ata13: hard resetting port
Jun  6 04:29:13 x kernel: ata13: SATA link up 1.5 Gbps (SStatus 113 SContro=
l 310)
Jun  6 04:29:13 x kernel: ata13.00: qc timeout (cmd 0x27)
Jun  6 04:29:13 x kernel: ata13.00: ata_hpa_resize 1: hpa sectors (0) is sm=
aller than sectors (625142448)
Jun  6 04:29:13 x kernel: ata13.00: failed to set xfermode (err_mask=3D0x40=
)
Jun  6 04:29:13 x kernel: ata13.00: limiting speed to UDMA/100:PIO3
Jun  6 04:29:13 x kernel: ata13: failed to recover some devices, retrying i=
n 5 secs
Jun  6 04:29:13 x kernel: ata13: hard resetting port
Jun  6 04:29:13 x kernel: ata13: SATA link up 1.5 Gbps (SStatus 113 SContro=
l 310)
Jun  6 04:29:13 x kernel: ata13.00: qc timeout (cmd 0xec)
Jun  6 04:29:13 x kernel: ata13.00: failed to IDENTIFY (I/O error, err_mask=
=3D0x4)
Jun  6 04:29:13 x kernel: ata13.00: revalidation failed (errno=3D-5)
Jun  6 04:29:13 x kernel: ata13.00: disabled
Jun  6 04:29:13 x kernel: ata13: EH pending after completion, repeating EH =
(cnt=3D4)
Jun  6 04:29:13 x kernel: ata13: port is slow to respond, please be patient=
 (Status 0xd0)
Jun  6 04:29:13 x kernel: ata13: device not ready (errno=3D-16), forcing ha=
rdreset
Jun  6 04:29:13 x kernel: ata13: hard resetting port
Jun  6 04:29:13 x kernel: ata13: SATA link up 1.5 Gbps (SStatus 113 SContro=
l 310)
Jun  6 04:29:13 x kernel: ata13: EH complete
Jun  6 04:29:13 x kernel: sd 12:0:0:0: [sdm] Result: hostbyte=3DDID_BAD_TAR=
GET driverbyte=3DDRIVER_OK,SUGGEST_OK
Jun  6 04:29:13 x kernel: end_request: I/O error, dev sdm, sector 350365623
Jun  6 04:29:13 x kernel: sd 12:0:0:0: [sdm] Result: hostbyte=3DDID_BAD_TAR=
GET driverbyte=3DDRIVER_OK,SUGGEST_OK
Jun  6 04:29:13 x kernel: end_request: I/O error, dev sdm, sector 350365879
Jun  6 04:29:13 x kernel: sd 12:0:0:0: [sdm] READ CAPACITY failed
Jun  6 04:29:13 x kernel: sd 12:0:0:0: [sdm] Result: hostbyte=3DDID_BAD_TAR=
GET driverbyte=3DDRIVER_OK,SUGGEST_OK
Jun  6 04:29:13 x kernel: sd 12:0:0:0: [sdm] Sense not available.
Jun  6 04:29:13 x kernel: sd 12:0:0:0: [sdm] Write Protect is off
Jun  6 04:29:13 x kernel: sd 12:0:0:0: [sdm] Asking for cache data failed
Jun  6 04:29:13 x kernel: sd 12:0:0:0: [sdm] Assuming drive cache: write th=
rough
Jun  6 04:29:13 x kernel: md: super_written gets error=3D-5, uptodate=3D0
Jun  6 04:29:13 x kernel: raid5: Disk failure on sdm2, disabling device. Op=
eration continuing on 3 devices
Jun  6 04:29:13 x kernel: RAID5 conf printout:
Jun  6 04:29:13 x kernel:  --- rd:4 wd:3
Jun  6 04:29:13 x kernel:  disk 0, o:1, dev:sdj2
Jun  6 04:29:13 x kernel:  disk 1, o:1, dev:sdl2
Jun  6 04:29:13 x kernel:  disk 2, o:1, dev:sdk2
Jun  6 04:29:13 x kernel:  disk 3, o:0, dev:sdm2
Jun  6 04:29:13 x kernel: RAID5 conf printout:
Jun  6 04:29:13 x kernel:  --- rd:4 wd:3
Jun  6 04:29:13 x kernel:  disk 0, o:1, dev:sdj2
Jun  6 04:29:13 x kernel:  disk 1, o:1, dev:sdl2
Jun  6 04:29:13 x kernel:  disk 2, o:1, dev:sdk2

# mdadm --detail  /dev/md-2008=20
        Version : 01.02.03
  Creation Time : Sun Jun  1 09:26:59 2008
     Raid Level : raid5
     Array Size : 925970112 (883.07 GiB 948.19 GB)
  Used Dev Size : 617313408 (294.36 GiB 316.06 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 125
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sun Jun  8 00:25:40 2008
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : md-2008
         Events : 49342

    Number   Major   Minor   RaidDevice State
       0       8      146        0      active sync   /dev/sdj2
       1       8      178        1      active sync   /dev/sdl2
       2       8      162        2      active sync   /dev/sdk2
       4       8      194        3      active sync   /dev/sdm2


--=-ARjes5ZetTNqprxWPnUi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkhKq5kACgkQsIKOrI+5WvMVkACdFpJ33sQSusLb/dcCacQ3bp9G
+DoAoJY/F9foUv3iSQoUq6rSaMMAEacE
=tNEv
-----END PGP SIGNATURE-----

--=-ARjes5ZetTNqprxWPnUi--

