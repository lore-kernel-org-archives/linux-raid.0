From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Re: resync duration ?
Date: Thu, 14 May 2009 13:07:47 -0500
Message-ID: <20090514180747.GA9995@atlantis.cc.ndsu.NoDak.edu>
References: <1308264373.20090514150647@kaneda.iguw.tuwien.ac.at> <20090514135840.GB8862@atlantis.cc.ndsu.NoDak.edu> <4A0C4FAB.3020607@anonymous.org.uk>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A0C4FAB.3020607@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
List-Id: linux-raid.ids


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2009 at 06:06:51PM +0100, John Robinson wrote:
> I think about 160 minutes is reasonable for 750GB, on an otherwise =20
> unloaded box; it's only 70MB/sec off 3 drives and on to 1 newer, faster =
=20
> drive.

I have a similar setup with 4 750G SATA drives.  The box is
failry beefy, with 8 processor cores and a PCI-E SATA controler
(3Ware 9650SE).  For an initial sync, it will take about 315
minutes to complete.

I'm not sure if this is a fair comparison, since Rainer was do a
resync.

md8 : active raid5 sdx1[4] sdw1[2] sdv1[1] sdu1[0]
      2197209600 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
      [>....................]  recovery =3D  1.6% (12015536/732403200) fini=
sh=3D312.3min speed=3D38437K/sec

I'm probably splitting hairs at this point.

Bryan

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFKDF3zlSl3SAlkhEcRAjMcAJ45lZAMmYa1/b/NgSiFIZEvMkOVwgCgu8wF
dAb1wdfDL8/+lZ+/NRUjSyg=
=ef5z
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
