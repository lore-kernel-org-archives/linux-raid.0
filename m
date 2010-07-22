From: Justin Bronder <jsbronder@gentoo.org>
Subject: Re: Raid10 device hangs during resync and heavy I/O.
Date: Thu, 22 Jul 2010 14:49:33 -0400
Message-ID: <20100722184933.GA22647@gmail.com>
References: <20100716184618.GA25890@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100716184618.GA25890@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16/07/10 14:46 -0400, Justin Bronder wrote:
> I've been able to reproduce this across a number of machines with the same
> hardware configuration.  During a raid10 resync, it's possible to hang the
> device so that any further I/O operations will also block.  This can be
> fairly simply done using dd. =20
>=20
> Interestingly, this is not reproducible when using a non-partitioned devi=
ce.
> That is, creating the device with --auto=3Dyes and then directly using it
> functions as expected.  However, using --auto=3Dyes or --auto=3Dmdp and t=
hen
> creating a partition across the device will cause the hang.
>=20

I've done some more research that may potentially help. All of
the following was done with 2.6.34.1.

Still produces the hang:
    - Using cp (may take a bit longer).
    - Using jfs as the filesystem.
    - Dropping RESYNC_DEPTH to 32
    - Using the offset layout.

Does not produce the hang:
    - Using the near layout.
    - Using dd on the partition directly instead of on a
      filesystem via something like:
      dd if=3D/dev/${MD_DEV}p1 of=3D/dev/${MD_DEV}p1 seek=3D4001 bs=3D1M


As the barrier code is very similiar, I repeated a number of
these tests using raid1 instead of raid10.  In every case, I was
unable to cause the system to hang.  I focused on the barriers
due to the tracebacks in the previous email.  For the heck of it,
I added some tracing (patch below) where the reason for the hang
is fairly obvious.  Of course, how it happened isn't.

The last bit of the trace before the hang.

          <idle>-0     [003]   188.987489: allow_barrier:     swapper - w:2=
 p:1 b:1
          <idle>-0     [003]   188.987495: allow_barrier:     swapper - w:2=
 p:0 b:1
           <...>-4910  [003]   188.987518: raise_barrier: out: md99_resync =
- w:2 p:0 b:1
           <...>-4910  [003]   188.987733: raise_barrier: in:  md99_resync =
- w:2 p:0 b:1
           <...>-4909  [003]   188.988174: lower_barrier:     md99_raid10 -=
 w:2 p:0 b:0
           <...>-4915  [002]   188.988188: wait_barrier: out: flush-9:99 - =
w:1 p:1 b:0
           <...>-4996  [003]   188.988199: wait_barrier: out: dd - w:0 p:2 =
b:0
           <...>-4915  [002]   188.988203: wait_barrier: in:  flush-9:99 - =
w:0 p:2 b:0
           <...>-4915  [002]   188.988204: wait_barrier: out: flush-9:99 - =
w:0 p:3 b:0
           <...>-4915  [002]   188.988208: wait_barrier: in:  flush-9:99 - =
w:0 p:3 b:0
           <...>-4915  [002]   188.988209: wait_barrier: out: flush-9:99 - =
w:0 p:4 b:0
           <...>-4996  [003]   188.988211: wait_barrier: in:  dd - w:0 p:4 =
b:0
           <...>-4996  [003]   188.988211: wait_barrier: out: dd - w:0 p:5 =
b:0
           <...>-4996  [003]   188.988214: wait_barrier: in:  dd - w:0 p:5 =
b:0
           <...>-4996  [003]   188.988214: wait_barrier: out: dd - w:0 p:6 =
b:0
           <...>-4915  [002]   188.988234: wait_barrier: in:  flush-9:99 - =
w:0 p:6 b:0
           <...>-4915  [002]   188.988235: wait_barrier: out: flush-9:99 - =
w:0 p:7 b:0
           <...>-4915  [002]   188.988244: wait_barrier: in:  flush-9:99 - =
w:0 p:7 b:0
           <...>-4915  [002]   188.988244: wait_barrier: out: flush-9:99 - =
w:0 p:8 b:0
           <...>-4915  [002]   188.988248: wait_barrier: in:  flush-9:99 - =
w:0 p:8 b:0
           <...>-4915  [002]   188.988249: wait_barrier: out: flush-9:99 - =
