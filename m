From: Kinga Tanska <kinga.tanska@intel.com>
Subject: [PATCH] Block overwriting existing links while manual assembly
Date: Wed, 27 May 2020 09:14:43 +0200
Message-ID: <20200527071443.20998-1-kinga.tanska@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com
List-Id: linux-raid.ids

Manual assembly with existing link caused overwriting
this link. Add checking link and block this situation.

Change-Id: I29ef58636e8fd8583bcaef1b28b6cf2edec385ef
Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Assemble.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Assemble.c b/Assemble.c
index 6b5a7c8e..92616251 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1482,6 +1482,10 @@ try_again:
 				name = content->name;
 			break;
 		}
+		if (mddev && map_by_name(&map, mddev) != NULL) {
+			pr_err("Cannot create device with %s because is in use\n", mddev);
+			goto out;
+		}
 		if (!auto_assem)
 			/* If the array is listed in mdadm.conf or on
 			 * command line, then we trust the name
-- 
2.16.4
