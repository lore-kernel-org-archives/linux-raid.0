From: Jonathan Liu <net147@gmail.com>
Subject: mse->metadata_version segmentation fault
Date: Tue, 12 Apr 2011 18:38:29 +1000
Message-ID: <4DA40F85.4060106@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060008030100020708030107"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------060008030100020708030107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Just wanted to post an additional patch to fix segmentation fault with 
mdadm that was missed by eb28e119b03fd5149886ed516fa4bb006ad3602e.

Regards,
Jonathan

--------------060008030100020708030107
Content-Type: text/plain;
 name="metadata_version.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="metadata_version.patch"

From e8ed972a1d104ebda80cf253a45cd95d96357a6c Mon Sep 17 00:00:00 2001
From: Jonathan Liu <net147@gmail.com>
Date: Tue, 12 Apr 2011 18:28:01 +1000
Subject: [PATCH] 0.90 array do not report the metadata type in /proc/mdstat,
 so we cannot assume that mse->metadata_version is non-NULL.

So add an appropriate check.

Adds an additional check missed by commit eb28e119b03fd5149886ed516fa4bb006ad3602e.
---
 Monitor.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index a3ea724..55aebeb 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -577,7 +577,8 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 			info[i].major = info[i].minor = 0;
 	}
 
-	if (strncmp(mse->metadata_version, "external:", 9) == 0 &&
+	if (mse->metadata_version &&
+	    strncmp(mse->metadata_version, "external:", 9) == 0 &&
 	    is_subarray(mse->metadata_version+9))
 		st->parent_dev =
 			devname2devnum(mse->metadata_version+10);
-- 
1.7.4.4


--------------060008030100020708030107--
