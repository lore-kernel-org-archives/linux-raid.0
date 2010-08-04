From: Doug Ledford <dledford@redhat.com>
Subject: Re: mdadm 3.1.x and bitmap chunk
Date: Tue, 03 Aug 2010 21:03:15 -0400
Message-ID: <4C58BC53.1070304@redhat.com>
References: <20100609210541.GA12153@lazy.lzy> <4C57114A.4000100@redhat.com> <20100803183632.GB2474@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA1CD22AD58F12C14A5E971A2"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100803183632.GB2474@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA1CD22AD58F12C14A5E971A2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/03/2010 02:36 PM, Piergiorgio Sartor wrote:
> Hi,
>=20
>> This depends somewhat on what you mean by "minimum size" to the bitmap=

>> chunk.  The bitmap chunk size can never be smaller than the minimum si=
ze
>> on the device, so 512bytes for most drives, 4k for newer drives.  But
>=20
> as far as I know, there is a limited space for
> the bitmap, hence if the chunk is too small,
> the bitmap will not fit in that space.

For internal bitmaps, this is correct and what I mentioned next.

>> such a chunk size would be horrible for performance as it would make
>> every single write synchronous on the bitmap update.  However, the
>> minimum size can also be limited by the available space for the bitmap=

>> when using an internal bitmap.  So, you can only make the size as smal=
l
>> as it will go and the bitmap still fit between the end of the
>> {array,superblock} and the start of the {superblock,array}.
>>
>> However, in general, a bitmap that's small enough that you can sync th=
e
>> dirty section in a second or two should be good enough.  With modern
>> disks, they can sync 32MB or 64MB in only a second or two, hence the
>> default size.  Anything less than that is really a case of diminishing=

>> returns.  You are sacrificing write speed on each and every write to t=
he
>> array in exchange for a *possible* speed up in the event of a crash.
>> Not a very good trade off IMO.
>=20
> Those are my usual USB HDDs in RAID-6 configuration.
>=20
> Since the setup might be quite fragile, since the
> write performances are anyway limited by the USB
> and not by the seek time and writinig is anywau slow,

Seeks will *always* limit array speed, even when the link is slow.
Especially on bitmaps where the seek is synchronous to the pending write.=


> I would like to keep the bitmap resync fast.
>=20
> That is, if a USB cable fails, I can just replace it
> and resync using bitmap, this will be quite fast, if
> the bitmap chunk is not too big.

It will be faster than a full resync regardless.

> 64MB is quite a huge amount of data for USB, so it
> will not help to keep the bitmap resync fast.

It will help, without a doubt.  Any bitmap is better than no bitmap for
resync.  However, any bitmap is a hurt on performance.  How much of a
help versus a hurt just depends on the chunk size.

> Which means the chunk should be small, one target
> could be the smallest possible, given the available
> space in the superblock.

I don't have an easy answer for the smallest chunk size based upon the
space between the superblock and the array.  It depends on the
superblock type you are using and the layout of the superblock on the
device/partition.  You should be able to get the layout info from the
output of mdadm -E on a constituent device (aka, mdadm -E /dev/sde1 or
whatever you use in the array).  For version 1.1 and 1.2 superblocks,
the array will be offset from the beginning of the partition and that
offset will be listed.  Take out 4k for a version 1.1 superblock, or 8k
for a version 1.2 superblock, take out a little more for the bitmap
superblock, and from what's left you can calculate the number of free
sectors, and then each sector is 512 * 8 bits (for a 512byte sector
device).  Then divide the number of available bits into the array size,
then round up to the closest power of two to get the smallest possible
chunk size.  For version 1.0 and 0.90 superblocks, the process is
similar, except you need to know the offset of the superblock from the
beginning of the array, and subtract from that the used dev size, and
what's left is the number of sectors between the end of the data and the
start of the superblock.  Subtract a bit again for the bitmap
superblock, then repeat the math I listed above.

In any case though, I would just try reducing the bitmap chunk to the
old default of 8mb.  At 8mb you are already suffering a 5% or so
performance penalty on write, but 8mb is not too much to resync, even
over USB, so it might be a good compromise in your case.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigA1CD22AD58F12C14A5E971A2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkxYvFMACgkQg6WylM+/8ZQqfgCgrr6c+LhLMGvFLvLmLjEOmgWU
lBQAn25uC9gX0frQjpr/Bx3E2EJxD4g3
=B0pF
-----END PGP SIGNATURE-----

--------------enigA1CD22AD58F12C14A5E971A2--
