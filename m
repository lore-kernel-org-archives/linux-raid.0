From: Robert Buchholz <robert.buchholz@goodpoint.de>
Subject: [PATCH] Re: Find mismatch in data blocks during raid6 repair
Date: Fri, 20 Jul 2012 12:40:04 +0200
Message-ID: <2060628.pGJ05f4kvM@peanut>
References: <10900468.MPSjVn2C3J@peanut> <20120703202734.GA10087@lazy.lzy> <20120709134308.0ea5b18d@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1532068.n9dNsYu7DV"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120709134308.0ea5b18d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--nextPart1532068.n9dNsYu7DV
Content-Type: multipart/mixed; boundary="nextPart3171995.iUmXQWbv4L"
Content-Transfer-Encoding: 7Bit


--nextPart3171995.iUmXQWbv4L
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hello,

On Monday, July 09, 2012 01:43:08 PM NeilBrown wrote:
> On Tue, 3 Jul 2012 22:27:34 +0200 Piergiorgio Sartor
> <piergiorgio.sartor@nexgo.de> wrote:
> > On Tue, Jul 03, 2012 at 09:10:41PM +0200, Robert Buchholz wrote:
> > > > Why always two blocks?
> > > 
> > > The reason is simply to have less cases to handle in the code.
> > > There's already three ways to regenerate regenerate two
> > > blocks (D&D, D/P&Q and D&P), and there would be two more
> > > cases if only one block was to be repaired. With the original
> > > patch, if you can repair two blocks, that allows you to
> > > repair one (and one other in addition) as well.> 
> > sorry, I express myself not clearly.
> > 
> > I mean, a two parities Reed-Solomon system can
> > only detect one incorrect slot position, so I would
> > expect to have the possibility to fix only one, not
> > two slots.
> > 
> > So, I did not understand why two. I mean, I understand
> > that a RAID-6 can correct exact up two incorrect slots,
> > but the "unknown" case might have more and correcting
> > will mean no correction or, maybe, even more damage.
> > 
> > I would prefer, if you agree, to simply tell "raid6check"
> > to fix a single slot, or the (single) wrong slots it finds
> > during the check.
> 
> I think this is a sensible feature to offer.  Maybe if "autorepair" is
> given in place of "repair", then it should choose which block to
> repair, and do that one?

That makes sense, I wanted to make it work and get some feedback first.
I'll look into this.

> I have applied the patches, though with some fairly minor editing
> (wrapping lines, moving variable declarations before any statements,
> removing tab-at-the-end-of-the-line).  They probably won't appear in
> my public .git for a little while I I have some other patches that I
> need to sort through and organise first.

Thank you for merging and the cleanup.
I have attached three patches against your latest HEAD.
The first fixes compilation of the raid6check tool after the xmalloc 
refactoring. The other two are bugfixes in the repair code. The latter 
bug is somewhat embarrassing, I used geo_map in the wrong direction, 
yielding incorrect data block indices to repair. This will lead to a 
data corruption on the stripe in most cases (interestingly, not in my 
test case due to the way the raid size and stripe index were chosen).


Cheers,
Robert

--nextPart3171995.iUmXQWbv4L
Content-Disposition: attachment; filename="0001-Move-xmalloc-et-al-into-their-own-file.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0001-Move-xmalloc-et-al-into-their-own-file.patch"

From 24d8787a7ec2a56e4de62e9347ede9b2c2990617 Mon Sep 17 00:00:00 2001
From: Robert Buchholz <rbu@goodpoint.de>
Date: Mon, 16 Jul 2012 23:56:54 +0200
Subject: [PATCH 1/3] Move xmalloc et al into their own file

This avoid code duplication for utilities that do not link to
util.c and everything that comes with it, such as test_restripe and
raid6check
---
 Makefile   |   12 +++++-----
 restripe.c |   22 ------------------
 util.c     |   40 ---------------------------------
 xmalloc.c  |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 78 insertions(+), 68 deletions(-)
 create mode 100644 xmalloc.c

diff --git a/Makefile b/Makefile
index 315455b..19cd22c 100644
--- a/Makefile
+++ b/Makefile
@@ -104,10 +104,10 @@ OBJS =  mdadm.o config.o policy.o mdstat.o  ReadMe.o util.o maps.o lib.o \
 	Incremental.o \
 	mdopen.o super0.o super1.o super-ddf.o super-intel.o bitmap.o \
 	super-mbr.o super-gpt.o \
