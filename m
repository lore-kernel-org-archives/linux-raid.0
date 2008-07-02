From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  new bottleneck section in wiki
Date: Wed, 2 Jul 2008 20:17:28 +0100
Message-ID: <20080702191728.GA16356@cthulhu.home.robinhill.me.uk>
References: <20080702155603.GA11156@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com> <20080702190337.GA2311@sewage.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080702190337.GA2311@sewage.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Jul 02, 2008 at 02:03:37PM -0500, Matt Garman wrote:

> On Wed, Jul 02, 2008 at 12:04:11PM -0500, David Lethe wrote:
> > The PCI (and PCI-X) bus is shared bandwidth, and operates at
> > lowest common denominator.  Put a 33Mhz card in the PCI bus, and
> > not only does everything operate at 33Mhz, but all of the cards
> > compete.  Grossly simplified, if you have a 133Mhz card and a
> > 33Mhz card in the same PCI bus, then that card will operate at
> > 16Mhz. Your motherboard's embedded Ethernet chip and disk
> > controllers are "on" the PCI bus, so even if you have a single PCI
> > controller card, and a multiple-bus motherboard, then it does make
> > a difference what slot you put the controller in.
>=20
> Is that true for all PCI-X implementations?  What's the point, then,
> of having PCI-X (64 bit/66 MHz or greater) if you have even one PCI
> card (32 bit/33 MHz)?
>=20
> A lot of "server" motherboards offer PCI-X and some simple graphics
> chip.  If you read the motherboard specs, that simple graphics is
> usually attached to the PCI bus [1].  So what's the point of having
> PCI-X slots if everything is automatically downgraded to PCI speeds
> due to the embedded graphics?
>=20
Server class boards have multiple PCI buses (2 or 3 usually), so the
PCI-X slots are on a different bus.

> I read some of the high-level info on the Intel 6702 PHX PCI-X hub
> [2].  If I understand correctly, that controller is actually
> attached to the PCI express bus.  So to me, it seems possible that
> PCI and PCI-X could be independant, and that PCI-X will compete with
> PCI-E for bandwidth.
>=20
Newer workstation (and probably server boards) have the PCI-X slots on a
PCI-E "bus" (hence you can actually get boards with PCI-X slots for a
reasonable price nowadays).  In actual fact PCI-E doesn't have a bus as
such, all the connections are point-to-point so there's no bandwidth
contention at that stage.  You may get contention afterwards though,
depending on how the PCI-E lanes are connected to the processor.  AMDs
HyperTransport is supposed to be very good for this, whereas Intel
systems tend to suffer more (or did - I've not looked at this recently
so they may have moved on now).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--huq684BweRXVnRxX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhr1EcACgkQShxCyD40xBLaHwCg20FbrfUPJ7m8Qh3qGXjX89DP
gREAniMno4JrFzVa6zP5NCE8H0HlD895
=fcp8
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
