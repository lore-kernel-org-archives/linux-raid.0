From: CoolCold <coolthecold@gmail.com>
Subject: [Trivial PATCH] removing doubled description for sync_max, merging it
 within sync_min/sync_max
Date: Wed, 26 Jun 2013 19:46:58 +0400
Message-ID: <CAGqmV7qzdY8=sN0qOyD7gEKb3df3CQ1v3JR4HsgPVBSWWoc8LA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

After last md.txt edits for sync_min/max, sync_max description became
doubled. Removing 1st copy, merging details into common
sync_min/sync_max section.

Signed-off-by: Roman Ovchinnikov <coolthecold@gmail.com>
---
 Documentation/md.txt |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/Documentation/md.txt b/Documentation/md.txt
index e0ddd32..d2e4071 100644
--- a/Documentation/md.txt
+++ b/Documentation/md.txt
@@ -566,13 +566,6 @@ also have
      when it reaches the current sync_max (below) and possibly at
      other times.

-   sync_max
-     This is a number of sectors at which point a resync/recovery
-     process will pause.  When a resync is active, the value can
-     only ever be increased, never decreased.  The value of 'max'
-     effectively disables the limit.
-
-
    sync_speed
      This shows the current actual speed, in K/sec, of the current
      sync_action.  It is averaged over the last 30 seconds.
@@ -592,6 +585,12 @@ also have
      You can use 'select' or 'poll' on "sync_completed" to wait for
      that number to reach sync_max.  Then you can either increase
      "sync_max", or can write 'idle' to "sync_action".
+
+     The value of 'max' for "sync_max" effectively disables the limit.
+     When a resync is active, the value can only ever be increased,
+     never decreased.
+     The value of '0' is the minimum for "sync_min".
+


 Each active md device may also have attributes specific to the
--
1.7.2.5


--
Best regards,
[COOLCOLD-RIPN]
