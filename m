From: dean gaudet <dean@arctic.org>
Subject: [patch] improve stripe_cache_size documentation
Date: Sat, 29 Dec 2007 13:07:08 -0800 (PST)
Message-ID: <alpine.DEB.0.999999.0712291305270.5207@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Document the amount of memory used by the stripe cache and the fact that 
it's tied down and unavailable for other purposes (right?).  thanks to Dan 
Williams for the formula.

-dean

Signed-off-by: dean gaudet <dean@arctic.org>

Index: linux/Documentation/md.txt
===================================================================
--- linux.orig/Documentation/md.txt	2007-12-29 13:01:25.000000000 -0800
+++ linux/Documentation/md.txt	2007-12-29 13:04:17.000000000 -0800
@@ -438,5 +438,11 @@
   stripe_cache_size  (currently raid5 only)
       number of entries in the stripe cache.  This is writable, but
       there are upper and lower limits (32768, 16).  Default is 128.
+
+      The stripe cache memory is locked down and not available for other uses.
+      The total size of the stripe cache is determined by this formula:
+
+        PAGE_SIZE * raid_disks * stripe_cache_size
+
   strip_cache_active (currently raid5 only)
       number of active entries in the stripe cache
