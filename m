From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: Cannot remove failed disk from container
Date: Tue, 3 Jan 2012 11:40:57 +1100
Message-ID: <20120103114057.6de14797@notabene.brown>
References: <20111229132738.5659.99578.stgit@gklab-128-013.igk.intel.com>
	<20120103103104.3f179d73@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d4OGg1I19aIXUV/_jOW3L5+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120103103104.3f179d73@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/d4OGg1I19aIXUV/_jOW3L5+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Jan 2012 10:31:04 +1100 NeilBrown <neilb@suse.de> wrote:

> On Thu, 29 Dec 2011 14:27:38 +0100 Adam Kwolek <adam.kwolek@intel.com> wr=
ote:
>=20
> > When disk is failed by mdadm e.g.:
> >     mdadm -f /dev/md/raid_array /dev/sdX
> > and then it is tried to be removed from container e.g.:
> >     mdadm --remove /dev/md/container /dev/sdX
> >=20
> > mdadm refuses it with information:
> >     mdadm: /dev/sdX is still in use, cannot remove.
> >=20
> > Problem was introduced in commit:
> >     monitor: don't unblock a device that isn't blocked.
> >     /2011-12-06/
> > Disk without unblocking it cannot be really removed from array
> > and reference to if is still reported under 'holders' sysfs entry.
> >=20
> > As this commit is necessary for managing degraded array during
> > reshape and rebuild code for unconditional unblocking disk on removal
> > is added.
> > Guard for setting DS_UNBLOCK during reshape/rebuild avoids process
> > performance degradation.
>=20
> You seem to be addressing the symptom rather than understanding the real
> problem.
>=20
> If a device isn't marked as 'blocked' then it simply doesn't make any sen=
se
> to "unblock" it - that cannot do anything useful.
>=20
> If the commit you identify broke things for you, then we need to understa=
nd
> exactly why.  What exactly is the problem, how was the code previously
> allowing things to work?  What is the minimal thing we need to do to allow
> things to work again?
>=20
> Just setting DS_UNBLOCK because it seems to work but without a clear
> justification isn't acceptable.
>=20

The problem was that when were try to "remove" a device that can fail and t=
he
comment said we assume another event would happen soon which would trigger a
second attempt to remove the device.  That apparently isn't true.

Your patch that caused it to "unblock" again only worked because that
triggered another event immediately - so you were relying on a side-effect.

I have committed the following two patches which fix the problem 'properly'.

Thanks,
NeilBrown

=46rom 77b3ac8c6521d836dd3c6ef247c252293920fd52 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 3 Jan 2012 11:18:59 +1100
Subject: [PATCH 1/2] monitor: make return from read_and_act more symbolic.

Rather than just a number, use a named flag.

This makes the code easier to understand and allows room for returning
more flags later.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 monitor.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/monitor.c b/monitor.c
index 29bde18..cfe4178 100644
--- a/monitor.c
+++ b/monitor.c
@@ -211,6 +211,7 @@ static void signal_manager(void)
  *
  */
=20
+#define ARRAY_DIRTY 1
 static int read_and_act(struct active_array *a)
 {
 	unsigned long long sync_completed;
@@ -218,7 +219,7 @@ static int read_and_act(struct active_array *a)
 	int check_reshape =3D 0;
 	int deactivate =3D 0;
 	struct mdinfo *mdi;
-	int dirty =3D 0;
+	int ret =3D 0;
 	int count =3D 0;
=20
 	a->next_state =3D bad_word;
@@ -254,14 +255,14 @@ static int read_and_act(struct active_array *a)
 	if (a->curr_state =3D=3D write_pending) {
 		a->container->ss->set_array_state(a, 0);
 		a->next_state =3D active;
-		dirty =3D 1;
+		ret |=3D ARRAY_DIRTY;
 	}
 	if (a->curr_state =3D=3D active_idle) {
 		/* Set array to 'clean' FIRST, then mark clean
 		 * in the metadata
 		 */
 		a->next_state =3D clean;
-		dirty =3D 1;
+		ret |=3D ARRAY_DIRTY;
 	}
 	if (a->curr_state =3D=3D clean) {
 		a->container->ss->set_array_state(a, 1);
@@ -269,7 +270,7 @@ static int read_and_act(struct active_array *a)
 	if (a->curr_state =3D=3D active ||
 	    a->curr_state =3D=3D suspended ||
 	    a->curr_state =3D=3D bad_word)
-		dirty =3D 1;
+		ret |=3D ARRAY_DIRTY;
 	if (a->curr_state =3D=3D readonly) {
 		/* Well, I'm ready to handle things.  If readonly
 		 * wasn't requested, transition to read-auto.
@@ -284,7 +285,7 @@ static int read_and_act(struct active_array *a)
 				a->next_state =3D read_auto; /* array is clean */
 			else {
 				a->next_state =3D active; /* Now active for recovery etc */
-				dirty =3D 1;
+				ret |=3D ARRAY_DIRTY;
 			}
 		}
 	}
@@ -459,7 +460,7 @@ static int read_and_act(struct active_array *a)
 	if (deactivate)
 		a->container =3D NULL;
=20
-	return dirty;
+	return ret;
 }
=20
 static struct mdinfo *
