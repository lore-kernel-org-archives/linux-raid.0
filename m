From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Fri, 18 Sep 2009 09:13:13 +0100
Message-ID: <20090918081313.GC22909@cthulhu.home.robinhill.me.uk>
References: <20090917210148.GB19611@cthulhu.home.robinhill.me.uk>
 <200909171746569.SM04116@trainer>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+xNpyl7Qekk2NvDX"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200909171746569.SM04116@trainer>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--+xNpyl7Qekk2NvDX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Sep 17, 2009 at 05:46:33PM -0400, Sunpyo Hong wrote:

> First off, lemme tell you the initial problem. I had a WD ShareSpace that
> had one of the disk go bad. They sent a replacement and it was suppose to
> rebuild on its own, however after the build, the array went bad and it was
> no longer able to see any of the files.=20
>=20
> I downloaded and tested the drives using windows data recovery tools I saw
> that the ext3 was Linux FS and that using these tools would not help in t=
he
> recovery. However through the tools I was able to see and recover some of
> the files, but the files themselves were usable. I confirmed with WD that
> ext3 was in fact the FS and took steps to recover the data. These are the
> steps I took in order for me to assemble the raid.
>=20
> Right now I have 3/4 drives with the data. I did #mdadm --assemble --scan,
> which let me assemble the raid. However at this point I was not able to s=
ee
> any of the files or mount the drive to the mount point it was once at. I
> have also tried #mdadm --create with the array in the right order /w the
> missing disk.=20
>=20
> Initially the --assemble --scan assembled the array /dev/md2 with the dis=
ks
> in the wrong order. I know because I physically saw where the disks were =
in
> relation to the disk order and wrote down the disk order on every HD.
>=20
This should not be possible - --assemble will read the metadata from the
superblocks and determine the order the drives should be within the
array.  The physical positioning/ordering is irrelevant here.  I suggest
you recreate the array in the original order --assemble did (and hope
that the chunk size used is the default).

> #cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]=20
> md2 : active raid5 sdb4[1] sdd4[3] sdc4[2]
>       5856150144 blocks level 5, 64k chunk, algorithm 2 [4/3] [_UUU]
>      =20
> md0 : active raid1 sdd1[0] sdb1[2] sdc1[1]
>       208768 blocks [4/3] [UUU_]
>      =20
I find it somewhat odd that md0 and md2 have the drives in a different
order.  Is this related to your recreating the array?  Admittedly, md0
is only a RAID1 so the order doesn't actually matter, but if the arrays
were created at the same time then the normal behaviour would be to use
the same order in the create command.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--+xNpyl7Qekk2NvDX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqzQRgACgkQShxCyD40xBLflgCcC9mzy3qqam4tXxZHEyMjge7L
p5EAn19I7OgfuU1WjwPZNgQi3jQippBW
=V01v
-----END PGP SIGNATURE-----

--+xNpyl7Qekk2NvDX--
