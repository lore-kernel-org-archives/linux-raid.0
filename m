From: mwilck@arcor.de
Subject: [PATCH 1/2] select_devices: fix scanning of container members with dev list
Date: Thu, 20 Jun 2013 22:21:04 +0200
Message-ID: <1371759665-5625-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

commit b3908491 "Detail: fix --brief --verbose" introduced a
problem when a mdadm.conf file generated with
"mdadm --Detail --brief --verbose" is later scanned with
"mdadm --Assemble --scan --config=mdadm.conf"

mdadm -Dbv will print a "devices" list now, but because the
container device is not in that list, it won't be considered
for assembly.

This patch fixes that by moving the test for member devices
further down, after the check for a container.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 Assemble.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index c927c20..1f023e8 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -170,13 +170,6 @@ static int select_devices(struct mddev_dev *devlist,
 		if (tmpdev->used > 1)
 			continue;
 
-		if (ident->devices &&
-		    !match_oneof(ident->devices, devname)) {
-			if (report_mismatch)
-				pr_err("%s is not one of %s\n", devname, ident->devices);
-			continue;
-		}
-
 		tst = dup_super(st);
 
 		dfd = dev_open(devname, O_RDONLY);
@@ -365,6 +358,14 @@ static int select_devices(struct mddev_dev *devlist,
 			int rv = 0;
 			struct mddev_ident *match;
 
+			if (ident->devices &&
+			    !match_oneof(ident->devices, devname)) {
+				if (report_mismatch)
+					pr_err("%s is not one of %s\n", devname,
+					       ident->devices);
+				goto loop;
+			}
+
 			content = *contentp;
 			tst->ss->getinfo_super(tst, content, NULL);
 
-- 
1.7.1
