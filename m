From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: array went wonky
Date: Sat, 13 Apr 2013 16:46:17 +0100
Message-ID: <20130413154617.GA17005@cthulhu.home.robinhill.me.uk>
References: <474B6DA3-FED2-4674-9707-1BC43378CB90@gmail.com>
 <DC0F689B-F5E5-41F3-9CD4-74813E4A6108@bingner.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DC0F689B-F5E5-41F3-9CD4-74813E4A6108@bingner.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gimpbully <gimpbully@gmail.com>
Cc: "<linux-raid@vger.kernel.org>" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat Apr 13, 2013 at 02:20:50 +0000, Sam Bingner wrote:

> On Apr 12, 2013, at 7:41 PM, Gimpbully <gimpbully@gmail.com> wrote:
>=20
> > Good Evening Folks,
> >     Alright, I have a 5 disk raid5, it's worked for years.  Today a
> >     disk went "click click" and I dropped the cold spare I had in
> >     and started a rebuild.  Everything was great until I checked
> >     around 35% rebuild and everything was in the toilet.  Here is
> >     the current -E info.  Any advise would be *amazingly*
> >     appreciated.  (I can't believe I didn't just put the spare in
> >     and just go RAID5...).
> >=20
> > /dev/sda1:
> >         Events : 25952
> > this     4       8        1        4      active sync   /dev/sda1
> >   0     0       8       33        0      active sync   /dev/sdc1
> >   2     2       8       65        2      active sync   /dev/sde1
> >   4     4       8        1        4      active sync   /dev/sda1
> >   5     5       8       81        5      spare   /dev/sdf1
> > /dev/sdb1:
> >         Events : 25944
> > this     1       8       17        1      active sync   /dev/sdb1
> >   0     0       8       33        0      active sync   /dev/sdc1
> >   1     1       8       17        1      active sync   /dev/sdb1
> >   2     2       8       65        2      active sync   /dev/sde1
> >   4     4       8        1        4      active sync   /dev/sda1
> >   5     5       8       81        5      spare   /dev/sdf1
> > /dev/sdc1:
> >         Events : 25952
> > this     0       8       33        0      active sync   /dev/sdc1
> >   0     0       8       33        0      active sync   /dev/sdc1
> >   2     2       8       65        2      active sync   /dev/sde1
> >   4     4       8        1        4      active sync   /dev/sda1
> >   5     5       8       81        5      spare   /dev/sdf1
> > /dev/sde1:
> >         Events : 25952
> > this     2       8       65        2      active sync   /dev/sde1
> >   0     0       8       33        0      active sync   /dev/sdc1
> >   2     2       8       65        2      active sync   /dev/sde1
> >   4     4       8        1        4      active sync   /dev/sda1
> >   5     5       8       81        5      spare   /dev/sdf1
> > /dev/sdf1:
> >         Events : 25952
> > this     5       8       81        5      spare   /dev/sdf1
> >   0     0       8       33        0      active sync   /dev/sdc1
> >   2     2       8       65        2      active sync   /dev/sde1
> >   4     4       8        1        4      active sync   /dev/sda1
> >   5     5       8       81        5      spare   /dev/sdf1
> >=20
> > --=20
> >=20
>=20
> I suspect that your sdb drive is also bad... you should try to copy it
> to a new drive.  I would suggest GNU ddrescue (don't forget to use the
> logfile feature).  At this point I would actually suggest making a
> copy of all the drives (except the spare)...=20
>
Yes, looks like a read error on sdb - this may be just a transient
issue, or could be a sign of pending failure. Once you've got it copied,
you can do a more thorough check (SMART tests, badblocks, etc).

> After that you can try to recreate the array with the proper order
> (sdc1, sdb1, sde1, missing, sda1) and copy data off or add the spare
> in again depending on if you were able to recover all the data wih GNU
> ddrescue.
>=20
No! Definitely DO NOT recreate the array. A force assemble should get
the array back up, without any risk of differing data offsets, metadata
formats, etc.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlFpfcgACgkQShxCyD40xBKJAgCgyHwNsLzf/HrmB7AOSx4KpcPn
MhcAoJe3s8FVApGPsCRrAB3B32pwAmdw
=Bq5w
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
