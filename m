From: NeilBrown <neilb@suse.com>
Subject: [lvm2 PATCH] Remove special-case for md in 69-dm-lvm-metadata.rules
Date: Wed, 04 Jan 2017 14:30:52 +1100
Message-ID: <87eg0jmrgz.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: lvm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: GuoQing Jiang <gqjiang@suse.com>, Lidong Zhong <lidong.zhong@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


This special casing brings no value.  It appears to attempt to
determine if the array is active yet or not, and to skip
processing if the array has not yet been started.
However, if the array hasn't been started, then "blkid" will
not have been able to read a signature, so:
  ENV{ID_FS_TYPE}!=3D"LVM2_member|LVM1_member", GOTO=3D"lvm_end"
will have caused all this code to be skipped.

Further, this code causes incorrect behaviour in at least one case.
It assumes that the first "add" event should be ignored, as it will be
followed by a "change" event which indicates the array coming on line.
This is consistent with how the kernel sends events, but not always
consistent with how this script sees event.
Specifically: if the initrd has "mdadm" support installed, but not
"lvm2" support, then the initial "add" and "change" events will
happen while the initrd is in charge and this file is not available.
Once the root filesystem is mountd, this file will be available
and "udevadm trigger --action=3Dadd" will be run.
So the first and only event seen by this script for an md device will be
"add", and it will incorrectly ignore it.

It is probable that the special handling for "loop" should be removed as
well, but I have not actually seen that cause a problem, so I'm
leaving it unchanged.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 udev/69-dm-lvm-metad.rules.in | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/udev/69-dm-lvm-metad.rules.in b/udev/69-dm-lvm-metad.rules.in
index bd75fc8efcd5..db213ed67f21 100644
=2D-- a/udev/69-dm-lvm-metad.rules.in
+++ b/udev/69-dm-lvm-metad.rules.in
@@ -50,16 +50,6 @@ KERNEL!=3D"dm-[0-9]*", GOTO=3D"next"
 ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=3D=3D"1", ENV{DM_ACTIVATION}=3D=3D"1", GO=
TO=3D"lvm_scan"
 GOTO=3D"lvm_end"
=20
=2D# MD device:
=2DLABEL=3D"next"
=2DKERNEL!=3D"md[0-9]*", GOTO=3D"next"
=2DIMPORT{db}=3D"LVM_MD_PV_ACTIVATED"
=2DACTION=3D=3D"add", ENV{LVM_MD_PV_ACTIVATED}=3D=3D"1", GOTO=3D"lvm_scan"
=2DACTION=3D=3D"change", ENV{LVM_MD_PV_ACTIVATED}!=3D"1", TEST=3D=3D"md/arr=
ay_state", ENV{LVM_MD_PV_ACTIVATED}=3D"1", GOTO=3D"lvm_scan"
=2DACTION=3D=3D"add", KERNEL=3D=3D"md[0-9]*p[0-9]*", GOTO=3D"lvm_scan"
=2DENV{LVM_MD_PV_ACTIVATED}!=3D"1", ENV{SYSTEMD_READY}=3D"0"
=2DGOTO=3D"lvm_end"
=2D
 # Loop device:
 LABEL=3D"next"
 KERNEL!=3D"loop[0-9]*", GOTO=3D"next"
=2D-=20
2.11.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhsbGwACgkQOeye3VZi
gblj1g//RomkX8Emip5ERtehvabLjJ2tozq0fuvHgaMrxkpmIkoN10xg4r5ojq9l
0v0qmgzUviMNfK6SQ96hWG1TYOVZknYtS8ABLlJEYdPfg3SvyZV5tZlhqpvzD0fr
1Xy2jWNTdbgGWwrXOc6dMAYlJJu2/yPh4LMNHXHY+tVdse5SkhCTBsC5axuwKbZQ
sU9qTzNKisPPJcJ8EJzdHiJMO2Rsf/crTy+ZwT6dq0/R4U1/kUDHsEfTyrMdUOeo
IVPCPxaVSGwEzIxT/N87VlbFkeOj0QD1lyekxUrVL6qw0K1Ab2w/8o++j2wYdR8a
eVBc9XcFAQUuHlQAYKccoh7+Ru5Z1tMOyJ7iVwBXAKKYr6n7GyG6e3vogjlm1ZWF
JNkNzAUTHRn8zztjDd3FDgV59oZGWyi8dXbTBYgGXNRE+PzKk+2jjM1kK9vtTioY
ABoG0/jN170V6ds+0AQHYkli1f5txYpnLpyMbkcIpEPxKkAMFk9N7yLYJV8TbymU
Frw+N+LLo5k0xxi+8PPx8RBn3sYhop3eSkqf8JAuLjyj+xftuzcdsSAeiNBYLxBF
+R/VilOMSVWILNCsG+zz0s1Ow82Vxl7+mzY7A1p0WdHTc+kyrORCdmQiJaU/1MqJ
QLpvIX2hI/9tYx+eTeP/+dMOr6E0K66s/JulKpyO4xYrWMz/ens=
=gVAW
-----END PGP SIGNATURE-----
--=-=-=--
