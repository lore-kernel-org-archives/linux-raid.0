From: Philip Hands <phil@hands.com>
Subject: mdadm seems not be doing rewrites on unreadable blocks
Date: Mon, 29 Nov 2010 15:23:56 +0000
Message-ID: <87oc98jgqb.fsf@poker.hands.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Transfer-Encoding: quoted-printable

Hi,

I have a server with some 2TB disks, that are partitioned, and those
partitions assembled as RAID1's.

One of the disks has been showing non-zero Current_Pending_Sectors in
smart, so I've added more disks to the machine, partitioned one of the
new disks, and added each of it's partitions to the relevant RAID,
growing the raid to three devices to force the data to be written to the
new disk.

Initially, I did this under single user mode, so that was the only thing
going on on the machine.

One of the old drives (/dev/sda at the time, and the first disk in the
RAID0) then started throwing lots of errors, which seemed to take a long
time to resolve each -- watching this made me think that, under the
circumstances, rather than continuing to read only from /dev/sda, it
might be bright to try reading from /dev/sdb (the other original disk)
in order to provide the data for /dev/sdc (the new disk).

Also, I got the impression that the data on the unreadable blocks was
not being written back to /dev/sda once it was finally read from
/dev/sdb (although confirming that wasn't easy when on the console, with
errors pouring up the screen, and the system being rather unresponsive,
so I rebooted -- after the reboot, it seemed to be getting along better,
so I put it back in production).

After waiting the several days it took to allow the third disk to be
populated with data, I thought I'd try forcing the unreadable sectors to
be written, to get them remapped if they were really bad, or just to get
rid of the Current_Pending_Sector count if it was just a case of the
sectors being corrupt but the physical sector being OK.

[BTW After some rearrangement while I was doing the install, the
doubtful disk is now /dev/sdb, while the newly copied disk is /dev/sdc]

So choosing one of the sectors in question, I did:

  root#  dd bs=3D512 skip=3D19087681 seek=3D19087681 count=3D1 if=3D/dev/sd=
