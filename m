From: Doug Ledford <dledford@redhat.com>
Subject: Re: Minor mdadm fixes
Date: Wed, 24 Mar 2010 13:48:03 -0400
Message-ID: <4BAA5053.20108@redhat.com>
References: <4BA2DDB2.2040508@redhat.com> <20100324112740.6b67b287@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF2B16AE5C8A4816C92102272"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100324112740.6b67b287@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF2B16AE5C8A4816C92102272
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/23/2010 08:27 PM, Neil Brown wrote:
> I thought udev always created the directory if it was needed, and alway=
s
> removed it if it became empty after deleting an entry.  But I have no s=
trong
> basis for believing that.

I don't know about the removing of a directory, but it will only create
a directory if we indicate it should place a symlink in it (speaking of
/dev/md/).  And we only do that if mdadm -D --export prints out
MD_DEVNAME, and we only print that out if the name field of the
superblock includes /dev/md/.  So, if the name is something shorthand,
like host:0 or host:md0, we never print out MD_DEVNAME and so udev
doesn't create the symlinks in /dev/md.

But, regardless of that, we need the mapfile prior to devices being
brought up, so prior to any possible directory creation by udev.  Hence
we must take care of the issue ourselves.

> However I do think that mdadm should create the directory in this case =
- not
> any parents, but if they exist and are writeable, then create the direc=
tory.
>=20
> So I modified you patch to do that when creating the mapfile (not when
> reading it).

Makes sense, thanks.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigF2B16AE5C8A4816C92102272
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuqUFMACgkQg6WylM+/8ZRQ3ACfWmwNGZ/q7/zd2YjIwb8snuLh
cf8AoJQJPEBRhUTTVfX+eU7+1GeEIV/q
=SU+0
-----END PGP SIGNATURE-----

--------------enigF2B16AE5C8A4816C92102272--
