From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: Why is a "init 0" halt not bringing my raid5 up clean?
Date: Thu, 20 Feb 2003 11:25:47 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030220162547.GE19609@rdlg.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



I have a server with 4 RAID5 arrays.  I just went in and did an init0 on
the box to remove the fourth array and replace all 4 disks to create a
new RAID5 array (long story).  When I brought the box back up md0 and
md1 were both showing their 1st disk as faulty.  They were both clean
and error free before the init 0.

This happens a good bit.  Any reason why?


:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | PGP Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu=20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.
FYI:
 perl -e 'print $i=3Dpack(c5,(41*2),sqrt(7056),(unpack(c,H)-2),oct(115),10)=
;'


--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+VQGL8+1vMONE2jsRAng4AKDYzNUwBud+Jvl3mKOVMIig2JifhgCgojF5
I7q4tvxWsmcjglDsLBKKvOs=
=PIwY
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--
