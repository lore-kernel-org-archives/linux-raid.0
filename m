From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: upgrading a RAID array in-place with larger drives.  request for
 review of my approach?
Date: Mon, 1 Dec 2014 09:08:14 +0000
Message-ID: <20141201090814.GA3772@cthulhu.home.robinhill.me.uk>
References: <1417402553.1412807.197119853.0D7A911E@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1417402553.1412807.197119853.0D7A911E@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: terrygalant@mailbolt.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Nov 30, 2014 at 06:55:53PM -0800, terrygalant@mailbolt.com wrote:

> Hi,
>=20
> I have a 4-drive RAID-10 array.  I've been using mdadm for awhile to
> manage the array, and replace drives as they die without changing
> anything.
>=20
> Now, I want to increase its size in-place.  I'd like to ask for some
> help with a review of my setup and plans on how to do it right.
>=20
> I'm really open to any advice that'll help me get there without
> blowing this all up!
>=20
> My array is
>=20
> 	cat /proc/mdstat
> 		...
> 		md2 : active raid10 sdd1[1] sdc1[0] sde1[4] sdf1[3]
> 		      1953519616 blocks super 1.2 512K chunks 2 far-copies [4/4] [UUUU]
> 		      bitmap: 0/466 pages [0KB], 2048KB chunk
> 		...
>=20
A question was raised just recently about reshaping "far" RAID10 arrays.
Neil Brown (the md maintainer) said:
    I recommend creating some loop-back block devices and experimenting.

    But I'm fairly sure that "far" RAID10 arrays cannot be reshaped at all.

> it's comprised of 4 drives; each is 1TB physical size, partitioned
> with a single 'max size' partition, where that partition is formatted
> 'Linux raid autodetect'
>=20
> 	fdisk -l /dev/sd[cdef]
>=20
> 		Disk /dev/sdc: 931.5 GiB, 1000204886016 bytes, 1953525168 sectors
> 		Units: sectors of 1 * 512 =3D 512 bytes
> 		Sector size (logical/physical): 512 bytes / 512 bytes
> 		I/O size (minimum/optimal): 512 bytes / 512 bytes
> 		Disklabel type: dos
> 		Disk identifier: 0x00000000
>=20
> 		Device     Boot Start        End    Sectors   Size Id Type
> 		/dev/sdc1          63 1953520064 1953520002 931.5G fd Linux raid autode=
tect
>=20
> 		Disk /dev/sdd: 931.5 GiB, 1000204886016 bytes, 1953525168 sectors
> 		Units: sectors of 1 * 512 =3D 512 bytes
> 		Sector size (logical/physical): 512 bytes / 512 bytes
> 		I/O size (minimum/optimal): 512 bytes / 512 bytes
> 		Disklabel type: dos
> 		Disk identifier: 0x00000000
>=20
> 		Device     Boot Start        End    Sectors   Size Id Type
> 		/dev/sdd1          63 1953520064 1953520002 931.5G fd Linux raid autode=
tect
>=20
> 		Disk /dev/sde: 931.5 GiB, 1000204886016 bytes, 1953525168 sectors
> 		Units: sectors of 1 * 512 =3D 512 bytes
> 		Sector size (logical/physical): 512 bytes / 512 bytes
> 		I/O size (minimum/optimal): 512 bytes / 512 bytes
> 		Disklabel type: dos
> 		Disk identifier: 0x00000000
>=20
> 		Device     Boot Start        End    Sectors   Size Id Type
> 		/dev/sde1          63 1953520064 1953520002 931.5G fd Linux raid autode=
tect
>=20
> 		Disk /dev/sdf: 931.5 GiB, 1000204886016 bytes, 1953525168 sectors
> 		Units: sectors of 1 * 512 =3D 512 bytes
> 		Sector size (logical/physical): 512 bytes / 512 bytes
> 		I/O size (minimum/optimal): 512 bytes / 512 bytes
> 		Disklabel type: dos
> 		Disk identifier: 0x00000000
>=20
> 		Device     Boot Start        End    Sectors   Size Id Type
> 		/dev/sdf1          63 1953520064 1953520002 931.5G fd Linux raid autode=
tect
>=20
> the array contains only/multiple LVs, in a RAID-10 array size of 2TB,
>=20
> 	pvs /dev/md2
> 	  PV         VG     Fmt  Attr PSize PFree
> 	  /dev/md2   VGBKUP lvm2 a--  1.82t 45.56g
> 	vgs VGBKUP
> 	  VG     #PV #LV #SN Attr   VSize VFree
> 	  VGBKUP   1   8   0 wz--n- 1.82t 45.56g
> 	lvs VGBKUP
> 	  LV                VG     Attr      LSize   Pool Origin Data%  Move Log=
 Cpy%Sync Convert
