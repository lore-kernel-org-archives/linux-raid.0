From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Fri, 2 Oct 2009 08:54:42 +0100
Message-ID: <20091002075442.GA13523@cthulhu.home.robinhill.me.uk>
References: <babafd2f0910011827l2bc62facpc5fe15ab3994b512@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <babafd2f0910011827l2bc62facpc5fe15ab3994b512@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Oct 01, 2009 at 06:27:57PM -0700, Ben DJ wrote:

> (2) As far as I can tell, none of the installers in Centos, Ubuntu or
> Opensuse are RAID-10 aware.  Seems like the sanest way to get setup
> would be to boot from SystemRescueCD, do the partitioning and RAID
> creation, then re-boot from an installer disk using the pre-setup
> disks.
>=20
> Am I missing some other, simpler approach?
>=20
With OpenSUSE you can just switch to the second console at that point of
the install and do the partitioning & RAID setup there (you can in text
mode anyway, I've not used the graphical installer), then you just need
to tell the installer to rescan the partition table and it'll pick up
the new details.

I'm pretty sure CentOS doesn't offer multiple consoles during the
install so a SystemRescueCD/LiveCD will be needed there.  I've never
used Ubuntu so I've no idea what it offers.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrFscAACgkQShxCyD40xBKGnACfcAsOZhc/9lslZOJr+evBAu4q
o2sAn2q1EdsiF3ida+q92EtpCpC+tIIx
=0MIY
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
