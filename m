From: Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH] Create new md devices consistently
Date: Tue, 23 Oct 2012 15:04:00 -0700
Message-ID: <1351029840-5030-1-git-send-email-jmaggard10@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Justin Maggard <jmaggard10@gmail.com>
List-Id: linux-raid.ids

 Creating a new MD device with the name 'd-0' results in some
 unexpected behavior, since mdadm sees that '-0' is a
 non-negative integer and therefore makes a "partitionable"
 device (/dev/md_d0).  This is not the expected behavior,
 since the documentation mentions 'dN' several places, and a
 reboot brings it up as /dev/md/d-0.  Make this consistent
 by ensuring that the character immediately following 'd' is
 a digit during creation.

---
 mdopen.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mdopen.c b/mdopen.c
index 61eda81..24188df 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -207,7 +207,10 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 			char *ep;
 			if (cname[0] == 'd')
 				sp++;
-			num = strtoul(sp, &ep, 10);
+			if (isdigit(sp[0]))
+				num = strtoul(sp, &ep, 10);
+			else
+				ep = sp;
 			if (ep == sp || *ep || num < 0)
 				num = -1;
 			else if (cname[0] == 'd')
-- 
1.7.9.5

