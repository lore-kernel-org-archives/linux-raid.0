From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID 5 : recovery after failure
Date: Tue, 8 Oct 2013 22:06:03 +0100
Message-ID: <20131008210603.GA22876@cthulhu.home.robinhill.me.uk>
References: <CAPbD+Repm2SDpCGsR35QbW9Zq-MiCu1Fsdh4jjP_yESE3E3Exg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPbD+Repm2SDpCGsR35QbW9Zq-MiCu1Fsdh4jjP_yESE3E3Exg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Betous <guillaume.betous@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Oct 08, 2013 at 09:19:44 +0200, Guillaume Betous wrote:

> Hi,
>=20
> My RAID 5 has failed... After a first failure, the spare disk has
> started its rebuild. During the rebuild process (60%), I received a
> 2nd email :(
>=20
> The RAID became laggy and finally unusable.
>=20
> Now I can't recover the RAID array. Even if there is no particular
> precious data, I'm trying to recover it, only be to learn a little bit
> :)
>=20
> I've tried the procedures written in the wiki, and before trying the
> last one (recreate), I write this mail, as said in the wiki :)
>=20
> Trying to --force fails with the following message :
> mdadm: /dev/sdf1 has no superblock - assembly aborted
>=20
> Removing sdf1 from RAID array results in same error on sdd1 and so on...
>=20
> You'll find some command results here after :
>=20
> mdadm --examine : http://pastie.org/8385891
> timeouts : http://pastie.org/8385901
> smartclt -x : http://pastebin.com/BXMHADZD
>=20
Looks like you've got some timeout mismatches, which is probably causing
some of the issues. Two of the drives are WD Reds, which have SCT ERC
enabled by default at 7 seconds (which is good). There's also a Seagate
which supports ERC but it isn't enabled (you'll need to set that each
boot). Then there's a Seagate and a WD Green which don't support ERC at
all, so you'll need to set the timeouts to 180+ at each boot for those.

I've no idea which disk is which though - I'd guess the smartctl output
is in order, but there's nothing to actually say which output
corresponds with which device.

The first WD Red (sda?) is reporting a couple of read errors - those are
the only obvious SMART errors though. There are a couple of command
timeouts in the SMART attributes for the non-green Seagate (sdb?) as
well, which might also be relevant (I'm not familiar with that attribute
though, so I'm not entirely sure).

As far as the array goes, it looks like you _should_ be able to force
assembly with sdc1, sde1 & sdf1. They all have array positions listed,
whereas the other two are just listed as spares. If that fails, retry
with --verbose and post the resulting error messages (and the
corresponding section of dmesg output).

Make sure you set the ERC/timeouts before attempting to re-add either of
the other disks though.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iEYEARECAAYFAlJUc7oACgkQShxCyD40xBILjwCgyK285LHElyCueRSeghWqKjuA
xwgAnixFNtENitc66ZgjSip9+L29Taff
=cUZn
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
