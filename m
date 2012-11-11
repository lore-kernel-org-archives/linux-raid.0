From: Mike Frysinger <vapier@gentoo.org>
Subject: mdadm: ARRAY <ignore> lines not correctly handled
Date: Sun, 11 Nov 2012 03:42:35 -0500
Message-ID: <201211110342.36095.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1902524.5rR6fm1JAN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--nextPart1902524.5rR6fm1JAN
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

the mdadm.conf man page states:
The ARRAY lines identify actual arrays.  The second word on the line may be=
=20
the name of the device where the array is normally assembled, [...]. =20
Alternately the word <ignore> (complete with angle brackets) can be given i=
n=20
which case any array which matches the rest of the line will never be=20
automatically assembled.

so let's say i have a raid that looks like:
/dev/md0:
        Version : 1.2
  Creation Time : Wed Oct 31 16:05:49 2012
     Raid Level : raid6
     Array Size : 1953522688 (1863.02 GiB 2000.41 GB)
  Used Dev Size : 976761344 (931.51 GiB 1000.20 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Sun Nov 11 03:35:26 2012
          State : clean=20
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : vapier:0  (local to host vapier)
           UUID : 51b812dc:094ea54b:f8f7b331:9982b16c
         Events : 112048

    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc
       1       8        0        1      active sync   /dev/sda
       4       8       16        2      active sync   /dev/sdb
       5       8       64        3      active sync   /dev/sde

the man page says i should be able to prevent this from being auto-assemble=
d=20
via `mdamd -As` by doing something like:
ARRAY <ignore> uuid=3D51b812dc:094ea54b:f8f7b331:9982b16c

or perhaps:
DEVICE /dev/sd[abce]
ARRAY <ignore> devices=3D/dev/sda,/dev/sdb,/dev/sde,/dev/sdc

unfortunately, this turns out to not be the case.  mdadm goes ahead and aut=
o-
assembles things anyways.  looking at the code, it seems that it's due to t=
he=20
code falling back if nothing was detected:
mdadm.c
=2E..
    do {
        failures =3D 0;
        successes =3D 0;
        rv =3D 0;
        for (a =3D array_list; a ; a =3D a->next) {
            int r;
            if (a->assembled)
                continue;
            if (a->devname &&  =20
                strcasecmp(a->devname, "<ignore>") =3D=3D 0)
                continue;

            r =3D Assemble(ss, a->devname,
                     a, NULL, c);
            if (r =3D=3D 0) {
                a->assembled =3D 1;
                successes++;
            } else
                failures++;
            rv |=3D r;
            cnt++;
        }
    } while (failures && successes);
    if (c->homehost && cnt =3D=3D 0) {
        /* Maybe we can auto-assemble something.
         * Repeatedly call Assemble in auto-assemble mode
         * until it fails
         */
        int rv2;
        int acnt;
        ident->autof =3D c->autof;
        do {
            struct mddev_dev *devlist =3D conf_get_devs();
            acnt =3D 0;
            do {
                rv2 =3D Assemble(ss, NULL,
                           ident,
                           devlist, c);
=2E..

the idea is to be able to have a system with multiple raids (some of which =
are=20
dormant/backups), blacklist the ones that you want to keep idle, and bring=
=20
online all the rest.
=2Dmike

--nextPart1902524.5rR6fm1JAN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQn2T8AAoJEEFjO5/oN/WBJjsQANGy6kxLQP+EerDRHX/EdlIg
av4kVfx10NrN07Xoa3FoPE+iJxyTjV4+wu/b5bPncEiq/jnroPSnQGpakAW41XxZ
qH5lKyzdEvwte4IwuNFzcMxEMMbG/+OtnwoGsWj9KfgtvF8OUpR+oJldSj8HOt6A
2D9aqsULXG6UBVM8l4biS9BtarrqwdFDpK5nr3aV611WnETzT9j+zEReX3VoU2xT
mAXmeqb9KnvUcgwBRcVhvQoo/601IQHTbUlk+XCnHoGj++uaOGKrv7UIncvUwSLw
OM0w4NxIwJfXiHQ0oqvVugkIpKvpnQwnF/aAdKuTMTKeMHZaEtAw3rmTMnagbs0l
iCQf3goPv7UJ2x13X9r9JRyzp/3ZcEZCxyAOaRD1HLoXTYWAWUsZlOS/0hNHUlVx
o3zPhaTl5MCz9KSaJRahQOmkg5yxwFlAsULqGSFzclKkBqIsNCgKYdDZWAVii7aP
GTA5RODdIfTk9MXv0GIdbKJomNnkAYBzuYkM/SrBaAg+2jCpXYaKvAEpbvs/J+FD
F5xMfMEs6j8+9z3dO+wzZQpC0SSLyaIiCoNRmQ2oSA1+K0kz7m5YnlyM+52u8bhk
fAUeymBHtV8xMmsD6sZxv69I4yl05xK7ewBd+oU3eaPv9utgVQ8z4GcBLHSFTqu7
HCXI+/XnO258eblG/1Wo
=/hTh
-----END PGP SIGNATURE-----

--nextPart1902524.5rR6fm1JAN--
