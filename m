From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] cleanup drivers/md/Makefile
Date: Tue, 3 Mar 2009 19:00:01 +0100
Message-ID: <20090303180001.GB27386@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Use the -y variables instead of the old -objs so we can easily add
conditional objects to the modules.  Also always use += to add
subobjects to avoid problems when placing additional objects in
some place in the file.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/md/Makefile
===================================================================
--- linux-2.6.orig/drivers/md/Makefile	2009-02-27 17:45:02.374285905 +0100
+++ linux-2.6/drivers/md/Makefile	2009-02-27 17:45:40.906289678 +0100
@@ -2,20 +2,20 @@
 # Makefile for the kernel software RAID and LVM drivers.
 #
 
-dm-mod-objs	:= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
+dm-mod-y	+= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
 		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o
-dm-multipath-objs := dm-path-selector.o dm-mpath.o
-dm-snapshot-objs := dm-snap.o dm-exception-store.o dm-snap-transient.o \
+dm-multipath-y	+= dm-path-selector.o dm-mpath.o
+dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
 		    dm-snap-persistent.o
-dm-mirror-objs	:= dm-raid1.o
-md-mod-objs     := md.o bitmap.o
-raid456-objs	:= raid5.o raid6algos.o raid6recov.o raid6tables.o \
+dm-mirror-y	+= dm-raid1.o
+md-mod-y	+= md.o bitmap.o
+raid456-y	+= raid5.o raid6algos.o raid6recov.o raid6tables.o \
 		   raid6int1.o raid6int2.o raid6int4.o \
 		   raid6int8.o raid6int16.o raid6int32.o \
 		   raid6altivec1.o raid6altivec2.o raid6altivec4.o \
 		   raid6altivec8.o \
 		   raid6mmx.o raid6sse1.o raid6sse2.o
-hostprogs-y	:= mktables
+hostprogs-y	+= mktables
 
 # Note: link order is important.  All raid personalities
 # and must come before md.o, as they each initialise 
