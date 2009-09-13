From: Ronny Adsetts <ronny.adsetts@amazinginternet.com>
Subject: RAID mirror, resyncing from bad disk
Date: Sun, 13 Sep 2009 20:19:10 +0100
Message-ID: <4AAD45AE.6060503@amazinginternet.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC4C5F541786FE8D3BFDF066D"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID ML <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC4C5F541786FE8D3BFDF066D
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

I've found myself in a situation that I'm unable to resolve hence this re=
quest for help.

A messed up /etc/mdadm/mdadm.conf led to one of the disk in a RAID 1 mirr=
ored pair being kicked from the array. Unfortunately, the disk left in th=
e array has bad sectors so I can't resync the good disk back in so I can =
fail the bad disk and replace it.

/proc/mdstat looks like this:

Personalities : [raid1]
md0 : active raid1 sdb1[0] sdc1[1]
      489856 blocks [2/2] [UU]

md1 : active raid1 sdb2[0] sdc2[2](F)
      1951808 blocks [2/1] [U_]

md2 : active raid1 sdb3[2](F) sdc3[1]
      114776320 blocks [2/1] [_U]

unused devices: <none>

The problematic array is /dev/md2 and the dying disk is /dev/sdc.

When I try to resync it gets to about 99.2% then gives load of I/O errors=
 in /var/log/kern.log and finally gives up and restarts the sync.

Ideally I just want to tell the system to ignore the bad sector and just =
resync the array.

Does anyone have any ideas on how I can get this resolved short of reinst=
alling? This is a production server so I'd like to avoid the downtime if =
at all possible. (I have all the important stuff backed up on tape; /dev/=
md2 is mainly system stuff).

Other misc. info:

$ mdadm --version
mdadm - v2.6.2 - 21st May 2007

$ uname -a
Linux vimes 2.6.24-etchnhalf.1-amd64 #1 SMP Sat Aug 15 20:38:41 UTC 2009 =
x86_64 GNU/Linux

The system is sata disks for the md2 array. This is then an LVM volume wh=
ich is partitioned up in to about 5 partitions all using the XFS filesyst=
em.

