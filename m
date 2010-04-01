From: Doug Ledford <dledford@redhat.com>
Subject: Re: mounting component device of RAID1 with internal bitmap
Date: Thu, 01 Apr 2010 14:14:41 -0400
Message-ID: <4BB4E291.5090304@redhat.com>
References: <q2zf19d625d1004011047gf9d48094p696ac38e669fb5e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5172C8E888C4D8C2B794ED9B"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <q2zf19d625d1004011047gf9d48094p696ac38e669fb5e4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5172C8E888C4D8C2B794ED9B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/01/2010 01:47 PM, CoolCold wrote:
> Hello!
> For raid1 array with metadata 0.90 it is possible to mount component
> (let's say /dev/sda1) as usual FS, fix smth, /etc/fstab for example,
> unmount and then assamble arary.

At which point you have just corrupted your array.

> but is this possible for raid1 array
> with internal bitmap ? If my guesses are right this may damage array.

Bitmap doesn't matter, you corrupt your array when you do this either way=
=2E



--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig5172C8E888C4D8C2B794ED9B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku04pIACgkQg6WylM+/8ZSZQwCgo0JJslxtU6zUAMHqUWcj2fOE
JB4AoJP3tI3u+UQxXnlRr02sQAZ381y5
=6qR+
-----END PGP SIGNATURE-----

--------------enig5172C8E888C4D8C2B794ED9B--
