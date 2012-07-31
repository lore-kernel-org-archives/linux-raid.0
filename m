From: harald@redhat.com
Subject: [PATCH] udev-rules: prevent systemd from mount devices before they are ready.
Date: Tue, 31 Jul 2012 10:53:47 +0200
Message-ID: <1343724827-2179-1-git-send-email-harald@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, Harald Hoyer <harald@redhat.com>
List-Id: linux-raid.ids

From: Harald Hoyer <harald@redhat.com>

In the "add" uevent, ATTR{md/array_state} does not exist, so the next
rule does not kick in.

When an array is assembled incrementally, systemd might see it
before it is ready, try to mount it, fail, and give up.
Result is that array doesn't get mounted.

If we ask udev to tell systemd that it isn't ready yet in this
case, systemd waits until it is ready, and all are happy.
---
 udev-md-raid.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/udev-md-raid.rules b/udev-md-raid.rules
index 814c897..da9d3c5 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -27,7 +27,7 @@ ENV{DEVTYPE}=="partition", GOTO="md_ignore_state"
 # container devices have a metadata version of e.g. 'external:ddf' and
 # never leave state 'inactive'
 ATTR{md/metadata_version}=="external:[A-Za-z]*", ATTR{md/array_state}=="inactive", GOTO="md_ignore_state"
-TEST!="md/array_state", GOTO="md_end"
+TEST!="md/array_state", ENV{SYSTEMD_READY}="0", GOTO="md_end"
 ATTR{md/array_state}=="|clear|inactive", ENV{SYSTEMD_READY}="0", GOTO="md_end"
 LABEL="md_ignore_state"
 
-- 
1.7.11.2

