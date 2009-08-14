From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Help understanding the root cause of a member dropping out of
	a  RAID 1 set.
Date: Fri, 14 Aug 2009 14:21:30 +0100
Message-ID: <20090814132130.GA21880@cthulhu.home.robinhill.me.uk>
References: <ABFC24E4C13D81489F7F624E14891C860BF9A409@uk-ex-mbx1.terastack.bluearc.com> <a43edf1b0908130913x238b33ecref5a3d070bf3cb16@mail.gmail.com> <64960.78.86.108.203.1250180799.squirrel@www.yuiop.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <64960.78.86.108.203.1250180799.squirrel@www.yuiop.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Aug 13, 2009 at 05:26:39PM +0100, John Robinson wrote:

> On Thu, 13 August, 2009 5:13 pm, Billy Crook wrote:
> > On Thu, Aug 13, 2009 at 03:44, Simon Jackson<sjackson@bluearc.com> wrot=
e:
> [...]
> >> 2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.348168] md:
> >> super_written gets error=3D-5, uptodate=3D0
> >
> > mdraid notices.  says oh craps.
> >
> >> 2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.348168] raid1:
> >> Operation continuing on 1 devices.
> >
> > mdraid marks the component that encountered the error failed, and
> > keeps on keeping on
> >
> >> 2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.348168] ata1: EH
> >> complete
> >
> > ata reset (of link, and subsequently drive) is complete.
>=20
> Can or could md be made or configured to try re-adding a device if this
> sort of thing happens? After all, a stray cosmic ray or whatever perhaps
> shouldn't make one lose redundancy if the drive's actually OK?
>=20
If you want to do this, it should be doable via the PROGRAM option in
mdadm.conf (using standard mdadm calls).  As has been pointed out
elsewhere though, doing so automatically can be rather a risky option.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqFZNoACgkQShxCyD40xBJCnwCgtMIdesWDJER1xZNGpS9XrTbp
C9UAnitemgcUKWdWQ5PvDb6xp9D7/zZZ
=DWs5
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
