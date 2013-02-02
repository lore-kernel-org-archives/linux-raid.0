From: John Spencer <maillist-mdadm@barfooze.de>
Subject: [PATCH] three compatibility patches for musl libc
Date: Sat, 02 Feb 2013 17:53:28 +0100
Message-ID: <510D4488.4050306@barfooze.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010207090906070505030905"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------010207090906070505030905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


--------------010207090906070505030905
Content-Type: text/x-patch;
 name="0001-platform-intel-canonicalize_file_name-is-not-portabl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-platform-intel-canonicalize_file_name-is-not-portabl.pa";
 filename*1="tch"

From 23114b8c77982717cc3ce3d437321c7fb0b1c918 Mon Sep 17 00:00:00 2001
From: John Spencer <maillist-mdadm@barfooze.de>
Date: Sat, 2 Feb 2013 17:26:45 +0100
Subject: [PATCH 1/3] platform-intel: canonicalize_file_name() is not portable

this is a GLIBC specific feature and should not be used.

according to its manpage:
"The call canonicalize_file_name(path) is equivalent
to the call realpath(path, NULL)."

thus, we use realpath so it works everywhere.

Signed-off-by: John Spencer <maillist-mdadm@barfooze.de>
---
 platform-intel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 0dcf07c..d8d4942 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -116,7 +116,7 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 
 		list->dev_id = (__u16) dev_id;
 		list->type = type;
-		list->path = canonicalize_file_name(path);
+		list->path = realpath(path, NULL);
 		list->next = NULL;
 		if ((list->pci_id = strrchr(list->path, '/')) != NULL)
 			list->pci_id++;
@@ -459,7 +459,7 @@ char *devt_to_devpath(dev_t dev)
 	char device[46];
 
 	sprintf(device, "/sys/dev/block/%d:%d/device", major(dev), minor(dev));
-	return canonicalize_file_name(device);
+	return realpath(device, NULL);
 }
 
 char *diskfd_to_devpath(int fd)
-- 
1.7.3.4


--------------010207090906070505030905
Content-Type: text/x-patch;
 name="0002-mdadm.h-fix-ugly-glibc-specific-ifdeffery.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-mdadm.h-fix-ugly-glibc-specific-ifdeffery.patch"

From 9467d1dcef907addbd9ef4f0f9068766674fd587 Mon Sep 17 00:00:00 2001
From: John Spencer <maillist-mdadm@barfooze.de>
Date: Sat, 2 Feb 2013 17:37:55 +0100
Subject: [PATCH 2/3] mdadm.h: fix ugly glibc specific ifdeffery

the code that was exposed on anything else than dietlibc and klibc
is entirely glibc specific and broke the build on musl libc.

Signed-off-by: John Spencer <maillist-mdadm@barfooze.de>
---
 mdadm.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index f1352e3..addd423 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -25,9 +25,9 @@
 #define	_GNU_SOURCE
 #define _FILE_OFFSET_BITS 64
 #include	<unistd.h>
-#if !defined(__dietlibc__) && !defined(__KLIBC__)
+#ifdef __GLIBC__
 extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
-#else
+#elif !defined(lseek64)
 # if defined(__NO_STAT64) || __WORDSIZE != 32
 # define lseek64 lseek
 # endif
-- 
1.7.3.4


--------------010207090906070505030905
Content-Type: text/x-patch;
 name="0003-remove-Werror-from-Makefile.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-remove-Werror-from-Makefile.patch"

From eb55533b387c0805ac11134bab1404108851ef04 Mon Sep 17 00:00:00 2001
From: John Spencer <maillist-mdadm@barfooze.de>
Date: Sat, 2 Feb 2013 17:40:20 +0100
Subject: [PATCH 3/3] remove -Werror from Makefile

using -Werror breaks the build for any libc/compiler combination
the author didnt test yet, so it is insane to use it by default.

fixes build on musl libc.

Signed-off-by: John Spencer <maillist-mdadm@barfooze.de>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index b9787d6..0169824 100644
--- a/Makefile
+++ b/Makefile
@@ -42,7 +42,7 @@ KLIBC_GCC = gcc -nostdinc -iwithprefix include -I$(KLIBC)/klibc/include -I$(KLIB
 
 CC = $(CROSS_COMPILE)gcc
 CXFLAGS = -ggdb
-CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
+CWFLAGS = -Wall -Wstrict-prototypes -Wextra -Wno-unused-parameter
 ifdef WARN_UNUSED
 CWFLAGS += -Wp,-D_FORTIFY_SOURCE=2 -O
 endif
-- 
1.7.3.4


--------------010207090906070505030905--
