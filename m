From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 04/14] Documentation/md.txt update
Date: Tue, 31 Mar 2009 15:54:43 +1100
Message-ID: <20090331045443.2589.62526.stgit@notabene.brown>
References: <20090331044827.2589.95894.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090331044827.2589.95894.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Update md.txt to reflect recent changes in a number of sysfs
attributes.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 Documentation/md.txt |   37 ++++++++++++++++++++++++++++++-------
 1 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/Documentation/md.txt b/Documentation/md.txt
index 1da9d1b..4edd39e 100644
--- a/Documentation/md.txt
+++ b/Documentation/md.txt
@@ -164,15 +164,19 @@ All md devices contain:
   raid_disks
      a text file with a simple number indicating the number of devices
      in a fully functional array.  If this is not yet known, the file
-     will be empty.  If an array is being resized (not currently
-     possible) this will contain the larger of the old and new sizes.
-     Some raid level (RAID1) allow this value to be set while the
-     array is active.  This will reconfigure the array.   Otherwise
-     it can only be set while assembling an array.
+     will be empty.  If an array is being resized this will contain
+     the new number of devices.
+     Some raid levels allow this value to be set while the array is
+     active.  This will reconfigure the array.   Otherwise it can only
+     be set while assembling an array.
+     A change to this attribute will not be permitted if it would
+     reduce the size of the array.  To reduce the number of drives
+     in an e.g. raid5, the array size must first be reduced by
+     setting the 'array_size' attribute.
 
   chunk_size
-     This is the size if bytes for 'chunks' and is only relevant to
-     raid levels that involve striping (1,4,5,6,10). The address space
+     This is the size in bytes for 'chunks' and is only relevant to
+     raid levels that involve striping (0,4,5,6,10). The address space
      of the array is conceptually divided into chunks and consecutive
      chunks are striped onto neighbouring devices.
      The size should be at least PAGE_SIZE (4k) and should be a power
@@ -183,6 +187,20 @@ All md devices contain:
      simply a number that is interpretted differently by different
      levels.  It can be written while assembling an array.
 
+  array_size
+     This can be used to artificially constrain the available space in
+     the array to be less than is actually available on the combined
+     devices.  Writing a number (in Kilobytes) which is less than
+     the available size will set the size.  Any reconfiguration of the
+     array (e.g. adding devices) will not cause the size to change.
+     Writing the word 'default' will cause the effective size of the
+     array to be whatever size is actually available based on
+     'level', 'chunk_size' and 'component_size'.
+
+     This can be used to reduce the size of the array before reducing
+     the number of devices in a raid4/5/6, or to support external
+     metadata formats which mandate such clipping.
+
   reshape_position
      This is either "none" or a sector number within the devices of
      the array where "reshape" is up to.  If this is set, the three
@@ -207,6 +225,11 @@ All md devices contain:
      about the array.  It can be 0.90 (traditional format), 1.0, 1.1,
      1.2 (newer format in varying locations) or "none" indicating that
      the kernel isn't managing metadata at all.
+     Alternately it can be "external:" followed by a string which
+     is set by user-space.  This indicates that metadata is managed
+     by a user-space program.  Any device failure or other event that
+     requires a metadata update will cause array activity to be
+     suspended until the event is acknowledged.
 
   resync_start
      The point at which resync should start.  If no resync is needed,


