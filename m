From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  Online resize
Date: Tue, 11 Mar 2008 14:58:32 +0000
Message-ID: <20080311145832.GC2086@cthulhu.home.robinhill.me.uk>
References: <200803111119.56015.wayne@flashmedia.co.za> <20080311111219.GA2086@cthulhu.home.robinhill.me.uk> <200803111444.17502.wayne@flashmedia.co.za>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200803111444.17502.wayne@flashmedia.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Mar 11, 2008 at 02:44:17PM +0200, Wayne Gemmell wrote:

> Well that didn't go so well
>=20
> On Tuesday 11 March 2008 13:12:19 Robin Hill wrote:
> > =A02) Force the OS to be aware of the new partition sizes - either a
> > =A0 =A0 reboot or using partprobe.
> > =A03) Grow the array (mdadm --grow) - check the manual page for details.
> I ran partprobe and then mdadm --grow --size=3Dmax /dev/md4 and nothing=
=20
> happened. Then I decided to reboot thinking that partprobe hadn't picked =
up=20
> that change and now it says that sda6 doesn't have a superblock. Any idea=
s=20
> what went wrong?
>=20
What version metadata are you using?  I'm not sure how 1.0 will handle
partition resizes but any other should certainly be okay.  Have you
tried running mdadm -E on each of the component partitions?  I assume
the new partitions are starting from the same position as the old ones?

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFH1p4XShxCyD40xBIRArvpAKCZcOLjE7TF8aQ1WjwQi8JvffhhRACeOcv4
sk0Hh0t9s+hQbFDCPsjeTAQ=
=xPS3
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
