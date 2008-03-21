From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  Redundancy check using "echo check > sync_action": error
	reporting?
Date: Fri, 21 Mar 2008 17:43:56 +0000
Message-ID: <20080321174356.GA4188@cthulhu.home.robinhill.me.uk>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu> <47E2EE64.5080101@rabbit.us> <47E3C504.3010700@tmr.com> <47E3CBAF.4090808@rabbit.us> <20080321171348.GK7991@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080321171348.GK7991@mit.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Mar 21, 2008 at 01:13:48PM -0400, Theodore Tso wrote:

> On Fri, Mar 21, 2008 at 03:52:31PM +0100, Peter Rabbitson wrote:
> > I was actually specifically advocating that md must _not_ do anything o=
n=20
> > its own. Just provide the hooks to get information (what is the current=
=20
> > stripe state) and update information (the described repair extension). =
The=20
> > logic that you are describing can live only in an external app, it has =
no=20
> > place in-kernel.
>=20
> Why not?  If md doesn't do anything on its own, then when it detects a
> disagreement between the data and the two parity blocks, it has two
> choices (a) return possibly incorrect data to the application, or (b)
> return an I/O error and cause the application to blow up.
>=20
> Sure, it could then give the information so that the external repair
> tool can fix it up after the fact, but that seems like a really lousy
> thing to do as far as the original application is concerned.  (Or I
> suppose you could try to block the userspace application until the
> repair tool has a chance to do automatically what md could have done
> automatically in the kernel anyway, but that has other problems.)
>=20
> So what's the harm in having an option where md does exactly what ECC
> memory does, which is when it can fix things up, to do so?  I bet most
> system administrators would turn it on in a heartbeat.
>=20
Depends on how you look at things. ECC memory is designed to deal with
occasional mismatches caused by such obscure and rare events as cosmic
radiation. RAID subsytems, on the other hand, are designed to deal with
catastrophic failures of one (or more) drives. There's no trivially
explaianable reason why a drive would sporadically suffer from incorrect
data reading/writing (unlike with ECC memory) so there's no recovery
case.

Admittedly, it would be possible to do this, but that would mean adding
an extra read penalty on every RAID read (and, in some situations,
throwing away the advantages of parallelism) in order to cover the
exceptionally rare case where a drive has (for unknown reason) written
the wrong data.

Personally, this would be an option I'd avoid like the plague.  If I
know there's an issue then I replace the hardware, otherwise I expect
the system to work as fast as possible in the assumption that all is
correct.  Admittedly, a check/repair option to view/select how the
blocks are recovered might be useful, but I'd also see this sitting
well outside the md code.

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFH4/PYShxCyD40xBIRAvDzAJkBtT33TIaqe9lX6Jqfc43jxu98kwCdEotu
yQf3JwO72xUc3UlJi+HboSk=
=H9B6
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