w:0 p:9 b:0
           <...>-4996  [003]   188.988251: wait_barrier: in:  dd - w:0 p:9 =
b:0
           <...>-4996  [003]   188.988252: wait_barrier: out: dd - w:0 p:10=
 b:0
           <...>-4996  [003]   188.988261: wait_barrier: in:  dd - w:0 p:10=
 b:0
           <...>-4996  [003]   188.988262: wait_barrier: out: dd - w:0 p:11=
 b:0
           <...>-4996  [003]   188.988264: wait_barrier: in:  dd - w:0 p:11=
 b:0
           <...>-4996  [003]   188.988264: wait_barrier: out: dd - w:0 p:12=
 b:0
           <...>-4915  [002]   188.988272: wait_barrier: in:  flush-9:99 - =
w:0 p:12 b:0
           <...>-4915  [002]   188.988272: wait_barrier: out: flush-9:99 - =
w:0 p:13 b:0
           <...>-4915  [002]   188.988281: wait_barrier: in:  flush-9:99 - =
w:0 p:13 b:0
           <...>-4915  [002]   188.988281: wait_barrier: out: flush-9:99 - =
w:0 p:14 b:0
           <...>-4996  [003]   188.988282: wait_barrier: in:  dd - w:0 p:14=
 b:0
           <...>-4996  [003]   188.988283: wait_barrier: out: dd - w:0 p:15=
 b:0
           <...>-4915  [002]   188.988285: wait_barrier: in:  flush-9:99 - =
w:0 p:15 b:0
           <...>-4915  [002]   188.988286: wait_barrier: out: flush-9:99 - =
w:0 p:16 b:0
           <...>-4996  [003]   188.988290: wait_barrier: in:  dd - w:0 p:16=
 b:0
           <...>-4996  [003]   188.988290: wait_barrier: out: dd - w:0 p:17=
 b:0
           <...>-4996  [003]   188.988292: wait_barrier: in:  dd - w:0 p:17=
 b:0
           <...>-4996  [003]   188.988293: wait_barrier: out: dd - w:0 p:18=
 b:0
           <...>-4915  [002]   188.988309: wait_barrier: in:  flush-9:99 - =
w:0 p:18 b:0
           <...>-4915  [002]   188.988310: wait_barrier: out: flush-9:99 - =
w:0 p:19 b:0
           <...>-4996  [003]   188.988310: wait_barrier: in:  dd - w:0 p:19=
 b:0
           <...>-4996  [003]   188.988311: wait_barrier: out: dd - w:0 p:20=
 b:0
           <...>-4996  [003]   188.988317: wait_barrier: in:  dd - w:0 p:20=
 b:0
           <...>-4996  [003]   188.988318: wait_barrier: out: dd - w:0 p:21=
 b:0
           <...>-4996  [003]   188.988321: wait_barrier: in:  dd - w:0 p:21=
 b:0
           <...>-4996  [003]   188.988321: wait_barrier: out: dd - w:0 p:22=
 b:0
           <...>-4915  [002]   188.988323: allow_barrier:     flush-9:99 - =
w:0 p:21 b:0
           <...>-4996  [003]   188.988327: wait_barrier: in:  dd - w:0 p:21=
 b:0
           <...>-4996  [003]   188.988328: wait_barrier: out: dd - w:0 p:22=
 b:0
           <...>-4915  [002]   188.988356: wait_barrier: in:  flush-9:99 - =
w:0 p:22 b:0
           <...>-4915  [002]   188.988356: wait_barrier: out: flush-9:99 - =
w:0 p:23 b:0
           <...>-4915  [002]   188.988361: wait_barrier: in:  flush-9:99 - =
w:0 p:23 b:0
           <...>-4915  [002]   188.988361: wait_barrier: out: flush-9:99 - =
w:0 p:24 b:0
           <...>-4910  [003]   188.988370: raise_barrier: mid: md99_resync =
- w:0 p:24 b:1
           <...>-4915  [002]   188.988378: wait_barrier: in:  flush-9:99 - =
