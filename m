From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm/md.4: set page-length as 1000 to avoid warnings from grotty
Date: Tue,  9 May 2017 14:25:17 +0800
Message-ID: <20170509062517.20755-1-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

"nroff" ("man") or ("tbl") needs a long page to avoid warnings
from "grotty", set 'pl' as 1000 to fix the following issue.

This command invokes by Makefile rule.
linux-tjrh:~/mdadm # man -l md.4 > test
grotty:<standard input> (<standard input>):5967:
character above first line discarded
... ...

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 md.4 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/md.4 b/md.4
index 5bdf7a7..3a1d677 100644
--- a/md.4
+++ b/md.4
@@ -4,6 +4,7 @@
 .\"   the Free Software Foundation; either version 2 of the License, or
 .\"   (at your option) any later version.
 .\" See file COPYING in distribution for details.
+.if n .pl 1000v
 .TH MD 4
 .SH NAME
 md \- Multiple Device driver aka Linux Software RAID
-- 
2.10.2

