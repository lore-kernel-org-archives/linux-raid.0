From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH v1 2/2] mdadm/manpage:clustered arrays don't support array-size yet
Date: Wed, 12 Apr 2017 16:37:27 +0800
Message-ID: <1491986247-16706-1-git-send-email-zlliu@suse.com>
References: <1d2103a9-a7f2-54f8-ec51-ad0a04c6d9ae@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1d2103a9-a7f2-54f8-ec51-ad0a04c6d9ae@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Update manpage for array-size section:
Clustered arrays don't support the --array-size yet.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 mdadm.8.in | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mdadm.8.in b/mdadm.8.in
index f10a8b8..fb99a5c 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -541,6 +541,8 @@ A value of
 restores the apparent size of the array to be whatever the real
 amount of available space is.
 
+Clustered arrays do not support this parameter yet.
+
 .TP
 .BR \-c ", " \-\-chunk=
 Specify chunk size of kilobytes.  The default when creating an
-- 
2.6.6

