From: Xiao Ni <xni@redhat.com>
Subject: [MDADM PATCH] A sanity check for missing device
Date: Fri,  2 Feb 2018 11:57:38 +0800
Message-ID: <1517543858-6937-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com
List-Id: linux-raid.ids

If we don't check the number of missing devices and create raid device
with all missing devices, it gives the error message:
[root@storageqe-15 mdadm]# ./test --tests=00raid1
Testing on linux-3.10.0-830.el7.x86_64 kernel
tests/00raid1...
ERROR: dmesg prints errors when testing 00raid1!

FAILED - see /var/tmp/00raid1.log and /var/tmp/fail00raid1.log for details

After checking the missing devices number, the test case can pass. And it
gives a error log in log file:
++ /root/mdadm/mdadm --quiet -CR /dev/md0 -l 1 -n2 missing missing --auto=yes
++ rv=1
++ case  in
++ cat /var/tmp/stderr
mdadm: Subdevs can't be all missing

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/00raid1 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/00raid1 b/tests/00raid1
index c93465d..752bbbf 100644
--- a/tests/00raid1
+++ b/tests/00raid1
@@ -3,6 +3,9 @@
 # test version0, version1, and no super
 # test resync and recovery.
 
+# It's just a sanity check. This command shouldn't run successfully
+mdadm -CR $md0 -l 1 -n2 missing missing
+
 mdadm -CR $md0 -l 1 -n2 $dev0 $dev1
 check resync
 check raid1
-- 
2.7.4

