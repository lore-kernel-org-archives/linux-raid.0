From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raid1 issue after disk failure: both disks of the array are
 still active
Date: Sat, 15 Sep 2012 20:41:02 +0100
Message-ID: <20120915194102.GA10403@cthulhu.home.robinhill.me.uk>
References: <5051AF17.8010501@linuxsystems.it>
 <20120913103432.GA11764@cthulhu.home.robinhill.me.uk>
 <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com>
 <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se>
 <5052E096.5040509@linuxsystems.it>
 <45F26B36-1890-4F8E-BDF9-0DB49FDEE922@colorremedies.com>
 <20120914182755.GA2534@cthulhu.home.robinhill.me.uk>
 <7664099D-4C11-4254-B970-2DCAD5F86A46@colorremedies.com>
 <5054D175.5070303@linuxsystems.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5054D175.5070303@linuxsystems.it>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?Niccol=F2?= Belli <darkbasic@linuxsystems.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat Sep 15, 2012 at 09:05:25 +0200, Niccol=F2 Belli wrote:

> CHECK didn't help me, so I did a echo "repair >=20
> /sys/block/md0/md/sync_action". REPAIR didn't work too :(
>=20
Didn't work for what you were wanting anyway. It may well have worked
for its intended purpose.

> Here is syslog of REPAIR:
>=20
> Sep 15 19:34:10 asterisk mdadm[2117]: RebuildStarted event detected on=20
> md device /dev/md/0
> Sep 15 19:34:10 asterisk kernel: [258470.152296] md: requested-resync of=
=20
> RAID array md0
> Sep 15 19:34:10 asterisk kernel: [258470.152301] md: minimum=20
> _guaranteed_  speed: 1000 KB/sec/disk.
> Sep 15 19:34:10 asterisk kernel: [258470.152304] md: using maximum=20
> available idle IO bandwidth (but not more than 200000 KB/sec) for=20
> requested-resync.
> Sep 15 19:34:10 asterisk kernel: [258470.152310] md: using 128k window,=
=20
> over a total of 311619448k.
> Sep 15 19:34:11 asterisk kernel: [258471.165653] ata3.00: exception=20
> Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> Sep 15 19:34:11 asterisk kernel: [258471.167468] ata3.00: BMDMA stat 0x44
> Sep 15 19:34:11 asterisk kernel: [258471.169912] ata3.00: failed=20
> command: READ DMA EXT
> Sep 15 19:34:11 asterisk kernel: [258471.172769] ata3.00: cmd=20
> 25/00:00:00:15:00/00:04:00:00:00/e0 tag 0 dma 524288 in
> Sep 15 19:34:11 asterisk kernel: [258471.172771]          res=20
> 51/40:00:90:17:00/40:00:00:00:00/e0 Emask 0x9 (media error)
> Sep 15 19:34:11 asterisk kernel: [258471.176753] ata3.00: status: { DRDY=
=20
> ERR }
> Sep 15 19:34:11 asterisk kernel: [258471.178605] ata3.00: error: { UNC }
> Sep 15 19:34:12 asterisk kernel: [258472.148217] ata3.00: configured for=
=20
> UDMA/133
> Sep 15 19:34:12 asterisk kernel: [258472.148232] ata3: EH complete
> Sep 15 19:34:13 asterisk kernel: [258473.131054] ata3.00: exception=20
> Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> Sep 15 19:34:13 asterisk kernel: [258473.132881] ata3.00: BMDMA stat 0x44
> Sep 15 19:34:13 asterisk kernel: [258473.134639] ata3.00: failed=20
> command: READ DMA EXT
> Sep 15 19:34:13 asterisk kernel: [258473.136413] ata3.00: cmd=20
> 25/00:00:00:15:00/00:04:00:00:00/e0 tag 0 dma 524288 in
> Sep 15 19:34:13 asterisk kernel: [258473.136415]          res=20
> 51/40:00:90:17:00/40:00:00:00:00/e0 Emask 0x9 (media error)
> Sep 15 19:34:13 asterisk kernel: [258473.141768] ata3.00: status: { DRDY=
=20
> ERR }
> Sep 15 19:34:13 asterisk kernel: [258473.144049] ata3.00: error: { UNC }
> Sep 15 19:34:14 asterisk kernel: [258474.112209] ata3.00: configured for=
=20
> UDMA/133
> Sep 15 19:34:14 asterisk kernel: [258474.112224] ata3: EH complete
> Sep 15 19:34:15 asterisk kernel: [258475.071642] ata3.00: exception=20
> Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> Sep 15 19:34:15 asterisk kernel: [258475.073476] ata3.00: BMDMA stat 0x44
> Sep 15 19:34:15 asterisk kernel: [258475.075240] ata3.00: failed=20
> command: READ DMA EXT
> Sep 15 19:34:15 asterisk kernel: [258475.077027] ata3.00: cmd=20
> 25/00:00:00:15:00/00:04:00:00:00/e0 tag 0 dma 524288 in
> Sep 15 19:34:15 asterisk kernel: [258475.077029]          res=20
> 51/40:00:90:17:00/40:00:00:00:00/e0 Emask 0x9 (media error)
> Sep 15 19:34:15 asterisk kernel: [258475.080720] ata3.00: status: { DRDY=
=20
> ERR }
> Sep 15 19:34:15 asterisk kernel: [258475.083512] ata3.00: error: { UNC }
> Sep 15 19:34:16 asterisk kernel: [258476.100935] ata3.00: configured for=
=20
> UDMA/133
> Sep 15 19:34:16 asterisk kernel: [258476.100960] ata3: EH complete
> Sep 15 19:41:29 asterisk asterisk[3492]: rc_avpair_new: unknown=20
> attribute 1490026597
> Sep 15 19:41:46 asterisk asterisk[3492]: rc_avpair_new: unknown=20
> attribute 1490026597
> Sep 15 19:41:52 asterisk asterisk[3492]: rc_avpair_new: unknown=20
> attribute 1490026597
> Sep 15 19:42:52 asterisk asterisk[3492]: rc_avpair_new: unknown=20
> attribute 1490026597
> Sep 15 19:46:34 asterisk smartd[2581]: Device: /dev/sda [SAT], 2=20
> Currently unreadable (pending) sectors
> Sep 15 19:46:34 asterisk smartd[2581]: Device: /dev/sda [SAT], 1 Offline=
=20
> uncorrectable sectors
> Sep 15 19:50:51 asterisk mdadm[2117]: Rebuild26 event detected on md=20
> device /dev/md/0
> Sep 15 20:07:31 asterisk mdadm[2117]: Rebuild53 event detected on md=20
> device /dev/md/0
> Sep 15 20:16:34 asterisk smartd[2581]: Device: /dev/sda [SAT], 2=20
> Currently unreadable (pending) sectors
> Sep 15 20:16:34 asterisk smartd[2581]: Device: /dev/sda [SAT], 1 Offline=
=20
> uncorrectable sectors
> Sep 15 20:16:34 asterisk smartd[2581]: Device: /dev/sda [SAT],=20
> Temperature changed +4 Celsius to 42 Celsius (Min/Max 30/46)
> Sep 15 20:16:34 asterisk smartd[2581]: Device: /dev/sda [SAT], SMART=20
> Usage Attribute: 201 Soft_Read_Error_Rate changed from 99 to 100
> Sep 15 20:16:34 asterisk smartd[2581]: Device: /dev/sdb [SAT], SMART=20
> Usage Attribute: 190 Airflow_Temperature_Cel changed from 61 to 60
> Sep 15 20:24:11 asterisk mdadm[2117]: Rebuild75 event detected on md=20
> device /dev/md/0
> Sep 15 20:40:51 asterisk mdadm[2117]: Rebuild93 event detected on md=20
> device /dev/md/0
> Sep 15 20:46:34 asterisk smartd[2581]: Device: /dev/sda [SAT], 2=20
> Currently unreadable (pending) sectors
> Sep 15 20:46:34 asterisk smartd[2581]: Device: /dev/sda [SAT], 1 Offline=
=20
> uncorrectable sectors
> Sep 15 20:46:34 asterisk smartd[2581]: Device: /dev/sda [SAT], SMART=20
> Usage Attribute: 190 Airflow_Temperature_Cel changed from 61 to 60
> Sep 15 20:47:24 asterisk kernel: [262863.781068] md: md0:=20
> requested-resync done.
> Sep 15 20:47:24 asterisk mdadm[2117]: RebuildFinished event detected on=
=20
> md device /dev/md/0
>=20
>=20
Okay, so the drive logs an exception at 19:34:11, then completes its
error handling at 19:34:16.

