From: Winston Weinert <winston@ml1.net>
Subject: [PATCH v2] mdadm/md.4: update path to in-kernel-tree documentation
Date: Wed, 22 Jul 2020 08:33:22 -0500
Message-ID: <20200722133321.8512-1-winston@ml1.net>
References: <20200718103314.14549-1-winstonml1.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200718103314.14549-1-winstonml1.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes Sorensen <jes@trained-monkey.org>, Winston Weinert <winston@ml1.net>
List-Id: linux-raid.ids

Documentation/md.txt was renamed to Documentation/admin-guide/md.rst
in linux commit 9d85025b0418163fae079c9ba8f8445212de8568 (Oct 26,
2016).

Signed-off-by: Winston Weinert <winston@ml1.net>
---
I am sending this updated patch which includes a sign-off, fixes a
commit message typo, and CC's Jes Sorensen. I hope it is up to
standards.

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
