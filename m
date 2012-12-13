From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Degraded Raid6
Date: Thu, 13 Dec 2012 09:52:37 +0000
Message-ID: <20121213095237.GB17294@cthulhu.home.robinhill.me.uk>
References: <S1754985Ab2LLT4x/20121212195656Z+425@vger.kernel.org>
 <20121212204907.248080@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z6Eq5LdranGa6ru8"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121212204907.248080@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Waage <berndman1980@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--z6Eq5LdranGa6ru8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Dec 12, 2012 at 09:49:07PM +0100, Bernd Waage wrote:

> Hello all,
>=20
> I run an 8-disk raid 6 on which sporadically 2 drives dropped out,
> that I could just re-add when I zeroed the zuperblock beforehand.
> Recently, upon re-adding those 2 drives (after the zero-superblock) a
> third drive dropped out after 5-10 minutes of syncing. I then did a
> zero-superblock on the third drive and tried to re-add it - which
> failed.
>=20
Firstly, drives sporadically dropping out of the array should _never_
just be ignored. You have a problem with your setup which needs fixing.
If the drives are actually okay (run SMART and full badblocks tests on
them) then it's probably a controller issue. I used to have a similar
issue on one of my servers and fixed it by moving the drives off the
onboard SATA controller and onto a proper SAS/SATA controller card.
Alternately, it may be the cables, power supply, or input power
fluctuations.

> I'm pretty much at my wits' end and stumbled upon this list. Perhaps
> someone of you guys can help me out. I'm running an ubuntu 12.04 box
> with kernel 3.3.8, so I should not be affected by the kernel-bug that
> popped up some time ago.
>=20
> I append the output of mdadm --detail as well as mdadm --examine...
>=20
They're all using the same data offset anyway, which is good. You do
need to check the mdadm version though as versions 3.2.4 and above use a
different data offset (as do versions prior to 3.0).

I'd also recommend checking the drives before proceeding - full SMART
tests and read-only badblocks tests on each drive should find any
issues (if there are any then you'll need to get replacements and clone
the old ones).

You'll then need to recreate the array, using exactly the same
parameters as for the original array. From the looks of it, that should
be:
    mdadm -C /dev/md0 -l 6 -e 1.2 -n 8 -c 4096 /dev/sdf1 /dev/sdd1 \
        missing missing /dev/sdi1 /dev/sdc1 /dev/sdb1 missing

One of those "missing" values should be replaced with the drive that
originally was in that slot, but you've not provided that information.
The output from dmesg should show which drives failed when, and where
they were in the array. If your rebuild was using the drives in the same
order as they were before the first failure then any drive will be okay
to use as they should all have the correct information (though you'd be
better avoiding the one with the read error), otherwise you'll have to
use the last one that failed.

Of course, the easiest option would be to start from scratch, test all
the drives, create a new array, and restore the data from backup. I'm
guessing you don't have a backup though.

Good luck,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--z6Eq5LdranGa6ru8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlDJpWQACgkQShxCyD40xBInzACg23CxO8rpIsn2NOq1tQSriOGD
oewAnisZOwwl5Vsv11QKP1Orwc8llLfQ
=EfaL
-----END PGP SIGNATURE-----

--z6Eq5LdranGa6ru8--
