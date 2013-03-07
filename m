From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] MD: Fix typos in MD documentation
Date: Thu, 07 Mar 2013 16:19:26 -0600
Message-ID: <1362694766.28152.1.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

MD:  Fix some typos/grammer in MD documentation

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/Documentation/md.txt
===================================================================
--- linux-upstream.orig/Documentation/md.txt
+++ linux-upstream/Documentation/md.txt
@@ -119,7 +119,7 @@ device to add.
 The array is started with the RUN_ARRAY ioctl.
 
 Once started, new devices can be added.  They should have an
-appropriate superblock written to them, and then passed be in with
+appropriate superblock written to them, and then be passed in with
 ADD_NEW_DISK.
 
 Devices that have failed or are not yet active can be detached from an
@@ -131,7 +131,7 @@ Specific Rules that apply to format-0 su
 -------------------------------------------------------------
 
 An array can be 'created' by describing the array (level, chunksize
-etc) in a SET_ARRAY_INFO ioctl.  This must has major_version==0 and
+etc) in a SET_ARRAY_INFO ioctl.  This must have major_version==0 and
 raid_disks != 0.
 
 Then uninitialized devices can be added with ADD_NEW_DISK.  The
@@ -426,7 +426,7 @@ Each directory contains:
       offset
         This gives the location in the device (in sectors from the
         start) where data from the array will be stored.  Any part of
-        the device before this offset us not touched, unless it is
+        the device before this offset is not touched, unless it is
         used for storing metadata (Formats 1.1 and 1.2).
 
       size
@@ -440,7 +440,7 @@ Each directory contains:
         When the device is not 'in_sync', this records the number of
 	sectors from the start of the device which are known to be
 	correct.  This is normally zero, but during a recovery
-	operation is will steadily increase, and if the recovery is
+	operation it will steadily increase, and if the recovery is
 	interrupted, restoring this value can cause recovery to
 	avoid repeating the earlier blocks.  With v1.x metadata, this
 	value is saved and restored automatically.
@@ -468,7 +468,7 @@ Each directory contains:
 
 
 
-An active md device will also contain and entry for each active device
+An active md device will also contain an entry for each active device
 in the array.  These are named
 
     rdNN
@@ -482,7 +482,7 @@ will show 'in_sync' on every line.
 
 
 
-Active md devices for levels that support data redundancy (1,4,5,6)
+Active md devices for levels that support data redundancy (1,4,5,6,10)
 also have
 
    sync_action
@@ -494,7 +494,7 @@ also have
                        failed/missing device
        idle          - nothing is happening
        check         - A full check of redundancy was requested and is
-                       happening.  This reads all block and checks
+                       happening.  This reads all blocks and checks
                        them. A repair may also happen for some raid
                        levels.
        repair        - A full check and repair is happening.  This is
@@ -522,7 +522,7 @@ also have
 
    degraded
       This contains a count of the number of devices by which the
-      arrays is degraded.  So an optimal array with show '0'.  A
+      arrays is degraded.  So an optimal array will show '0'.  A
       single failed/missing drive will show '1', etc.
       This file responds to select/poll, any increase or decrease
       in the count of missing devices will trigger an event.


