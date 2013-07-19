From: mwilck@arcor.de
Subject: [PATCH 4/6] tests/10ddf-create: create RAID5 first
Date: Fri, 19 Jul 2013 21:04:13 +0200
Message-ID: <1374260655-5788-5-git-send-email-mwilck@arcor.de>
References: <1374260655-5788-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374260655-5788-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Let the first created array be RAID5 rather than RAID0. This makes
the test harder than before, because everything after the first
Create has do be done indirectly through mdmon.
---
 tests/10ddf-create |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tests/10ddf-create b/tests/10ddf-create
index 9eb1c5c..50c85ae 100644
--- a/tests/10ddf-create
+++ b/tests/10ddf-create
@@ -11,18 +11,18 @@
 set -e
 
 mdadm -CR /dev/md/ddf0 -e ddf -n 5 $dev8 $dev9 $dev10 $dev11 $dev12
-mdadm -CR r0 -l0 -n5 /dev/md/ddf0 -z 5000
-if mdadm -CR r0 -l1 -n2 /dev/md/ddf0 -z 5000
+mdadm -CR r5 -l5 -n5 /dev/md/ddf0 -z 5000
+if mdadm -CR r5 -l1 -n2 /dev/md/ddf0 -z 5000
 then echo >&2 create with same name should fail ; exit 1
 fi
 mdadm -CR r10 -l10 -n4 -pn2 /dev/md/ddf0 -z 5000
 mdadm -CR r1 -l1 -n2 /dev/md/ddf0
-mdadm -CR r5 -l5 -n3 /dev/md/ddf0
-testdev /dev/md/r0 5 5000 512
+mdadm -CR r0 -l0 -n3 /dev/md/ddf0
+testdev /dev/md/r5 4 5000 512
 testdev /dev/md/r10 2 5000 512
 # r0/r10 will use 4608 due to chunk size, so that leaves 23552 for the rest
 testdev /dev/md/r1 1 23552 64
-testdev /dev/md/r5 2 23552 512
+testdev /dev/md/r0 3 23552 512
 dd if=/dev/sda of=/dev/md/r0 || true
 dd if=/dev/sda of=/dev/md/r10 || true
 dd if=/dev/sda of=/dev/md/r1 || true
-- 
1.7.1
