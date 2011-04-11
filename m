From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: iostat with raid device...
Date: Mon, 11 Apr 2011 10:25:59 +0100
Message-ID: <20110411092559.GA20532@cthulhu.home.robinhill.me.uk>
References: <BANLkTi=6uvCsQTpCi4xLUWzx5X7o99_=5g@mail.gmail.com>
 <20110409094629.2eae2d5b@notabene.brown>
 <BANLkTin2KP-_vy8jbmV3JB-LHHJNOEVCKw@mail.gmail.com>
 <20110409085044.GB417@cthulhu.home.robinhill.me.uk>
 <BANLkTim4fenro-GQchqJ0JzrcDAcJXG0UQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTim4fenro-GQchqJ0JzrcDAcJXG0UQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Apr 11, 2011 at 01:32:34 -0700, Linux Raid Study wrote:
> On Sat, Apr 9, 2011 at 1:50 AM, Robin Hill <robin@robinhill.me.uk> wrote:
> > On Fri Apr 08, 2011 at 05:40:46PM -0700, Linux Raid Study wrote:
> >
> >> What I'm not sure of is if the device is newly formatted, would raid
> >> recovery happen? What else could explain difference in the first run
> >> of IO benchmark?
> >>
> > When an array is first created, it's created in a degraded state - this
> > is the simplest way to make it available to the user instantly. The
> > final drive(s) are then automatically rebuilt, calculating the
> > parity/data information as normal for recovering a drive.
> >
> Thanks. So, the uneven (unequal) distribution of Wrtie/Sec numbers in
> the iostat output are ok...is that correct?
>=20
If it hadn't completed the initial recovery, yes.  If it _had_ completed
the initial recovery then I'd expect writes to be balanced (barring
any differences in hardware).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2iySYACgkQShxCyD40xBLsLACglIBrmwi9oYVyE35th1yyrHHn
fisAniQalq/tZUL/jvJDPppBrj7SRk6F
=H8aR
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
