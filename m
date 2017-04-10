From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 1/2] mdadm/manpage:update description for readonly in manpage
Date: Mon, 10 Apr 2017 16:04:37 +0800
Message-ID: <1491811478-9234-1-git-send-email-zlliu@suse.com>
References: <1491811296-9118-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1491811296-9118-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

update readonly/readwrite in man page:
Currently both the readwrite and readonly are worked well,
thus updates description for them.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 mdadm.8.in | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 744c12b..f006cf5 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -925,7 +925,8 @@ will not try to be so clever.
 Start the array
 .B read only
 rather than read-write as normal.  No writes will be allowed to the
-array, and no resync, recovery, or reshape will be started.
+array, and no resync, recovery, or reshape will be started. It works with
+Create, Assemble, Manage and Misc mode.
 
 .TP
 .BR \-a ", " "\-\-auto{=yes,md,mdp,part,p}{NN}"
@@ -2232,7 +2233,7 @@ be in use.
 
 .TP
 .B \-\-readonly
-start the array readonly \(em not supported yet.
+start the array with readonly status.
 
 .SH MANAGE MODE
 .HP 12
@@ -2438,12 +2439,11 @@ This will fully activate a partially assembled md array.
 
 .TP
 .B \-\-readonly
-This will mark an active array as read-only, providing that it is
-not currently being used.
+This will set an active array as read-only status.
 
 .TP
 .B \-\-readwrite
-This will change a
+This will change an
 .B readonly
 array back to being read/write.
 
-- 
2.6.6

