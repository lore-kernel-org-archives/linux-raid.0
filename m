From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH] systemd: add %I to description of mdadm-last-resort services.
Date: Mon, 30 Oct 2017 11:42:15 +1100
Message-ID: <87tvyhbh5k.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>, Andrei Borzenkov <arvidjaar@gmail.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Just like the other template services, include the instance
name (I%) in the description of
 mdadm-last-resort@.service
 mdadm-last-resort@.timer

so that it is clear from the logs which array is affected.

Reported-by: Andrei Borzenkov <arvidjaar@gmail.com>
Link: http://bugzilla.opensuse.org/show_bug.cgi?id=3D1064915
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 systemd/mdadm-last-resort@.service | 2 +-
 systemd/mdadm-last-resort@.timer   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/systemd/mdadm-last-resort@.service b/systemd/mdadm-last-resort=
@.service
index f9d4d12738a3..efeb3f639193 100644
=2D-- a/systemd/mdadm-last-resort@.service
+++ b/systemd/mdadm-last-resort@.service
@@ -1,5 +1,5 @@
 [Unit]
=2DDescription=3DActivate md array even though degraded
+Description=3DActivate md array %I even though degraded
 DefaultDependencies=3Dno
 ConditionPathExists=3D!/sys/devices/virtual/block/%i/md/sync_action
=20
diff --git a/systemd/mdadm-last-resort@.timer b/systemd/mdadm-last-resort@.=
timer
index 52b3f227b05d..45ad223083eb 100644
=2D-- a/systemd/mdadm-last-resort@.timer
+++ b/systemd/mdadm-last-resort@.timer
@@ -1,5 +1,5 @@
 [Unit]
=2DDescription=3DTimer to wait for more drives before activating degraded a=
rray.
+Description=3DTimer to wait for more drives before activating degraded arr=
ay %I.
 DefaultDependencies=3Dno
 Conflicts=3Dsys-devices-virtual-block-%i.device
=20
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAln2dWgACgkQOeye3VZi
gblG7Q//csFFb3Z2huymb24dBHv8arInASZOjQFsN3BsT/ai+UkePEHqy0s4/tBo
OngbMoFeTqnNtwpSXypYW4QXJQAuSy+4AhUoVXMdhqzbMA0pMFp4mt5RyO3rxQ0i
nK9JX8y5BPO3ysTAFlcnTNY+5xe2Ti2peI7+SaEfaEkKeV4b9hJJOoAJ5mCo3tD7
lmZBQ6QxegTZvWNkwQKfNN/RhpyhTchIYiA/A9m/pYsqV9DJ/d4ThL8ZG8D7zRcg
mvsb7DreaP4SbIhQQNfIozZaMHPDCuSJocdadpSYVYV8nBGQSbMlbAyHaJ5oLHdl
i/oUZCziEXKl4g4VZDZ56AN/4E2+9LpfneH5w49g63SjXtwxt1SgxeVk6OFa2tM4
cMrNvdewpZZ1qZMdqoSEtZt2MyrWUzZ0g8Tnrqkz/keHOrhECO1W2pfjN9kKYxb8
RFx+x1A9W3BXMJGpXJvseCN0E/86jnqBB8bnB0dWVxeNsAD2i6+cEUSyFyuBmAFj
3u7sQrmj4bBvJyorneoUa8AHnUjD7NoVC0RH6qvYUilY4a2uy2QSu35iW1us73GN
m9GbfVFnjFtfRbeqg2Dgxgr1gA14LRz6cgZHeduR1fCWalZcxcwFdUljOFfXR4pM
aOOsMEuc7X5DaKWx5Ft5t8rLOvFBTmB9tEL5BF7yrD3Ddsg/4p0=
=u/Ut
-----END PGP SIGNATURE-----
--=-=-=--
