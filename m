From: NeilBrown <neilb@suse.de>
Subject: Re: Another RAID-5 problem
Date: Wed, 9 May 2012 21:03:00 +1000
Message-ID: <20120509210300.3939dc35@notabene.brown>
References: <2002541871.570559.1336554658940.JavaMail.ngmail@webmail06.arcor-online.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4g61EnC3QuWctV7FDjvAGuK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2002541871.570559.1336554658940.JavaMail.ngmail@webmail06.arcor-online.net>
Sender: linux-raid-owner@vger.kernel.org
To: piergiorgio.sartor@nexgo.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4g61EnC3QuWctV7FDjvAGuK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 9 May 2012 11:10:58 +0200 (CEST) piergiorgio.sartor@nexgo.de wrote:

> Hi all,
>=20
> we're hit by a RAID-5 issue, it seems Ubuntu 12.04 is shipping
> some bugged kernel/mdadm combination.

Buggy kernel.  My fault.  I think they know and an update should follow.

However I suspect that Ubuntu must be doing something else to cause the
problem to trigger so often.  The circumstance that makes it happen should =
be
extremely rare.  It is as though the md array is half-stopped just before
shutdown.  If it were completely stopped or not stopped at all, this wouldn=
't
happen.

>=20
> Following the other thread about a similar issue, I understood
> it is possible to fix the array without losing data.

Correct.

>=20
> Problems are:
>=20
> 1) We do not know the HDD order and it is a 5 disks RAID-5

If you have kernel logs from the last successful boot they would contain
a "RAID conf printout" which would give you the order, but maybe that it on
the RAID-5 array?
If it is you will have to try different permutations until you find one that
works.

> 2) 4 of 5 disks have a data offset of 264 sectors, while the
> fourth one, added later, has 1048 sectors.

Ouch.
It would be easiest to just make a degraded array with the 4 devices with t=
he
same data offset, then add the 5th later.
To get the correct data offset you could  either use the same mdadm that the
array was originally built with, or you could get the 'r10-reshape'
branch from git://neil.brown.name/mdadm/ and build that.
Then create the array with --data-offset=3D132K as well as all the other fl=
ags.
However that hasn't been tested extensively so it would be best to test it
elsewhere first.  Check that it created the array with correct data-offset
and correct size.

> 3) There is a LVM setup on the array, not a plain filesystem.

That does make it a little more complex but not much.
You would need to activate the LVM, then "fsck -n" the filesystems to check=
 if
you have the devices in the right order.
However this could help you identify the first device quickly.
If you
  dd if=3D/dev/sdXX skip=3D264 count=3D1=20
then for the first device in the array it will show you the textual
description of the LVM setup.  For the other devices it will probably be
binary or something unrelated.

>=20
> Any idea on how can we get the array back without losing any
> data?

Do you know what the chunk size was?  Probably 64K if it was an old array.
Maybe 512K though.

I would:
 1/ look at old logs if possible to find out the device order
 2/ try to remember what the chunk size could be.  If you have the exact
    used-device size (mdadm -E should give that) you can get an upper limit
    for the chunk size by finding the larger power-of-2 which divides it.
 3/ Try to identify the first device by looking for LVM metadata.
 4/ Make a list of the possible arrangements of devices and possible chunk
    sizes based on the info you collected.
 5/ Check that you can create an array with a data-offset for 264 sectors
    using one of the approaches listed above.
 6/ write a script which iterated though the possibilities and re-created t=
he
    array then tries to turn on LVM and the fsck.  Or maybe iterate by hand.
    The command to create an array would be something like
      mdadm -C /dev/md0 -l5 -n5 --assume-clean --chunk=3D64 \
      --data-offset=3D132K   /dev/sdX missing /dev/sdY /dev/sdZ /dev/sdW
 7/ Find out which arrangement produces least fsck errors, and use that.

>=20
> At the moment, it seems quite difficult to provide dump of
> "mdadm -E" or similar, since the PC does not boot at all.
> In any case, if necessary we could try to take a picture of
> the screen and send it here or directly per email, if appropriate.

You probably need to boot from a DVD-ROM or similar.
Certainly feel free to post the data you collect and the conclusions you dr=
aw
and even the script you write if you would like them reviewed and confirmed.

NeilBrown



--Sig_/4g61EnC3QuWctV7FDjvAGuK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6pO5Dnsnt1WYoG5AQJMpA/6A1eTNwu9yxpMkWLDkyDfRKkIgs/gEByn
XuagCMnWu8Sn/19qs4V69cvkMzWIoJaN0tP8wLaWcFc9/LwgEVRFXhUvV+Sq85uP
ml43zK3h+ryAtmvXAQIiMqx3QJyzuESZf/qZ6CwCAkMPB/WZNG3qqYs8O5wDkYSB
5Gn6l6lhiR3ZlGuCYGlo9wudQSMZVnEaIMbhKI335MsE+tiYi2GTXIoWc9Wb9bLU
mv/M3rIE2d0Km4jdvCXod6lcKn0XYFgpknOuc/KCrYqbfD9PAngXGeHqNNRwneYo
q43YCLBUJhVm5quCRoJw5Ibwx+/7NcvHRylX6fOFg3eywmJkCOPf8DZXAEdcSkko
LwTKxiZ10Gnn+SSE6YDteK1WNK+n7qrOjKMBS5/27O2GFpPMCxlDV+zdnrK0RqAe
PfPWndpjd2Pxeb+0gfBrYGWAa+aLzrnt3DPvg8y9/sM1DdtG3LkCiPSCeWH9OYkS
UeX4h+5kgJBT3BVWprmnIelY4B+8cOgANh/+aH2RsOOMokuuG2BQD0X8q2izQVF8
4L2u8H2T2dSZk36sEUkYXxF7wVoDqKl/2NJh9U6ehvkbL5txCkt+zQlgDO6xzTLs
GoHNbZlGS5bXLhsCqViCHmbyIJJb+GGCc6wgJqD0RkephAdmeTWc95QEd9ssMIgb
hcFURBjMtNo=
=mfBj
-----END PGP SIGNATURE-----

--Sig_/4g61EnC3QuWctV7FDjvAGuK--
