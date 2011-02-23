From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: failing a drive while RAID5 is initializing
Date: Wed, 23 Feb 2011 22:33:28 +0000
Message-ID: <20110223223328.GA26337@cthulhu.home.robinhill.me.uk>
References: <4D6533D2.3020600@cdf.toronto.edu>
 <20110223163354.GA25777@cthulhu.home.robinhill.me.uk>
 <4D658570.2040601@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D658570.2040601@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Iordan Iordanov <iordan@cdf.toronto.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Feb 23, 2011 at 05:08:48PM -0500, Iordan Iordanov wrote:

> > Some of the features on Neil's current roadmap should allow for "lazy
> > initialisation" where the recovery data is added only as the drive is
> > written to, which should mean the array is available immediately but
> > still retains full recoverability.
>=20
> I was thinking that this is how things work now, but now that you=20
> mentioned it, the man-page does say that the array is degraded to begin=
=20
> with and is rebuilding onto the last device during initialization.
>=20
> To make this lazy initialization possible, one would have to have a=20
> bitmap of "dirtied" chunks, though, right?
>=20
Yes, that's correct.  He's also suggested using this same bitmap with
TRIM operations for SSDs - I'm not sure whether this is mainly intended
for recognising when an entire block in unsynced and can be trimmed, or
whether it's primarily to allow TRIM operations to be delayed until the
system is less busy (as they require a flush of the I/O buffer and
command queue).

Anyway, I'd suggest reading the roadmap as it goes into a lot more
detail on the planned implementation (it was posted here a week or so
ago, and is also on his blog at
http://neil.brown.name/blog/20090129234603).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk1lizcACgkQShxCyD40xBJIcQCcDSR8iE6hsbSXFFfgJxy+eLOX
aogAn2gSOjvNbHXb2/iaddsh691osikD
=fc4V
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
