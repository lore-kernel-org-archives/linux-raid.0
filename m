From: Chris Zimmerman <czimmer@mclaneco.com>
Subject: Perhaps this has been answered before...
Date: 21 Aug 2002 11:18:42 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1029946722.31116.64.camel@zimmerman>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-JXD9Q3m4xn5y+iDnfnM6"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-JXD9Q3m4xn5y+iDnfnM6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I am new to the list, so forgive me if this is a FAQ:=20

I have a Slack system running a patched 2.2.17 kernel with raidtools
0.90 that is running RAID 1 on 2 internal 20 GB IDE drives (one on each
bus).  Periodically, and now happening more frequently, the machine will
partially freeze.  I cannot login into the machine, but the IP address
still answers. =20

Here is my fstab:=20

/dev/md0       swap        swap        defaults   0   0=20
/dev/md1       /        ext2        defaults   1   1=20
/dev/md2       /var        ext2        defaults   1   1=20
/dev/md3       /home        ext2        defaults   1   1=20
none             /dev/pts  devpts     gid=3D5,mode=3D620  0   0=20
none             /proc    proc        defaults   0   0=20


Here is my raidtab:=20

raiddev /dev/md0=20
        raid-level              1=20
        nr-raid-disks           2=20
        nr-spare-disks          0=20
        persistent-superblock   1=20
        chunk-size              4=20

        device                  /dev/hda1=20
        raid-disk               0=20
        device                  /dev/hdb1=20
        raid-disk               1=20
#       failed-disk             1=20
#=20
#=20
raiddev /dev/md1=20
        raid-level              1=20
        nr-raid-disks           2=20
        nr-spare-disks          0=20
        persistent-superblock   1=20
        chunk-size              4=20

        device                  /dev/hda2=20
        raid-disk             0=20
        device                  /dev/hdb2=20
        raid-disk               1=20
#=20
#=20
raiddev /dev/md2=20
        raid-level              1=20
        nr-raid-disks           2=20
        nr-spare-disks          0=20
        persistent-superblock   1=20
        chunk-size              4=20

        device                  /dev/hda3=20
        raid-disk             0=20
        device                  /dev/hdb3=20
        raid-disk               1=20
#=20
#=20
raiddev /dev/md3=20
        raid-level              1=20
        nr-raid-disks           2=20
        nr-spare-disks          0=20
        persistent-superblock   1=20
        chunk-size              4=20

        device                  /dev/hda4=20
        raid-disk             0=20
        device                  /dev/hdb4=20
        raid-disk               1=20

I suspect that "maybe" my swap on md0 is causing the problem, but that
is a guess since I have nothing in the logs up to the time the machine
failed that indicates a problem.  Does anything jump out at you?=20

Chris Zimmerman=20




--=-JXD9Q3m4xn5y+iDnfnM6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQA9Y71h9u4GRRZAJ2YRAiVaAJ4x0X754I4fIO2JuLkNBMvblDg+ZwCeMq77
GshNVkZvY/sd1nUhU98/fuA=
=IjXW
-----END PGP SIGNATURE-----

--=-JXD9Q3m4xn5y+iDnfnM6--
