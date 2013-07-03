From: mwilck@arcor.de
Subject: [PATCH 27/27] tests/10ddf-create: add RAID 10 array
Date: Wed,  3 Jul 2013 22:28:07 +0200
Message-ID: <1372883287-8859-28-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This patch adds RAID10 support to the DDF test script.
It actually passes!

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 tests/10ddf-create |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tests/10ddf-create b/tests/10ddf-create
index 3055a5d..6f1f51d 100644
--- a/tests/10ddf-create
+++ b/tests/10ddf-create
@@ -14,17 +14,21 @@ mdadm -CR r0 -l0 -n5 /dev/md/ddf0 -z 5000
 if mdadm -CR r0 -l1 -n2 /dev/md/ddf0 -z 5000
 then echo >&2 create with same name should fail ; exit 1
 fi
+mdadm -CR r10 -l10 -n4 -pn2 /dev/md/ddf0 -z 5000
 mdadm -CR r1 -l1 -n2 /dev/md/ddf0
 mdadm -CR r5 -l5 -n3 /dev/md/ddf0
 testdev /dev/md/r0 5 5000 512
-# r0 will use 4608 due to chunk size, so that leaves 28160 for the rest
-testdev /dev/md/r1 1 28160 64
-testdev /dev/md/r5 2 28160 512
+testdev /dev/md/r10 2 5000 512
+# r0/r10 will use 4608 due to chunk size, so that leaves 23552 for the rest
+testdev /dev/md/r1 1 23552 64
+testdev /dev/md/r5 2 23552 512
 dd if=/dev/sda of=/dev/md/r0 || true
+dd if=/dev/sda of=/dev/md/r10 || true
 dd if=/dev/sda of=/dev/md/r1 || true
 dd if=/dev/sda of=/dev/md/r5 || true
 
 s0=`sha1sum /dev/md/r0`
+s10=`sha1sum /dev/md/r10`
 s1=`sha1sum /dev/md/r1`
 s5=`sha1sum /dev/md/r5`
 
@@ -35,12 +39,16 @@ mdadm -I /dev/md/ddf0
 
 udevadm settle
 s0a=`sha1sum /dev/md/r0`
+s10a=`sha1sum /dev/md/r10`
 s1a=`sha1sum /dev/md/r1`
 s5a=`sha1sum /dev/md/r5`
 
 if [ "$s0" != "$s0a" ]; then
    echo r0 did not match ; exit 1;
 fi
+if [ "$s10" != "$s10a" ]; then
+   echo r10 did not match ; exit 1;
+fi
 if [ "$s1" != "$s1a" ]; then
    echo r1 did not match ; exit 1;
 fi
@@ -50,6 +58,7 @@ fi
 
 # failure status just means it has completed already, so ignore it.
 mdadm --wait /dev/md/r1 || true
+mdadm --wait /dev/md/r10 || true
 mdadm --wait /dev/md/r5 || true
 
 mdadm -Dbs > /var/tmp/mdadm.conf
-- 
1.7.1
