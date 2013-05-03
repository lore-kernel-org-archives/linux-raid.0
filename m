From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: array went wonky
Date: Fri, 3 May 2013 08:40:07 +0100
Message-ID: <20130503074007.GA27548@cthulhu.home.robinhill.me.uk>
References: <474B6DA3-FED2-4674-9707-1BC43378CB90@gmail.com>
 <DC0F689B-F5E5-41F3-9CD4-74813E4A6108@bingner.com>
 <F29438B9-DA12-40B1-8382-30886C95B5BD@gmail.com>
 <71F985BA-11B9-45E8-A17B-03F9CB5C8F52@bingner.com>
 <517FD8FB.7000006@turmel.org>
 <59BD334D-D9B3-4856-AEF3-F033E511B0DD@gmail.com>
 <15E1BF3C-2361-4FC7-8D19-AA319C187AF5@gmail.com>
 <CF52FDBB-A0DA-4912-9352-3A742BBC273B@gmail.com>
 <724CACBC-1D7E-4EE0-91FE-97D5ADC0CD59@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <724CACBC-1D7E-4EE0-91FE-97D5ADC0CD59@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gimpbully <gimpbully@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Sam Bingner <sam@bingner.com>, "<linux-raid@vger.kernel.org>" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu May 02, 2013 at 07:29:38AM -0700, Gimpbully wrote:

> Sorry, I realize I had md127 started.  So I stopped it and did the
> assemble and got the following (the problem is sdf isn't supposed to
> be a spare at all, it's supposed to be a ddrescue'd sdc:
>=20
> eduardo ~ # mdadm --stop /dev/md127
> mdadm: stopped /dev/md127
> eduardo ~ # mdadm --assemble --force /dev/md127 /dev/sd{f,g,e,a}1
> mdadm: /dev/md127 assembled from 3 drives and 1 spare - not enough to sta=
rt the array.
> eduardo ~ #
>=20
>=20
> eduardo ~ # mdadm --examine /dev/sd{f,g,e,a}1 | egrep 'Event|/dev/sd'
> /dev/sdf1:
>          Events : 25979
> this     5       8       81        5      spare   /dev/sdf1
>    0     0       8       33        0      active sync   /dev/sdc1
>    2     2       8       65        2      active sync   /dev/sde1
>    4     4       8        1        4      active sync   /dev/sda1
>    5     5       8       81        5      spare   /dev/sdf1
> /dev/sdg1:
>          Events : 25979
> this     1       8       17        1      active sync   /dev/sdb1
>    0     0       8       33        0      active sync   /dev/sdc1
>    1     1       8       17        1      active sync   /dev/sdb1
>    2     2       8       65        2      active sync   /dev/sde1
>    4     4       8        1        4      active sync   /dev/sda1
>    5     5       8       81        5      spare   /dev/sdf1
> /dev/sde1:
>          Events : 25979
> this     2       8       65        2      active sync   /dev/sde1
>    0     0       8       33        0      active sync   /dev/sdc1
>    2     2       8       65        2      active sync   /dev/sde1
>    4     4       8        1        4      active sync   /dev/sda1
>    5     5       8       81        5      spare   /dev/sdf1
> /dev/sda1:
>          Events : 25979
> this     4       8        1        4      active sync   /dev/sda1
>    0     0       8       33        0      active sync   /dev/sdc1
>    2     2       8       65        2      active sync   /dev/sde1
>    4     4       8        1        4      active sync   /dev/sda1
>    5     5       8       81        5      spare   /dev/sdf1
>=20

Okay, so we have:
  sda - original disk
  sde - original disk
  sdf - supposed to be ddrescue of original sdc
  sdg - ddrescue of original sdb

=46rom the metadata, it would appear that sdf is not in fact a ddrescue of
sdc, so I'd suggest going back and redoing that. Check afterwards that
the metadata reported by "mdadm --examine" on the two disks matches.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlGDadYACgkQShxCyD40xBJR4gCggMTvrf+F859U+532gkK0UtwP
uwwAnRWRYUjVVX3u90E5rBxIOTkIcniq
=gstn
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