Logs for a resync:
---
Aug 19 12:20:54 vimes mdadm: Rebuild80 event detected on md device /dev/m=
d2
Aug 19 12:38:26 vimes kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr =
0x0 action 0x0
Aug 19 12:38:26 vimes kernel: ata2.00: BMDMA stat 0x24
Aug 19 12:38:26 vimes kernel: ata2.00: cmd 25/00:00:b0:e2:f1/00:04:0d:00:=
00/e0 tag 0 dma 524288 in
Aug 19 12:38:26 vimes kernel:          res 51/40:55:05:e4:f1/40:01:0d:00:=
00/e0 Emask 0x9 (media error)
Aug 19 12:38:26 vimes kernel: ata2.00: status: { DRDY ERR }
Aug 19 12:38:26 vimes kernel: ata2.00: error: { UNC }
Aug 19 12:38:26 vimes kernel: ata2.00: configured for UDMA/133
Aug 19 12:38:26 vimes kernel: ata2: EH complete
Aug 19 12:38:30 vimes kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr =
0x0 action 0x0
Aug 19 12:38:30 vimes kernel: ata2.00: BMDMA stat 0x24
Aug 19 12:38:30 vimes kernel: ata2.00: cmd 25/00:00:b0:e2:f1/00:04:0d:00:=
00/e0 tag 0 dma 524288 in
Aug 19 12:38:30 vimes kernel:          res 51/40:55:05:e4:f1/40:01:0d:00:=
00/e0 Emask 0x9 (media error)
Aug 19 12:38:30 vimes kernel: ata2.00: status: { DRDY ERR }
Aug 19 12:38:30 vimes kernel: ata2.00: error: { UNC }
Aug 19 12:38:30 vimes kernel: ata2.00: configured for UDMA/133
Aug 19 12:38:30 vimes kernel: ata2: EH complete
Aug 19 12:38:33 vimes kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr =
0x0 action 0x0
Aug 19 12:38:33 vimes kernel: ata2.00: BMDMA stat 0x24
Aug 19 12:38:33 vimes kernel: ata2.00: cmd 25/00:00:b0:e2:f1/00:04:0d:00:=
00/e0 tag 0 dma 524288 in
Aug 19 12:38:33 vimes kernel:          res 51/40:55:05:e4:f1/40:01:0d:00:=
00/e0 Emask 0x9 (media error)
Aug 19 12:38:33 vimes kernel: ata2.00: status: { DRDY ERR }
Aug 19 12:38:33 vimes kernel: ata2.00: error: { UNC }
Aug 19 12:38:33 vimes kernel: ata2.00: configured for UDMA/133
Aug 19 12:38:33 vimes kernel: ata2: EH complete
Aug 19 12:38:37 vimes kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr =
0x0 action 0x0
Aug 19 12:38:37 vimes kernel: ata2.00: BMDMA stat 0x24
Aug 19 12:38:37 vimes kernel: ata2.00: cmd 25/00:00:b0:e2:f1/00:04:0d:00:=
00/e0 tag 0 dma 524288 in
Aug 19 12:38:37 vimes kernel:          res 51/40:55:05:e4:f1/40:01:0d:00:=
00/e0 Emask 0x9 (media error)
Aug 19 12:38:37 vimes kernel: ata2.00: status: { DRDY ERR }
Aug 19 12:38:37 vimes kernel: ata2.00: error: { UNC }
Aug 19 12:38:37 vimes kernel: ata2.00: configured for UDMA/133
Aug 19 12:38:37 vimes kernel: ata2: EH complete
Aug 19 12:38:41 vimes kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr =
0x0 action 0x0
Aug 19 12:38:41 vimes kernel: ata2.00: BMDMA stat 0x24
Aug 19 12:38:41 vimes kernel: ata2.00: cmd 25/00:00:b0:e2:f1/00:04:0d:00:=
00/e0 tag 0 dma 524288 in
Aug 19 12:38:41 vimes kernel:          res 51/40:55:05:e4:f1/40:01:0d:00:=
00/e0 Emask 0x9 (media error)
Aug 19 12:38:41 vimes kernel: ata2.00: status: { DRDY ERR }
Aug 19 12:38:41 vimes kernel: ata2.00: error: { UNC }
Aug 19 12:38:41 vimes kernel: ata2.00: configured for UDMA/133
Aug 19 12:38:41 vimes kernel: ata2: EH complete
Aug 19 12:38:45 vimes kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr =
0x0 action 0x0
Aug 19 12:38:45 vimes kernel: ata2.00: BMDMA stat 0x24
Aug 19 12:38:45 vimes kernel: ata2.00: cmd 25/00:00:b0:e2:f1/00:04:0d:00:=
00/e0 tag 0 dma 524288 in
Aug 19 12:38:45 vimes kernel:          res 51/40:55:05:e4:f1/40:01:0d:00:=
00/e0 Emask 0x9 (media error)
Aug 19 12:38:45 vimes kernel: ata2.00: status: { DRDY ERR }
Aug 19 12:38:45 vimes kernel: ata2.00: error: { UNC }
Aug 19 12:38:45 vimes kernel: ata2.00: configured for UDMA/133
Aug 19 12:38:45 vimes kernel: sd 1:0:0:0: [sdb] Result: hostbyte=3DDID_OK=
 driverbyte=3DDRIVER_SENSE,SUGGEST_OK
Aug 19 12:38:45 vimes kernel: sd 1:0:0:0: [sdb] Sense Key : Medium Error =
[current] [descriptor]
Aug 19 12:38:45 vimes kernel: Descriptor sense data with sense descriptor=
s (in hex):
Aug 19 12:38:45 vimes kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00=
 00 00 00 00
