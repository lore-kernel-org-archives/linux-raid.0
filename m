From: ross@jose.lug.udel.edu (Ross Vandegrift)
Subject: [PATCH] minor bugfix in expected_spares logic
Date: Mon, 14 Nov 2005 02:03:36 -0500
Message-ID: <20051114070336.GC17105@jose.lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

After implementing syslogging, I noticed that mdadm was logging INFO
level messages that my arrays were missing spares.  Thing is, none of
my arrays have spares.

This patch adds a check for expected_spares != UnSet, so if "spares=0"
is missing from an array, it is not logged.

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37



diff -ur mdadm-2.0/Monitor.c mdadm-2.0-bugfix/Monitor.c
--- mdadm-2.0/Monitor.c	2005-07-06 19:19:53.000000000 -0400
+++ mdadm-2.0-bugfix/Monitor.c	2005-11-14 00:54:13.000000000 -0500
@@ -278,6 +278,7 @@
 
 			if (st->utime == 0 && /* new array */
 			    st->expected_spares > 0 && 
+			    st->expected_spares != UnSet && 
 			    array.spare_disks < st->expected_spares) 
 				alert("SparesMissing", dev, NULL, mailaddr, alert_cmd);
 			if (mse &&