> 	  LV001             VGBKUP -wi-ao---   1.46t
> 	  LV002             VGBKUP -wi-ao--- 300.00g
> 	  LV003             VGBKUP -wi-ao--- 160.00m
> 	  LV004             VGBKUP -wi-ao---  12.00g
> 	  LV005             VGBKUP -wi-ao--- 512.00m
> 	  LV006             VGBKUP -wi-a---- 160.00m
> 	  LV007             VGBKUP -wi-a----   4.00g
> 	  LV008             VGBKUP -wi-a---- 512.00m
>=20
> where, currently, ~45.56G of the phy dev is unused
>=20
> I've purchased 4 new 3TB drives.
>=20
> I want to upgrade the existing array of 4x1TB drives to 4x3TB drives.
>=20
> I want to end up with a single partition, @ max_size =3D=3D ~ 3TB.
>=20
> I'd like to do this *in-place*, never bringing down the array.
>=20
> Iiuc, this IS doable.
>=20
> 1st, I think the following procedure starts the process correctly:
>=20
> 	(1) format each new 3TB drive, with one 1TB partition, as 'linux
> 	raid autodetect', making sure it's IDENTICAL to the partition layout
> 	on the current array's disks
>=20
> 	(2) with the current array up & running, mdadm FAIL one drive
>=20
> 	(3) mdadm remove the FAIL'd drive from the array
>=20
> 	(4) physically remove the FAIL'd drive
>=20
> 	(5) physically insert the new, pre-formatted 3TB drive
>=20
> 	(6) mdadm add the newly inserted drive
>=20
> 	(7) allow the array to rebuild, until 'cat /proc/mdstat' says it's done
>=20
> 	(8) repeat steps (2) - (7) for each of the three remaining drives.
>=20
> 2nd, I have to correctly/safely to, in 'some' order
>=20
> 	extend the physical partitions on all four drives, or of the array
> 	(not sure which)
> 	extend the volume group on the array
> 	expand, or add, the existing LVMs in the volume group.
>=20
> I'm really not sure about what steps, in what order to do *here*.
>=20
> Can anyone verify that my first part is right, and help me out with
> doing the 2nd part right?
>=20
If it is doable (see comment above), it'll be simpler to just partition
the disks to the final size (or skip partitioning at all) - md will
quite happily accept larger devices added to an array (though it doesn't
use the extra space). Otherwise, your initial steps are correct - though
if you have a spare bay (or even a USB/SATA adapter), you can add the
drive as a spare and then use "mdadm --replace" (you may need a newer
version of mdadm for this) command to flag one of the existing array
members for replacement. This will do a direct copy of the data from the
existing disk to the new one and is quicker (and safer) than fail/add.

You'll then need to grow the array, the volume group, then the LVMs.

As I say above, I think you're out of luck though. I'd recommend
connecting up one of the new drives (if you have a spare bay or can hook
it up externally, do so, otherwise you'll need to fail one of the array
members), then:
    - Copy all the data over to the new disk
    - Stop the old array
    - Remove the old disks and insert the new ones
    - Create a new array (with a missing member if you only have 4 bays)
    - Copy the data off the single disk and onto the new array
    - Add the single disk to the array as the final member

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlR8L/4ACgkQShxCyD40xBICSQCgqkTS9l8QSYlD8CmCQL8732G/
7oQAoIZgV/8h7EPKFzQwgp7uGBXJGDqO
=mcsy
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