Aug 19 12:38:45 vimes kernel:         0d f1 e4 05
Aug 19 12:38:45 vimes kernel: sd 1:0:0:0: [sdb] Add. Sense: Unrecovered r=
ead error - auto reallocate failed
Aug 19 12:38:45 vimes kernel: end_request: I/O error, dev sdb, sector 233=
956357
Aug 19 12:38:45 vimes kernel: ata2: EH complete
Aug 19 12:38:45 vimes kernel: sd 1:0:0:0: [sdb] 234441648 512-byte hardwa=
re sectors (120034 MB)
Aug 19 12:38:45 vimes kernel: sd 1:0:0:0: [sdb] Write Protect is off
Aug 19 12:38:45 vimes kernel: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Aug 19 12:38:45 vimes kernel: sd 1:0:0:0: [sdb] Write cache: enabled, rea=
d cache: enabled, doesn't support DPO or FUA
Aug 19 12:38:45 vimes kernel: sd 1:0:0:0: [sdb] 234441648 512-byte hardwa=
re sectors (120034 MB)
Aug 19 12:38:45 vimes kernel: sd 1:0:0:0: [sdb] Write Protect is off
Aug 19 12:38:45 vimes kernel: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Aug 19 12:38:45 vimes kernel: sd 1:0:0:0: [sdb] Write cache: enabled, rea=
d cache: enabled, doesn't support DPO or FUA
Aug 19 12:38:49 vimes kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr =
0x0 action 0x0
Aug 19 12:38:49 vimes kernel: ata2.00: BMDMA stat 0x24
Aug 19 12:38:49 vimes kernel: ata2.00: cmd c8/00:08:00:e4:f1/00:00:00:00:=
00/ed tag 0 dma 4096 in
Aug 19 12:38:49 vimes kernel:          res 51/40:05:05:e4:f1/40:01:0d:00:=
00/ed Emask 0x9 (media error)
Aug 19 12:38:49 vimes kernel: ata2.00: status: { DRDY ERR }
Aug 19 12:38:49 vimes kernel: ata2.00: error: { UNC }
Aug 19 12:38:49 vimes kernel: ata2.00: configured for UDMA/133
Aug 19 12:38:49 vimes kernel: ata2: EH complete
Aug 19 12:38:52 vimes kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr =
0x0 action 0x0
Aug 19 12:38:52 vimes kernel: ata2.00: BMDMA stat 0x24
Aug 19 12:38:52 vimes kernel: ata2.00: cmd c8/00:08:00:e4:f1/00:00:00:00:=
00/ed tag 0 dma 4096 in
Aug 19 12:38:52 vimes kernel:          res 51/40:05:05:e4:f1/40:01:0d:00:=
00/ed Emask 0x9 (media error)
Aug 19 12:38:52 vimes kernel: ata2.00: status: { DRDY ERR }
Aug 19 12:38:52 vimes kernel: ata2.00: error: { UNC }
Aug 19 12:38:53 vimes kernel: ata2.00: configured for UDMA/133
Aug 19 12:38:53 vimes kernel: ata2: EH complete
Aug 19 12:38:56 vimes kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr =
0x0 action 0x0
Aug 19 12:38:56 vimes kernel: ata2.00: BMDMA stat 0x24
Aug 19 12:38:56 vimes kernel: ata2.00: cmd c8/00:08:00:e4:f1/00:00:00:00:=
00/ed tag 0 dma 4096 in
Aug 19 12:38:56 vimes kernel:          res 51/40:05:05:e4:f1/40:01:0d:00:=
00/ed Emask 0x9 (media error)
Aug 19 12:38:56 vimes kernel: ata2.00: status: { DRDY ERR }
Aug 19 12:38:56 vimes kernel: ata2.00: error: { UNC }
Aug 19 12:38:56 vimes kernel: ata2.00: configured for UDMA/133
Aug 19 12:38:56 vimes kernel: ata2: EH complete
Aug 19 12:39:00 vimes kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr =
0x0 action 0x0
Aug 19 12:39:00 vimes kernel: ata2.00: BMDMA stat 0x24
Aug 19 12:39:00 vimes kernel: ata2.00: cmd c8/00:08:00:e4:f1/00:00:00:00:=
00/ed tag 0 dma 4096 in
Aug 19 12:39:00 vimes kernel:          res 51/40:05:05:e4:f1/40:01:0d:00:=
00/ed Emask 0x9 (media error)
Aug 19 12:39:00 vimes kernel: ata2.00: status: { DRDY ERR }
Aug 19 12:39:00 vimes kernel: ata2.00: error: { UNC }
Aug 19 12:39:00 vimes kernel: ata2.00: configured for UDMA/133
Aug 19 12:39:00 vimes kernel: ata2: EH complete
Aug 19 12:39:04 vimes kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr =
0x0 action 0x0
Aug 19 12:39:04 vimes kernel: ata2.00: BMDMA stat 0x24
Aug 19 12:39:04 vimes kernel: ata2.00: cmd c8/00:08:00:e4:f1/00:00:00:00:=
00/ed tag 0 dma 4096 in
Aug 19 12:39:04 vimes kernel:          res 51/40:05:05:e4:f1/40:01:0d:00:=
00/ed Emask 0x9 (media error)
Aug 19 12:39:04 vimes kernel: ata2.00: status: { DRDY ERR }
Aug 19 12:39:04 vimes kernel: ata2.00: error: { UNC }
Aug 19 12:39:04 vimes kernel: ata2.00: configured for UDMA/133
Aug 19 12:39:04 vimes kernel: ata2: EH complete
Aug 19 12:39:08 vimes kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr =
0x0 action 0x0
Aug 19 12:39:08 vimes kernel: ata2.00: BMDMA stat 0x24
Aug 19 12:39:08 vimes kernel: ata2.00: cmd c8/00:08:00:e4:f1/00:00:00:00:=
00/ed tag 0 dma 4096 in
Aug 19 12:39:08 vimes kernel:          res 51/40:05:05:e4:f1/40:01:0d:00:=
00/ed Emask 0x9 (media error)
Aug 19 12:39:08 vimes kernel: ata2.00: status: { DRDY ERR }
Aug 19 12:39:08 vimes kernel: ata2.00: error: { UNC }
Aug 19 12:39:08 vimes kernel: ata2.00: configured for UDMA/133
Aug 19 12:39:08 vimes kernel: sd 1:0:0:0: [sdb] Result: hostbyte=3DDID_OK=
 driverbyte=3DDRIVER_SENSE,SUGGEST_OK
