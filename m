From: Dan Williams <dan.j.williams@intel.com>
Subject: fixes for 3.1.3 (was: Re: [mdadm GIT PULL] rebuild checkpoints...)
Date: Tue, 06 Jul 2010 12:51:49 -0700
Message-ID: <1278445909.3949.11.camel@dwillia2-linux>
References: <1274921452.17973.253.camel@dwillia2-linux>
	 <20100531113710.29e12d97@notabene.brown>
	 <AANLkTimgVuEIkB2s9rra5QS11YMUSpvSkBOcbzza44LX@mail.gmail.com>
	 <20100616163343.2c57de59@notabene.brown>
	 <1278032211.2179.24.camel@dwillia2-linux>
	 <20100706145043.107f7f76@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100706145043.107f7f76@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, Doug Ledford <dledford@redhat.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, linux-raid <linux-raid@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>
List-Id: linux-raid.ids

On Mon, 2010-07-05 at 21:50 -0700, Neil Brown wrote:
> I'm fairly seriously considering cutting a 3.1.3 shortly (Thursday?) =
so that
> I have a clean slate to build the policy frame work and aim it for 3.=
2.0.
>=20
> If you have anything that you would like to see included in (or addre=
ssed
> for) 3.1.3, please let me know.
>=20

The pthread_create() vs clone(2) issue is still being discussed, but in
the meantime using pthreads seems the safe thing to do.  So, here is
that implementation and another trivial build-warning fixup.

The following changes since commit 1538aca5cbbd99be47657e0ca0b7e2186426=
a1b1:
  NeilBrown (1):
        Merge branch 'master' of git://github.com/djbw/mdadm

are available in the git repository at:

  git://github.com/djbw/mdadm.git master

Dan Williams (2):
      mdmon: satisfy glibc tls abi requirements with pthreads
      imsm: fix a -O2 build warning

 Makefile      |   14 +++++++++++---
 mdmon.c       |   42 +++++++++++++++++++++++++++++++++++++++---
 super-intel.c |    4 ++--
 3 files changed, 52 insertions(+), 8 deletions(-)

commit f4190c2f12527e37304f7c185afa0449fa9dee1c
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jul 6 12:48:56 2010 -0700

    mdmon: satisfy glibc tls abi requirements with pthreads
   =20
    Setting up a proper tls descriptor is required to conform to the ab=
i
    [1].  Until it can be implemented in mdmon use pthreads instead of
    clone(2) to let glibc handle the details.  The old behaviour can be=
 had
    by un-defining USE_PTHREADS.
   =20
    Note, the "O2" builds need LDFLAGS now to pick up the '-pthread' op=
tion.
   =20
    [1]: http://people.redhat.com/drepper/tls.pdf
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/Makefile b/Makefile
index 237f4fc..0f42f88 100644
--- a/Makefile
+++ b/Makefile
@@ -75,6 +75,14 @@ ALTFLAGS =3D -DALT_RUN=3D\"$(ALT_RUN)\" -DALT_MAPFIL=
E=3D\"$(ALT_MAPFILE)\"
 VARFLAGS =3D -DVAR_RUN=3D\"$(VAR_RUN)\"
 CFLAGS =3D $(CWFLAGS) $(CXFLAGS) -DSendmail=3D\""$(MAILCMD)"\" $(CONFF=
ILEFLAGS) $(ALTFLAGS) $(VARFLAGS)
=20
+# The glibc TLS ABI requires applications that call clone(2) to set up
+# TLS data structures, use pthreads until mdmon implements this suppor=
t
+USE_PTHREADS =3D 1
+ifdef USE_PTHREADS
+CFLAGS +=3D -DUSE_PTHREADS
+LDFLAGS +=3D -pthread
+endif
+
 # If you want a static binary, you might uncomment these
 # LDFLAGS =3D -static
 # STRIP =3D -s
@@ -149,13 +157,13 @@ mdadm.klibc : $(SRCS) mdadm.h
 	$(CC) -nostdinc -iwithprefix include -I$(KLIBC)/klibc/include -I$(KLI=
BC)/linux/include -I$(KLIBC)/klibc/arch/i386/include -I$(KLIBC)/klibc/i=
nclude/bits32 $(CFLAGS) $(SRCS)
=20
 mdadm.Os : $(SRCS) mdadm.h
