From: Nix <nix@esperi.org.uk>
Subject: [PATCH*2] mdadm works with uClibc from SVN
Date: Tue, 20 Jun 2006 23:06:15 +0100
Message-ID: <87wtbbjxd4.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

For some time, mdadm's been dumping core on me in my uClibc-built
initramfs. As you might imagine this is somewhat frustrating, not least
since my root filesystem's in LVM on RAID. Half an hour ago I got around
to debugging this.

Imagine my surprise when I found that it was effectively guaranteed to
crash: map_dev() in util.c is stubbed out for uClibc builds, and
returns -1 at all times. That means that code in, among other places,
config.c:load_partitions() is guaranteed to segfault, which is a bit
tough if you're using the (sane) default `DEVICE partitions' in your
mdadm.conf.

As far as I can tell this is entirely because ftw() support is not
implemented in uClibc. But as of November 2005, it *is* implemented in
uClibc 0.9.29-to-be in SVN, which rumour has it is soon to be officially
released. (The ftw() implementation is currently a copy of that from
glibc, but knowing the uClibc folks it will shrink dramatically as time
goes by. :) )

There are two options here. Either the trivial but rather unhelpful
approach of, well, *telling* people that what they're building
isn't going to work:

diff -durN 2.5.1-orig/Makefile 2.5.1-patched/Makefile
--- 2.5.1-orig/Makefile	2006-06-20 22:49:56.000000000 +0100
+++ 2.5.1-patched/Makefile	2006-06-20 22:50:34.000000000 +0100
@@ -97,6 +97,7 @@
 mdadm.tcc : $(SRCS) mdadm.h
 	$(TCC) -o mdadm.tcc $(SRCS)
 
+# This doesn't work
 mdadm.uclibc : $(SRCS) mdadm.h
 	$(UCLIBC_GCC) -DUCLIBC -DHAVE_STDINT_H -o mdadm.uclibc $(SRCS) $(STATICSRC)
 
@@ -115,6 +116,7 @@
 	rm -f $(OBJS)
 	$(CC) $(LDFLAGS) $(ASSEMBLE_FLAGS) -static -DHAVE_STDINT_H -o mdassemble.static $(ASSEMBLE_SRCS) $(STATICSRC)
 
+# This doesn't work
 mdassemble.uclibc : $(ASSEMBLE_SRCS) mdadm.h
 	rm -f $(OJS)
 	$(UCLIBC_GCC) $(ASSEMBLE_FLAGS) -DUCLIBC -DHAVE_STDINT_H -static -o mdassemble.uclibc $(ASSEMBLE_SRCS) $(STATICSRC)
diff -durN 2.5.1-orig/mdadm.h 2.5.1-patched/mdadm.h
--- 2.5.1-orig/mdadm.h	2006-06-02 06:35:22.000000000 +0100
+++ 2.5.1-patched/mdadm.h	2006-06-20 22:50:55.000000000 +0100
@@ -344,6 +344,7 @@
 #endif
 
 #ifdef UCLIBC
+#error This is known not to work.
   struct FTW {};
 # define FTW_PHYS 1
 #else

Or the even-more-trivial but arguably far more useful approach of making
it work when possible (failing to compile with old uClibc because of the
absence of <ftw.h>, and working perfectly well with new uClibc):

diff -durN 2.5.1-orig/Makefile 2.5.1-patched/Makefile
--- 2.5.1-orig/Makefile	2006-06-20 22:49:56.000000000 +0100
+++ 2.5.1-patched/Makefile	2006-06-20 22:52:34.000000000 +0100
@@ -98,7 +98,7 @@
 	$(TCC) -o mdadm.tcc $(SRCS)
 
 mdadm.uclibc : $(SRCS) mdadm.h
-	$(UCLIBC_GCC) -DUCLIBC -DHAVE_STDINT_H -o mdadm.uclibc $(SRCS) $(STATICSRC)
+	$(UCLIBC_GCC) -DHAVE_STDINT_H -o mdadm.uclibc $(SRCS) $(STATICSRC)
 
 mdadm.klibc : $(SRCS) mdadm.h
 	rm -f $(OBJS) 
@@ -117,7 +117,7 @@
 
 mdassemble.uclibc : $(ASSEMBLE_SRCS) mdadm.h
 	rm -f $(OJS)
-	$(UCLIBC_GCC) $(ASSEMBLE_FLAGS) -DUCLIBC -DHAVE_STDINT_H -static -o mdassemble.uclibc $(ASSEMBLE_SRCS) $(STATICSRC)
+	$(UCLIBC_GCC) $(ASSEMBLE_FLAGS) -DHAVE_STDINT_H -static -o mdassemble.uclibc $(ASSEMBLE_SRCS) $(STATICSRC)
 
 # This doesn't work
 mdassemble.klibc : $(ASSEMBLE_SRCS) mdadm.h
diff -durN 2.5.1-orig/mdadm.h 2.5.1-patched/mdadm.h
--- 2.5.1-orig/mdadm.h	2006-06-02 06:35:22.000000000 +0100
+++ 2.5.1-patched/mdadm.h	2006-06-20 22:53:02.000000000 +0100
@@ -343,14 +343,9 @@
 struct stat64;
 #endif
 
-#ifdef UCLIBC
-  struct FTW {};
+#include <ftw.h>
+#ifdef __dietlibc__
 # define FTW_PHYS 1
-#else
-# include <ftw.h>
-# ifdef __dietlibc__
-#  define FTW_PHYS 1
-# endif
 #endif
 
 extern int add_dev(const char *name, const struct stat *stb, int flag, struct FTW *s);
diff -durN 2.5.1-orig/util.c 2.5.1-patched/util.c
--- 2.5.1-orig/util.c	2006-06-16 01:25:44.000000000 +0100
+++ 2.5.1-patched/util.c	2006-06-20 22:54:13.000000000 +0100
@@ -354,21 +354,6 @@
 } *devlist = NULL;
 int devlist_ready = 0;
 
-#ifdef UCLIBC
-int add_dev(const char *name, const struct stat *stb, int flag, struct FTW *s)
-{
-	return 0;
-}
-char *map_dev(int major, int minor, int create)
-{
-#if 0
-	fprintf(stderr, "Warning - fail to map %d,%d to a device name\n",
-		major, minor);
-#endif
-	return NULL;
-}
-#else
-
 #ifdef __dietlibc__
 int add_dev_1(const char *name, const struct stat *stb, int flag)
 {
@@ -467,8 +452,6 @@
 	return nonstd ? nonstd : std;
 }
 
-#endif
-
 unsigned long calc_csum(void *super, int bytes)
 {
 	unsigned long long newcsum = 0;


With this latter patch, mdadm works flawlessly with my uClibc,
svnversion r15342 from 2006-06-08, and probably works just as well with
all SVN releases after r13017, 2005-12-30.


(One final request: please turn on world-readability in your generated
tarballs ;) right now util.c and some others are readable only by
user. Thanks.)

-- 
`NB: Anyone suggesting that we should say "Tibibytes" instead of
 Terabytes there will be hunted down and brutally slain.
 That is all.' --- Matthew Wilcox
