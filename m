From: Roman Mamedov <rm@romanrm.ru>
Subject: Unconventional reshape - a success story
Date: Mon, 11 Apr 2011 16:09:46 +0600
Message-ID: <20110411160946.60558225@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Z6inU9k0QaTXT5CyaI9CP8E"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Z6inU9k0QaTXT5CyaI9CP8E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

Thought I'd share this 'trick' (if using the documented functionality can be
called that :).

I needed to upgrade my 3-disk RAID5 to a 5-disk RAID6. Problem is, due to a
lack of free space I needed to do that in stages, i.e. add one drive, gain
additional space in the array, move some data over, then add another drive.

The usual way of doing this perhaps would be to first reshape to a 4-disk
RAID5, and only after that to a 5-disk RAID6.

But I wanted to have this done in just one reshape. So I got the idea to
reshape from a 3-disk RAID5 right to a degraded 5-disk RAID6 (with 4 drives
active and one missing).

On my RAID5 with 3 "active" drives and 1 newly-added "spare" drive I execut=
ed:

  mdadm --grow --level=3D6 --raid-devices=3D5 /dev/md0

And indeed, this worked exactly as intended:=20

/dev/md0:
        Version : 1.2
  Creation Time : Wed Jun  9 12:14:49 2010
     Raid Level : raid6
     Array Size : 3887004672 (3706.94 GiB 3980.29 GB)
  Used Dev Size : 1943502336 (1853.47 GiB 1990.15 GB)
   Raid Devices : 5
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Fri Apr  8 11:52:03 2011
          State : clean, degraded, recovering
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric-6
     Chunk Size : 64K

 Reshape Status : 0% complete
  Delta Devices : 1, (4->5)
     New Layout : left-symmetric

           Name : natsu:0  (local to host natsu)
           UUID : 7f0c87dd:bcd14e11:7624e659:a7701e85
         Events : 35389

    Number   Major   Minor   RaidDevice State
       0       8       35        0      active sync   /dev/sdc3
       1       8       67        1      active sync   /dev/sde3
       3       8       51        2      active sync   /dev/sdd3
       4       8       99        3      spare rebuilding   /dev/sdg3
       4       0        0        4      removed


--=20
With respect,
Roman

--Sig_/Z6inU9k0QaTXT5CyaI9CP8E
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2i02sACgkQTLKSvz+PZwgSrQCfQSdvGl3n2P4upMkf1Qgo6aFa
GL0An2lT0Y5sKe2m6HvSxCy/1B5XDP5S
=6xV/
-----END PGP SIGNATURE-----

--Sig_/Z6inU9k0QaTXT5CyaI9CP8E--
