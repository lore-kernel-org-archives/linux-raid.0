From: Doug Ledford <dledford@redhat.com>
Subject: Re: new bottleneck section in wiki
Date: Thu, 03 Jul 2008 01:10:48 -0400
Message-ID: <1215061848.14196.3.camel@firewall.xsintricity.com>
References: <20080702155603.GA11156@rap.rap.dk>
	 <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com>
	 <20080702190337.GA2311@sewage.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-P15OBuhMFFae4GzyJkV7"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080702190337.GA2311@sewage.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: David Lethe <david@santools.com>, Keld J?rn Simonsen <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-P15OBuhMFFae4GzyJkV7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-02 at 14:03 -0500, Matt Garman wrote:
> Is that true for all PCI-X implementations?  What's the point, then,
> of having PCI-X (64 bit/66 MHz or greater) if you have even one PCI
> card (32 bit/33 MHz)?

A 32bit/33MHz card only slows down the particular bus it's plugged into.
A lot of the server class machines that have had PCI-X in the past made
a specific point of using multiple PCI busses for the slots so that
plugging in that 32bit/33MHz card wouldn't effect the PCI-X card next to
it because they were on physically distinct busses.

> A lot of "server" motherboards offer PCI-X and some simple graphics
> chip.  If you read the motherboard specs, that simple graphics is
> usually attached to the PCI bus [1].  So what's the point of having
> PCI-X slots if everything is automatically downgraded to PCI speeds
> due to the embedded graphics?

Again, different physical busses.

> I read some of the high-level info on the Intel 6702 PHX PCI-X hub
> [2].  If I understand correctly, that controller is actually
> attached to the PCI express bus.  So to me, it seems possible that
> PCI and PCI-X could be independant, and that PCI-X will compete with
> PCI-E for bandwidth.
>=20
> [1] The ASUS M2N-LR has PCI-X (via the Intel 6702PHX) and an
> embedded ATI ES1000 video card.  The ES1000's specs say it has a PCI
> bus interface.
> ES1000: http://ati.amd.com/products/server/es1000/index.html
>=20
> [2] http://www.intel.com/design/chipsets/datashts/303633.htm
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-P15OBuhMFFae4GzyJkV7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkhsX0wACgkQTzP9PM7pjw/SLgCfUeGWGKz/JFFz5dImU+bNmfsI
mHIAn2AfQ4f5Sbjj4ZYeYTtcpVOQcaw1
=v3f1
-----END PGP SIGNATURE-----

--=-P15OBuhMFFae4GzyJkV7--