-	restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o \
+	restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o xmalloc.o \
 	platform-intel.o probe_roms.o
 
-CHECK_OBJS = restripe.o sysfs.o maps.o lib.o
+CHECK_OBJS = restripe.o sysfs.o maps.o lib.o xmalloc.o
 
 SRCS =  $(patsubst %.o,%.c,$(OBJS))
 
@@ -117,7 +117,7 @@ MON_OBJS = mdmon.o monitor.o managemon.o util.o maps.o mdstat.o sysfs.o \
 	config.o policy.o lib.o \
 	Kill.o sg_io.o dlink.o ReadMe.o super0.o super1.o super-intel.o \
 	super-mbr.o super-gpt.o \
-	super-ddf.o sha1.o crc32.o msg.o bitmap.o \
+	super-ddf.o sha1.o crc32.o msg.o bitmap.o xmalloc.o \
 	platform-intel.o probe_roms.o
 
 MON_SRCS = $(patsubst %.o,%.c,$(MON_OBJS))
@@ -126,7 +126,7 @@ STATICSRC = pwgr.c
 STATICOBJS = pwgr.o
 
 ASSEMBLE_SRCS := mdassemble.c Assemble.c Manage.c config.c policy.c dlink.c util.c \
-	maps.c lib.c \
+	maps.c lib.c xmalloc.c \
 	super0.c super1.c super-ddf.c super-intel.c sha1.c crc32.c sg_io.c mdstat.c \
 	platform-intel.c probe_roms.c sysfs.c super-mbr.c super-gpt.c
 ASSEMBLE_AUTO_SRCS := mdopen.c
@@ -175,8 +175,8 @@ mdmon : $(MON_OBJS)
 	$(CC) $(CFLAGS) $(LDFLAGS) $(MON_LDFLAGS) -Wl,-z,now -o mdmon $(MON_OBJS) $(LDLIBS)
 msg.o: msg.c msg.h
 
-test_stripe : restripe.c mdadm.h
-	$(CC) $(CXFLAGS) $(LDFLAGS) -o test_stripe -DMAIN restripe.c
+test_stripe : restripe.c xmalloc.o mdadm.h
+	$(CC) $(CXFLAGS) $(LDFLAGS) -o test_stripe xmalloc.o  -DMAIN restripe.c
 
 raid6check : raid6check.o mdadm.h $(CHECK_OBJS)
 	$(CC) $(CXFLAGS) $(LDFLAGS) -o raid6check raid6check.o $(CHECK_OBJS)
diff --git a/restripe.c b/restripe.c
index 1d2da1a..90896c8 100644
--- a/restripe.c
+++ b/restripe.c
@@ -998,26 +998,4 @@ main(int argc, char *argv[])
 	exit(0);
 }
 
-
-void *xmalloc(size_t len)
-{
-	void *rv = malloc(len);
-	char *msg;
-	if (rv)
-		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
-	write(2, msg, strlen(msg));
-	exit(4);
-}
-
-void *xcalloc(size_t num, size_t size)
-{
-	void *rv = calloc(num, size);
-	char *msg;
-	if (rv)
-		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
-	write(2, msg, strlen(msg));
-	exit(4);
-}
 #endif /* MAIN */
diff --git a/util.c b/util.c
index ad3c150..de12685 100644
--- a/util.c
+++ b/util.c
@@ -1799,43 +1799,3 @@ struct mdinfo *container_choose_spares(struct supertype *st,
 	}
 	return disks;
 }
