From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 11/13] mdadm/test: did basic improvement for 05r1-internalbitmap
Date: Fri,  1 Dec 2017 17:48:12 +0800
Message-ID: <1512121694-18168-12-git-send-email-zlliu@suse.com>
References: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

clean the code style.
add sleep after add new device so that udev could
have enough time to execute.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 tests/05r1-internalbitmap | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/tests/05r1-internalbitmap b/tests/05r1-internalbitmap
index dd7232a..587d5d8 100644
--- a/tests/05r1-internalbitmap
+++ b/tests/05r1-internalbitmap
@@ -2,8 +2,10 @@
 #
 # create a raid1 with an internal bitmap
 #
-mdadm --create -e0.90 --run $md0 --level=1 -n2 --delay=1  --bitmap internal --bitmap-chunk=4 $dev1 $dev2
+mdadm --create -e0.90 --run $md0 --level=1 -n2 --delay=1 --bitmap internal --bitmap-chunk=4 $dev1 $dev2
 check wait
+check raid1
+check state UU
 testdev $md0 1 $mdsize0 64
 mdadm -S $md0
 
@@ -14,8 +16,9 @@ sleep 4
 dirty2=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
 if [ $dirty1 -lt 400 -o $dirty2 -ne 0 ]
-then  echo >&2 "ERROR bad 'dirty' counts: $dirty1 and $dirty2"
-  exit 1
+then
+	echo >&2 "ERROR bad 'dirty' counts: $dirty1 and $dirty2"
+	exit 1
 fi
 mdadm $md0 -f $dev1
 testdev $md0 1 $mdsize0 64
@@ -23,16 +26,19 @@ sleep 4
 dirty3=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 if [ $dirty3 -lt 400 ]
 then
-   echo >&2 "ERROR dirty count $dirty3 is too small"
-   exit 2
+	echo >&2 "ERROR dirty count $dirty3 is too small"
+	exit 2
 fi
-
 mdadm -S $md0
 
 mdadm --assemble -R $md0  $dev2
 mdadm --zero-superblock $dev1
 mdadm $md0 --add $dev1
+sleep 1
 check recovery
+check wait
+check raid1
+check state UU
 
 dirty4=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 check wait
@@ -40,8 +46,10 @@ sleep 4
 dirty5=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
 if [ $dirty4 -lt 400 -o $dirty5 -ne 0 ]
-then echo echo >&2 "ERROR bad 'dirty' counts at end: $dirty4 $dirty5"
-  exit 1
+then
+	echo echo >&2 "ERROR bad 'dirty' counts at end: $dirty4 $dirty5"
+	exit 1
 fi
-
 mdadm -S $md0
+
+exit 0
-- 
1.8.5.6

