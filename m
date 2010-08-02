From: Doug Ledford <dledford@redhat.com>
Subject: Re: mdadm 3.1.x and bitmap chunk
Date: Mon, 02 Aug 2010 14:41:14 -0400
Message-ID: <4C57114A.4000100@redhat.com>
References: <20100609210541.GA12153@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig264BC023978AF1F1AE9E3D16"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100609210541.GA12153@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig264BC023978AF1F1AE9E3D16
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/09/2010 05:05 PM, Piergiorgio Sartor wrote:
> Hi folks,
>=20
> I just noticed that mdadm 3.1.x sets the default
> bitmap chunk to 64MB.
>=20
> Searching around, I found the reason should be
> related with write performances, which seem to
> be less compromised with large bitmap chunks.
>=20
> I've no problem with that, but is it possible
> to set the bitmap chunk to the minimum size,
> without trying all the possible dimensions?
>=20
> Thanks a lot in advance,
>=20
> bye,
>=20

This depends somewhat on what you mean by "minimum size" to the bitmap
chunk.  The bitmap chunk size can never be smaller than the minimum size
on the device, so 512bytes for most drives, 4k for newer drives.  But
such a chunk size would be horrible for performance as it would make
every single write synchronous on the bitmap update.  However, the
minimum size can also be limited by the available space for the bitmap
when using an internal bitmap.  So, you can only make the size as small
as it will go and the bitmap still fit between the end of the
{array,superblock} and the start of the {superblock,array}.

However, in general, a bitmap that's small enough that you can sync the
dirty section in a second or two should be good enough.  With modern
disks, they can sync 32MB or 64MB in only a second or two, hence the
default size.  Anything less than that is really a case of diminishing
returns.  You are sacrificing write speed on each and every write to the
array in exchange for a *possible* speed up in the event of a crash.
Not a very good trade off IMO.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig264BC023978AF1F1AE9E3D16
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkxXEUoACgkQg6WylM+/8ZR1EwCggtCOwcKFCTsuyj2wVKByat9A
UTAAnRkS/NKR8SjZHpjDhpLWPbwsP+U+
=ymtI
-----END PGP SIGNATURE-----

--------------enig264BC023978AF1F1AE9E3D16--
