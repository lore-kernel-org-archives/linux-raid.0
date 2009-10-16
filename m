From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 06/11] md: drivers/md/unroll.pl replaced with awk analog
Date: Fri, 16 Oct 2009 16:49:18 +1100
Message-ID: <20091016054918.24208.57984.stgit@notabene.brown>
References: <20091016054316.24208.33818.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091016054316.24208.33818.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Vladimir Dronnikov <dronnikov@gmail.com>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

From: Vladimir Dronnikov <dronnikov@gmail.com>

drivers/md/unroll.pl replaced by awk script to drop build-time
dependency on perl

Signed-off-by: Vladimir Dronnikov <dronnikov@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/Makefile           |   22 +++++++++++----------
 drivers/md/raid6altivec.uc    |    2 +-
 drivers/md/raid6int.uc        |    2 +-
 drivers/md/raid6test/Makefile |   42 +++++++++++++++++++++--------------------
 drivers/md/unroll.awk         |   20 ++++++++++++++++++++
 drivers/md/unroll.pl          |   24 -----------------------
 6 files changed, 54 insertions(+), 58 deletions(-)
 create mode 100644 drivers/md/unroll.awk
 delete mode 100644 drivers/md/unroll.pl

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 1dc4185..e355e7f 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -46,7 +46,7 @@ obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 
 quiet_cmd_unroll = UNROLL  $@
-      cmd_unroll = $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
+      cmd_unroll = $(AWK) -f$(srctree)/$(src)/unroll.awk -vN=$(UNROLL) \
                    < $< > $@ || ( rm -f $@ && exit 1 )
 
 ifeq ($(CONFIG_ALTIVEC),y)
@@ -59,56 +59,56 @@ endif
 
 targets += raid6int1.c
 $(obj)/raid6int1.c:   UNROLL := 1
-$(obj)/raid6int1.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
+$(obj)/raid6int1.c:   $(src)/raid6int.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
 
 targets += raid6int2.c
 $(obj)/raid6int2.c:   UNROLL := 2
-$(obj)/raid6int2.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
+$(obj)/raid6int2.c:   $(src)/raid6int.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
 
 targets += raid6int4.c
 $(obj)/raid6int4.c:   UNROLL := 4
-$(obj)/raid6int4.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
+$(obj)/raid6int4.c:   $(src)/raid6int.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
 
 targets += raid6int8.c
 $(obj)/raid6int8.c:   UNROLL := 8
-$(obj)/raid6int8.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
+$(obj)/raid6int8.c:   $(src)/raid6int.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
 
 targets += raid6int16.c
 $(obj)/raid6int16.c:  UNROLL := 16
-$(obj)/raid6int16.c:  $(src)/raid6int.uc $(src)/unroll.pl FORCE
+$(obj)/raid6int16.c:  $(src)/raid6int.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
 
 targets += raid6int32.c
 $(obj)/raid6int32.c:  UNROLL := 32
-$(obj)/raid6int32.c:  $(src)/raid6int.uc $(src)/unroll.pl FORCE
+$(obj)/raid6int32.c:  $(src)/raid6int.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
 
 CFLAGS_raid6altivec1.o += $(altivec_flags)
 targets += raid6altivec1.c
 $(obj)/raid6altivec1.c:   UNROLL := 1
-$(obj)/raid6altivec1.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
+$(obj)/raid6altivec1.c:   $(src)/raid6altivec.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
 
 CFLAGS_raid6altivec2.o += $(altivec_flags)
 targets += raid6altivec2.c
 $(obj)/raid6altivec2.c:   UNROLL := 2
-$(obj)/raid6altivec2.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
+$(obj)/raid6altivec2.c:   $(src)/raid6altivec.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
 
 CFLAGS_raid6altivec4.o += $(altivec_flags)
 targets += raid6altivec4.c
 $(obj)/raid6altivec4.c:   UNROLL := 4
-$(obj)/raid6altivec4.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
+$(obj)/raid6altivec4.c:   $(src)/raid6altivec.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
 
 CFLAGS_raid6altivec8.o += $(altivec_flags)
 targets += raid6altivec8.c
 $(obj)/raid6altivec8.c:   UNROLL := 8
-$(obj)/raid6altivec8.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
+$(obj)/raid6altivec8.c:   $(src)/raid6altivec.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
 
 quiet_cmd_mktable = TABLE   $@
diff --git a/drivers/md/raid6altivec.uc b/drivers/md/raid6altivec.uc
index 699dfee..2654d5c 100644
--- a/drivers/md/raid6altivec.uc
+++ b/drivers/md/raid6altivec.uc
@@ -15,7 +15,7 @@
  *
  * $#-way unrolled portable integer math RAID-6 instruction set
  *
