From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH v2] md: add documentation for bad block log
Date: Wed, 27 Jul 2011 00:03:43 +0900
Message-ID: <1311692623-2741-1-git-send-email-namhyung@gmail.com>
References: <87livlxw9w.fsf@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87livlxw9w.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Previous patch in the bad block series added new sysfs interfaces
([unacknowledged_]bad_blocks) for each rdev without documentation.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
Previous version misplaced the descriptions. Move them to correct
position (under rdev directory).


 Documentation/md.txt |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/Documentation/md.txt b/Documentation/md.txt
index f0eee83ff78a..923a6bddce7c 100644
--- a/Documentation/md.txt
+++ b/Documentation/md.txt
@@ -419,7 +419,6 @@ Each directory contains:
         written, it will be rejected.
 
       recovery_start
-
         When the device is not 'in_sync', this records the number of
 	sectors from the start of the device which are known to be
 	correct.  This is normally zero, but during a recovery
@@ -435,6 +434,20 @@ Each directory contains:
 	Setting this to 'none' is equivalent to setting 'in_sync'.
 	Setting to any other value also clears the 'in_sync' flag.
 	
+      bad_blocks
+	This gives the list of all known bad blocks in the form of
+	start address and length (in sectors respectively). If output
+	is too big to fit in a page, it will be truncated. Writing
+	"sector length" to this file adds new acknowledged (i.e.
+	recorded to disk safely) bad blocks.
+
+      unacknowledged_bad_blocks
+	This gives the list of known-but-not-yet-saved-to-disk bad
+	blocks in the same form of 'bad_blocks'. If output is too big
+	to fit in a page, it will be truncated. Writing to this file
+	adds bad blocks without acknowledging them. This is largely
+	for testing.
+
 
 
 An active md device will also contain and entry for each active device
-- 
1.7.6