-	$(CC) -o mdadm.Os $(CFLAGS)  -DHAVE_STDINT_H -Os $(SRCS)
+	$(CC) -o mdadm.Os $(CFLAGS) $(LDFLAGS) -DHAVE_STDINT_H -Os $(SRCS)
=20
 mdadm.O2 : $(SRCS) mdadm.h mdmon.O2
-	$(CC) -o mdadm.O2 $(CFLAGS)  -DHAVE_STDINT_H -O2 -D_FORTIFY_SOURCE=3D=
2 $(SRCS)
+	$(CC) -o mdadm.O2 $(CFLAGS) $(LDFLAGS) -DHAVE_STDINT_H -O2 -D_FORTIFY=
_SOURCE=3D2 $(SRCS)
=20
 mdmon.O2 : $(MON_SRCS) mdadm.h mdmon.h
-	$(CC) -o mdmon.O2 $(CFLAGS)  -DHAVE_STDINT_H -O2 -D_FORTIFY_SOURCE=3D=
2 $(MON_SRCS)
+	$(CC) -o mdmon.O2 $(CFLAGS) $(LDFLAGS) -DHAVE_STDINT_H -O2 -D_FORTIFY=
_SOURCE=3D2 $(MON_SRCS)
=20
 # use '-z now' to guarantee no dynamic linker interactions with the mo=
nitor thread
 mdmon : $(MON_OBJS)
diff --git a/mdmon.c b/mdmon.c
index 0c37426..c4c0181 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -58,8 +58,11 @@
 #include	<fcntl.h>
 #include	<signal.h>
 #include	<dirent.h>
-
+#ifdef USE_PTHREADS
+#include	<pthread.h>
+#else
 #include	<sched.h>
+#endif
=20
 #include	"mdadm.h"
 #include	"mdmon.h"
@@ -71,7 +74,39 @@ int mon_tid, mgr_tid;
=20
 int sigterm;
=20
-int run_child(void *v)
+#ifdef USE_PTHREADS
+static void *run_child(void *v)
+{
+	struct supertype *c =3D v;
+
+	mon_tid =3D syscall(SYS_gettid);
+	do_monitor(c);
+	return 0;
+}
+
+static int clone_monitor(struct supertype *container)
+{
+	pthread_attr_t attr;
+	pthread_t thread;
+	int rc;
+
+	mon_tid =3D -1;
+	pthread_attr_init(&attr);
+	pthread_attr_setstacksize(&attr, 4096);
+	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
+	rc =3D pthread_create(&thread, &attr, run_child, container);
+	if (rc)
+		return rc;
+	while (mon_tid =3D=3D -1)
+		usleep(10);
+	pthread_attr_destroy(&attr);
+
+	mgr_tid =3D syscall(SYS_gettid);
+
+	return mon_tid;
+}
+#else /* USE_PTHREADS */
+static int run_child(void *v)
 {
 	struct supertype *c =3D v;
=20
@@ -85,7 +120,7 @@ int __clone2(int (*fn)(void *),
 	    int flags, void *arg, ...
 	 /* pid_t *pid, struct user_desc *tls, pid_t *ctid */ );
 #endif
- int clone_monitor(struct supertype *container)
+static int clone_monitor(struct supertype *container)
 {
 	static char stack[4096];
=20
@@ -103,6 +138,7 @@ int __clone2(int (*fn)(void *),
=20
 	return mon_tid;
 }
+#endif /* USE_PTHREADS */
=20
 static int make_pidfile(char *devname)
 {

commit 569cc43ffb0634510defee91407d261555c7a991
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jul 6 12:48:59 2010 -0700

    imsm: fix a -O2 build warning
   =20
    super-intel.c: In function =E2=80=98imsm_add_spare=E2=80=99:
    super-intel.c:4833: error: =E2=80=98array_start=E2=80=99 may be use=
d uninitialized in this function
    super-intel.c:4834: error: =E2=80=98array_end=E2=80=99 may be used =
uninitialized in this function
   =20
    This is valid, if we don't find a spare candidate then array_{start=
,end}
    will be uninitialized.
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/super-intel.c b/super-intel.c
index daf811f..6826d9b 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4830,8 +4830,8 @@ static struct dl *imsm_add_spare(struct intel_sup=
er *super, int slot,
 	struct extent *ex;
 	int i, j;
 	int found;
-	__u32 array_start;
-	__u32 array_end;
+	__u32 array_start =3D 0;
+	__u32 array_end =3D 0;
 	struct dl *dl;
=20
 	for (dl =3D super->disks; dl; dl =3D dl->next) {


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
