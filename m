From: mwilck@arcor.de
Subject: [PATCH 5/6] test: increase number of devices to 13
Date: Fri, 19 Jul 2013 21:04:14 +0200
Message-ID: <1374260655-5788-6-git-send-email-mwilck@arcor.de>
References: <1374260655-5788-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374260655-5788-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

extended DDF/RAID10 tests need 6 disks for DDF.
---
 test |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/test b/test
index 8a6418d..1c5aba1 100755
--- a/test
+++ b/test
@@ -64,7 +64,7 @@ config=/tmp/mdadm.conf
 cleanup() {
 	udevadm settle
 	$mdadm -Ssq 2> /dev/null
-	for d in 0 1 2 3 4 5 6 7  8 9 10 11 12
+	for d in 0 1 2 3 4 5 6 7  8 9 10 11 12 13
 	do
 	    losetup -d /dev/loop$d ; # rm -f $targetdir/mdtest$d
 	    rm -f /dev/disk/by-path/loop*
@@ -80,7 +80,7 @@ do_setup() {
   trap ctrl_c 2
 
   devlist=
-  for d in 0 1 2 3 4 5 6 7 8 9 10 11 12
+  for d in 0 1 2 3 4 5 6 7 8 9 10 11 12 13
   do
     sz=$size
     if [ $d -gt 7 ]; then sz=$ddfsize ; fi
-- 
1.7.1