@@ -629,7 +630,6 @@ static int wait_and_act(struct supertype *container, in=
t nowait)
 	rv =3D 0;
 	dirty_arrays =3D 0;
 	for (a =3D *aap; a ; a =3D a->next) {
-		int is_dirty;
=20
 		if (a->replaces && !discard_this) {
 			struct active_array **ap;
@@ -644,14 +644,14 @@ static int wait_and_act(struct supertype *container, =
int nowait)
 			signal_manager();
 		}
 		if (a->container && !a->to_remove) {
-			is_dirty =3D read_and_act(a);
+			int ret =3D read_and_act(a);
 			rv |=3D 1;
-			dirty_arrays +=3D is_dirty;
+			dirty_arrays +=3D !!(ret & ARRAY_DIRTY);
 			/* when terminating stop manipulating the array after it
 			 * is clean, but make sure read_and_act() is given a
 			 * chance to handle 'active_idle'
 			 */
-			if (sigterm && !is_dirty)
+			if (sigterm && !(ret & ARRAY_DIRTY))
 				a->container =3D NULL; /* stop touching this array */
 		}
 	}
--=20
1.7.7


=46rom 68226a80812cd9fce63dbd14d2225ffdf16a781b Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 3 Jan 2012 00:36:23 +1100
Subject: [PATCH 2/2] monitor: ensure we retry soon when 'remove' fails.

If a 'remove' fails there is no certainty that another event will
happen soon, so make sure we retry soon anyway.

Reported-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 mdadm.h   |    1 +
 monitor.c |   16 ++++++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 3bcd052..381ef86 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -867,6 +867,7 @@ struct supertype {
 			*  external:/md0/12
 			*/
 	int devcnt;
+	int retry_soon;
=20
 	struct mdinfo *devs;
=20
diff --git a/monitor.c b/monitor.c
index cfe4178..c987d10 100644
--- a/monitor.c
+++ b/monitor.c
@@ -212,6 +212,7 @@ static void signal_manager(void)
  */
=20
 #define ARRAY_DIRTY 1
+#define ARRAY_BUSY 2
 static int read_and_act(struct active_array *a)
 {
 	unsigned long long sync_completed;
@@ -419,9 +420,9 @@ static int read_and_act(struct active_array *a)
 		if ((mdi->next_state & DS_REMOVE) && mdi->state_fd >=3D 0) {
 			int remove_result;
=20
-			/* the kernel may not be able to immediately remove the
-			 * disk, we can simply wait until the next event to try
-			 * again.
+			/* The kernel may not be able to immediately remove the
+			 * disk.  In that case we wait a little while and
+			 * try again.
 			 */
 			remove_result =3D write_attr("remove", mdi->state_fd);
 			if (remove_result > 0) {
@@ -429,7 +430,8 @@ static int read_and_act(struct active_array *a)
 				close(mdi->state_fd);
 				close(mdi->recovery_fd);
 				mdi->state_fd =3D -1;
-			}
+			} else
+				ret |=3D ARRAY_BUSY;
 		}
 		if (mdi->next_state & DS_INSYNC) {
 			write_attr("+in_sync", mdi->state_fd);
@@ -597,7 +599,7 @@ static int wait_and_act(struct supertype *container, in=
t nowait)
 		struct timespec ts;
 		ts.tv_sec =3D 24*3600;
 		ts.tv_nsec =3D 0;
-		if (*aap =3D=3D NULL) {
+		if (*aap =3D=3D NULL || container->retry_soon) {
 			/* just waiting to get O_EXCL access */
 			ts.tv_sec =3D 0;
 			ts.tv_nsec =3D 20000000ULL;
@@ -612,7 +614,7 @@ static int wait_and_act(struct supertype *container, in=
t nowait)
 		#ifdef DEBUG
 		dprint_wake_reasons(&rfds);
 		#endif
-
+		container->retry_soon =3D 0;
 	}
=20
 	if (update_queue) {
@@ -653,6 +655,8 @@ static int wait_and_act(struct supertype *container, in=
t nowait)
 			 */
 			if (sigterm && !(ret & ARRAY_DIRTY))
 				a->container =3D NULL; /* stop touching this array */
+			if (ret & ARRAY_BUSY)
+				container->retry_soon =3D 1;
 		}
 	}
=20
--=20
1.7.7




--Sig_/d4OGg1I19aIXUV/_jOW3L5+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwJOmTnsnt1WYoG5AQLpjBAAtEpl88q9QRNHBQz61Lyqfi6f+9suDrlF
6jDpK+2J5XzhO6KwgRGgnXZnnylUu8uvQGhkccXSB4twDjQKgd1/DnktvYOeC7yI
qndZrR1IfsubfZMIO0U2Hqu5iQy2pd4IZW7DDSou55NOgK2G/LqdQwIVAODCqQn2
j3KpZV7Awr+s1F29FfCFUBnANTaCM38kvXIQA8IdgM0/QmT2ywOYcR09DanvBfox
qL6lTubgu84d9Wx/joZmkhSIa1yMA5MGlqYsSJRFIaOHjcCgCwgh5JCbWVa0iOR2
WxHqVYIn5IgoBi7mjpQ+bMtV5f7Z+mKVvujhpTIFCHHy/xi4sWWV1VcSBucP9RSQ
Ws1iW3R44ww/9AvFUyRXASjWkKf2FQxmEdlU7vzVJq2A/BZAnlFs1cbUCQWBdjvU
Udmn+CMUvkSoH/n04l7Zj+OyDmio6A4otghKK2xOIHocq7WEyS2gOux2uxhbW0md
OmS+JxWk3bFit8rm1Xu7QlMT5esS9e2wgLpJVK+Z6LtzcD1Ha3fgi3rhlc/Cwcoi
KGktzULHU/sU5KO+sbuA0PRAi13MAHs4KA4O1wwCmv+MjsUkbRl3HPBmMFyRnfIQ
RD7lqTsI+OeF0mH2JRi79izJKR3aZwrD8qvthSUy5oYFE5KKdeFJEYY8IL2JaFW0
MowSpnBnk5g=
=GNvv
-----END PGP SIGNATURE-----

--Sig_/d4OGg1I19aIXUV/_jOW3L5+--