-
-void *xmalloc(size_t len)
-{
-	void *rv = malloc(len);
-	char *msg;
-	if (rv)
-		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
-	exit(4+!!write(2, msg, strlen(msg)));
-}
-
-void *xrealloc(void *ptr, size_t len)
-{
-	void *rv = realloc(ptr, len);
-	char *msg;
-	if (rv)
-		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
-	exit(4+!!write(2, msg, strlen(msg)));
-}
-
-void *xcalloc(size_t num, size_t size)
-{
-	void *rv = calloc(num, size);
-	char *msg;
-	if (rv)
-		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
-	exit(4+!!write(2, msg, strlen(msg)));
-}
-
-char *xstrdup(const char *str)
-{
-	char *rv = strdup(str);
-	char *msg;
-	if (rv)
-		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
-	exit(4+!!write(2, msg, strlen(msg)));
-}
diff --git a/xmalloc.c b/xmalloc.c
new file mode 100644
index 0000000..8d42a7c
--- /dev/null
+++ b/xmalloc.c
@@ -0,0 +1,72 @@
+/* mdadm - manage Linux "md" devices aka RAID arrays.
+ *
+ * Copyright (C) 2001-2009 Neil Brown <neilb@suse.de>
+ *
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License
+ *    along with this program; if not, write to the Free Software
+ *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ *    Author: Neil Brown
+ *    Email: <neilb@suse.de>
+ */
+
+#include	"mdadm.h"
+/*#include	<sys/socket.h>
+#include	<sys/utsname.h>
+#include	<sys/wait.h>
+#include	<sys/un.h>
+#include	<ctype.h>
+#include	<dirent.h>
+#include	<signal.h>
+*/
+
+void *xmalloc(size_t len)
+{
+	void *rv = malloc(len);
+	char *msg;
+	if (rv)
+		return rv;
+	msg = Name ": memory allocation failure - aborting\n";
+	exit(4+!!write(2, msg, strlen(msg)));
+}
+
+void *xrealloc(void *ptr, size_t len)
+{
+	void *rv = realloc(ptr, len);
+	char *msg;
+	if (rv)
+		return rv;
+	msg = Name ": memory allocation failure - aborting\n";
+	exit(4+!!write(2, msg, strlen(msg)));
+}
+
+void *xcalloc(size_t num, size_t size)
+{
+	void *rv = calloc(num, size);
+	char *msg;
+	if (rv)
+		return rv;
+	msg = Name ": memory allocation failure - aborting\n";
+	exit(4+!!write(2, msg, strlen(msg)));
+}
+
+char *xstrdup(const char *str)
+{
+	char *rv = strdup(str);
+	char *msg;
+	if (rv)
+		return rv;
+	msg = Name ": memory allocation failure - aborting\n";
+	exit(4+!!write(2, msg, strlen(msg)));
+}
-- 
1.7.3.4


--nextPart3171995.iUmXQWbv4L
Content-Disposition: attachment; filename="0002-raid6check-Fix-off-by-one-in-argument-check.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0002-raid6check-Fix-off-by-one-in-argument-check.patch"

From bc15e20f19bcced2b271479be9da92e9db335747 Mon Sep 17 00:00:00 2001
From: Robert Buchholz <rbu@goodpoint.de>
Date: Thu, 19 Jul 2012 17:14:47 +0200
Subject: [PATCH 2/3] raid6check: Fix off-by-one in argument check

In repair mode, specifying a failed slot that is equal to the number of
devices in the raid could cause a segfault.
---
 raid6check.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/raid6check.c b/raid6check.c
index aba8160..dffadbe 100644
--- a/raid6check.c
+++ b/raid6check.c
@@ -416,12 +416,12 @@ int main(int argc, char *argv[])
 		failed_disk1 = getnum(argv[4], &err);
 		failed_disk2 = getnum(argv[5], &err);
 
