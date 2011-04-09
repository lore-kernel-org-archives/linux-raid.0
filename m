From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: iostat with raid device...
Date: Sat, 9 Apr 2011 09:50:44 +0100
Message-ID: <20110409085044.GB417@cthulhu.home.robinhill.me.uk>
References: <BANLkTi=6uvCsQTpCi4xLUWzx5X7o99_=5g@mail.gmail.com>
 <20110409094629.2eae2d5b@notabene.brown>
 <BANLkTin2KP-_vy8jbmV3JB-LHHJNOEVCKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTin2KP-_vy8jbmV3JB-LHHJNOEVCKw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Apr 08, 2011 at 05:40:46PM -0700, Linux Raid Study wrote:

> What I'm not sure of is if the device is newly formatted, would raid
> recovery happen? What else could explain difference in the first run
> of IO benchmark?
>=20
When an array is first created, it's created in a degraded state - this
is the simplest way to make it available to the user instantly. The
final drive(s) are then automatically rebuilt, calculating the
parity/data information as normal for recovering a drive.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2gHdoACgkQShxCyD40xBL6OwCgsq/wOJfj380UPhoT6m3371nL
qh4Anj8+vtiVzOfzHeHdn9m7UbWY/crm
=mlT/
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
