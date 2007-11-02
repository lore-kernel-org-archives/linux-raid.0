From: Doug Ledford <dledford@redhat.com>
Subject: Re: Implementing low level timeouts within MD
Date: Fri, 02 Nov 2007 15:15:32 -0400
Message-ID: <1194030932.25553.49.camel@firewall.xsintricity.com>
References: <1193418753.4771.17.camel@w100>
	 <1193425254.10336.290.camel@firewall.xsintricity.com>
	 <87tzoc7soa.fsf@willow.rfc1149.net>  <1193721577.3876.12.camel@w100>
	 <1193765984.10336.519.camel@firewall.xsintricity.com>
	 <1193893689.3649.19.camel@w100>
	 <1193944573.10336.684.camel@firewall.xsintricity.com>
	 <1193992909.3649.75.camel@w100>
	 <1194018326.25553.28.camel@firewall.xsintricity.com>
	 <1194027687.11827.32.camel@w100>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C3+w5LaHBBk4UMJ+l57R"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1194027687.11827.32.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-C3+w5LaHBBk4UMJ+l57R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-11-02 at 13:21 -0500, Alberto Alonso wrote:
> On Fri, 2007-11-02 at 11:45 -0400, Doug Ledford wrote:
>=20
> > The key word here being "supported".  That means if you run across a
> > problem, we fix it.  It doesn't mean there will never be any problems.
>=20
> On hardware specs I normally read "supported" as "tested within that
> OS version to work within specs". I may be expecting too much.

It was tested, it simply obviously had a bug you hit.  Assuming that
your particular failure situation is the only possible outcome for all
the other people that used it would be an invalid assumption.  There are
lots of code paths in an error handler routine, and lots of different
hardware failure scenarios, and they each have their own independent
outcome should they ever be experienced.

> > I'm sorry, but given the "specially the RHEL" case you cited, it is
> > clear I can't help you.  No one can.  You were running first gen
> > software on first gen hardware.  You show me *any* software company
> > who's first gen software never has to be updated to fix bugs, and I'll
> > show you a software company that went out of business they day after
> > they released their software.
>=20
> I only pointed to RHEL as an example since that was a particular
> distro that I use and exhibited the problem. I probably could of
> replaced it with Suse, Ubuntu, etc. I may have called the early
> versions back in 94 first gen but not today's versions. I know I=20
> didn't expect the SLS distro to work reliably back then.=20

Then you didn't pay attention to what I said before: RHEL3 was the first
ever RHEL product that had support for SATA hardware.  The SATA drivers
in RHEL3 *were* first gen.

> Can you provide specific chipsets that you used (specially for SATA)?=20

All of the Adaptec SCSI chipsets through the 7899, Intel PATA, QLogic
FC, and nVidia and winbond based SATA.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-C3+w5LaHBBk4UMJ+l57R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHK3dUTzP9PM7pjw8RArITAJwMg2YwlJicZqXEAnhAmhlrqi+xuwCbBFtE
K6mtF9JNsy9UDyitwvC/uo8=
=7ePD
-----END PGP SIGNATURE-----

--=-C3+w5LaHBBk4UMJ+l57R--

