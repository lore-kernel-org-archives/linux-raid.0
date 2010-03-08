From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: 3 disk RAID1?
Date: Mon, 8 Mar 2010 20:58:03 +0000
Message-ID: <20100308205803.GA31731@cthulhu.home.robinhill.me.uk>
References: <5bdc1c8b1003081239l32c5653fs8347179e23c0a287@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5bdc1c8b1003081239l32c5653fs8347179e23c0a287@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Mar 08, 2010 at 12:39:26PM -0800, Mark Knecht wrote:

> Hi all,
>    I'm still very much on a steep learning curve about what I can do
> with Linux software RAID. In another thread this weekend a couple of
> responders discussed among themselves 3-disk RAID1 solutions that can
> survive if 2 disks die. I don't understand what that means. Can
> someone point me at a quick explanation? Is that really possible?
>=20
>    In general I'm using a few Wikipedia pages and gravitate toward the
> diagrams as much as anything.
>=20
> http://en.wikipedia.org/wiki/RAID
> http://en.wikipedia.org/wiki/RAID1#RAID_1
>=20
> RAID0 - striping, speed not reliability (2 disk minimum)
> RAID1 - duplicate data, no other protection (2 disk minimum)
>=20
>    How do I build RAID1 using three drives? Just duplicate the data 3
> times? If drives start going bad how do I determine which one or two
> are failing? (fsck? SMART?) With 3 drives 1 fail seems relatively
> straightforward to figure out, but 2?
>=20
A 3-disk RAID1 is just 3 duplicate copies, yes.  And RAID only protects
against hardware failures, so you know which disk has failed because it
gets kicked out of the array as faulty.  This is the same regardless of
how many mirrored copies you have (md will detect a write failure to a
drive and mark it as faulty - read errors will cause the failed block to
get rewritten).

As for how to create it - it's just the same process as for a 2-disk
RAID1 but specifying 3 drives (assuming you're using Linux md software
RAID - if not, please specify what you're intending to use).  The manual
page for mdadm should give you everything you need - do ask if there's
anything you want clarifying though.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEUEARECAAYFAkuVZNoACgkQShxCyD40xBLeIACXX2pMafHHkJkdtZbcNruTjSlV
qQCfesCzysCs2n7cQQzew1Ril+mF0C4=
=6bRY
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
