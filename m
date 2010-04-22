From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 13/13] manual update for subarray delete/rename
Date: Thu, 22 Apr 2010 23:13:20 +0100
Message-ID: <66C59AD0932712458090B447266D638CD405E3C1@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Adds description for subarray delete and subarray rename switches.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 mdadm.8 |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/mdadm.8 b/mdadm.8
index 4edfc41..edc511c 100644
--- a/mdadm.8
+++ b/mdadm.8
@@ -1173,6 +1173,20 @@ the block where the superblock would be is overwritten even if it
 doesn't appear to be valid.
 
 .TP
+.B \-\-zero\-subarray
+Removes references to IMSM subarray identified by member id, name
+or UUID. When parent container is running either this container or
+list of devices consistent with container devices needs to be given.
+Otherwise any subset of devices can be passed, but result of future
+assembly can be unpredictable. You may wish to pass an optional value
+defining member index of array to be deleted. The identity can also
+be selected with the
+.B \-\-uuid
+option, or the
+.B \-\-name
+option.
+
+.TP
 .BR \-t ", " \-\-test
 When used with
 .BR \-\-detail ,
@@ -1204,6 +1218,19 @@ kernel handles both dirty-clean transitions and resync checkpointing in
 the kernel at shutdown.  No action is taken if safe-mode handling is
 disabled.
 
+.TP
+.BR \-U=name ", " \-\-update=name
+Changes serial id of IMSM subarray (renames subarray) identified by name
+or UUID. Needs either container or list of devices consistent
+with container devices to be given (see
+.BR \-\-zero\-subarray )
+. The identity can be selected
+with the
+.B \-\-uuid
+option, or the
+.B \-\-name
+option.
+
 .SH For Incremental Assembly mode:
 .TP
 .BR \-\-rebuild\-map ", " \-r
-- 
1.6.4.2


--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski
Software Development Engineer