If md hasn't failed the drive then either:
  - md didn't get a read error
  - md got a success message when re-writing the block
  - there's a bug in md and it's not handled the error at all

My guess would be on one of the first two (I'm not sure what's logged if
md gets a read error and does a re-write).

>=20
> I still get:
>=20
> Num  Test_Description    Status                  Remaining=20
> LifeTime(hours)  LBA_of_first_error
> # 1  Offline             Completed: read failure       90%      8985=20
>       3912
>=20
> and
>=20
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always=
=20
>        -       2
> 198 Offline_Uncorrectable   0x0030   100   100   000    Old_age=20
> Offline      -       1
>=20
>=20
> How is it possible? Next thing I will try is manually failing /dev/sda=20
> and filling it with zeros. I would like to do a *low level format* but I=
=20
> didn't find the utility for my disk :(
>=20
I'm pretty sure there's no such thing as a *low level format* for any
modern disk (or not one that does anything more than writing a known
pattern to the disk). The low-level information is far too precisely
laid out for the disk heads to be able to write.

Writing zeros is certainly what I'd do in this situation - I've done it
for several drives in the past where they've had offline uncorrectable
sectors flagged.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBU2c0ACgkQShxCyD40xBIl0QCffAP9OtcGiBWP4HM2E3VhiH12
no8AoJJE38bJKx2VINK1M+kJPgA/uk/8
=TPKa
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
