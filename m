From: dean gaudet <dean@arctic.org>
Subject: Re: [patch] improve stripe_cache_size documentation
Date: Sun, 30 Dec 2007 14:32:05 -0800 (PST)
Message-ID: <alpine.DEB.0.999999.0712301431270.21851@twinlark.arctic.org>
References: <alpine.DEB.0.999999.0712291305270.5207@twinlark.arctic.org> <52471.88.217.76.64.1199012468.squirrel@www.e18.physik.tu-muenchen.de> <alpine.DEB.0.999999.0712301016290.5207@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.999999.0712301016290.5207@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Sun, 30 Dec 2007, dean gaudet wrote:

> On Sun, 30 Dec 2007, Thiemo Nagel wrote:
> 
> > >    stripe_cache_size  (currently raid5 only)
> > 
> > As far as I have understood, it applies to raid6, too.
> 
> good point... and raid4.
> 
> here's an updated patch.

and once again with a typo fix.  oops.

-dean

Signed-off-by: dean gaudet <dean@arctic.org>

Index: linux/Documentation/md.txt
===================================================================
--- linux.orig/Documentation/md.txt	2007-12-29 13:01:25.000000000 -0800
+++ linux/Documentation/md.txt	2007-12-30 14:30:40.000000000 -0800
@@ -435,8 +435,14 @@
 
 These currently include
 
-  stripe_cache_size  (currently raid5 only)
+  stripe_cache_size  (raid4, raid5 and raid6)
       number of entries in the stripe cache.  This is writable, but
       there are upper and lower limits (32768, 16).  Default is 128.
-  strip_cache_active (currently raid5 only)
+
+      The stripe cache memory is locked down and not available for other uses.
+      The total size of the stripe cache is determined by this formula:
+
+        PAGE_SIZE * raid_disks * stripe_cache_size
+
+  stripe_cache_active (raid4, raid5 and raid6)
       number of active entries in the stripe cache

