From: Artur Wojcik <artur.wojcik@intel.com>
Subject: [mdadm PATCH] Move symbol definitions from source files to Makefile.
Date: Thu, 28 Jan 2010 16:47:45 +0100
Message-ID: <20100128154745.31726.15500.stgit@awojcik-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

This patch will move _GNU_SOURCE and _FILE_OFFSET_BITS=64 from
various source files to Makefile.

Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
---
 Makefile    |   10 +++++++---
 managemon.c |    3 ---
 mdadm.h     |    2 --
 mdmon.c     |    4 ----
 msg.c       |    3 ---
 5 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/Makefile b/Makefile
index deb6c34..901b3e0 100644
--- a/Makefile
+++ b/Makefile
@@ -47,10 +47,14 @@ ifdef WARN_UNUSED
 CWFLAGS += -Wp,-D_FORTIFY_SOURCE=2 -O
 endif
 
+CPPFLAGS = -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64
+
 ifdef DEBIAN
-CPPFLAGS= -DDEBIAN
-else
-CPPFLAGS=
+CPPFLAGS += -DDEBIAN
+endif
+
+ifdef DEBUG
+CPPFLAGS += -DDEBUG
 endif
 
 SYSCONFDIR = /etc
diff --git a/managemon.c b/managemon.c
index 47ed892..31809b6 100644
--- a/managemon.c
+++ b/managemon.c
@@ -99,9 +99,6 @@
  * - Watch for change in raid-disks, chunk-size, etc.  Update metadata and
  *   start a reshape.
  */
-#ifndef _GNU_SOURCE
-#define _GNU_SOURCE
-#endif
 #include	"mdadm.h"
 #include	"mdmon.h"
 #include	<sys/syscall.h>
diff --git a/mdadm.h b/mdadm.h
index 4f193a8..2ea0175 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -22,8 +22,6 @@
  *    Email: <neilb@suse.de>
  */
 
-#define	_GNU_SOURCE
-#define _FILE_OFFSET_BITS 64
 #include	<unistd.h>
 #if !defined(__dietlibc__) && !defined(__KLIBC__)
 extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
diff --git a/mdmon.c b/mdmon.c
index 0ec4259..e378ffe 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -39,10 +39,6 @@
  *
  */
 
-#ifndef _GNU_SOURCE
-#define _GNU_SOURCE
-#endif
-
 #include	<unistd.h>
 #include	<stdlib.h>
 #include	<sys/types.h>
diff --git a/msg.c b/msg.c
index 8d52b94..7390fcb 100644
--- a/msg.c
+++ b/msg.c
@@ -16,9 +16,6 @@
  * this program; if not, write to the Free Software Foundation, Inc.,
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
-#ifndef _GNU_SOURCE
-#define _GNU_SOURCE
-#endif
 #include <unistd.h>
 #include <stdio.h>
 #include <string.h>

