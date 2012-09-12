From: Roman Mamedov <rm@romanrm.ru>
Subject: Can't reshape RAID1 to RAID5 due to chunk size
Date: Wed, 12 Sep 2012 10:59:56 +0600
Message-ID: <20120912105956.155f5d5e@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/h4xADXx1DEilpAJCtm_TsIH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/h4xADXx1DEilpAJCtm_TsIH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

# mdadm --detail /dev/md1=20
/dev/md1:
        Version : 1.2
  Creation Time : Fri May 27 09:50:54 2011
     Raid Level : raid1
     Array Size : 488372863 (465.75 GiB 500.09 GB)
  Used Dev Size : 488372863 (465.75 GiB 500.09 GB)
   Raid Devices : 2
  Total Devices : 3
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Sep 12 10:54:33 2012
          State : active=20
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

           Name : avdeb:1  (local to host avdeb)
           UUID : e29a222d:e6245302:5ff3f834:ad471a01
         Events : 26

    Number   Major   Minor   RaidDevice State
       0       8       82        0      active sync   /dev/sdf2
       1       8       34        1      active sync   /dev/sdc2

       2       8       50        -      spare   /dev/sdd2

# mdadm --grow /dev/md1 --chunk=3D64K --level=3D5 --raid-devices=3D3
mdadm: New chunk size does not divide component size

-----
Shouldn't mdadm be able to figure out a way to somehow proceed in this case=
? :)
So what if it does not divide, I am increasing the array size by 33%, it
has plenty of new space, why not leave a bit of it in the end of all device=
s so
the chunk size does divide...
Also I heard of cases (on #linux-raid IRC, I think) when people reshaped li=
ke
this without specifying the chunk size explicitly, and ended up with someth=
ing
like a 4K chunk, which is certainly less than optimal.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/h4xADXx1DEilpAJCtm_TsIH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBQFswACgkQTLKSvz+PZwg9fQCcDw2r5j5BN5fs3OIMTlqmXbWf
PZAAnj57NRcEs+BEYjW5d64A60j3vqnE
=FMKx
-----END PGP SIGNATURE-----

--Sig_/h4xADXx1DEilpAJCtm_TsIH--
