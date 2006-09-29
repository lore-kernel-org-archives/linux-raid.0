From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 6] md: Fix duplicity of levels in md.txt
Date: Fri, 29 Sep 2006 12:52:52 +1000
Message-ID: <1060929025252.15187@suse.de>
References: <20060929125047.14064.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Christian Kujau <evil@g-house.de>
List-Id: linux-raid.ids


md.txt has two sections describing the 'level'
sysfs attribute, and some of the text is out-of-date.
So make just one section, and make it right.

Cc: Christian Kujau <evil@g-house.de>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff .prev/Documentation/md.txt ./Documentation/md.txt
--- .prev/Documentation/md.txt	2006-09-29 11:44:38.000000000 +1000
+++ ./Documentation/md.txt	2006-09-29 11:48:54.000000000 +1000
@@ -154,11 +154,12 @@ contains further md-specific information
 
 All md devices contain:
   level
-     a text file indicating the 'raid level'.  This may be a standard
-     numerical level prefixed by "RAID-" - e.g. "RAID-5", or some
-     other name such as "linear" or "multipath".
+     a text file indicating the 'raid level'. e.g. raid0, raid1,
+     raid5, linear, multipath, faulty.
      If no raid level has been set yet (array is still being
-     assembled), this file will be empty.
+     assembled), the value will reflect whatever has been written
+     to it, which may be a name like the above, or may be a number
+     such as '0', '5', etc.
 
   raid_disks
      a text file with a simple number indicating the number of devices
@@ -192,14 +193,6 @@ All md devices contain:
      1.2 (newer format in varying locations) or "none" indicating that
      the kernel isn't managing metadata at all.
 
-  level
-     The raid 'level' for this array.  The name will often (but not
-     always) be the same as the name of the module that implements the
-     level.  To be auto-loaded the module must have an alias
-        md-$LEVEL  e.g. md-raid5
-     This can be written only while the array is being assembled, not
-     after it is started.
-
   layout
      The "layout" for the array for the particular level.  This is
      simply a number that is interpretted differently by different
