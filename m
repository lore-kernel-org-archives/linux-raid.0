From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Installing Red Hat Enterprise Linux on Dell Hardware Raid
Date: Thu, 10 Dec 2009 15:11:37 +0000
Message-ID: <20091210151137.GA13641@cthulhu.home.robinhill.me.uk>
References: <4B210A66.2010302@uga.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B210A66.2010302@uga.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Dec 10, 2009 at 09:49:10AM -0500, Harold Pritchett wrote:

> I wish to install Red Hat Enterprise Linux 5.4 on this using hardware rai=
d-6.
> I have four 250 GB drives and four additional hot swap bays for future
> expansion.
>=20
> What do I need to do this?  Instructions? Drivers? 32 vs 64 bit?
>=20
> Any assistance would be appreciated.
>=20
This is mostly a software RAID list, but this looks straightforward
enough.  The specs you listed show that you've specified the RAID-6
setup, so it should arrive pre-configured.  If not, you'll need to set
it up via the controller BIOS (should pop up a message at boot time).
The drivers should be included with RHEL5, and with 6GB RAM I'd say
you'd want 64-bit (there's little reason to go for 32-bit over 64-bit
nowadays).

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkshD6kACgkQShxCyD40xBLPpQCgjZGvngcG3KyyZoHkk+++sxhC
M90An2bAE+Bwa5sXbKEsN3sxlri/K+z/
=mfWe
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
