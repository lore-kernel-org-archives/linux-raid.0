From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: About seting up Raid5 on a four disk box.
Date: Wed, 14 Oct 2009 09:56:06 +0100
Message-ID: <20091014085606.GA13917@cthulhu.home.robinhill.me.uk>
References: <hb1udb$6t1$1@ger.gmane.org>
 <20091013152304.GA19668@cthulhu.home.robinhill.me.uk>
 <hb3vij$j47$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <hb3vij$j47$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Oct 14, 2009 at 03:45:21AM -0400, Antonio Perez wrote:

> Robin Hill wrote:
>=20
> > On Tue Oct 13, 2009 at 09:13:13AM -0400, Antonio Perez wrote:
>=20
> Then, the two consequences of dividing disks in several md are correct:
>=20
> 1.- Will improve rebuild time, as each md is smaller.
> 2.- Will allow to control if the md is in the outside (faster) disk area.
>=20
> Am I understanding you correctly?
>=20
Certainly both of these will apply, yes.  My understanding is that
there'll be little (if any) negative effects from this, but that's based
more on what (and where) the tunables are for the IO stack, rather than
any knowledge of what's actually going on in it.

> There are two areas of interest:
>=20
> 1.- The "Boot disk area" including the MBR.:
> On the usual (at least for me) partition scheme, the first cylinder*,=20
> Sectors (LBA) 0-62 [CHS 0/0/1 to 0/0/63] of the disk are left empty, exce=
pt=20
> for sector 0, a.k.a. MBR. That is called the disk boot area.
> Grub uses the sector 0 as the MBR and several sectors following it to emb=
ed=20
> the booting code: core.img.
>=20
> 2.- The "partition boot area":
> There is also an empty space at the beginning of each partition of 63=20
> sectors. The first partition uses (LBA) 63-125 [CHS 0/1/0 to 0/1/63] for =
the=20
> "partition boot area" therefore restoring alignment on the disk heads.
> Next partitions repeat this setup.
> This area is used to boot if grub is installed to sda1 instead of sda
>=20
> So, I assume that a RAID1 on "sd[a..d]1" will mirror the "Area 2" but wil=
l=20
> not touch any of the "Area 1".
>=20
> Is this assumption correct?
>=20
Yes - anything that falls within the blocks covered by the array will
get replicated, so "Area 2" will automatically get taken care of (you'll
have to make sure the RAID metadata version is chosen correctly so as
not to conflict though - 1.1/1.2 metadata may overlap with the area used
by grub here).

As for "Area 1" - from what you've written (and reading the grub
internals documentation), I can only assume you're referring to the
stage1.5 bootloader (unless you're using grub2?).  This can live on the
file system (I don't see anything obvious in the documentation about how
you set where it goes - the documentation seems to suggest that the file
system is the default), so so there may well be no need to do anything
about this (other than the MBR itself).

> >> 2.- Is there a recomended way to trigger the said copy of question 2?
> >> Where should a call to copy the MBR should be placed? On update-grub?
>=20
> > I always just rerun the grub install for each disk manually (see
> > http://lists.us.dell.com/pipermail/linux-poweredge/2003-July/008898.html
> > for example).
>=20
> That's the usual procedure on a first install, correct.
>=20
It's what I do every update - it's a quick enough process, and grub
updates aren't very common (all the development's on grub2 now).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrVkiYACgkQShxCyD40xBI03QCgvhhp/Zfma0QU+9wlE9Af7TJW
YVIAoJWYLrXNYtlyiGg75trIMGrJ4IUp
=a6BL
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
