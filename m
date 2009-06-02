From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID 5 re-add of removed drive? (failed drive replacement)
Date: Tue, 2 Jun 2009 12:17:29 +0100
Message-ID: <20090602111729.GA15172@cthulhu.home.robinhill.me.uk>
References: <23828899.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <23828899.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Jun 02, 2009 at 03:09:11AM -0700, Alex R wrote:

>=20
> I have a serious RAID problem here. Please have a look at this. Any help
> would be greatly appreciated!
>=20
> As always, most problems occur only during critical tasks like
> enlarging/restoring. I tried to replace a drive in my 7disc 6T RAID5 array
> as explained here:
> http://michael-prokop.at/blog/2006/09/09/raid5-online-resizing-with-linux/
>=20
> After removing a drive and restoring to the new one, another disc in the
> array failed. Now I still have all the data redundantly available (the old
> drive is still there), but the RAID header is now in a state where it's
> impossible to access the data. Is it possible to rearrange the drives to
> force the kernel to a valid array?
>=20
<-- SNIP details -->

AFAIK, the only solution at this stage is to recreate the array.

You need to use the "--assume-clean" flag (or replace one of the drives
with "missing"), along with _exactly_ the same parameters & drive order
as when you originally created the array (you should be able to get most
of this from mdadm -D).  This will rewrite the RAID metadata, but leave
the filesystem untouched.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkolCkkACgkQShxCyD40xBLOawCfTexGCxxH70p0V0VMCbd2jvix
LGIAoMGiWgHnsFtaGZ8ZH4L7xCrvXNSF
=eEXJ
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
