From: mwilck@arcor.de
Subject: [PATCH 8/8] tests/10ddf-create: omit log output check
Date: Mon, 25 Mar 2013 23:11:13 +0000 (UTC)
Message-ID: <1382695659-6231-9-git-send-email-mwilck@arcor.de>
References: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Date: Fri, 25 Oct 2013 12:07:39 +0200
In-Reply-To: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

The test script was counting output lines - its expectations
don't match the current code any more. Remove this pointless
test.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 tests/10ddf-create |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/tests/10ddf-create b/tests/10ddf-create
index 0925612..3055a5d 100644
--- a/tests/10ddf-create
+++ b/tests/10ddf-create
@@ -67,11 +67,7 @@ mdadm -Ss
 # and now assemble fully incrementally.
 for i in  $dev8 $dev9 $dev10 $dev11 $dev12
 do 
-  #./mdadm -I $i -vv 2>&1 | wc -l > /tmp/cnt
-  ./mdadm -I $i 2> /tmp/thing
-  wc -l < /tmp/thing > /tmp/cnt
-  # should find container and 2 devices, so 3 lines.
-  [ `cat /tmp/cnt` -eq 3 ]
+   mdadm -I $i -c /var/tmp/mdadm.conf
 done
 check nosync
 udevadm settle
-- 
1.7.1
