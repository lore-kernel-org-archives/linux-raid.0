From: NeilBrown <neilb@suse.com>
Subject: [PATCH] percpu-refcount: support synchronous switch to atomic mode.
Date: Wed, 22 Mar 2017 12:50:12 +1100
Message-ID: <87o9wuaxm3.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


percpu_ref_switch_to_atomic_sync() schedules the switch
to atomic mode, then waits for it to complete.

Also export percpu_ref_switch_to_* so they can be used from modules.

This will be used in md/raid to count the number of pending write
requests to an array.
We occasionally need to check if the count is zero, but most often
we don't care.
We always want updates to the counter to be fast, as in some cases
we count every 4K page.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 include/linux/percpu-refcount.h |  1 +
 lib/percpu-refcount.c           | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcoun=
t.h
index 3a481a49546e..c13dceb87b60 100644
=2D-- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -99,6 +99,7 @@ int __must_check percpu_ref_init(struct percpu_ref *ref,
 void percpu_ref_exit(struct percpu_ref *ref);
 void percpu_ref_switch_to_atomic(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_switch);
+void percpu_ref_switch_to_atomic_sync(struct percpu_ref *ref);
 void percpu_ref_switch_to_percpu(struct percpu_ref *ref);
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill);
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 9ac959ef4cae..d133ed43a375 100644
=2D-- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -260,6 +260,23 @@ void percpu_ref_switch_to_atomic(struct percpu_ref *re=
f,
=20
 	spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
 }
+EXPORT_SYMBOL_GPL(percpu_ref_switch_to_atomic);
+
+/**
+ * percpu_ref_switch_to_atomic_sync - switch a percpu_ref to atomic mode
+ * @ref: percpu_ref to switch to atomic mode
+ *
+ * Schedule switching the ref to atomic mode, and wait for the
+ * switch to complete.  Caller must ensure that no other thread
+ * will switch back to percpu mode.
+ *
+ */
+void percpu_ref_switch_to_atomic_sync(struct percpu_ref *ref)
+{
+	percpu_ref_switch_to_atomic(ref, NULL);
+	wait_event(percpu_ref_switch_waitq, !ref->confirm_switch);
+}
+EXPORT_SYMBOL_GPL(percpu_ref_switch_to_atomic_sync);
=20
 /**
  * percpu_ref_switch_to_percpu - switch a percpu_ref to percpu mode
@@ -290,6 +307,7 @@ void percpu_ref_switch_to_percpu(struct percpu_ref *ref)
=20
 	spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
 }
+EXPORT_SYMBOL_GPL(percpu_ref_switch_to_percpu);
=20
 /**
  * percpu_ref_kill_and_confirm - drop the initial ref and schedule confirm=
ation
=2D-=20
2.12.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljR2FQACgkQOeye3VZi
gbnmtw//afH6KDwCOw0ZvtPEK0xycKGyR978tiXgOUauhkzFMf4QToYz/RWxt97T
xWbu/sLVVJ35qF2PVfZjesI1XQ010thlPi28oofIP2xpu65v9LKl5WYl8gqj3o05
97W9MR+i/13HOTwpqYQ2a0yDsV4R56f4IDBFJZ1y4hmJEk/3bW0idNer8dxQt7T5
O+DQMeFgOWNfkZksMVkZhmOrUrvHCbS3OVPNNz3yhfoz8NW3CinZ/TQbwYBfb2XX
AqAPHVKgvUtGICIKJv9+Akt9UXOo9k2TjsKS5KUw4McNwgb9QMdGq4K/Dh/LGN2G
K0onKdCtj6OYKWw35W6fn1t44yCesGAUoCnyZ1JAEVsU3B47mlNICIsjB1oHzpRp
ZcW7q01WvW7W8WGZJ+rOtwqoyzBSI9j3QzXQnlN851vy7jZLSxRSjh8Ow3dkSYBJ
0cOWyhITjzDOBNo39YbGUYJvhi/chHVbvQSK/lVTPM02OkeZQKwWEXZ0xDvJgEvl
FzTxebzSGhlo9mjZxSVWHCdFqYMKzs1IQ/KQ4LFaQZW23zTO+XYc4zefIsRiRT9C
hCj+RbtH6XojNKHlVOlVUiUScPPZhALbVB6d7dclmPHblzZ52RVgUP8+TvDf8fw8
SpZAFkkf72mOGTpVOkb7wOE13EB+Bf+URGCNzOEjlBuQaqvSXX0=
=G8yi
-----END PGP SIGNATURE-----
--=-=-=--
