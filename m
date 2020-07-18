From: Winston Weinert <winston@ml1.net>
Subject: [PATCH] mdadm/md.4: update path to in-kernel-tree documentation
Date: Sat, 18 Jul 2020 05:33:15 -0500
Message-ID: <20200718103314.14549-1-winston@ml1.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Winston Weinert <winston@ml1.net>
List-Id: linux-raid.ids

Documentation/md.txt was renamed to Documentation/admin/guide/md.rst
in linux commit 9d85025b0418163fae079c9ba8f8445212de8568 (Oct 26,
2016).
---
 md.4 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/md.4 b/md.4
index 0712af2..aecff38 100644
--- a/md.4
+++ b/md.4
@@ -1061,7 +1061,7 @@ which contains various files for providing access to information about
 the array.
 
 This interface is documented more fully in the file
-.B Documentation/md.txt
+.B Documentation/admin-guide/md.rst
 which is distributed with the kernel sources.  That file should be
 consulted for full documentation.  The following are just a selection
 of attribute files that are available.
-- 
2.26.2
