From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raid-5 initiated as raid-4?
Date: Thu, 7 Feb 2013 17:53:28 +0000
Message-ID: <20130207175328.GA5391@cthulhu.home.robinhill.me.uk>
References: <4216250.12.1360256939673.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4216250.12.1360256939673.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Feb 07, 2013 at 06:08:59 +0100, Roy Sigurd Karlsbakk wrote:

> Hi all
>=20
> I have a test vm on which I do some testing of md raid. Just tried
>=20
> root@raidtest:~# mdadm --create /dev/md0 --level=3D5 --raid-devices=3D3 /=
dev/vd{b..d}
> (wait a bit)
> root@raidtest:~# cat /proc/mdstat=20
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [rai=
d4] [raid10]=20
> md0 : active raid5 vdf[5](S) vde[4](S) vdd[3] vdc[1] vdb[0]
>       4191232 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UU=
U]
>=20
Where did vde & vdf spring from? They weren't in your create command -
did you add those as spares later?

> ok, raid's up, but checking the data actually stored on disk on the host =
system shows:
>=20
> root@smilla:/raid/libvirt/images# ls -l raidtest-{1..3}.qcow2
> -rw-r--r-- 1 libvirt-qemu kvm     393216 Feb  7 18:06 raidtest-1.qcow2
> -rw-r--r-- 1 libvirt-qemu kvm     393216 Feb  7 18:06 raidtest-2.qcow2
> -rw-r--r-- 1 libvirt-qemu kvm 2146500608 Feb  7 18:06 raidtest-3.qcow2
>=20
> Does this mean the raid-5 is actually initiated as a raid-4?
>=20
RAID-5 is always created with n-1 disks, with the final disk being
recovered afterwards. It's quicker to do a linear read from the other
disks and a linear write onto the final disk (creating parity or
rebuilding the data as needed) than it is to intersperse reads & writes
on all disks and just create the parity data (for RAID5 anyway -
reconstructing the data on a RAID6 from P & Q parity is far more
expensive, so it's quicker to just generate the parity there).

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlET6hgACgkQShxCyD40xBLkMgCfc18kS3oUCD/IxDAQjTKliG8t
LtUAoNs94wIUZWQ9lW0LRDieSjjJGvb6
=0ZP6
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
