From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID10 scrub
Date: Wed, 2 Oct 2013 08:55:38 +0100
Message-ID: <20131002075538.GA20005@cthulhu.home.robinhill.me.uk>
References: <CA+FAjA90MPuA4aQUqmKRAzEsxJFMFJ9_UZFeiWJd__QAmS-mBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+FAjA90MPuA4aQUqmKRAzEsxJFMFJ9_UZFeiWJd__QAmS-mBg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Keisler <mark@mitsein.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Oct 01, 2013 at 03:42:39 -0500, Mark Keisler wrote:

> Is scrub (sync) needed on RAID10?  I've noticed in mdadm monitor logs that
> it seems to re-allocate data destined for bad blocks on the fly anyway.
>  Maybe I don't quite understand what the scrub does, though :)
> I ran it for the first time on my RAID last night anyway to make sure all
> way well since I am failing out a dying disk for replacement today.

"Scrubbing" will read all the data on all the disks in the array, which
ensures there's no read errors (as well as correcting any parity/mirror
mismatches). Any found will then get rewritten (which may cause a bad
block re-allocation in the background) while the parity/mirrored data is
still available. If there's too many in a short time then the disk will
be failed.

Otherwise you'll only find out about read errors if the data happens to
be read in normal use, or when you're trying to recover a failed disk
(and unless you have multiple levels of redundancy, you're then
stuffed).

I'd recommend running it regularly on any software RAID setup (well, any
with redundancy anyway).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iEYEARECAAYFAlJL0XkACgkQShxCyD40xBLBFQCgvGcDITCd6GPDlfT67bukj3y9
/qAAn0+Z+ufOvnxIpTnuM8H+PqFK7d1z
=MghK
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
