From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Units for mdadm --data-offset ?
Date: Fri, 29 Aug 2014 18:39:23 +0100
Message-ID: <20140829173923.GA6774@cthulhu.home.robinhill.me.uk>
References: <CAKGkouuVrkjxSNOLqiNnd0OAByMw4iOLDgXVvQW0cMtRK5-sVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKGkouuVrkjxSNOLqiNnd0OAByMw4iOLDgXVvQW0cMtRK5-sVw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Aug 29, 2014 at 10:22:21am -0700, Patrick J. LoPresti wrote:

> What are the units for the "--data-offset" flag to mdadm? I am
> guessing kilobytes, but "--examine" displays the value in sectors, so
> I am not sure.
>=20
> Also, is the "data-offset" per-member, or for the RAID as an aggregate?
>=20
> Forgive me if this is all documented somewhere, but I cannot find it.
>=20
It's in the mdadm man page on my system anyway. According to that:

    Arrays with 1.x metadata can leave a gap between the start of the
    device and the start of array data. This gap can be used for various
    metadata. The start of data is known as the data-offset. Normally an
    appropriate data offset is computed automatically. However it can be
    useful to set it explicitly such as when re-creating an array which
    was originally created using a different version of mdadm which
    computed a different offset.

    Setting the offset explicitly over-rides the default. The value
    given is in Kilobytes unless an 'M' or 'G' suffix is given.

    Since Linux 3.4, --data-offset can also be used with --grow for some
    RAID levels (initially on RAID10). This allows the data-offset to be
    changed as part of the reshape process. When the data offset is
    changed, no backup file is required as the difference in offsets is
    used to provide the same functionality.

    When the new offset is earlier than the old offset, the number of
    devices in the array cannot shrink. When it is after the old offset,
    the number of devices in the array cannot increase.

    When creating an array, --data-offset can be specified as variable.
    In the case each member device is expected to have a offset appended
    to the name, separated by a colon. This makes it possible to
    recreate exactly an array which has varying data offsets (as can
    happen when different versions of mdadm are used to add different
    devices).

It would look like the data offset is per member (it's not explicitly
stated, but that's certainly how I read it and how I recall seeing it
used previously).

HTH,
    Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlQAusoACgkQShxCyD40xBI7GQCfeFjBxwwyPsUZDRXrs48hia5w
ljAAoOI2mAc5cQjpxNmwWWgNNZFWe49V
=qFOX
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
