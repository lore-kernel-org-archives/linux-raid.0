From: Andre Noll <maan@systemlinux.org>
Subject: Re: Read errors on raid5 device; array is still clean
Date: Thu, 14 Jan 2010 20:59:27 +0100
Message-ID: <20100114195927.GN7517@skl-net.de>
References: <4B4E261E.7070508@ungerer.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Osvg0bgWkLaeQPMj"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B4E261E.7070508@ungerer.us>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Ungerer <steve@ungerer.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Osvg0bgWkLaeQPMj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14:59, Steve Ungerer wrote:
> Jan 13 10:50:28 RAID kernel: [3126305.778753] ata3.00: cmd 60/00:30:3f:39=
:4d/01:00:64:00:00/40 tag 6 ncq 131072 in
> Jan 13 10:50:28 RAID kernel: [3126305.778754]          res 41/40:34:3f:39=
:4d/40:00:64:00:00/40 Emask 0x9 (media error)
> Jan 13 10:50:28 RAID kernel: [3126305.778799] ata3.00: status: { DRDY ERR=
 }
> Jan 13 10:50:28 RAID kernel: [3126305.778812] ata3.00: error: { UNC }
> Jan 13 10:50:28 RAID kernel: [3126305.778828] ata3: hard resetting link
> Jan 13 10:50:29 RAID kernel: [3126306.680039] ata3: SATA link up 3.0 Gbps=
 (SStatus 123 SControl 300)
> Jan 13 10:50:29 RAID kernel: [3126306.720221] ata3.00: configured for UDM=
A/133
> Jan 13 10:50:29 RAID kernel: [3126306.720269] sd 2:0:0:0: [sdc] Result: h=
ostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE,SUGGEST_OK
> <snip>
> Jan 13 10:50:29 RAID kernel: [3126306.720534] end_request: I/O error, dev=
 sdc, sector 1682783039
> Jan 13 10:50:29 RAID kernel: [3126306.720573] sd 2:0:0:0: [sdc] Result: h=
ostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE,SUGGEST_OK
> Jan 13 10:50:29 RAID kernel: [3126306.720576] sd 2:0:0:0: [sdc] Sense Key=
 : Medium Error [current] [descriptor]
> Jan 13 10:50:29 RAID kernel: [3126306.720578] Descriptor sense data with =
sense descriptors (in hex):
> Jan 13 10:50:29 RAID kernel: [3126306.720580]         72 03 11 04 00 00 0=
0 0c 00 0a 80 00 00 00 00 00=20
> Jan 13 10:50:29 RAID kernel: [3126306.720586]         64 4d 39 3f=20
> Jan 13 10:50:29 RAID kernel: [3126306.720588] sd 2:0:0:0: [sdc] Add. Sens=
e: Unrecovered read error - auto reallocate failed
> Jan 13 10:50:29 RAID kernel: [3126306.720591] end_request: I/O error, dev=
 sdc, sector 1682782783
> Jan 13 10:50:29 RAID kernel: [3126306.720631] sd 2:0:0:0: [sdc] Result: h=
ostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE,SUGGEST_OK
> Jan 13 10:50:29 RAID kernel: [3126306.720633] sd 2:0:0:0: [sdc] Sense Key=
 : Medium Error [current] [descriptor]
> Jan 13 10:50:29 RAID kernel: [3126306.720636] Descriptor sense data with =
sense descriptors (in hex):
> Jan 13 10:50:29 RAID kernel: [3126306.720637]         72 03 11 04 00 00 0=
0 0c 00 0a 80 00 00 00 00 00=20
> Jan 13 10:50:29 RAID kernel: [3126306.720643]         64 4d 39 3f=20
> Jan 13 10:50:29 RAID kernel: [3126306.720646] sd 2:0:0:0: [sdc] Add. Sens=
e: Unrecovered read error - auto reallocate failed
> Jan 13 10:50:29 RAID kernel: [3126306.720648] end_request: I/O error, dev=
 sdc, sector 1682782527
> Jan 13 10:50:29 RAID kernel: [3126306.720683] ata3: EH complete
> Jan 13 10:50:29 RAID kernel: [3126306.720720] sd 2:0:0:0: [sdc] 195352516=
8 512-byte hardware sectors: (1.00 TB/931 GiB)
> Jan 13 10:50:29 RAID kernel: [3126306.720734] sd 2:0:0:0: [sdc] Write Pro=
tect is off
> Jan 13 10:50:29 RAID kernel: [3126306.720736] sd 2:0:0:0: [sdc] Mode Sens=
e: 00 3a 00 00
> Jan 13 10:50:29 RAID kernel: [3126306.720755] sd 2:0:0:0: [sdc] Write cac=
he: enabled, read cache: enabled, doesn't support DPO or FUA
> Jan 13 10:50:29 RAID kernel: [3126306.733783] __ratelimit: 182 callbacks =
suppressed
> Jan 13 10:50:29 RAID kernel: [3126306.733786] raid5:md0: read error corre=
cted (8 sectors at 1682781184 on sdc1)
> Jan 13 10:50:29 RAID kernel: [3126306.733790] raid5:md0: read error corre=
cted (8 sectors at 1682781192 on sdc1)
> Jan 13 10:50:29 RAID kernel: [3126306.733793] raid5:md0: read error corre=
cted (8 sectors at 1682781200 on sdc1)
> Jan 13 10:50:29 RAID kernel: [3126306.733795] raid5:md0: read error corre=
cted (8 sectors at 1682781208 on sdc1)
> Jan 13 10:50:29 RAID kernel: [3126306.733798] raid5:md0: read error corre=
cted (8 sectors at 1682781216 on sdc1)
> Jan 13 10:50:29 RAID kernel: [3126306.733800] raid5:md0: read error corre=
cted (8 sectors at 1682781224 on sdc1)
> Jan 13 10:50:29 RAID kernel: [3126306.733802] raid5:md0: read error corre=
cted (8 sectors at 1682781232 on sdc1)
> Jan 13 10:50:29 RAID kernel: [3126306.733809] raid5:md0: read error corre=
cted (8 sectors at 1682781240 on sdc1)
> Jan 13 10:50:29 RAID kernel: [3126306.733811] raid5:md0: read error corre=
cted (8 sectors at 1682781248 on sdc1)
> Jan 13 10:50:29 RAID kernel: [3126306.733814] raid5:md0: read error corre=
cted (8 sectors at 1682781256 on sdc1)
> </snip>
>=20
> My first question: what exactly is going on here? /dev/sdc reports an
> unrecovered read error, md tries to reset the link, reattempts the
> read which still fails, recovers parity from the other drives in the
> array?

Yes (but it's the (S)ATA layer that resets the link).

> Does anything happen to these bad sectors on sdc?

md computes the data the read should have returned by reading all
other component devices of the array. Then it writes that data back
to the bad sector on sdc1 in the hope the drive will reassign the
bad sector. The "read error corrected" message indicates that this
write succeeded.

> A check of the md array still shows it as clean with no drives failing.

This is how it is supposed to be :)

> Is there the possibility I'm replacing a perfectly good drive and
> these errors are due to some software problem?

Unlikely, since you mentioned the smart log also contains error
messages.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Osvg0bgWkLaeQPMj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLT3efWto1QDEAkw8RAjsWAKCgD4dUFNub3VTgOsdVDZD04/d1pQCeIjYr
um88UfgcWr/30b4FNczd3xw=
=gM9V
-----END PGP SIGNATURE-----

--Osvg0bgWkLaeQPMj--
