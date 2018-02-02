From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 06/19] manpage: add prompt in --zero-superblock against clustered raid
Date: Fri,  2 Feb 2018 14:10:50 +0800
Message-ID: <1517551863-1511-7-git-send-email-zlliu@suse.com>
References: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Clustered raid would be damaged if calls --zero-superblock
incorrectly, so add prompt in --zero-superblock chapter of
manpage. Such as: cluster node1 has assembled cluster-md,
but calls --zero-superblock in other cluster node.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 mdadm.8.in | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mdadm.8.in b/mdadm.8.in
index f0fd1fc..e6befeb 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1691,6 +1691,10 @@ overwritten with zeros.  With
 the block where the superblock would be is overwritten even if it
 doesn't appear to be valid.
 
+.B Note:
+Be careful to call \-\-zero\-superblock with clustered raid, make sure
+array isn't used or assembled in other cluster node before execute it.
+
 .TP
 .B \-\-kill\-subarray=
 If the device is a container and the argument to \-\-kill\-subarray
-- 
2.6.6

