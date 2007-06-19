From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  Software based SATA RAID-5 expandable arrays?
Date: Tue, 19 Jun 2007 15:23:46 +0100
Message-ID: <20070619142346.GA9545@cthulhu.home.robinhill.me.uk>
References: <335871.82002.qm@web54105.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <335871.82002.qm@web54105.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Jun 19, 2007 at 06:43:27AM -0700, Michael wrote:

> I have yet to get info on what build and/or distro I should use.  What
> commands I need in Linux to build an array.  What commands I need in
> Linux to expand the array, and what type of RAID-5 setup linux option
> I should use to   What SATA adapter cards I should use.  Or any other
> ideas and suggestions.
>=20
You didn't actually _ask_ any of these questions in your original mail,
which may be why you've not had any answers yet!  Anyway - if you're
planning on going with a dedicated server build then you may be best
looking at one of the distros specifically designed for storage servers
(e.g. NASLite - http://www.serverelements.com/).  Alternately, as a
linux newbie, one of the more user-friendly distributions like Ubuntu
would probably be a good option.

All the linux RAID configuration is done through the mdadm command - the
manual page should give you a pretty good idea of what can be done and
how.  You're best coming back for more details when you know what disks,
controller, distribution, etc. you're going with as that'll influence
the exact command line to use.

I can't really offer much advice in the way of SATA cards as I've only
used the onboard stuff so far.  You're best looking at somewhere like
www.linux-drivers.org to check for compatability, or ask here about
specific cards - someone probably has experience, good or bad, they can
share.

HTH,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7-ecc0.1.6 (GNU/Linux)

iD8DBQFGd+byShxCyD40xBIRAugqAJ9h7x6SMy6g9hFdUNrvI0n+N2YF9wCdHx1U
1b7FNog1PN9o45mqFVf+mms=
=ci8v
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
