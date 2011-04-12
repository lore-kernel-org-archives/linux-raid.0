From: Jonathan Liu <net147@gmail.com>
Subject: Re: mse->metadata_version segmentation fault
Date: Tue, 12 Apr 2011 19:43:02 +1000
Message-ID: <4DA41EA6.1030203@gmail.com>
References: <4DA40F85.4060106@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080600080006020006080609"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA40F85.4060106@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080600080006020006080609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 12/04/2011 6:38 PM, Jonathan Liu wrote:
> Just wanted to post an additional patch to fix segmentation fault with 
> mdadm that was missed by eb28e119b03fd5149886ed516fa4bb006ad3602e.
Slightly better formatted commit patch attached.

Regards,
Jonathan

--------------080600080006020006080609
Content-Type: text/plain;
 name="metadata_version.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="metadata_version.patch"

From 2dce5f9292bba3cfe1cd89408114087b5df7638f Mon Sep 17 00:00:00 2001
From: Jonathan Liu <net147@gmail.com>
Date: Tue, 12 Apr 2011 18:28:01 +1000
Subject: [PATCH] Monitor: avoid NULL dereference with 0.90 metadata

0.90 array do not report the metadata type in /proc/mdstat, so
we cannot assume that mse->metadata_version is non-NULL.

So add an appropriate check.

This adds an additional check missed by commit
eb28e119b03fd5149886ed516fa4bb006ad3602e.
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


--------------080600080006020006080609--
