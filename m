From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: mdadm -c magic?
Date: Thu, 20 Feb 2003 11:44:43 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030220164443.GG19609@rdlg.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nHwqXXcoX0o6fKCv"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--nHwqXXcoX0o6fKCv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Situation, I need to get a RAID5 array online ASAP.  It's to be 4 160Gig IDE
drives on a 3ware raid controller.

One hitch, I just lit up the box and started to mess with the disks to
make the array and it seems one disk is having "issues"...  I'm sending
it off for RMA which can take 1-2 weeks easily.

Is it possible to have mdadm make the array and just leave the one spot
open anyway?  I tried a few options:

root@legato-disk5.acs:~# mdadm -C -c 128  -l 5 -p left-asymmetric -n 4 -x 0=
 /dev/md3 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1
mdadm: /dev/sdm1 appears to contain an ext2fs file system
    size=3D480238464K  mtime=3DTue Dec  3 11:11:22 2002
mdadm: /dev/sdm1 appear to be part of a raid array:
    level=3D5 disks=3D4 ctime=3DTue Dec  3 10:48:56 2002
mdadm: /dev/sdo1 appear to be part of a raid array:
    level=3D5 disks=3D4 ctime=3DTue Dec  3 10:48:56 2002
mdadm: Cannot open /dev/sdp1: No such file or directory
mdadm: create aborted
root@legato-disk5.acs:~# mdadm -C -c 128  -l 5 -p left-asymmetric -n 4 -x 0=
 /dev/md3 /dev/sdm1 /dev/sdn1 /dev/sdo1
mdadm: You haven't given enough devices (real or missing) to create this ar=
ray


I figured trying to create it with 3 drives and then adding a 4th would
just make that 4th a spare.  Yes I know it's not very redundant with 3
of 4 drives but atleast I can get it online and start testing with light
data load.  If it fails another disk I won't be any farther behind than
if I just waited...

Robert


:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | PGP Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu=20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.
FYI:
 perl -e 'print $i=3Dpack(c5,(41*2),sqrt(7056),(unpack(c,H)-2),oct(115),10)=
;'


--nHwqXXcoX0o6fKCv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+VQX78+1vMONE2jsRAmwQAJ9qOF6lPJ6vvr8G1t0RTwzJtENoOgCfSxj2
FH5sxCaZwJ3iNfu+DkT3Tp0=
=82hp
-----END PGP SIGNATURE-----

--nHwqXXcoX0o6fKCv--