c of=3D/dev/sdb
  dd: writing `/dev/sdb': Input/output error
  1+0 records in
  0+0 records out
  0 bytes (0 B) copied, 11.3113 s, 0.0 kB/s

Which gives rise to this:

[325487.740650] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[325487.740746] ata2.00: irq_stat 0x00060002, device error via D2H FIS
[325487.740841] ata2.00: failed command: READ DMA
[325487.740924] ata2.00: cmd c8/00:08:40:41:23/00:00:00:00:00/e1 tag 0 dma =
4096 in
[325487.740925]          res 51/40:00:41:41:23/00:00:01:00:00/e1 Emask 0x9 =
(media error)
[325487.741153] ata2.00: status: { DRDY ERR }
[325487.741230] ata2.00: error: { UNC }
[325487.749790] ata2.00: configured for UDMA/100
[325487.749797] ata2: EH complete
[325489.757669] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[325489.757759] ata2.00: irq_stat 0x00060002, device error via D2H FIS
[325489.757852] ata2.00: failed command: READ DMA
[325489.757936] ata2.00: cmd c8/00:08:40:41:23/00:00:00:00:00/e1 tag 0 dma =
4096 in
[325489.757937]          res 51/40:00:41:41:23/00:00:01:00:00/e1 Emask 0x9 =
(media error)
[325489.758165] ata2.00: status: { DRDY ERR }
[325489.758243] ata2.00: error: { UNC }
[325489.766758] ata2.00: configured for UDMA/100
[325489.766765] ata2: EH complete
[325491.532420] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[325491.532508] ata2.00: irq_stat 0x00060002, device error via D2H FIS
[325491.532595] ata2.00: failed command: READ DMA
[325491.532676] ata2.00: cmd c8/00:08:40:41:23/00:00:00:00:00/e1 tag 0 dma =
4096 in
[325491.532677]          res 51/40:00:41:41:23/00:00:01:00:00/e1 Emask 0x9 =
(media error)
[325491.532902] ata2.00: status: { DRDY ERR }
[325491.532978] ata2.00: error: { UNC }
[325491.543346] ata2.00: configured for UDMA/100
[325491.543354] ata2: EH complete
[325493.424305] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[325493.424397] ata2.00: irq_stat 0x00060002, device error via D2H FIS
[325493.424481] ata2.00: failed command: READ DMA
[325493.424571] ata2.00: cmd c8/00:08:40:41:23/00:00:00:00:00/e1 tag 0 dma =
4096 in
[325493.424572]          res 51/40:00:41:41:23/00:00:01:00:00/e1 Emask 0x9 =
(media error)
[325493.424792] ata2.00: status: { DRDY ERR }
[325493.424874] ata2.00: error: { UNC }
[325493.435219] ata2.00: configured for UDMA/100
[325493.435226] ata2: EH complete
[325495.190061] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[325495.190145] ata2.00: irq_stat 0x00060002, device error via D2H FIS
[325495.190232] ata2.00: failed command: READ DMA
[325495.190312] ata2.00: cmd c8/00:08:40:41:23/00:00:00:00:00/e1 tag 0 dma =
4096 in
[325495.190313]          res 51/40:00:41:41:23/00:00:01:00:00/e1 Emask 0x9 =
(media error)
[325495.190545] ata2.00: status: { DRDY ERR }
[325495.190613] ata2.00: error: { UNC }
[325495.200984] ata2.00: configured for UDMA/100
[325495.200991] ata2: EH complete
[325497.090964] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[325497.091059] ata2.00: irq_stat 0x00060002, device error via D2H FIS
[325497.091160] ata2.00: failed command: READ DMA
[325497.091241] ata2.00: cmd c8/00:08:40:41:23/00:00:00:00:00/e1 tag 0 dma =
4096 in
[325497.091242]          res 51/40:00:41:41:23/00:00:01:00:00/e1 Emask 0x9 =
(media error)
[325497.091473] ata2.00: status: { DRDY ERR }
[325497.091552] ata2.00: error: { UNC }
[325497.100074] ata2.00: configured for UDMA/100
[325497.100081] sd 1:0:0:0: [sdb] Unhandled sense code
[325497.100082] sd 1:0:0:0: [sdb] Result: hostbyte=3DDID_OK driverbyte=3DDR=
IVER_SENSE
[325497.100084] sd 1:0:0:0: [sdb] Sense Key : Medium Error [current] [descr=
iptor]
[325497.100087] Descriptor sense data with sense descriptors (in hex):
[325497.100088]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[325497.100092]         01 23 41 41=20
[325497.100094] sd 1:0:0:0: [sdb] Add. Sense: Unrecovered read error - auto=
 reallocate failed
[325497.100097] sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 01 23 41 40 00 00 08=
 00
[325497.100101] end_request: I/O error, dev sdb, sector 19087681
[325497.100197] ata2: EH complete

If I use hdparm's --write-sector on the same sector, it succeeds, and
the dd then succeeds (unless there's another sector following that's
also bad).  This doesn't end up resulting in Reallocated_Sector_Ct
increasing (it's still zero on that disk), so it seems that the disk
thinks the physical sector is fine now that it's been written.

I get the impression that for several of the sectors in question,
attempting to write the bad sector revealed a sector one or two
further into the disk that was also corrupt, so despite writing about 20
of them, the Pending sector count has actually gone up from 12 to 32.

Given all that, it seems like this might be a good test case, so I
stopped fixing things in the hope that we'd be able to use the bad
blocks for testing.

I have failed the disk out of the array though (which might be a bit of
an mistake from the testing side of things, but seemed prudent since I'm
serving live data from this server).

So, any suggestions about how I can use this for testing, or why it
appears that mdadm isn't doing it's job a well as it might?  I would
think that it should do whatever hdparm's --write-sector does to get the
sector writable again, and then write the data back from the good disk,
since leaving it with the bad blocks means that the RAID is degraded for
those blocks at least.

If it really cannot rewrite the sector then should it not be declaring
the disk faulty?  Not that I think that would be the best thing to do in
this circumstance, since it's clearly not _that_ faulty, but blithely
carrying on when some of the data is no longer redundant seems broken as
well.

=3D-=3D-=3D-=3D-

BTW The machine is running Debian Squeeze, with the kernel being:

  linux-image-2.6.35-trunk-amd64_2.6.35-1~experimental.3

The version of mdadm is 3.1.4-1+8efb9d1, hdparm is 9.27-2.1, the drives
in question are all WDC WD2001FASS-00W2B0 (firmware: 01.00101)

Cheers, Phil.

P.S.  I'm not subscribed to the list, so please Cc: replies to me.
=2D-
|)|  Philip Hands [+44 (0)20 8530 9560]    http://www.hands.com/
|-|  HANDS.COM Ltd.                    http://www.uk.debian.org/
|(|  10 Onslow Gardens, South Woodford, London  E18 1NE  ENGLAND

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJM88WMAAoJENBLo6ABJdXAniAQAKW/pDu+eZ2HW22zN9Izqm0N
BuKp9gawVJUpSbKFXAPr/w+Ef2NnurB+GnE9nAm/1fo0tdIZiAKWqlnMRPiQIf5h
bvvY65rHAM/320OWPC8uV5ZfoSwdwz91reoA4gCzN5dGPaVHIdQdqlbyaz7gyN2M
fNwoQyy5lqhICwc9IIFMwbA52GbyjG9JUGwkRu/FfS74af/oJraFq5/cUmFVL6Ka
u6Io1qoZDjfe3L2mz+3QhO7pfl8Rknn3EbVaJBnsiL0TK2sSwTWqlMzsl1D5LQHx
sFTz1pEmaP2vs38pZxGaKQGsWfcgcLaGa7WFiBF8V9e83SGh/nM5r0A8r6mJl2t8
xWdtNXguzEEY9hy8XZRPRA/y7vQ/oeRx/WSeyRei6AFqbTkuGeHuialteSFDhcDE
nvS2jJzX3BAdH8Jjy0M/xAhOzYYNzMdC0H1Cp/NMOgd9nhRBS+d+uqm+lH5VVgIa
IfMpJNofkQN/msAV9xSeUv7Z1qPAY0BQt2RKu1LIu25KkFkFYxrmK6FWda/wRwEr
VDAu6aZV40Dp1eXzIf7wZii5gMUPown0fodf71yias7GtuFw8HaY1F0PzmOXR30a
dlphBHQ75wRKD9vwe4qC7kF0ZrfUynJq4gEABO+V66WvLbbG227pvA0cwZ5TiIvW
U+TOknHEBpaBxJbXYYUM
=140O
-----END PGP SIGNATURE-----
--=-=-=--
