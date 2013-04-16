From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Question about resync in RAID5
Date: Tue, 16 Apr 2013 17:55:22 +0100
Message-ID: <20130416165522.GA14744@cthulhu.home.robinhill.me.uk>
References: <20130416102452.GC25795@cthulhu.home.robinhill.me.uk>
 <4915289.2.1366127167165.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4915289.2.1366127167165.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid@vger.kernel.org, Robin Dong <robin.k.dong@gmail.com>
List-Id: linux-raid.ids


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Apr 16, 2013 at 05:46:07PM +0200, Roy Sigurd Karlsbakk wrote:

> > > Is there any method to just resync WRITTEN data to new-added-disk ?
> > > Or any developing plan to add this feature?
> >=20
> > No, because md is a block device it has no knowledge of what data has
> > actually been written to the disk or where it is stored. This means it
> > has to rebuild the entire disk.
> >=20
> > There are plans to improve this by keeping track of which stripes have
> > been written to, which should help (and will also mean no need for an
> > initial RAID sync). I don't know whether this has progressed beyond
> > the idea stage yet though.
>=20
> Interesting - do you have any docs about this? I haven't seen any talk
> on this list about it...
>=20
It's from Neil's 2011 MD/RAID roadmap:
    http://neil.brown.name/blog/20110216044002

The basic idea was mentioned in a 2009 roadmap as well, but is a lot
more fleshed out in the above one.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlFtgnoACgkQShxCyD40xBJi4ACggXrBRQETBg5al1pVY4nvNRET
C00AoLDm9jq98rja3vpKq5Jtxq3UWPsm
=WIDS
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
