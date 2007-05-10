From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  Questions about the speed when MD-RAID array is being initialized.
Date: Fri, 11 May 2007 00:03:10 +0100
Message-ID: <20070510230310.GA12433@cthulhu.home.robinhill.me.uk>
References: <20070508170441.GB4333@scavenger.homeip.net> <f1sc2p$33q$1@sea.gmane.org> <BAY125-DAV2F4ABCF54BCB7458BA3D7933A0@phx.gbl> <Pine.LNX.4.64.0705101732540.11720@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705101732540.11720@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu May 10, 2007 at 05:33:17PM -0400, Justin Piszcz wrote:

>=20
>=20
> On Thu, 10 May 2007, Liang Yang wrote:
>=20
> >Hi,
> >
> >I created a MD-RAID5 array using 8 Maxtor SAS Disk Drives (chunk size is=
=20
> >256k). I have measured the data transfer speed for single SAS disk drive=
=20
> >(physical drive, not filesystem on it), it is roughly about 80~90MB/s.
> >
> >However, I notice MD also reports the speed for the RAID5 array when it =
is=20
> >being initialized (cat /proc/mdstat). The speed reported by MD is not=20
> >constant which is roughly from 70MB/s to 90MB/s (average is 85MB/s which=
=20
> >is very close to the single disk data transfer speed).
> >
> >I just have three questions:
> >1. What is the exact meaning of the array speed reported by MD? Is that=
=20
> >mesured for the whole array (I used 8 disks) or for just single underlyi=
ng=20
> >disk? If it is for the whole array, then 70~90B/s seems too low=20
> >considering 8 disks are used for this array.
> >
> >2. How is this speed measured and what is the I/O packet size being used=
=20
> >when the speed is measured?
> >
> >3. From the beginning when MD-RAID 5 array is initialized to the end whe=
n=20
> >the intialization is done, the speed reports by MD gradually decrease fr=
om=20
> >90MB/s down to 70MB/s. Why does the speed change? Why does the speed=20
> >gradually decrease?
> >
> >Could anyone give me some explanation?
> >
> >I'm using RHEL 4U4 with 2.6.18 kernel. MDADM version is 1.6.
> >
> >Thanks a lot,
> >
> >Liang
> >
>=20
> For no 3. because it starts from the fast end of the disk and works its=
=20
> way to the slower part (slower speeds).
>=20
And I'd assume for no 1 it's because it's only writing to a single disk
at this point, so will obviously be limited to the transfer rate of a
single disk.  RAID5 arrays are created as a degraded array, then the
final disk is "recovered" - this is done so that the array is ready for
use very quickly.  So what you're seeing in /proc/mdstat is the speed in
calculating and writing the data for the final drive (and is, unless
computationally limited, going to be the write speed of the single
drive).

HTH,
        Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6-ecc01.6 (GNU/Linux)

iD8DBQFGQ6SuShxCyD40xBIRArmRAKCGAwP+mXmyB0bVErN0pt1Ev6zIhwCcD6Bw
WlQdzimGMzbafaV8RAfPyO8=
=Y9HQ
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
