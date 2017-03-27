From: SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] Fix dead URLs to ftp.kernel.org
Date: Mon, 27 Mar 2017 21:44:06 +0900
Message-ID: <20170327124406.6910-1-sj38.park@gmail.com>
References: <CAEjAshqR0Nhp4Wkmkg_HrswsiuUb3rYJ=TOUSBSvoUT3FSWTjg@mail.gmail.com>
Return-path: <autofs-owner@vger.kernel.org>
In-Reply-To: <CAEjAshqR0Nhp4Wkmkg_HrswsiuUb3rYJ=TOUSBSvoUT3FSWTjg@mail.gmail.com>
Sender: autofs-owner@vger.kernel.org
To: trivial@kernel.org, rml@tech9.net, axboe@fb.com, shli@kernel.org, raven@themaw.net, yamada.masahito@socionext.com, mmarek@suse.com
Cc: linux-raid@vger.kernel.org, autofs@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
List-Id: linux-raid.ids

URLs to ftp.kernel.org are still exist though the service is closed [0].
This commit fixes the URLs to use www.kernel.org instead.

[0] https://www.kernel.org/shutting-down-ftp-services.html

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 MAINTAINERS              | 2 +-
 drivers/block/Kconfig    | 2 +-
 drivers/md/Kconfig       | 2 +-
 fs/autofs4/Kconfig       | 2 +-
 scripts/ksymoops/README  | 5 ++---
 scripts/package/builddeb | 4 ++--
 6 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c45c02bc6082..0a4df79c0823 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10068,7 +10068,7 @@ W:	http://sourceforge.net/projects/accel-pptp
 PREEMPTIBLE KERNEL
 M:	Robert Love <rml@tech9.net>
 L:	kpreempt-tech@lists.sourceforge.net
-W:	ftp://ftp.kernel.org/pub/linux/kernel/people/rml/preempt-kernel
+W:	https://www.kernel.org/pub/linux/kernel/people/rml/preempt-kernel
 S:	Supported
 F:	Documentation/preempt-locking.txt
 F:	include/linux/preempt.h
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index f744de7a0f9b..7b608cf2516f 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -219,7 +219,7 @@ config BLK_DEV_LOOP
 
 	  To use the loop device, you need the losetup utility, found in the
 	  util-linux package, see
-	  <ftp://ftp.kernel.org/pub/linux/utils/util-linux/>.
+	  <https://www.kernel.org/pub/linux/utils/util-linux/>.
 
 	  The loop device driver can also be used to "hide" a file system in
 	  a disk partition, floppy, or regular file, either using encryption
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index b7767da50c26..585ff3284bf5 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -115,7 +115,7 @@ config MD_RAID10
 
 	  RAID-10 requires mdadm-1.7.0 or later, available at:
 
-	  ftp://ftp.kernel.org/pub/linux/utils/raid/mdadm/
+	  https://www.kernel.org/pub/linux/utils/raid/mdadm/
 
 	  If unsure, say Y.
 
diff --git a/fs/autofs4/Kconfig b/fs/autofs4/Kconfig
index 1204d6384d39..44727bf18297 100644
--- a/fs/autofs4/Kconfig
+++ b/fs/autofs4/Kconfig
@@ -7,7 +7,7 @@ config AUTOFS4_FS
 	  automounter (amd), which is a pure user space daemon.
 
 	  To use the automounter you need the user-space tools from
-	  <ftp://ftp.kernel.org/pub/linux/daemons/autofs/v4/>; you also
+	  <https://www.kernel.org/pub/linux/daemons/autofs/v4/>; you also
 	  want to answer Y to "NFS file system support", below.
 
 	  To compile this support as a module, choose M here: the module will be
diff --git a/scripts/ksymoops/README b/scripts/ksymoops/README
index f6cb06e3f30e..413043980127 100644
--- a/scripts/ksymoops/README
+++ b/scripts/ksymoops/README
@@ -1,8 +1,7 @@
 ksymoops has been removed from the kernel.  It was always meant to be a
 free standing utility, not linked to any particular kernel version.
 The latest version can be found in
-ftp://ftp.<country>.kernel.org/pub/linux/utils/kernel/ksymoops together
-with patches to other utilities in order to give more accurate Oops
-debugging.
+https://www.kernel.org/pub/linux/utils/kernel/ksymoops together with patches to
+other utilities in order to give more accurate Oops debugging.
 
 Keith Owens <kaos@ocs.com.au> Sat Jun 19 10:30:34 EST 1999
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 3c575cd07888..676fc10c9514 100755
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -262,8 +262,8 @@ EOF
 cat <<EOF > debian/copyright
 This is a packacked upstream version of the Linux kernel.
 
-The sources may be found at most Linux ftp sites, including:
-ftp://ftp.kernel.org/pub/linux/kernel
+The sources may be found at most Linux archive sites, including:
+https://www.kernel.org/pub/linux/kernel
 
 Copyright: 1991 - 2015 Linus Torvalds and others.
 
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe autofs" in
