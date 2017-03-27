From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH 1/5] udev-md-raid-assembly.rules: Skip non-ready
 devices
Date: Mon, 27 Mar 2017 14:36:55 +1100
Message-ID: <149058581543.15679.11571755580221625885.stgit@noble>
References: <149058575542.15679.9804611071393072863.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149058575542.15679.9804611071393072863.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From: Hannes Reinecke <hare@suse.de>

If a device isn't fully initialized (e.g if it should be
handled by multipathing) it should not be considered for
md/RAID auto-assembly.  Doing so can cause incorrect results
such as causing multipath to fail during startup.

There is a convention that the udev environment variable
SYSTEMD_READY be set to zero for such devices.  So change
the mdadm rules to ignore devices with SYSTEMD_READY==0.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: NeilBrown <neilb@suse.com>
---
 udev-md-raid-assembly.rules |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
index d0d440a6394c..8ca232a44b1f 100644
--- a/udev-md-raid-assembly.rules
+++ b/udev-md-raid-assembly.rules
@@ -7,6 +7,9 @@ ENV{ANACONDA}=="?*", GOTO="md_inc_end"
 
 SUBSYSTEM!="block", GOTO="md_inc_end"
 
+# skip non-initialized devices
+ENV{SYSTEMD_READY}=="0", GOTO="md_inc_end"
+
 # handle potential components of arrays (the ones supported by md)
 ENV{ID_FS_TYPE}=="linux_raid_member", GOTO="md_inc"
 