-		if(failed_disk1 > info->array.raid_disks) {
+		if(failed_disk1 >= info->array.raid_disks) {
 			fprintf(stderr, "%s: failed_slot_1 index is higher than number of devices in raid\n", prg);
 			exit_err = 4;
 			goto exitHere;
 		}
-		if(failed_disk2 > info->array.raid_disks) {
+		if(failed_disk2 >= info->array.raid_disks) {
 			fprintf(stderr, "%s: failed_slot_2 index is higher than number of devices in raid\n", prg);
 			exit_err = 4;
 			goto exitHere;
-- 
1.7.3.4


--nextPart3171995.iUmXQWbv4L
Content-Disposition: attachment; filename="0003-raid6check-Repair-mode-used-geo_map-incorrectly.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0003-raid6check-Repair-mode-used-geo_map-incorrectly.patch"

From 90fe43106d33f22fd21fbfd49f853ec22592fa1f Mon Sep 17 00:00:00 2001
From: Robert Buchholz <rbu@goodpoint.de>
Date: Thu, 19 Jul 2012 19:33:22 +0200
Subject: [PATCH 3/3] raid6check: Repair mode used geo_map incorrectly

In repair mode, the data block indices to be repaired were calculated
using geo_map() which returns the disk slot for a data block index
and not the reverse. Now we simply store the reverse of that calculation
when we do it anyway.
---
 raid6check.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/raid6check.c b/raid6check.c
index dffadbe..122936d 100644
--- a/raid6check.c
+++ b/raid6check.c
@@ -126,6 +126,7 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 	int err = 0;
 	sighandler_t sig[3];
 	int rv;
+	int block_index_for_slot[data_disks];
 
 	extern int tables_ready;
 
@@ -172,6 +173,7 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 		for (i = 0 ; i < data_disks ; i++) {
 			int disk = geo_map(i, start, raid_disks, level, layout);
 			blocks[i] = stripes[disk];
+			block_index_for_slot[disk] = i;
 			printf("%d->%d\n", i, disk);
 		}
 
@@ -216,9 +218,7 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 				else
 					failed_data = failed_disk1;
 				printf("Repairing D/P(%d) and Q\n", failed_data);
-				failed_block_index = geo_map(
-					failed_data, start, raid_disks,
-					level, layout);
+				failed_block_index = block_index_for_slot[failed_data];
 				for (i=0; i < data_disks; i++)
 					if (failed_block_index == i)
 						all_but_failed_blocks[i] = stripes[diskP];
@@ -235,13 +235,13 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 						failed_data = failed_disk2;
 					else
 						failed_data = failed_disk1;
-					failed_block_index = geo_map(failed_data, start, raid_disks, level, layout);
+					failed_block_index = block_index_for_slot[failed_data];
 					printf("Repairing D(%d) and P\n", failed_data);
 					raid6_datap_recov(raid_disks, chunk_size, failed_block_index, (uint8_t**)blocks);
 				} else {
 					printf("Repairing D and D\n");
-					int failed_block_index1 = geo_map(failed_disk1, start, raid_disks, level, layout);
-					int failed_block_index2 = geo_map(failed_disk2, start, raid_disks, level, layout);
+					int failed_block_index1 = block_index_for_slot[failed_disk1];
+					int failed_block_index2 = block_index_for_slot[failed_disk2];
 					if (failed_block_index1 > failed_block_index2) {
 						int t = failed_block_index1;
 						failed_block_index1 = failed_block_index2;
-- 
1.7.3.4


--nextPart3171995.iUmXQWbv4L--

--nextPart1532068.n9dNsYu7DV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABCgAGBQJQCTWFAAoJECaaHo/OfoM5jQMP+wRjVAf8Cbbdee96wIsqk4oh
seBSVydYcAJn/Sr3jraKccvJGKkZh3V9lsVaFwApGAJuHs/n7+DD26XkIe+mXyU/
ZWq4+XZB7Qgt0lq5+9mi9KarmTEQAhfOpfyCMQ33n7beNC2gv0gFGZAOlOLNZRUm
FLUwt3UlnTcZw82ASSbRmKj/ty9ZP4qOem9W2KANWVMza+Y64Ty2is3AXN9eb5rT
qvl/H4lcJkYeN3zsMR98fmmK/MkF4IwZ5paFGkb+wEGtD6wbHKe1+rC0gOBAFNFn
Yzzaxh+stx05WLv08EjqYi3AoEWl4htJZ/E7NiI/SNFHXOfa0BP+IOodglVpTjdc
KxZ8Q3zv4gGxrWG/4TJ17E6EzwisTSmJNaijBhxfArg69YJS+BDrCIHi9BdoONIg
CyTUjGgDwRBdUrIAo5fkeJJe3wVEsYHy31fHkc7hGaphqnKMrHTcc67ma2t0wnoq
0GuViO8wXcmbAlWMW08TqBoToAGNllnp91Ib+fK8/24kx3CmziUrLbNOjGdZ33ym
hm8J+h1n2vlAtwYq7GUwDCRcn6usYVhCUrINlGR+U00ViVeluKfcZRSPVHqnAsH4
+aTkPnEOwNF4tM0TfACKqfnJKCZLnYHnH1gpgtS6q0Uz/U2xTjUlDh3N/4sK3w3d
kO8mOx9kLhXKuSpIk4/X
=VOly
-----END PGP SIGNATURE-----

--nextPart1532068.n9dNsYu7DV--

