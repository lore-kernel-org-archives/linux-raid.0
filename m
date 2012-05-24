From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] Increase minimum chunk size in testsuite to 64kB
Date: Thu, 24 May 2012 15:10:47 +1000
Message-ID: <20120524151047.7a011be9@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When running the mdadm testsuite on ppc64 with a 64kB page size I
see a couple of failures because the chunk size is smaller than a
page.

Bump the chunksize to 64kB to fix these failures.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/tests/02r5grow b/tests/02r5grow
index f9fd571..b91ffcd 100644
--- a/tests/02r5grow
+++ b/tests/02r5grow
@@ -2,7 +2,7 @@
 
 # create a small raid5 array, make it larger.  Then make it smaller
 
-mdadm -CR $md0 -e0.90 --level raid5 --chunk=32 --raid-disks 3 --size $[size/2] $dev1 $dev2 $dev3 
+mdadm -CR $md0 -e0.90 --level raid5 --chunk=64 --raid-disks 3 --size $[size/2] $dev1 $dev2 $dev3 
 check wait
 check state UUU
 testdev $md0 2 $[size/2] 32
diff --git a/tests/02r6grow b/tests/02r6grow
index 3f53904..38c7781 100644
--- a/tests/02r6grow
+++ b/tests/02r6grow
@@ -2,7 +2,7 @@
 
 # create a small raid6 array, make it larger.  Then make it smaller
 
-mdadm -CR $md0 -e 0.90 --level raid6 --chunk=32 --raid-disks 4 --size $[size/2] $dev1 $dev2 $dev3 $dev4 
+mdadm -CR $md0 -e 0.90 --level raid6 --chunk=64 --raid-disks 4 --size $[size/2] $dev1 $dev2 $dev3 $dev4 
 check wait
 check state UUUU
 testdev $md0 2 $[size/2] 32
