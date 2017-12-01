From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 13/13] mdadm/test: Change check nosync as check recovery in 05r1-re-add-nosuper
Date: Fri,  1 Dec 2017 17:48:14 +0800
Message-ID: <1512121694-18168-14-git-send-email-zlliu@suse.com>
References: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

The commit: 091e8e6e061a (Manage: Remove all references
to md_get_version()) has been result in the case failure
due to deprecate the API md_get_version(). So modify the
test case to check recovery when execute re-add.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 tests/05r1-re-add-nosuper | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tests/05r1-re-add-nosuper b/tests/05r1-re-add-nosuper
index 058d602..030acdf 100644
--- a/tests/05r1-re-add-nosuper
+++ b/tests/05r1-re-add-nosuper
@@ -9,6 +9,8 @@ rm -f $bmf
 mdadm -B $md0 -l1 -n2 -b$bmf -d1 $dev1 $dev2
 check resync
 check wait
+check state UU
+check raid1
 testdev $md0 1 $size 1
 sleep 4
 
@@ -16,7 +18,11 @@ mdadm $md0 -f $dev2
 sleep 1
 mdadm $md0 -r $dev2
 mdadm $md0 --re-add $dev2
-check nosync
+sleep 1
+check recovery
+check wait
+check state UU
+check raid1
 
 mdadm $md0 -f $dev2
 sleep 1
@@ -24,6 +30,8 @@ mdadm $md0 -r $dev2
 testdev $md0 1 $size 1
 mdadm $md0 --re-add $dev2
 check wait
+check state UU
+check raid1
 cmp --bytes=$[$mdsize0*1024] $dev1 $dev2
 
 mdadm $md0 -f $dev2; sleep 1
@@ -31,8 +39,14 @@ mdadm $md0 -r $dev2
 if dd if=/dev/zero of=$md0 ; then : ; fi
 blockdev --flushbufs $md0 # make sure writes have been sent
 mdadm $md0 --re-add $dev2
+sleep 1
 check recovery
 check wait
+check state UU
+check raid1
 # should BLKFLSBUF and then read $dev1/$dev2...
 cmp --bytes=$[$mdsize0*1024] $file1 $file2
 mdadm -S $md0
+rm -f $bmf
+
+exit 0
-- 
1.8.5.6

