From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 2/2] mdadm/manpage:clustered array doesn't support --array-size yet
Date: Mon, 10 Apr 2017 16:04:38 +0800
Message-ID: <1491811478-9234-2-git-send-email-zlliu@suse.com>
References: <1491811296-9118-1-git-send-email-zlliu@suse.com>
 <1491811478-9234-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1491811478-9234-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

update man page for --array-size:
clustered array isn't allowed to change array_sector by now.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 mdadm.8.in | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mdadm.8.in b/mdadm.8.in
index f006cf5..3555516 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -541,6 +541,10 @@ A value of
 restores the apparent size of the array to be whatever the real
 amount of available space is.
 
+The
+.B clustered
+array isn't supported this parameter yet.
+
 .TP
 .BR \-c ", " \-\-chunk=
 Specify chunk size of kilobytes.  The default when creating an
-- 
2.6.6

