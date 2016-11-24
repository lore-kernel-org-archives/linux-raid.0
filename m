From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 7/7] Man page changes for --rwh-policy
Date: Thu, 24 Nov 2016 13:29:52 +0100
Message-ID: <20161124122952.16529-8-artur.paszkiewicz@intel.com>
References: <20161124122952.16529-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161124122952.16529-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Describe the usage of the --rwh-policy parameter in Create and Misc
modes.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 mdadm.8.in | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mdadm.8.in b/mdadm.8.in
index 3c0c58f..9295dcb 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -996,6 +996,26 @@ simultaneously. If not specified, this defaults to 4.
 Specify journal device for the RAID-4/5/6 array. The journal device
 should be a SSD with reasonable lifetime.
 
+.TP
+.BR \-\-rwh-policy=
+Specify the RAID Write Hole policy for a RAID-4/5/6 array. Currently supported
+options are
+.BR off ,
+.B journal
+and
+.BR ppl .
+
+The
+.B journal
+policy is implicitly selected when using
+.BR \-\-write-journal .
+
+The
+.B ppl
+policy (Partial Parity Log) is a mechanism that can be used with RAID5 arrays.
+This feature prevents data loss by keeping parity consistent with data even in
+case of drive failure during dirty shutdown. PPL is stored in the metadata
+region of RAID member drives, no additional journal drive is needed.
 
 .SH For assemble:
 
@@ -1675,6 +1695,14 @@ can be found it
 under
 .BR "SCRUBBING AND MISMATCHES" .
 
+.TP
+.BR \-\-rwh-policy=
+Change the RAID Write Hole policy for a RAID-4/5/6 array at runtime. For
+details about the RWH policies, see the description for the same parameter
+under
+.B Create mode
+options.
+
 .SH For Incremental Assembly mode:
 .TP
 .BR \-\-rebuild\-map ", " \-r
-- 
2.10.1

