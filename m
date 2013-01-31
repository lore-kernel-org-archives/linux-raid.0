From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Thu, 31 Jan 2013 13:45:31 +0000
Message-ID: <20130131134531.GB20536@cthulhu.home.robinhill.me.uk>
References: <510A4AAE.6000009@evilazrael.de>
 <20130131113820.GA20536@cthulhu.home.robinhill.me.uk>
 <510A6E54.5050001@evilazrael.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <510A6E54.5050001@evilazrael.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jan 31, 2013 at 02:15:00PM +0100, Christoph Nelles wrote:

> Hello Robin,
>=20
> thanks for the answers :)
>=20
> Am 31.01.2013 12:38, schrieb Robin Hill:
> > Probably only one drive failed. If the rebuild was incomplete then a
> > single drive failure would cause the array to fail. Can you post the
> > errors? If the issue was a read failure then you'll need to fix that
> > before the array can be recovered properly.
>=20
> All drives are available again. And the seecond failed device reports
> UREs. I will run badblocks on that device before continuing.
> I attached the kernel logs of the first error and of the second error. I
> hope i filtered them reasonably.
>=20
Okay, those show that sdj had a read error during the rebuild. That
would have kicked the drive and failed the rebuild (and the array).

Your earlier error with sdg is a different issue. It looks to have timed
out on a write and then errored again when resetting the drive.

If you're using standard desktop drives then you may be running into
issues with the drive timeout being longer than the kernel's. You need
to reset on or the other to ensure that the drive times out (and is
available for subsequent commands) before the kernel does. Most current
consumer drives don't allow resetting the timeout, but it's worth trying
that first before changing the kernel timeout. For each
drive, do:
    smartctl -l scterc,70,70 /dev/sdX
        || echo 180 > /sys/block/sdX/device/timeout

That'll need to be run on every boot (or whenever a drive is
hot-plugged).

> >> When examining the drives, sdj1 has the information from before the cr=
ash:
> >>    Device Role : Active device 5
> >>    Array State : AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> >>
> >> sdg1 looks like this
> >>    Device Role : spare
> >>    Array State : A.AAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
> >>
> >> The other look like
> >>    Device Role : Active device 6
> >>    Array State : A.AAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
> >>
> > From the looks of it, sdg1 was the drive you were originally adding back
> > into the array, and sdj1 is the drive that failed part-way through the
> > rebuild?
>=20
> Exactly. I am running badblocks on that device. SMART reports one
> "Pending Sector Count" :(
>=20
That means you'll end up with some corruption. Whether that affects any
data or not will depend on exactly where it is.

> >> So looks that my repair tries made sdg1 a spare :\ I attached the full
> >> output to this mail.
> >>
> >> Is there anyway to restart the RAID from the information contained in
> >> drive sdj1? Perhaps via Incremental Build starting from one drive? Cou=
ld
> >> that work? If the RAID wouldn't have been rebuilding before the crash,=
 i
> >> would just recreate it with --assume-clean.
> >>
> > The first thing to try should _always_ be a forced assemble. Recreating
> > the array is very much a last-ditch move and should never be attempted
> > before asking the list for help (any mismatch in your create command, or
> > in the mdadm/kernel versions could cause data corruption). Stop the
> > array, then reassemble with the --force flag. It'll probably restart
> > with sdj1 added back into the array, and you can then add sdg1 back in
> > again and restart the rebuild.
>=20
> So
> # mdadm -A /dev/md0 -f /dev/sdc1 /dev/sdg1 /dev/sdh1 /dev/sdd1 \
> /dev/sdi1 /dev/sdj1 /dev/sdb1 /dev/sdf1 /dev/sde1
>=20
> should work? That would be a really simple solution :)
>=20
>=20
> On sdj1 there is still a superblock from before the crash, while the
> others have newer updated superblocks. are there any means to say that
> the RAID should be assembled with the older information from this
> particular superblock?
>=20
That'll be done automatically - mdadm looks at the event counters for
all the disks and assembles the array using the best set (if possible).
As sdj failed during the rebuild, taking down the array, there shouldn't
be any issues with doing this.

However, given you have unreadable blocks on sdj then you'll need to
sort that out first. (or you'll never be able to complete the rebuild).
Use ddrescue to copy the whole of sdj onto sdg (barring the unreadable
blocks). You can then force assemble the array using the other drives:

    mdadm -A /dev/md0 -f /dev/sdc1 /dev/sdg1 /dev/sdh1 /dev/sdd1 \
        /dev/sdi1 /dev/sdb1 /dev/sdf1 /dev/sde1

If that starts up okay then you can add sdj1 back into the array. You'll
need to run a fsck on the array afterwards to pick up what corruption
there's been (fsck -f /dev/md0).

Good luck,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEKdXoACgkQShxCyD40xBK58gCgl0cR8vcohuAmR2B/i6Q2b45B
a+EAoN5jAZc31hdzFRo92pfDlF3lKYvs
=+tiM
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
