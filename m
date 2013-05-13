From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Raid5 double failure recovery
Date: Mon, 13 May 2013 09:17:26 +0100
Message-ID: <20130513081726.GA6856@cthulhu.home.robinhill.me.uk>
References: <CAGXrYFTxx_2Avk5cCm9omm2hE_O12uF0qdFSttrFVfEpz64Yag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXrYFTxx_2Avk5cCm9omm2hE_O12uF0qdFSttrFVfEpz64Yag@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Finley <debenbain@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun May 12, 2013 at 05:01:57PM -0700, Chris Finley wrote:

> I could really use some experienced guidance before proceeding. This 4
> disk raid 5 (md0) holds media for MythTV and represents a great deal
> of work ripping my own DVDs. The system is on another drive, so most
> of the raid content is large-file and contiguous.
>=20
> System:  /dev/sda
> Raid:   /dev/sd[cdef]1
>=20
> From what I can tell, about a week ago, sde dropped out of the array.
> Ironically, Disk Utility says this drive is "healthy". With new disk
> in hand, I went to repair it a few days ago and found sdd dropped from
> the array as well.  I ran bad-blocks -v on sdd which found more bad
> sectors. I have NOT tried to force assembly or recreation of the
> array.
> The mdadm -E results are at
> http://pastebin.com/7ng1bmyZ.
>=20
> The event counts:
> sdc : 42810
> sdd : 42785
> sde : 35760
> sdf : 42810
>=20
> I was thinking of doing a force assembly and then adding the new drive
> as a fourth.
> mdadm --assemble --force /dev/sd[cdf]1
> Since these three are the closest event counts.
>=20
> Questions:
> 1. Would including sde (with the week-old data) in the forced assembly
> provide any additional information for the re-build? Is it better to
> start with a failed 3 drive array using the drive last in the array?
>=20
Including sde as well wouldn't help at all - it'd be left out of the
assembly anyway as its event count is lowest. Even with the issues on
sdd, it's highly unlikely that using sde instead would provide a more
consistent result.

> 2. I read in the archives about ddrescue. Should I use it to copy
> some/all of the drives to new drives first? I am concerned the failed
> drive would not survive a consistency check and raid rebuild. Which
> drives? Even sdc has a non-zero read error rate, but is still
> considered "healthy".
>=20
Yes, definitely use this to recover sdd first. The read error rate is
unlikely to be an issue - most drives will get some read errors, but
they're usually resolved internally by a re-read. Reallocated and
pending sectors are more of an issue, and your smartctl output shows
only sdd has issues there.

> 3. How likely is the smartmontools firmware-bug the cause of these
> errors? These are all Samsung HD204UI drives. The raid has been
> running for about 2 years; although, I just recently updated to Ubuntu
> 12.04.
> Smartmontools was installed yesterday to produce the smart_all output:
> http://pastebin.com/bP1EruEK
>=20
Unlikely. At a guess sde was kicked out due to error recovery taking too
long, then sdd failed during the rebuild due to the unreadable blocks.
You'd need to check the dmesg output at the point sde was kicked out to
be sure though.  Your drives do support SCTERC, so it's worth making
sure that's enabled and set. Use:
    smartctl -l scterc /dev/sdb
to check the current setting, and:
    smartctl -l scterc 70,70 /dev/sdb
to limit read/write error recovery to 7 seconds (the normal setting for
enterprise drives).

I'd recommend using GNU ddrescue to recover sdd to the new disk, then
use that along with sdc and sdf to force assemble the array. Depending
on how much was unreadable from sdd, you're likely to end up with an
amount of filesystem corruption, so a fsck will be needed. You may also
have file data corruption which won't get picked up, but hopefully
that'll be limited to a small number of files (and, with video files,
can cause very little obvious damage). You can then add sde back into
the array and let it rebuild.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlGQoZUACgkQShxCyD40xBLEJQCgzby07WEHHZihImTb08wqfD5B
aTIAni+43AIeYZfaOcSWrUoFm7n7tyT/
=hXvD
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
