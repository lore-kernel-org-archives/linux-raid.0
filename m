From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: md data-check causes soft lockup
Date: Tue, 22 Sep 2009 16:19:26 +0100
Message-ID: <20090922151925.GA20382@cthulhu.home.robinhill.me.uk>
References: <4AB7C11E.60801@howardsilvan.com>
 <70ed7c3e0909211154y3e4abcadyf76822e60127dfad@mail.gmail.com>
 <4AB8E2A6.2020800@howardsilvan.com>
 <70ed7c3e0909220748y2e151ebv7f232cf2b7c79617@mail.gmail.com>
 <4AB8E661.8080706@howardsilvan.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AB8E661.8080706@howardsilvan.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Sep 22, 2009 at 07:59:45AM -0700, Lee Howard wrote:

> Majed B. wrote:
> > I must have missed that part. It may not work for your case, but worth =
trying.
> >
> > Perhaps Neil Brown, or someone involved could shed some light on this.
> >
> > If I remember correctly, those soft lockups were harmless anyway.
> >  =20
>=20
> Not harmless for production use.  Yes, data is not harmed, and yes, the=
=20
> problem state does recover when the data-check finishes, but during the=
=20
> data-check the system is virtually unresponsive and all other use of the=
=20
> system is stalled.
>=20
Are you sure this is caused by these soft lockups, and that you're not
just running with too high a /sys/block/mdX/md/sync_speed_max setting?
I've had issues with this on some servers, where the I/O demand for the
sync/check is causing the system to become totally unresponsive.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq46v0ACgkQShxCyD40xBImZgCfV9GvZ2vzkpBPWp4yWDVuqSii
aDMAoJac6gszvMam+FFJ3Mj/oBmFlpBv
=W/UG
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