w:0 p:24 b:1
           <...>-4996  [003]   188.988638: wait_barrier: in:  dd - w:1 p:24=
 b:1
          <idle>-0     [003]   188.988887: allow_barrier:     swapper - w:2=
 p:23 b:1
          <idle>-0     [003]   188.988895: allow_barrier:     swapper - w:2=
 p:22 b:1
          <idle>-0     [003]   188.988899: allow_barrier:     swapper - w:2=
 p:21 b:1
          <idle>-0     [003]   188.988905: allow_barrier:     swapper - w:2=
 p:20 b:1
          <idle>-0     [003]   188.988909: allow_barrier:     swapper - w:2=
 p:19 b:1
          <idle>-0     [002]   188.996299: allow_barrier:     swapper - w:2=
 p:18 b:1
          <idle>-0     [002]   188.996310: allow_barrier:     swapper - w:2=
 p:17 b:1
          <idle>-0     [002]   188.996317: allow_barrier:     swapper - w:2=
 p:16 b:1
          <idle>-0     [002]   188.996325: allow_barrier:     swapper - w:2=
 p:15 b:1
          <idle>-0     [002]   188.996330: allow_barrier:     swapper - w:2=
 p:14 b:1
          <idle>-0     [002]   188.996336: allow_barrier:     swapper - w:2=
 p:13 b:1
          <idle>-0     [002]   188.996340: allow_barrier:     swapper - w:2=
 p:12 b:1
          <idle>-0     [003]   189.004270: allow_barrier:     swapper - w:2=
 p:11 b:1
          <idle>-0     [003]   189.004278: allow_barrier:     swapper - w:2=
 p:10 b:1
          <idle>-0     [003]   189.004284: allow_barrier:     swapper - w:2=
 p:9 b:1
          <idle>-0     [003]   189.004302: allow_barrier:     swapper - w:2=
 p:8 b:1
          <idle>-0     [003]   189.004313: allow_barrier:     swapper - w:2=
 p:7 b:1
          <idle>-0     [003]   189.004322: allow_barrier:     swapper - w:2=
 p:6 b:1
          <idle>-0     [002]   189.004936: allow_barrier:     swapper - w:2=
 p:5 b:1
          <idle>-0     [002]   189.004959: allow_barrier:     swapper - w:2=
 p:4 b:1
          <idle>-0     [002]   189.004970: allow_barrier:     swapper - w:2=
 p:3 b:1
          <idle>-0     [002]   189.004979: allow_barrier:     swapper - w:2=
 p:2 b:1
          <idle>-0     [002]   189.004996: allow_barrier:     swapper - w:2=
 p:1 b:1
          <idle>-0     [002]   189.005006: allow_barrier:     swapper - w:2=
 p:0 b:1
           <...>-4910  [002]   189.005030: raise_barrier: out: md99_resync =
- w:2 p:0 b:1
           <...>-4910  [002]   189.005251: raise_barrier: in:  md99_resync =
- w:2 p:0 b:1
           <...>-4909  [002]   189.005676: lower_barrier:     md99_raid10 -=
 w:2 p:0 b:0
           <...>-4915  [003]   189.005687: wait_barrier: out: flush-9:99 - =
w:1 p:1 b:0
           <...>-4996  [003]   189.005713: wait_barrier: out: dd - w:0 p:2 =
b:0
           <...>-4910  [002]   189.005715: raise_barrier: mid: md99_resync =
- w:0 p:2 b:1
           <...>-4996  [003]   189.005724: wait_barrier: in:  dd - w:0 p:2 =
b:1
          <idle>-0     [002]   189.012925: allow_barrier:     swapper - w:1=
 p:1 b:1
          <idle>-0     [002]   189.013271: allow_barrier:     swapper - w:1=
 p:0 b:1
           <...>-4910  [002]   189.013295: raise_barrier: out: md99_resync =
- w:1 p:0 b:1
           <...>-4910  [002]   189.013414: raise_barrier: in:  md99_resync =
- w:1 p:0 b:1
           <...>-4909  [002]   189.021171: lower_barrier:     md99_raid10 -=
 w:1 p:0 b:0
           <...>-4996  [003]   189.021179: wait_barrier: out: dd - w:0 p:1 =
b:0
           <...>-4910  [002]   189.021182: raise_barrier: mid: md99_resync =
- w:0 p:1 b:1
           <...>-4996  [003]   189.021184: wait_barrier: in:  dd - w:0 p:1 =
b:1
           <...>-4915  [003]   218.929283: wait_barrier: in:  flush-9:99 - =
w:1 p:1 b:1


diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ad945cc..35ad593 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -22,6 +22,7 @@
 #include <linux/delay.h>
 #include <linux/blkdev.h>
 #include <linux/seq_file.h>
+#include <linux/sched.h>
 #include "md.h"
 #include "raid10.h"
 #include "bitmap.h"
@@ -704,6 +705,9 @@ static void raise_barrier(conf_t *conf, int force)
 	BUG_ON(force && !conf->barrier);
 	spin_lock_irq(&conf->resync_lock);
=20
+    if ( conf->mddev->md_minor =3D=3D 99 )
+        trace_printk("in:  %s - w:%u p:%u b:%u\n", current->comm, conf->nr=
_waiting, conf->nr_pending, conf->barrier);
+
 	/* Wait until no block IO is waiting (unless 'force') */
 	wait_event_lock_irq(conf->wait_barrier, force || !conf->nr_waiting,
 			    conf->resync_lock,
@@ -712,12 +716,18 @@ static void raise_barrier(conf_t *conf, int force)
 	/* block any new IO from starting */
 	conf->barrier++;
=20
+    if ( conf->mddev->md_minor =3D=3D 99 )
+        trace_printk("mid: %s - w:%u p:%u b:%u\n", current->comm, conf->nr=
_waiting, conf->nr_pending, conf->barrier);
+
 	/* No wait for all pending IO to complete */
 	wait_event_lock_irq(conf->wait_barrier,
 			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
 			    conf->resync_lock,
 			    raid10_unplug(conf->mddev->queue));
=20
+    if ( conf->mddev->md_minor =3D=3D 99 )
+        trace_printk("out: %s - w:%u p:%u b:%u\n", current->comm, conf->nr=
_waiting, conf->nr_pending, conf->barrier);
+
 	spin_unlock_irq(&conf->resync_lock);
 }
=20
@@ -726,6 +736,8 @@ static void lower_barrier(conf_t *conf)
 	unsigned long flags;
 	spin_lock_irqsave(&conf->resync_lock, flags);
 	conf->barrier--;
+    if ( conf->mddev->md_minor =3D=3D 99 )
+        trace_printk("    %s - w:%u p:%u b:%u\n", current->comm, conf->nr_=
waiting, conf->nr_pending, conf->barrier);
 	spin_unlock_irqrestore(&conf->resync_lock, flags);
 	wake_up(&conf->wait_barrier);
 }
@@ -733,7 +745,9 @@ static void lower_barrier(conf_t *conf)
 static void wait_barrier(conf_t *conf)
 {
 	spin_lock_irq(&conf->resync_lock);
-	if (conf->barrier) {
+    if ( conf->mddev->md_minor =3D=3D 99 )
+        trace_printk("in:  %s - w:%u p:%u b:%u\n", current->comm, conf->nr=
_waiting, conf->nr_pending, conf->barrier);
+    if (conf->barrier) {
 		conf->nr_waiting++;
 		wait_event_lock_irq(conf->wait_barrier, !conf->barrier,
 				    conf->resync_lock,
@@ -741,6 +755,8 @@ static void wait_barrier(conf_t *conf)
 		conf->nr_waiting--;
 	}
 	conf->nr_pending++;
+    if ( conf->mddev->md_minor =3D=3D 99 )
+        trace_printk("out: %s - w:%u p:%u b:%u\n", current->comm, conf->nr=
_waiting, conf->nr_pending, conf->barrier);
 	spin_unlock_irq(&conf->resync_lock);
 }
=20
@@ -749,6 +765,8 @@ static void allow_barrier(conf_t *conf)
 	unsigned long flags;
 	spin_lock_irqsave(&conf->resync_lock, flags);
 	conf->nr_pending--;
+    if ( conf->mddev->md_minor =3D=3D 99 )
+        trace_printk("    %s - w:%u p:%u b:%u\n", current->comm, conf->nr_=
waiting, conf->nr_pending, conf->barrier);
 	spin_unlock_irqrestore(&conf->resync_lock, flags);
 	wake_up(&conf->wait_barrier);
 }

--=20
Justin Bronder

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEARECAAYFAkxIkr0ACgkQ4MrvBE1wQ8lxSQCghQsDvtHrQWvoqtsitN2RsECL
iygAoJNFWQZCxzsAGCDRurdEhJ8/Pum1
=EWZv
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
