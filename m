From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: mdadm: /dev/md0 has been started with 1 drive (out of 2).
Date: Wed, 6 Nov 2013 08:54:57 +0000
Message-ID: <20131106085457.GA4473@cthulhu.home.robinhill.me.uk>
References: <C8EFEBC6-4B43-4B71-AA3F-7DC69480220D@gmail.com>
 <5278C2A6.7060005@websitemanagers.com.au>
 <E9509E1D-C8FB-4496-ADD5-C6ACBEFC4007@gmail.com>
 <5278D84C.4040600@websitemanagers.com.au>
 <5E756798-9940-4EA9-821A-2A49F92E0B03@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5E756798-9940-4EA9-821A-2A49F92E0B03@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Nov 05, 2013 at 02:02:03PM +0200, Ivan Lezhnjov IV wrote:

> On Nov 5, 2013, at 1:36 PM, Adam Goryachev <mailinglists@websitemanagers.=
com.au> wrote:
>=20
> > The
> > alternative is to force the array, then run a check, and then a repair.
> > This will at least allow you to get consistent data regardless of which
> > disk you read from, however, you won't determine whether it is the
> > "newer" or "older" data (md will choose at random AFAIK).
>=20
> What are these check and repair commands that you refer to when
> talking about forcing an array? Are they echo check|repair >
> /sys/block/mdX/md/sync_action ?
>=20
> When you say force the array, does it translate to a different set of
> commands than what you showed in the very first reply? What would be
> those? I'm just curious to see how these things are done when managing
> the arrays, and examples help a lot!
>=20
There are 3 ways to get an array back up and running. The basic one is
just to do an assemble. This will only work if there's enough disks with
the same event count (and array state info) to assemble a working array.
It should always work with a RAID1 array as only a single disk is ever
needed.

The second option is to assemble with the --force flag. This will tell
md to ignore the event count when assembling the array (providing
they're close enough). This is only useful when a normal assemble fails
to get an array up and running. As you found, it won't add any extra
disks available, only the minimum needed to get the array back up. I
don't think this will ever be of use with a RAID1 array.

The final option (and it's definitely a last-hope scenario) is to
recreate the array using the exact same parameters as were originally
used and adding the --assume-clean flag. This is fraught with danger as
different mdadm versions have used different offsets (and only the very
latest allow specifying the data offset to use), and any error in
parameters or disk order can result in severe data loss. This should
only be used when all other options fail, and generally only when
advised to by one of the more knowledgeable people on this list (once
they're sure you've tried every other option and have pulled out the
necessary info from the array metadata to run the correct create
command). Again, I don't see this being useful for a RAID1 array.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlJ6A+EACgkQShxCyD40xBJlrACgym5ezgTDmi6AMFiTejsGUjSf
y3cAoNWptV9Ir7LQGhkeEXB+VaOBL3I+
=Hh/5
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
