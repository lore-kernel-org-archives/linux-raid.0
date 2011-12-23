From: Philip Hands <phil@hands.com>
Subject: RAID1 seems not to be able to scrub pending sectors shown by smart
Date: Fri, 23 Dec 2011 18:39:05 +0000
Message-ID: <87hb0r2kvq.fsf@poker.hands.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Transfer-Encoding: quoted-printable

Hi,

This is a little vague I'm afraid, but I've saved the syslogs, so please
feel free to ask for details if they'd help track down what's happening.

I'm running a relatively busy server (it hosts the VM for
ftp.uk.debian.org among other things) which has 6 disks, four of which
are 2TB Western Digital Caviar Black drives.

Each of the 2TB drives is split into a couple of small partitions at the
front (250MB & 750MB) on which are built 4-way RAID1s containing /boot
and / respectively, with the rest of the drives split into 4 ~500GB
chunks, which are then assembled into 5 3-way RAID1s.

A while ago, one of the drives started showing an increasing number of
pending sectors, over the course of several weeks getting up to 360 or
so.  Meanwhile another of the drives got up to about 90 pending sectors.

I assumed that by forcing a check, it would read the drives, notice that
sectors were unreadable, and write the data back from one of the clean
drives, but having run checks on all drives, the number of pending
sectors went down by about five or so each time (or once about ten) and
then crept up again.

So, I went in to the co-lo to see if there was something like a lose
cable causing the problem, say -- and just before I left I removed the
drive with fewer pending sectors, zeroed the superblocks to ensure that
it really would rewrite things, and then added it back in -- it dropped
the pending sector count from ~90 to 10 quite quickly, at which point
smart started declaring the dive as failed.  I've now replaced that drive.

The replacement drive was fitted a few days ago, and has now synced up.

While it was syncing, the drive with 360-ish pending sectors started
throwing many read errors, but the pending sector count remained
static -- this seems wrong to me.  Surely the md code should notice the
read errors, and decide to rewrite the data from the remaining drive.

While the read errors were happening, the system performance became dire
(with system load going up to about 15, as opposed to the normal 1-3,
and the whole system regularly pausing -- I had previously assumed that
this might be due to busy networks or dropped packets, but when I was
on-site I noticed that when a read error was occurring, that all other
disk activity would halt, as would the responsiveness of the CLI).

So, I failed the 360-pending-sector drive out of the RAID, and all
returned to normal, performance-wise.

Once the RAID synced (the one remaining disk, and the one that was
supplied as a replacement), I added the apparently duff dusk back into
the array, having zeroed its superblock, and made sure that the first
array to rebuild was the one containing at least some of the pending
sectors -- it turns out that that partition contained all of the pending
sectors, as they are now all gone.

None of those sectors has resulted in a reallocated sector, so they were
soft errors it seems -- so what I'm wondering is why none of the checks
or repairs I've run over the preceding weeks managed to put a dent in
the number of pending sectors.

I'll admit the possibility that some cabling or controller issue may have
been causing the duff sectors, as I've now moved it to a different SATA
port, but even so, is seems that it wasn't even trying to rewrite the
data.  It seems more likely that there really is some fault with the
disk (especially since a smart long test has just revealed another
unreadable sector in about the same area of the disk).

Perhaps you can suggest what I should look out for in the logs to
determine if read failures are really rewriting the blocks, or if my
suspicion that it's not happening is true.

Here's a sampling of one day's log which seems to show what I'm on
about:

  http://hands.com/~phil/tmp/sheikh.hands.com-mdadm-syslog-20111205

if for instance, you search for '25314' you'll find loads of this sort
of thing:

