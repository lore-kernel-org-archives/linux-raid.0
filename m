From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID6 questions
Date: Thu, 2 Jul 2009 17:23:56 +0100
Message-ID: <20090702162356.GA11607@cthulhu.home.robinhill.me.uk>
References: <2bdd5a4c0907020822s7d136681g23a4e34e13f0be8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2bdd5a4c0907020822s7d136681g23a4e34e13f0be8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jul 02, 2009 at 05:22:54PM +0200, Marek wrote:

> Hi,
>=20
> I'm trying to build a RAID6 array out of 6x1TB disks, and would like
> to ask the following:
>=20
> 1. Is it possible to convert from 0.9 superblock to 1.x with mdadm
> 3.0? The reason is that most distributions ship with mdadm 2.6.x which
> seems to use 0.9 superblock by default. I wasn't able to find any info
> on mdadm 2.6.x using or switching to 1.x superblocks, so it seems that
> unless I'm using mdadm 3.0 which is practically unavailable, I'm stuck
> with 0.9.
>=20
You can certainly use 1.x superblocks with mdadm 2.6.x (just specify the
--metadata=3D switch).  You certainly can't switch superblocks (easily)
with 2.6.x, and I've not heard anything to suggest 3.0 supports it yet
either.

> 2. Is it safe to upgrade to mdadm 3.x?
>=20
It certainly should be safe to use, and it's backward compatible so I
don't see there should be any issues with upgrading.

> 3. Is it possible to use 0xDA with 0.9 superblock and omit autodetect
> with mdadm 2.6.x? I couldn't find any information regarding this since
> most RAID related sources either still suggest 0xFD and
> autodetect(even with mdadm 3.0 by using -e 0.9 option) or they do not
> state which version of mdadm to use in case of 1.x superblocks. Since
> autodetect is deprecated, is there a safe way(without losing any data)
> to convert from autodetect + 0xFD in the future?
>=20
You can use 0xDA with any superblock version.  If you're not using
autodetect then you have to make sure you're using an initrd and that it
has the correct mdadm.conf in it.  Most distros will take care of this
for you.  You can switch back/forward between autodetect/not whenever
you like (providing you're using 0.9 metadata anyway).

> 4. (probably a stupid question but..) Should an extended 0x05
> partition be ignored on RAID build? This is not directly related to
> mdadm, but many tutorials basically suggest to
> for i in `seq 1 x`; do mdadm --create (...) /dev/md$i /dev/sda$i
> /dev/sdb$i (...)
> It's not obvious in case one decides to partition the drives into many
> small partitions e.g. 1TB into 20x 50GB, in such case he gets 3
> primary partitions and one extended containing(or pointing to?) the
> remaining logical partitions, however the extended partition shows up
> as e.g. /dev/sda4, while the logical partitions appear as /dev/sda5,
> /dev/sda6 etc., so in the above mentioned case it would basically also
> try to create a RAID array from extended partitions.
> It would seem more logical to lay out the logical partitions as
> /dev/sda4l1 /dev/sda4l2 .... /dev/sda4l17 but udev doesn't seem to do
> that. Is it safe to ignore /dev/sdX4 and just create RAIDs out of
> /dev/sdX(1..3,5..20)?
>=20
I'm not sure how mdadm would deal if you passed it an extended partition
- it's certainly safest not to do so!  You could also just use a single
partitionable array instead of using logical partitions.

> 5. In case one decides for a partitioned approach - does mdadm kick
> out faulty partitions or whole drives? I have read several sources
> including some comments on slashdot that it's much better to split
> large drives into many small partitions, but noone clarified in
> detail.  A possible though unlikely scenario would be simultaneous
> failure of all hdds in the array:
>=20
>  md1 RAID6 sda1[_] sdb1[_] sdc1[U] sdd1[U] sde1[U] sdf1[U]
>  md2 RAID6 sda2[U] sdb2[_] sdc2[_] sdd2[U] sde2[U] sdf2[U]
>  md3 RAID6 sda3[U] sdb3[U] sdc3[_] sdd3[_] sde3[U] sdf3[U]
>  md4 RAID6 sda4[U] sdb4[U] sdc4[U] sdd4[_] sde4[_] sdf4[U]
>  md5 RAID6 sda5[U] sdb5[U] sdc5[U] sdd5[U] sde5[_] sdf5[_]
> (...)
>=20
> If mdadm kicks out faulty partitions only, but leaves the remaining
> part of drive going as long as it's able to read it, would it mean
> that even if every single hdd in the array failed somewhere (for
> example due to Reallocated_Sector_Ct), mdadm would keep the healthy
> partitions of that failed drive running, thus the entire system would
> be still running in degraded mode without loss of data?
>=20
This depends on the failure mode.  Drives usually deal with soft
failures themselves (reallocating sectors), so a failure usually takes
out the whole drive.  In my experience, md will only kick out failed
partitions though.

> 6. Is it safe to have 20+ partitions for a RAID5,6 system? Most RAID
> related sources state that there's a limitation on number of
> partitions one can have on SATA drives(AFAIK 16), but i digged out
> some information about a recent patch which would remove this
> limitation and which according to some other source had also been
> accepted into mainline kernel, though I'm not sure about it.
> http://thread.gmane.org/gmane.linux.kernel/701825
> http://lwn.net/Articles/289927/
>=20
If your system can handle that many partitions then md should be fine.

> 7. Question about special metadata with X58 ICH10R controllers - since
> the 3.0 announcement states that the Intel Matrix metadata format used
> by recent Intel ICH controlers is also supported, I'd like to ask if
> there's some instructions available on how to use it and what benefits
> it would bring to the user.
>=20
Pass.  You'd probably be best searching an archive of this list though.

> 8. Most RAID related sources seem to deal with rather simple scenarios
> such as RAID0 or RAID1. There are only a few brief examples avaliable
> on how to build RAID5 and none for RAID6. Does anyone know of any
> recent & decent RAID6 tutorial?
>=20
Not that I've seen.  The process doesn't really differ between RAID
types though, and RAID5/RAID6 should take exactly the same parameters.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpM3xwACgkQShxCyD40xBI3uACfZXDoi2c9DgeCmsdgdk9w67/1
n5cAn0I6wdxvdADUqMB5fpT05aiPi/UA
=qubJ
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
