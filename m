From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 12/13] mdadm/test: did basic improvement for 05r1-n3-bitmapfile
Date: Fri,  1 Dec 2017 17:48:13 +0800
Message-ID: <1512121694-18168-13-git-send-email-zlliu@suse.com>
References: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Clean the code style.
Add sleep after add new device so that udev could
have enough time to execute.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 tests/05r1-n3-bitmapfile | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/tests/05r1-n3-bitmapfile b/tests/05r1-n3-bitmapfile
index f1c3f1e..b7002dd 100644
--- a/tests/05r1-n3-bitmapfile
+++ b/tests/05r1-n3-bitmapfile
@@ -6,8 +6,10 @@
 #
 bmf=$targetdir/bitmap
 rm -f $bmf
-mdadm --create -e0.90 --run $md0 --level=1 -n3 --delay=1  --bitmap $bmf $dev1 $dev2 $dev3
+mdadm --create -e0.90 --run $md0 --level=1 -n3 --delay=1 --bitmap $bmf $dev1 $dev2 $dev3
 check wait
+check raid1
+check state UUU
 testdev $md0 1 $mdsize0 64
 mdadm -S $md0
 
@@ -18,8 +20,9 @@ sleep 4
 dirty2=`mdadm -X $bmf | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
 if [ $dirty1 -lt 400 -o $dirty2 -ne 0 ]
-then  echo >&2 "ERROR bad 'dirty' counts: $dirty1 and $dirty2"
-  exit 1
+then
+	echo >&2 "ERROR bad 'dirty' counts: $dirty1 and $dirty2"
+	exit 1
 fi
 mdadm $md0 -f $dev2
 testdev $md0 1 $mdsize0 64
@@ -27,17 +30,20 @@ sleep 4
 dirty3=`mdadm -X $bmf | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 if [ $dirty3 -lt 400 ]
 then
-   echo >&2 "ERROR dirty count $dirty3 is too small"
-   exit 2
+	echo >&2 "ERROR dirty count $dirty3 is too small"
+	exit 2
 fi
-
 mdadm -S $md0
 
 mdadm --assemble -R $md0 --bitmap=$bmf $dev1 $dev3
 check nosync
 mdadm --zero-superblock $dev2
 mdadm $md0 --add $dev2
+sleep 1
 check recovery
+check wait
+check raid1
+check state UUU
 
 dirty4=`mdadm -X $bmf | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 check wait
@@ -45,9 +51,10 @@ sleep 4
 dirty5=`mdadm -X $bmf | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
 if [ $dirty4 -lt 400 -o $dirty5 -ne 0 ]
-then echo echo >&2 "ERROR bad 'dirty' counts at end: $dirty4 $dirty5"
-  exit 1
+then
+	echo >&2 "ERROR bad 'dirty' counts at end: $dirty4 $dirty5"
+	exit 1
 fi
-
 mdadm -S $md0
+
 exit 0
-- 
1.8.5.6

