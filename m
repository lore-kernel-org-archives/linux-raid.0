From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] manpage: bad block support for IMSM
Date: Thu, 18 May 2017 15:10:41 +0200
Message-ID: <1495113041-19753-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

---
 mdadm.8.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index fb99a5c..38a08d4 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2210,8 +2210,8 @@ option. In any case space for a bitmap will be reserved so that one
 can be added later with
 .BR "\-\-grow \-\-bitmap=internal" .
 
-If the metadata type supports it (currently only 1.x metadata), space
-will be allocated to store a bad block list.  This allows a modest
+If the metadata type supports it (currently only 1.x and IMSM metadata),
+space will be allocated to store a bad block list.  This allows a modest
 number of bad blocks to be recorded, allowing the drive to remain in
 service while only partially functional.
 
-- 
1.8.3.1

