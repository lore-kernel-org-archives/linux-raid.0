From: Roman Mamedov <rm@romanrm.ru>
Subject: RAID1 member mysteriously failing on 3.8+
Date: Mon, 15 Apr 2013 14:56:52 +0600
Message-ID: <20130415145652.302d87f1@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5uDsaINrT_OMY/HzZO4+2xk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5uDsaINrT_OMY/HzZO4+2xk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

Continuing on the dangerous and exciting journey with trying to upgrade my
system from a 3.7.10 kernel to 3.8.7, I face the following problem.

In a RAID1 array of an SSD and a HDD marked as write-mostly, mdadm at some
point just randomly decides that a device has failed, despite NO dmesg
messages that would confirm that anything at all happened to the device (at=
 133s).

Then I notice this, remove(413s) and re-add(418s) the device. It starts
rebuilding, but just after 10 seconds, "fails" again! (428s). This can repe=
at
and repeat, I can't readd it and have it rebuild successfully.

If a device truly failed in some way, I'd expect dmesg errors from e.g. the=
 ATA layer, etc.
But there is none; also what leads me to suspicion that this is some sort o=
f a
bug, is the fact that this same array works perfectly on the older (3.7.10)
kernel.

...
[   22.984532] r8169 0000:04:00.0 eth0: link up
[   22.984541] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   22.984584] IPv6: ADDRCONF(NETDEV_CHANGE): eth0.2: link becomes ready
[   22.996464] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recov=
ery directory
[   22.996712] NFSD: starting 90-second grace period (net ffffffff81cb36c0)
[   41.315150] ata1.00: configured for UDMA/133
[   41.315164] ata1: EH complete
[   41.329004] ata2.00: configured for UDMA/133
[   41.329019] ata2: EH complete
[   41.330625] ata3.00: configured for UDMA/133
[   41.330640] ata3: EH complete
[   41.333116] ata4.00: configured for UDMA/133
[   41.333130] ata4: EH complete
[   41.335766] ata5.00: configured for UDMA/133
[   41.335781] ata5: EH complete
[   41.356118] ata7.00: configured for UDMA/133
[   41.356133] ata7: EH complete
[   41.362298] ata12.00: configured for UDMA/133
[   41.362313] ata12: EH complete
[   41.362483] ata13.00: configured for UDMA/133
[   41.362491] ata13: EH complete
[   41.369409] ata11.00: configured for UDMA/133
[   41.369424] ata11: EH complete
[  133.191756] md/raid1:md3: Disk failure on sdg1, disabling device.
[  133.191756] md/raid1:md3: Operation continuing on 1 devices.
[  133.194892] RAID1 conf printout:
[  133.194901]  --- wd:1 rd:2
[  133.194906]  disk 0, wo:0, o:1, dev:sdf1
[  133.194911]  disk 1, wo:1, o:0, dev:sdg1
[  133.198199] RAID1 conf printout:
[  133.198213]  --- wd:1 rd:2
[  133.198219]  disk 0, wo:0, o:1, dev:sdf1
[  413.692816] md: unbind<sdg1>
[  413.692863] md: export_rdev(sdg1)
[  413.718257] device label home devid 1 transid 568912 /dev/md3
[  418.696848] md: bind<sdg1>
[  418.699066] RAID1 conf printout:
[  418.699074]  --- wd:1 rd:2
[  418.699080]  disk 0, wo:0, o:1, dev:sdf1
[  418.699085]  disk 1, wo:1, o:1, dev:sdg1
[  418.704862] md: recovery of RAID array md3
[  418.704873] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  418.704879] md: using maximum available idle IO bandwidth (but not more =
than 200000 KB/sec) for recovery.
[  418.704888] md: using 128k window, over a total of 58579264k.
[  418.763888] device label home devid 1 transid 568912 /dev/md3
[  428.464670] md/raid1:md3: Disk failure on sdg1, disabling device.
[  428.464670] md/raid1:md3: Operation continuing on 1 devices.
[  428.979635] md: md3: recovery done.
[  428.984824] RAID1 conf printout:
[  428.984836]  --- wd:1 rd:2
[  428.984843]  disk 0, wo:0, o:1, dev:sdf1
[  428.984848]  disk 1, wo:1, o:0, dev:sdg1
[  428.987765] RAID1 conf printout:
[  428.987771]  --- wd:1 rd:2
[  428.987777]  disk 0, wo:0, o:1, dev:sdf1


--=20
With respect,
Roman

--Sig_/5uDsaINrT_OMY/HzZO4+2xk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFrwNQACgkQTLKSvz+PZwj64QCeJdCr777fpMDBt3w2eukC5OZl
5GcAn0fFUJELSnhL5RXavjg1uEX4q4/3
=jlp+
-----END PGP SIGNATURE-----

--Sig_/5uDsaINrT_OMY/HzZO4+2xk--