- * This file is postprocessed using unroll.pl
+ * This file is postprocessed using unroll.awk
  *
  * <benh> hpa: in process,
  * you can just "steal" the vec unit with enable_kernel_altivec() (but
diff --git a/drivers/md/raid6int.uc b/drivers/md/raid6int.uc
index f9bf9cb..d1e276a 100644
--- a/drivers/md/raid6int.uc
+++ b/drivers/md/raid6int.uc
@@ -15,7 +15,7 @@
  *
  * $#-way unrolled portable integer math RAID-6 instruction set
  *
- * This file is postprocessed using unroll.pl
+ * This file is postprocessed using unroll.awk
  */
 
 #include <linux/raid/pq.h>
diff --git a/drivers/md/raid6test/Makefile b/drivers/md/raid6test/Makefile
index 58ffdf4..2874cbe 100644
--- a/drivers/md/raid6test/Makefile
+++ b/drivers/md/raid6test/Makefile
@@ -7,7 +7,7 @@ CC	 = gcc
 OPTFLAGS = -O2			# Adjust as desired
 CFLAGS	 = -I.. -I ../../../include -g $(OPTFLAGS)
 LD	 = ld
-PERL	 = perl
+AWK	 = awk
 AR	 = ar
 RANLIB	 = ranlib
 
@@ -35,35 +35,35 @@ raid6.a: raid6int1.o raid6int2.o raid6int4.o raid6int8.o raid6int16.o \
 raid6test: test.c raid6.a
 	$(CC) $(CFLAGS) -o raid6test $^
 
-raid6altivec1.c: raid6altivec.uc ../unroll.pl
-	$(PERL) ../unroll.pl 1 < raid6altivec.uc > $@
+raid6altivec1.c: raid6altivec.uc ../unroll.awk
+	$(AWK) ../unroll.awk -vN=1 < raid6altivec.uc > $@
 
-raid6altivec2.c: raid6altivec.uc ../unroll.pl
-	$(PERL) ../unroll.pl 2 < raid6altivec.uc > $@
+raid6altivec2.c: raid6altivec.uc ../unroll.awk
+	$(AWK) ../unroll.awk -vN=2 < raid6altivec.uc > $@
 
-raid6altivec4.c: raid6altivec.uc ../unroll.pl
-	$(PERL) ../unroll.pl 4 < raid6altivec.uc > $@
+raid6altivec4.c: raid6altivec.uc ../unroll.awk
+	$(AWK) ../unroll.awk -vN=4 < raid6altivec.uc > $@
 
-raid6altivec8.c: raid6altivec.uc ../unroll.pl
-	$(PERL) ../unroll.pl 8 < raid6altivec.uc > $@
+raid6altivec8.c: raid6altivec.uc ../unroll.awk
+	$(AWK) ../unroll.awk -vN=8 < raid6altivec.uc > $@
 
-raid6int1.c: raid6int.uc ../unroll.pl
-	$(PERL) ../unroll.pl 1 < raid6int.uc > $@
+raid6int1.c: raid6int.uc ../unroll.awk
+	$(AWK) ../unroll.awk -vN=1 < raid6int.uc > $@
 
-raid6int2.c: raid6int.uc ../unroll.pl
-	$(PERL) ../unroll.pl 2 < raid6int.uc > $@
+raid6int2.c: raid6int.uc ../unroll.awk
+	$(AWK) ../unroll.awk -vN=2 < raid6int.uc > $@
 
-raid6int4.c: raid6int.uc ../unroll.pl
-	$(PERL) ../unroll.pl 4 < raid6int.uc > $@
+raid6int4.c: raid6int.uc ../unroll.awk
+	$(AWK) ../unroll.awk -vN=4 < raid6int.uc > $@
 
-raid6int8.c: raid6int.uc ../unroll.pl
-	$(PERL) ../unroll.pl 8 < raid6int.uc > $@
+raid6int8.c: raid6int.uc ../unroll.awk
+	$(AWK) ../unroll.awk -vN=8 < raid6int.uc > $@
 
-raid6int16.c: raid6int.uc ../unroll.pl
-	$(PERL) ../unroll.pl 16 < raid6int.uc > $@
+raid6int16.c: raid6int.uc ../unroll.awk
+	$(AWK) ../unroll.awk -vN=16 < raid6int.uc > $@
 
-raid6int32.c: raid6int.uc ../unroll.pl
-	$(PERL) ../unroll.pl 32 < raid6int.uc > $@
+raid6int32.c: raid6int.uc ../unroll.awk
+	$(AWK) ../unroll.awk -vN=32 < raid6int.uc > $@
 
 raid6tables.c: mktables
 	./mktables > raid6tables.c
diff --git a/drivers/md/unroll.awk b/drivers/md/unroll.awk
new file mode 100644
index 0000000..c6aa036
--- /dev/null
+++ b/drivers/md/unroll.awk
@@ -0,0 +1,20 @@
+
+# This filter requires one command line option of form -vN=n
+# where n must be a decimal number.
+#
+# Repeat each input line containing $$ n times, replacing $$ with 0...n-1.
+# Replace each $# with n, and each $* with a single $.
+
+BEGIN {
+	n = N + 0
+}
+{
+	if (/\$\$/) { rep = n } else { rep = 1 }
+	for (i = 0; i < rep; ++i) {
+		tmp = $0
+		gsub(/\$\$/, i, tmp)
+		gsub(/\$\#/, n, tmp)
+		gsub(/\$\*/, "$", tmp)
+		print tmp
+	}
+}
diff --git a/drivers/md/unroll.pl b/drivers/md/unroll.pl
deleted file mode 100644
index 3acc710..0000000
--- a/drivers/md/unroll.pl
+++ /dev/null
@@ -1,24 +0,0 @@
-#!/usr/bin/perl
-#
-# Take a piece of C code and for each line which contains the sequence $$
-# repeat n times with $ replaced by 0...n-1; the sequence $# is replaced
-# by the unrolling factor, and $* with a single $
-#
-
-($n) = @ARGV;
-$n += 0;
-
-while ( defined($line = <STDIN>) ) {
-    if ( $line =~ /\$\$/ ) {
-	$rep = $n;
-    } else {
-	$rep = 1;
-    }
-    for ( $i = 0 ; $i < $rep ; $i++ ) {
-	$tmp = $line;
-	$tmp =~ s/\$\$/$i/g;
-	$tmp =~ s/\$\#/$n/g;
-	$tmp =~ s/\$\*/\$/g;
-	print $tmp;
-    }
-}


