From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/2] Check for multipath module before running multipath tests
Date: Tue, 22 May 2012 18:55:29 +0200
Message-ID: <1337705730-7335-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1337705730-7335-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1337705730-7335-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Some systems do not ship the md multipath module. If not available
simply skip any multipath tests.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 test              |    6 ++++++
 tests/00multipath |    5 +++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/test b/test
index 4f0979e..0679983 100755
--- a/test
+++ b/test
@@ -19,6 +19,12 @@ then
    echo >&2 "test: $mdadm isn't usable."
 fi
 
+# Check whether to run multipath tests
+modprobe multipath 2> /dev/null
+if grep -s 'Personalities : .*multipath' > /dev/null /proc/mdstat ; then
+    MULTIPATH="yes"
+fi
+
 # assume md0, md1, md2 exist in /dev
 md0=/dev/md0 md1=/dev/md1 md2=/dev/md2
 mdp0=/dev/md_d0
diff --git a/tests/00multipath b/tests/00multipath
index bc0429f..84e4d69 100644
--- a/tests/00multipath
+++ b/tests/00multipath
@@ -2,6 +2,11 @@
 #
 # create a multipath, and fail and stuff
 
+if [ "$MULTIPATH" != "yes" ]; then
+  echo -ne 'skipping... '
+  exit 0
+fi
+
 mdadm -CR $md1 -l multipath -n2 $path0 $path1
 
 testdev $md1 1 $mdsize12 1
-- 
1.7.7.6

