From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm:add man page for --symlinks
Date: Mon,  6 Mar 2017 10:39:57 +0800
Message-ID: <1488767997-21594-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

In build and create mode:
--symlinks
	Auto creation of symlinks in /dev to /dev/md, option --symlinks
	must be 'no' or 'yes' and work with --create and --build.
In assemble mode:
--symlinks
	See this option under Create and Build options.

Signed-off-by: Zhilong Liu <zlliu@suse.com>

diff --git a/mdadm.8.in b/mdadm.8.in
index 1e4f91d..df1d460 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1015,6 +1015,11 @@ simultaneously. If not specified, this defaults to 4.
 Specify journal device for the RAID-4/5/6 array. The journal device
 should be a SSD with reasonable lifetime.
 
+.TP
+.BR \-\-symlinks
+Auto creation of symlinks in /dev to /dev/md, option --symlinks must
+be 'no' or 'yes' and work with --create and --build.
+
 
 .SH For assemble:
 
@@ -1291,6 +1296,10 @@ Reshape can be continued later using the
 .B \-\-continue
 option for the grow command.
 
+.TP
+.BR \-\-symlinks
+See this option under Create and Build options.
+
 .SH For Manage mode:
 
 .TP
-- 
2.6.6

