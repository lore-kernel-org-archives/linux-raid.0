From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH 1/2] mdcheck: add some logging.
Date: Fri, 06 Oct 2017 12:33:36 +1100
Message-ID: <87h8vd12mn.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Use 'logger' to report when mdcheck starts, stops, or continues
the check on an array.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 misc/mdcheck | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/misc/mdcheck b/misc/mdcheck
index 2c8f54d6e4cf..589d038eed9b 100644
=2D-- a/misc/mdcheck
+++ b/misc/mdcheck
@@ -1,6 +1,6 @@
 #!/bin/bash
=20
=2D# Copyright (C) 2014 Neil Brown <neilb@suse.de>
+# Copyright (C) 2014-2017 Neil Brown <neilb@suse.de>
 #
 #
 #    This program is free software; you can redistribute it and/or modify
@@ -14,7 +14,7 @@
 #    GNU General Public License for more details.
 #
 #    Author: Neil Brown
=2D#    Email: <neilb@suse.de>
+#    Email: <neilb@suse.com>
=20
 # This script should be run periodically to automatically
 # perform a 'check' on any md arrays.
@@ -94,17 +94,20 @@ do
 	if [ -z "$cont" ]
 	then
 		start=3D0
+		logger -p daemon.info mdcheck start checking $dev
 	elif [ -z "$MD_UUID" -o ! -f "$fl" ]
 	then
 		# Nothing to continue here
 		continue
 	else
 		start=3D`cat "$fl"`
+		logger -p daemon.info mdcheck continue checking $dev from $start
 	fi
=20
 	cnt=3D$[cnt+1]
 	eval MD_${cnt}_fl=3D\$fl
 	eval MD_${cnt}_sys=3D\$sys
+	eval MD_${cnt}_dev=3D\$dev
 	echo $start > $fl
 	echo $start > $sys/md/sync_min
 	echo check > $sys/md/sync_action
@@ -145,6 +148,7 @@ for i in `eval echo {1..$cnt}`
 do
 	eval fl=3D\$MD_${i}_fl
 	eval sys=3D\$MD_${i}_sys
+	eval dev=3D\$MD_${i}_dev
=20
 	if [ -z "$fl" ]; then continue; fi
=20
@@ -156,4 +160,5 @@ do
 	fi
 	echo idle > $sys/md/sync_action
 	cat $sys/md/sync_min > $fl
+	logger -p daemon.info pause checking $dev at `cat $fl`
 done
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnW3XIACgkQOeye3VZi
gbkEhxAAouG3foPORyx+0CYwrdlI2yOmEVjsm6zjMwiYqA7BxcL2lAzr7FYcWO4E
I4wS5C0zN40B47SCceruKzD8vJWWs+Z0skJ6C7Loh0NrQaNDpVRXaCzTzFgero70
Y39UFTcdJ2Kjb1gR5+l2i2YacYsuVeRBjO2sevkRnn6vSUICuuoLtm/mbxefDxkh
2ju10BlzK56M1Y59l4HJhHQMUf6DgJW4guG5pxF9EAJGPphI96nbjqfsmv8sy6z5
hCj6rq4Zp8gZHvxyHuXe93bFQy2+erl8Hmi66384YPI+Ubx6u6LveGn9LE36hHIg
uNJLGCZQBiIVRaDuYhP10QEkGiN2kXpAFCG+wl3Cu11nrSPgBdCo+jfkX4fOC9Fh
RGEib7KVJRho0d4+EuPXIImLveoBwxRIz06RIea1Jz6F04XWq0EZkOEcSTq+WPC3
wjT56lXXN+p4duEUzjHW2/3meP+mAAQnkt3NuBAP3sRvgZmnGr53f2n4ng5mj6gi
hTd9b91ugXu7O4lm0qYYB28YPPJsffxRRn7gBBr1tW463cPAXKNTWGeMl1HPxYCz
CM3pzyvqSew9RgqaeY91xk9PsTPuuJe3T55Or4vK26xVK6RY/igUmLGouA6Z90DA
SG2ol9ICRyC3Py+/CQgHz7cJlGp9f2xY961O4pTXffnXs+l4m1w=
=/aVF
-----END PGP SIGNATURE-----
--=-=-=--
