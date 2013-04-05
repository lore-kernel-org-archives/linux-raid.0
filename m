From: Robin Hill <robin@robinhill.me.uk>
Subject: Bug#700975: RAID barely usable on my home machine
Date: Fri, 5 Apr 2013 09:23:47 +0100
Message-ID: <20130405082347.GA32145@cthulhu.home.robinhill.me.uk>
References: <CAO=zWDLfnBJBFgm4H67XEqsKPP=+Ayk3Jd4OUdEfmLXsvNGdog@mail.gmail.com>
Reply-To: Robin Hill <robin@robinhill.me.uk>, 700975@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.700975.B700975.136515024117082@bugs.debian.org>
Content-Disposition: inline
In-Reply-To: <CAO=zWDLfnBJBFgm4H67XEqsKPP=+Ayk3Jd4OUdEfmLXsvNGdog@mail.gmail.com>
List-URL: <http://lists.debian.org/debian-bugs-dist/>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Maik Zumstrull <maik@zumstrull.net>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, 700975@bugs.debian.org
List-Id: linux-raid.ids


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Apr 04, 2013 at 10:13:05 +0200, Maik Zumstrull wrote:

> Hello Linux RAID and ATA people,
>=20
> I've managed to find a configuration on my home desktop where a
> particular RAID array is barely usable.
>=20
> You can find my initial report at:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D700975
>=20
> In summary:
>=20
> - I create an array across four disks on a Marvell AHCI controller,
> which automatically goes into rebuild mode.
> - Somebody (e.g. smartd or udisks2 or me, testing) sends a SMART
> command to one of the disks.
> - The SMART command fails.
> - The ATA subsystems freaks out all over the place, until eventually
> none of the disks on that controller are responsive.
> - The array is dead until reboot. (Curiously, without data loss so
> far. Kudos on the RAID code, I guess.)
>=20
> I've found the issue to be highly reproducible so far. Things mostly
> work if the array is not under heavy load (not rebuilding, no big file
> copies going on) or I make completely sure nothing sends SMART
> commands. I currently do keep real files on that array, but backed-up
> ones, so I could wipe it for more tests if really necessary.
>=20
I used to have the same issues on one of my machines. The solution was
to buy a decent SAS/SATA HBA (I went with the Intel RS2WC080, but see
http://blog.zorinaq.com/?e=3D10 for a more complete list), which now works
perfectly with exactly the same drives as before.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlFeihMACgkQShxCyD40xBKJOgCgywxQlaKz6If4kMXzWtsCfRAD
O4AAnRIBHcsK/HHAWpdF08a6eC36hH3U
=ry+b
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
