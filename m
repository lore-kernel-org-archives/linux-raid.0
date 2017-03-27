From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH] udev-md-raid-assembly.rules: Skip non-ready devices
Date: Mon, 27 Mar 2017 11:15:44 +1100
Message-ID: <87fuhz8thr.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


From: Hannes Reinecke <hare@suse.de>

If a device isn't fully initialized (e.g if it should be
handled by multipathing) it should not be considered for
md/RAID auto-assembly.  Doing so can cause incorrect results
such as causing multipath to fail during startup.

There is a convention that the udev environment variable
SYSTEMD_READY be set to zero for such devices.  So change
the mdadm rules to ignore devices with SYSTEMD_READY=3D=3D0.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 udev-md-raid-assembly.rules | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
index d0d440a6394c..8ca232a44b1f 100644
=2D-- a/udev-md-raid-assembly.rules
+++ b/udev-md-raid-assembly.rules
@@ -7,6 +7,9 @@ ENV{ANACONDA}=3D=3D"?*", GOTO=3D"md_inc_end"
=20
 SUBSYSTEM!=3D"block", GOTO=3D"md_inc_end"
=20
+# skip non-initialized devices
+ENV{SYSTEMD_READY}=3D=3D"0", GOTO=3D"md_inc_end"
+
 # handle potential components of arrays (the ones supported by md)
 ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", GOTO=3D"md_inc"
=20
=2D-=20
2.12.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljYWbEACgkQOeye3VZi
gbkQqBAAqxhIZUbb5igGK1uRI0KL03G9VYJcKBzn+928nfq+Ua5hmeyfrNizVEWp
7CO3GCTK3DocZeZu/23PPj6eUfhjpT8W0c5zO2+T2LOK128DwwzRsZskdrnzjfwL
Jl//I4SCuFI4/w6L7Vr2SSfYDieSjw7UwSRlocU4vt/gkmd+1oU4slqv+Gped3vP
dKvVZ0wjATaM1sTxPNzQhNxfm71Of4OAikKNEXK9aVv46TAk1/1KRHUByHqujNd9
wjolrrq4fhjhl+vFVRQ5lxXHrRpF0w2f2FlqxL6HcxnAJbzsl9Am6SnNwSYDJ95v
Q96riCC2cvpufRhKatkqAbZnts0lTjtDr9xhOAtN2Edyp1A87gW5u491fFmEr5h8
yQM6JYpcSsfd5X0RjjdFSzY4pym4g+12FuXuVDVAvRjXmG80uJj+NzwbB4v7D+m8
9z7EqIInIB1VCrEUoxELu1jMdmxXNDCWh/+qw6TdoLzU9FbIWgceoPDRj9PquKj9
F7aYmfTIukY1B5Ttc8TtOrdjCoeCTc1+dsDD8ty+5NzXPfTiD88DsoV3xP40jCSz
O2qJ8iZKgz48fSn9UzKOQLpMGBY5bOYkSCAjgu1dCU/ZAPFpdal+Y0wo9YcrHJwa
1nOtS5mwoPW0SronzE4T4p3EImLe3Vyw+R6Os0T7Ppr1t5AAyI4=
=wsoN
-----END PGP SIGNATURE-----
--=-=-=--
