From: Gil <gil@fooplanet.com>
Subject: Re: How do I find endian-conversion function on Redhar/Fedora
Date: Sun, 05 Feb 2006 15:12:06 -0800
Message-ID: <43E68646.4000209@fooplanet.com>
References: <10AE6EFE-5542-4B43-8E19-87A66C4FFE6D@mac.com> <17382.30814.778053.416244@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080003050105040508060607"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17382.30814.778053.416244@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080003050105040508060607
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Neil Brown wrote:
> So my plea for help:  Could someone with a Redhat installation
> please see if there is any way to get functions that convert
> between little endian and host endian, or if there is some name I
> can #define to disable the 'private kernel header' warning..

I have an FC4 machine that I tried this out on.  I have no idea if
this is the right way to use these headers in /usr/include/linux,
but it made the compile problem go away at least.

--Gil

--------------080003050105040508060607
Content-Type: text/plain;
 name="mdadm-2.3-byteorder.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mdadm-2.3-byteorder.patch"

diff -r -u mdadm-2.3/bitmap.c mdadm-2.3-patched/bitmap.c
--- mdadm-2.3/bitmap.c	2005-12-15 17:41:31.000000000 -0800
+++ mdadm-2.3-patched/bitmap.c	2006-02-05 15:09:32.000000000 -0800
@@ -21,7 +21,16 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include "mdadm.h"
-#include <asm/byteorder.h>
+#include <endian.h>
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#  include <linux/byteorder/little_endian.h>
+#elif __BYTE_ORDER == __BIG_ENDIAN
+#  include <linux/byteorder/big_endian.h>
+#elif __BYTE_ORDER == __PDP_ENDIAN
+#  include <linux/byteorder/pdp_endian.h>
+#else
+#  error "unknown endianness."
+#endif
 
 #define min(a,b) (((a) < (b)) ? (a) : (b))
 
diff -r -u mdadm-2.3/super0.c mdadm-2.3-patched/super0.c
--- mdadm-2.3/super0.c	2006-01-26 23:06:09.000000000 -0800
+++ mdadm-2.3-patched/super0.c	2006-02-05 14:59:37.000000000 -0800
@@ -28,7 +28,18 @@
  */
 
 #include "mdadm.h"
-#include <asm/byteorder.h>
+
+#include <endian.h>
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#  include <linux/byteorder/little_endian.h>
+#elif __BYTE_ORDER == __BIG_ENDIAN
+#  include <linux/byteorder/big_endian.h>
+#elif __BYTE_ORDER == __PDP_ENDIAN
+#  include <linux/byteorder/pdp_endian.h>
+#else
+#  error "unknown endianness."
+#endif
+
 
 /*
  * All handling for the 0.90.0 version superblock is in
Only in mdadm-2.3-patched: .super0.c.swp
diff -r -u mdadm-2.3/super1.c mdadm-2.3-patched/super1.c
--- mdadm-2.3/super1.c	2006-01-30 17:45:32.000000000 -0800
+++ mdadm-2.3-patched/super1.c	2006-02-05 15:09:05.000000000 -0800
@@ -29,7 +29,15 @@
 
 #include "mdadm.h"
 #include <endian.h>
-#include "asm/byteorder.h"
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#  include <linux/byteorder/little_endian.h>
+#elif __BYTE_ORDER == __BIG_ENDIAN
+#  include <linux/byteorder/big_endian.h>
+#elif __BYTE_ORDER == __PDP_ENDIAN
+#  include <linux/byteorder/pdp_endian.h>
+#else
+#  error "unknown endianness."
+#endif
 /*
  * The version-1 superblock :
  * All numeric fields are little-endian.

--------------080003050105040508060607--
