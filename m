From: Jaakko =?iso-8859-1?q?Kantoj=E4rvi?= <jaakko@cs.hut.fi>
Subject: sys/time.h missing from linux/raid/pq.h for userspace builds
Date: Thu, 14 Jul 2011 17:15:17 +0300
Message-ID: <201107141715.17770.jaakko@cs.hut.fi>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I beleave this is required to build linux/raid/pq.h for userspace

--- /usr/src/linux-headers-2.6.39-2-common/include/linux/raid/pq.h     =
   2011-05-19 07:06:34.000000000 +0300
+++ /usr/src/linux-headers-2.6.39-2-common/include/linux/raid/pq.h     =
   2011-07-14 17:10:33.000000000 +0300
@@ -35,6 +35,7 @@
 #include <limits.h>
 #include <stddef.h>
 #include <sys/mman.h>
+#include <sys/time.h>
 #include <sys/types.h>
=20
 /* Not standard, but glibc defines it */


I bleave this "bug" is still in git.

--
Jaakko Kantoj=E4rvi

System Admin
Department of Computer Science and Engineering
School of Science
Aalto University
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
