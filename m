From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: slow mdadm reshape, normal?
Date: Thu, 11 Jun 2009 09:19:09 +0100
Message-ID: <20090611081909.GA16250@cthulhu.home.robinhill.me.uk>
References: <4A303C06.9080409@anonymous.org.uk> <20090610233659.GD30825@rlogin.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090610233659.GD30825@rlogin.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jun 11, 2009 at 01:36:59AM +0200, Michael Ole Olsen wrote:

> the slow disks (them with 85MB/s) in the posting are the one on the pci 4=
x sata controller
>=20
> the 32bit pci sata (sata_sil) controller has 3 disks connected
>=20
> the onboard sata2 6x sata connectors have 6 disks connected=20
> (p5n32-e sli motherboard), i believe all these are sata2 and not shared w=
ith
> an ide controller.
>=20
> so only the pci controller should have bus limitations, but i wonder why =
it is
> that slow on reshape compared to build.
>=20
The build was reading (sequentially) from all drives and writing
(sequentially) only to one, whereas a reshape is reading from and
writing to all the drives (including seeking between reads & writes).
This means it is inevitably a lot slower.  In addition, you're now using
3 rather than 2 drives on the PCI bus, which will increase the
congestion.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkowvfwACgkQShxCyD40xBI7jACg3qu89AY9XFu9PrfDjUQF9K0d
OIYAnA5WUDuZoXiinyoh/jgji9xYMh6d
=HEoI
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
