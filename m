From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 20:34:04 -0500
Message-ID: <4AFB660C.8000405@redhat.com>
References: <20091112002315724.HBYG5263@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig95A0445777C0DBEC5E4C2936"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091112002315724.HBYG5263@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'Linux RAID Mailing List' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig95A0445777C0DBEC5E4C2936
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/11/2009 07:23 PM, Leslie Rhorer wrote:

> 	I guess I skimmed over the manual rather quickly back then, and I
> was dealing with serious RAID issues at the time, so I must have improp=
erly
> inferred the man page to imply this in the section which says, "Note th=
at
> if you add a bitmap stored in a file which is in a filesystem that is o=
n the
> raid array being affected, the system will deadlock.  The bitmap must b=
e on
> a separate filesystem" to read something more like, "Note that if you a=
dd a
> bitmap ...  the bitmap must be on a separate filesystem.

Understandable, and now corrected, so no biggie ;-)

>> the only limitation is that the bitmap must be small enough to fit in
>> the reserved space around the superblock.  It's in the case that you
>> want to create some super huge, absolutely insanely fine grained bitma=
p
>> that it must be done at raid device creation time and that's only so i=
t
>> can reserve sufficient space for the bitmap.
>=20
> 	How can I know how much space is available?  I tried adding the
> internal bitmap without specifying anything, and it seems to have worke=
d
> fine.  When I created the bitmap in an external file (without specifyin=
g the
> size), it was around 100K, which seems rather small.

100k is a huge bitmap.  For my 2.5TB array, and a bitmap chunk size of
32768KB, I get the entire in-memory bitmap in 24k (as I recall, the
in-memory bitmap is larger than the on-disk bitmap as the on-disk bitmap
only stores a dirty/clean bit per chunk where as the in-memory bitmap
also includes a counter per chunk so it knows when all outstanding
writes complete and it needs to transition to clean, but I could be
mis-remembering that).

>  Both of these systems
> use un-partitioned disks with XFS mounted directly on the RAID array.  =
One
> is a 7 drive RAID5 array on 1.5 TB disks and the other is a 10 drive RA=
ID6
> array on 1.0TB disks.  Both are using a version 1.2 superblock.  The on=
ly
> thing which jumps out at me is --examine, but it doesn't seem to tell m=
e
> much:
>=20
> RAID-Server:/usr/share/pyTivo# mdadm --examine /dev/sda
> /dev/sda:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
>            Name : RAID-Server:0  (local to host RAID-Server)
>   Creation Time : Sat Apr 25 01:17:12 2009
>      Raid Level : raid6
>    Raid Devices : 10
>=20
>  Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
>      Array Size : 15628197888 (7452.11 GiB 8001.64 GB)
>   Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
>     Data Offset : 272 sectors
>    Super Offset : 8 sectors

The above two items are what you need for both version 1.1 and 1.2
superblocks in order to figure things out.  The data, aka the filesystem
itself, starts at the Data Offset which is 272 sectors.  The superblock
itself is 8 sectors in from the front of the disk because you have
version 1.2 superblocks.  So, 272 - 8 - size of the superblock, which is
only a sector or two, is how much internal space you have.  So, in your
case, you have about 132k of space for the bitmap.  Version 1.0
superblocks are a little different in that you need to know the actual
size of the device and you need the super offset and possibly the used
dev size.  There will be free space between the end of the data and the
superblock (super offset - used dev size) and free space after the
superblock (actual dev size as given by fdisk (either the size of the
device itself on whole disk devices or the size of the partition you are
using) - super offset - size of superblock).  I don't know which is used
by the bitmap, but I seem to recall the bitmap wants to be between the
superblock and the end of the data, so I think the used dev size and
super offset are the important numbers there.

You mentioned that you used the defaults when creating the bitmap.
That's likely to hurt your performance.  The default bitmap chunk is too
small.  I would redo it with a larger bitmap chunk.  If you look in
/proc/mdstat, it should tell you the current bitmap chunk.  Given that
you stream large sequential files, you could go with an insanely large
bitmap chunk and be fine.  Something like 65536 or 131072 should be good.=


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig95A0445777C0DBEC5E4C2936
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr7ZgwACgkQg6WylM+/8ZQGFgCcDfEq5x4o4lWnOq4G+2CE38P4
da4An1L3Qo2QuwEpZRkd9UoryVUbKCkl
=ba2Z
-----END PGP SIGNATURE-----

--------------enig95A0445777C0DBEC5E4C2936--
