From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: Failing disk?
Date: Wed, 25 Jun 2003 14:31:11 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030625183111.GF21580@rdlg.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



I'm asking this on the raid list even though it's LVM related for 2
reasons.  It's the best list I know of for this question and because the
LVM in question is disk 0 in a RAID 1 scheme so it's not 100 % off
topic.

I've got an lvm which consists of drive sda and sdbc.  One of the two
disks is complaining about scsi errors.  I get this on the console:

md: lvm-vg2/lvm2 [events: 0000000b]<6>(write) lvm-vg2/lvm2's sb offset:
35618752
 I/O error: dev 08:22, sector 35430824
 I/O error: dev 08:22, sector 35431072
 I/O error: dev 08:22, sector 35431320
 I/O error: dev 08:22, sector 35431568
 I/O error: dev 08:22, sector 35431816
 I/O error: dev 08:22, sector 35432064
 I/O error: dev 08:22, sector 35432312


Am I correct in assuming that the 22 is hex which translates to 34
giving me:
root@performance.tok:~# cat /proc/partitions=20
major minor  #blocks  name

  58     0   35618816 lvm-vg1/lvm1
  58     1   35618816 lvm-vg2/lvm2
   9     0   35618752 md/0
   8     0   17921835 scsi/host0/bus0/target0/lun0/disc
=2E
=2E
=2E
   8    33     104422 scsi/host0/bus0/target2/lun0/part1
   8    34   17816085 scsi/host0/bus0/target2/lun0/part2


Meaning it's partition 2 of disk hdc (host 0 target 2)?

Thoughts?
  Robert




:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | GPG Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.

Diagnosis: witzelsucht

IPv6 =3D robert@ipv6.rdlg.net	http://ipv6.rdlg.net
IPv4 =3D robert@mail.rdlg.net	http://www.rdlg.net

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE++epv8+1vMONE2jsRAkqVAKCG3f49Fu7z9ynd9WwaJCldx28WAwCdF4sk
DpZNAKW0N8jwkjm3IG6Qv4c=
=FFw7
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