Dec  5 17:00:54 sheikh kernel: [1663261.867952] md/raid1:md4: redirecting s=
ector 253145096 to other mirror: sdd4
Dec  5 17:00:54 sheikh kernel: [1663262.017791] md/raid1:md4: redirecting s=
ector 253145104 to other mirror: sdd4
Dec  5 17:00:55 sheikh kernel: [1663262.451139] md/raid1:md4: redirecting s=
ector 253145112 to other mirror: sdd4
Dec  5 17:00:56 sheikh kernel: [1663263.409472] md/raid1:md4: redirecting s=
ector 253145120 to other mirror: sdd4
Dec  5 17:00:56 sheikh kernel: [1663263.734508] md/raid1:md4: redirecting s=
ector 253145128 to other mirror: sdd4
Dec  5 17:00:56 sheikh kernel: [1663263.967813] md/raid1:md4: redirecting s=
ector 253145136 to other mirror: sdd4
Dec  5 17:00:56 sheikh kernel: [1663264.034509] md/raid1:md4: redirecting s=
ector 253145144 to other mirror: sdd4
Dec  5 17:00:56 sheikh kernel: [1663264.209565] md/raid1:md4: redirecting s=
ector 253145152 to other mirror: sdd4
Dec  5 17:00:58 sheikh kernel: [1663265.609860] md/raid1:md4: redirecting s=
ector 253145160 to other mirror: sdd4
Dec  5 17:00:58 sheikh kernel: [1663265.992975] md/raid1:md4: redirecting s=
ector 253145168 to other mirror: sdd4

often preceded by something like:

Dec  5 17:00:41 sheikh kernel: [1663248.685965] md/raid1:md4: read error co=
rrected (8 sectors at 253147088 on sdg4)

but to my eye, there don't seem to be enough of these corrections to go
with the errors, and they didn't get rid of all the pending sectors that
have since been wiped out as described above.

Once the raid that's currently rebuilding has finished (in about an
hour), I'll tell it to do a check to see if that notices/fixes the new
pending block that's turned up.

Cheers, Phil.
=2D-=20
|)|  Philip Hands [+44 (0)20 8530 9560]    http://www.hands.com/
|-|  HANDS.COM Ltd.                    http://www.uk.debian.org/
|(|  10 Onslow Gardens, South Woodford, London  E18 1NE  ENGLAND

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCgAGBQJO9MrJAAoJENBLo6ABJdXAV2EP/iU56J6A6NkrRgpO26g408aW
JdP/aLiFZZHw3URUqS6AhMoBGK04sE62rTWfxhLJ9Prqz1b10U+hL9bj99HOsRiX
Z0m/5LLHRLQDj+qy6ODPXU0DtvcgM5sO0M5u4odG8mS8f6i50cQvenl31HrfMvhb
xstQtz52L94vsz9gSsUK33zQDVmbv+r/RejbQQ4jV+LD+wy8Dj/SW8LoZwj+QZMv
FV+qvzgSp1zjdRSD6n2qpEol0BjQsqZDOVb7ojYJQapM64Wy4u05qXWJEtLIL350
SRraepqWLin77a66Wr2qngP0O7TxETUNe/ZcZ61Ml6AUPAwGzt/EpnVojIBA6MSq
HMUwYFkWz9/oKPwY1lVyEimphFlBN4g8Xe7hypoPJ+RK5o7CDtQcHeI5EqsMRdpe
2KBDt+TxM24YiR/6DzeUkiLPsGtiHQMmgz+dQdXU2xVO5g6qSGcocRWaUvSVreLd
nOUrPLhcWegwPLwtFrHRlsQZHGrHRASvNx0W3Lt0BUAarEPkfmjbYrsAT3rdqeYB
rVpiOHZxCm0H/RUwRBTRUUL0fHLM4RrvcSt9f/5mpyc4ymaRMscIdDQWwUVTrFx0
uBlXc2FfP+61ejsgCJM++QE9bU+2KyJb/w1IUfeUJrrbCgwVtDfoejCbla+pef2B
iyFeYfMxF28sHZHWmiWd
=6WI8
-----END PGP SIGNATURE-----
--=-=-=--
