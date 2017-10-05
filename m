From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH] Move mdadm_env.sh out of /usr/lib/systemd
Date: Thu, 05 Oct 2017 17:13:17 +1100
Message-ID: <87poa215s2.fsf@notabene.neil.brown.name>
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


The systemd developers like to keep control of the
lib/systemd namespace, and haven't approved of the use
of lib/systemd/scripts.  So we should stop using it.

Move the mdadm_env.sh script, optionally sourced by
mdmonitor.service, to a new directory /usr/lib/mdadm.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 Makefile                  | 3 ++-
 systemd/mdmonitor.service | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 0977f27d3750..188a21801fcc 100644
=2D-- a/Makefile
+++ b/Makefile
@@ -85,6 +85,7 @@ MDMON_DIR =3D $(RUN_DIR)
 # place for autoreplace cookies
 FAILED_SLOTS_DIR =3D $(RUN_DIR)/failed-slots
 SYSTEMD_DIR=3D/lib/systemd/system
+LIB_DIR=3D/usr/libexec/mdadm
=20
 COROSYNC:=3D$(shell [ -d /usr/include/corosync ] || echo -DNO_COROSYNC)
 DLM:=3D$(shell [ -f /usr/include/libdlm.h ] || echo -DNO_DLM)
@@ -280,7 +281,7 @@ install-systemd: systemd/mdmon@.service
 	   $(INSTALL) -D -m 755  .install.tmp.3 $(DESTDIR)$(SYSTEMD_DIR)-shutdown=
/$$file ; \
 	   rm -f .install.tmp.3; \
 	done
=2D	if [ -f /etc/SuSE-release -o -n "$(SUSE)" ] ;then $(INSTALL) -D -m 755 =
systemd/SUSE-mdadm_env.sh $(DESTDIR)$(SYSTEMD_DIR)/../scripts/mdadm_env.sh =
;fi
+	if [ -f /etc/SuSE-release -o -n "$(SUSE)" ] ;then $(INSTALL) -D -m 755 sy=
stemd/SUSE-mdadm_env.sh $(DESTDIR)$(LIB_DIR)/mdadm_env.sh ;fi
=20
 uninstall:
 	rm -f $(DESTDIR)$(MAN8DIR)/mdadm.8 $(DESTDIR)$(MAN8DIR)/mdmon.8 $(DESTDIR=
)$(MAN4DIR)/md.4 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5 $(DESTDIR)$(BINDIR)/mdadm
diff --git a/systemd/mdmonitor.service b/systemd/mdmonitor.service
index c7cff3e497ec..46f7b8801354 100644
=2D-- a/systemd/mdmonitor.service
+++ b/systemd/mdmonitor.service
@@ -12,5 +12,5 @@ DefaultDependencies=3Dno
 [Service]
 Environment=3D  MDADM_MONITOR_ARGS=3D--scan
 EnvironmentFile=3D-/run/sysconfig/mdadm
=2DExecStartPre=3D-/usr/lib/systemd/scripts/mdadm_env.sh
+ExecStartPre=3D-/usr/lib/mdadm/mdadm_env.sh
 ExecStart=3DBINDIR/mdadm --monitor $MDADM_MONITOR_ARGS
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnVzX0ACgkQOeye3VZi
gbltYxAAhX75l3Bgcjm4dPen1ymTYtKzKUE7+GjdIgPiy94b0Xvtq0BQos19xbhy
BrpEZ1vuMI+IHybRB/1na05wp+vIEc7ggNzYJxakuK+8VkPk1i52yaVCDfwL6sCp
71evCQRmkry3gEooj1cEixe9kIRSlnG+M8nJk9dsNLfAGH5zYwRK/bXKb+GahUzR
mMQbaRCShbjSvVvP9Kf0nJDE54os1BlfYOBPm2TgHCjG+0Bg/YxrABnaAiQxh8Oo
2tITwzD0WZTmu0jtNPlfo1l3dVCZpwbD5GHe9pbqsYCCkRKmE/xwi2pqzCF0AXhC
S4lgGCleSo/5yF8F8STeXlbZoMHSmcvqo5DwkNIerfU5skVGBB0N3RoVqkpfs9Yh
3mL4W4FjJ6Y+uxt+4z6L2CLzqBtUjVj9QXz5lIsCWHSKiswpGoWC/BCRw261rrAh
JFlOpoK2WDa9c28fVJj5sEOB5f5YQipv5MyVQPiKFJkmOVbUs8cLn6nDRy8h8tje
Mf6/pU0t7fpDAfS0bETZ8HhB0Ly2zPCCzdO8CyAl/gD7qiYmQS95JP4746IB7aL9
DXd9b8UleIoVeobIFPysAUqIr3oLghurv3z3lTd1fr35+gZKH3P9eWmgt6jMVlyY
y/3HIoZ+3Pt1HfLdnXMeSK5rqAiQuDhwjecEnXf7jvT3PtcbxTw=
=79rh
-----END PGP SIGNATURE-----
--=-=-=--
