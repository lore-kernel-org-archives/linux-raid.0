From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raid array with 3T disks and GPT partition
Date: Thu, 1 Sep 2011 17:58:40 +0100
Message-ID: <20110901165840.GA22274@cthulhu.home.robinhill.me.uk>
References: <20110901154759.GA32649@apartia.fr>
 <20110901155913.GA20825@cthulhu.home.robinhill.me.uk>
 <20110901163334.GA13347@apartia.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110901163334.GA13347@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Sep 01, 2011 at 06:33:34PM +0200, Louis-David Mitterrand wrote:

> On Thu, Sep 01, 2011 at 04:59:13PM +0100, Robin Hill wrote:
> > On Thu Sep 01, 2011 at 05:47:59PM +0200, Louis-David Mitterrand wrote:
> > >=20
> > > I'm trying to create a raid6 array from 10x3T disks. Since disks > 2T
> > > must use the GPT partion table I used parted to created a single
> > > partition on each drive with the correct GPT partion type.
> > >=20
> > > Now how do I make sure that these partitions have the correct "raid
> > > autodetect" (fd) id? Is it even still needed? I didn't find any way to
> > > set that flag in (g)parted.
> > >=20
> > It's only needed for kernel auto-assembly (in which case you're also
> > limited to 0.90 metadata and 2TB drives), so no, there's no need to use
> > that. 0xDA seems to be the recommended partition type for RAID arrays
> > nowadays - that should prevent the OS from trying to read them directly.
>=20
> Auto-assembly and metadata are not related: I regularly use 1.2 metadata
> on non-boot partitions and they auto-assemble fine.
>=20
Kernel auto-assembly and metadata are related (see the description for
the --auto-detect option in the mdadm manual page). Most distributions
now use mdadm in an initrd for assembly, which will (of course) work
with any metadata version.

> However lilo won't boot on anything other than 0.9, this I found the
> hard way :)
>=20
LILO (and grub) should work with 0.9 or 1.0 metadata, as both of these
write the metadata at the end of the disk, leaving the start looking the
same as a normal disk (for RAID-1 anyway).

> Kernel auto-assembly seems quite useful and desirable to me, especially
> when using, say, initrd to unlock dm-crypt partitions (no need to
> configure madadm.conf in the initrd).
>=20
Kernel auto-assembly is not recommended by the main md developer.

> BTW, what is that 0xDA type?
>=20
0xDA is "non-FS data".

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5fub8ACgkQShxCyD40xBLezQCdHRD1jElfM2ah+X4X8/LVq6CU
kwwAoMmbvS2boPGcvcfLYkNTE236yLSq
=Dyi+
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