Aug 19 12:39:08 vimes kernel: sd 1:0:0:0: [sdb] Sense Key : Medium Error =
[current] [descriptor]
Aug 19 12:39:08 vimes kernel: Descriptor sense data with sense descriptor=
s (in hex):
Aug 19 12:39:08 vimes kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00=
 00 00 00 00
Aug 19 12:39:08 vimes kernel:         0d f1 e4 05
Aug 19 12:39:08 vimes kernel: sd 1:0:0:0: [sdb] Add. Sense: Unrecovered r=
ead error - auto reallocate failed
Aug 19 12:39:08 vimes kernel: end_request: I/O error, dev sdb, sector 233=
956357
Aug 19 12:39:08 vimes kernel: raid1: sdb: unrecoverable I/O read error fo=
r block 229072512
Aug 19 12:39:08 vimes kernel: ata2: EH complete
Aug 19 12:39:08 vimes kernel: sd 1:0:0:0: [sdb] 234441648 512-byte hardwa=
re sectors (120034 MB)
Aug 19 12:39:08 vimes kernel: sd 1:0:0:0: [sdb] Write Protect is off
Aug 19 12:39:08 vimes kernel: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Aug 19 12:39:08 vimes kernel: sd 1:0:0:0: [sdb] Write cache: enabled, rea=
d cache: enabled, doesn't support DPO or FUA
Aug 19 12:39:08 vimes kernel: sd 1:0:0:0: [sdb] 234441648 512-byte hardwa=
re sectors (120034 MB)
Aug 19 12:39:08 vimes kernel: sd 1:0:0:0: [sdb] Write Protect is off
Aug 19 12:39:08 vimes kernel: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Aug 19 12:39:08 vimes kernel: sd 1:0:0:0: [sdb] Write cache: enabled, rea=
d cache: enabled, doesn't support DPO or FUA
Aug 19 12:39:08 vimes kernel: RAID1 conf printout:
Aug 19 12:39:08 vimes kernel:  --- wd:1 rd:2
Aug 19 12:39:08 vimes kernel:  disk 0, wo:1, o:1, dev:sda3
Aug 19 12:39:08 vimes kernel:  disk 1, wo:0, o:1, dev:sdb3
Aug 19 12:39:08 vimes kernel: RAID1 conf printout:
Aug 19 12:39:08 vimes kernel:  --- wd:1 rd:2
Aug 19 12:39:08 vimes kernel:  disk 1, wo:0, o:1, dev:sdb3
Aug 19 12:39:08 vimes kernel: RAID1 conf printout:
Aug 19 12:39:08 vimes kernel:  --- wd:1 rd:2
Aug 19 12:39:08 vimes kernel:  disk 0, wo:1, o:1, dev:sda3
Aug 19 12:39:08 vimes kernel:  disk 1, wo:0, o:1, dev:sdb3
Aug 19 12:39:08 vimes kernel: md: recovery of RAID array md2
Aug 19 12:39:08 vimes kernel: md: minimum _guaranteed_  speed: 1000 KB/se=
c/disk.
Aug 19 12:39:08 vimes mdadm: RebuildFinished event detected on md device =
/dev/md2
Aug 19 12:39:08 vimes kernel: md: using maximum available idle IO bandwid=
th (but not more than 200000 KB/sec) for recovery.
Aug 19 12:39:08 vimes kernel: md: using 128k window, over a total of 1147=
76320 blocks.
Aug 19 12:39:08 vimes mdadm: RebuildStarted event detected on md device /=
dev/md2
Aug 19 12:51:08 vimes mdadm: Rebuild20 event detected on md device /dev/m=
d2
---

Thanks for any help.

Ronny
--=20
Ronny Adsetts
Technical Director
Amazing Internet Ltd, London
t: +44 20 8607 9535
f: +44 20 8607 9536
w: www.amazinginternet.com

Registered office: UK House, 82 Heath Road, Twickenham TW1 4BW
Registered in England. Company No. 4042957=20



--------------enigC4C5F541786FE8D3BFDF066D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqtRa4ACgkQ/j4uMRUAlJ8ObgCgmcemnpoQq5haiZFXhnNYFm0c
N4wAoMA3beeErT4kf1ZcFNezwPT6Y63w
=gyB/
-----END PGP SIGNATURE-----

--------------enigC4C5F541786FE8D3BFDF066D--
