From: NeilBrown <neilb@suse.com>
Subject: Re: Question on blocks periodic writes
Date: Thu, 10 Nov 2016 13:00:05 +1100
Message-ID: <8760nwm6vu.fsf@notabene.neil.brown.name>
References: <CAOzB0-6NYUqrzUyx3iQ8CbPwFh-dctKTVwE6GKupdYM-8AfOrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOzB0-6NYUqrzUyx3iQ8CbPwFh-dctKTVwE6GKupdYM-8AfOrg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Theophanis Kontogiannis <tkonto@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Nov 10 2016, Theophanis Kontogiannis wrote:

> Hello All,
>
> I am in the middle of bringing my server's power consumption to an
> absolute minimum.
>
> Have already reduced idle power from 110W to 52W (including 10W
> consumed by the UPS).
>
> Having enabled spin down to all 5 x 2TB disks, with 5 seconds idle
> times, I noticed that the disks wake up quite often without the server
> doing anything actual.
>
> Following
>
>    'echo 1 > /proc/sys/vm/block_dump'
>
> I can not miss that
>
>    'dmesg -c'
>
> reports frequent messages like:
>
> [ 8662.496150] md0_raid6(631): WRITE block 16 on sda3 (8 sectors)
> [ 8662.496185] md0_raid6(631): WRITE block 16 on sdf3 (8 sectors)
> [ 8662.496253] md0_raid6(631): WRITE block 16 on sdg3 (8 sectors)
> [ 8662.496269] md0_raid6(631): WRITE block 16 on sdd3 (8 sectors)
> [ 8662.496282] md0_raid6(631): WRITE block 16 on sde3 (8 sectors)

These are probably the md bitmap being updated.
If you provided some basic detail about you array like
  mdadm --detail /dev/md1
  mdadm --examine /dev/sda3
it would be easier to be sure.


> [ 8664.849252] md0_raid6(631): WRITE block 8 on sda3 (1 sectors)
> [ 8664.849276] md0_raid6(631): WRITE block 8 on sdf3 (1 sectors)
> [ 8664.849287] md0_raid6(631): WRITE block 8 on sdg3 (1 sectors)
> [ 8664.849298] md0_raid6(631): WRITE block 8 on sdd3 (1 sectors)
> [ 8664.849352] md0_raid6(631): WRITE block 8 on sde3 (1 sectors)

This is probably the superblock being updated.

> [ 8664.858104] xfsaild/md1(658): WRITE block 0 on md1 (8 sectors)

This is XFS doing something.  md cannot possibly stop all IO while the
filesystem performs occasional IO.  If these continue, you need to
discuss with xfs developers how to stop it.  If the writes to individual
drives continue after there are no writes to 'md1', then it is worth
coming back here to ask.


> [ 8664.902688] md0_raid6(631): WRITE block 16 on sda3 (8 sectors)

> [ 8665.177050] md0_raid6(631): WRITE block 16 on sda3 (8 sectors)

> [ 8670.269138] md0_raid6(631): WRITE block 16 on sda3 (8 sectors)

> [ 8680.269050] md0_raid6(631): WRITE block 16 on sda3 (8 sectors)

The delay here is 270ms, then 5 seconds, then 10 seconds.
Does it reach a stable state?  What is the period in the stable state?

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYI9SlAAoJEDnsnt1WYoG5c8gP/Rf21uSO5ygD7x9s0W2SOyCD
LIJFDXjBi6EUHgy3L5gUd7OnzseQzbW5O6U+1B9okroh2OHRNOkFCOkcPI532KQ7
EZlq7iQZzYtr/eVIxju8pQogiML37cZxYzalTHaUNCeJJfMEzUa7bmQdItUfI9i6
57IbFngj/GrabOmHPEsAfwPRuexGp2lwmzVnv7srif3pncpzDQQuMPN45ZoHLlcL
AsLub5Fd5vTfZQhiMOBoO/szcsXPeI1TdtLvpxw32F3hBflLRsJzeWqYlpiQId2f
HodYvmoYTdZA78PCgZGg5Suv2iOo1Q11H5qTgJRmXFodr4kNIJrd9347qxrcLhYg
U4odTEF87S7+CWMeL2r1jxvRMahgl18GCVbiLFKUdWPPdLdu3gZlziiRHEpT/sZp
Kkyqt1nQpiQRo7HMRmglCgwbdgA7koWchZaVGZvB6OSJ4YhcPxXS3ID50BStjKMY
fOLGvIcwutlddFz7J3frSGCmNeqTRhDLAiizITt9a8Vxm7zZ8rwqEi1JIWTG/FRd
GbM2TZQYykJ65vq4CI1MyItexM/ttkhexi69/8eWZVdUkdozE69h7QXgH9ReSmyC
TbIb97g3Ham+2OT++movUnwDI4aPBJ/wf4PteL7AuEi6gwVS+Gk0FYFPs9jcIpBO
ZOQrF5/uwXX7bb/AeC2+
=wBRD
-----END PGP SIGNATURE-----
--=-=-=--
