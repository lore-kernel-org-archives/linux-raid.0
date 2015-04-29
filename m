From: heinzm@redhat.com
Subject: [PATCH v2 3/4] Documentation: add version history entries for raid0 support _and_ forgotten devices_handle_discards_safely module paramater
Date: Wed, 29 Apr 2015 14:03:48 +0200
Message-ID: <1430309029-24851-4-git-send-email-heinzm@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: linux-raid.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

This patch adds version history for md raid0 to dm-raid.txt
_and_
adds forgotten doc for the 1.6.0 version change as well

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 Documentation/device-mapper/dm-raid.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index ef8ba9f..bceb865 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -224,3 +224,6 @@ Version History
 	New status (STATUSTYPE_INFO) fields: sync_action and mismatch_cnt.
 1.5.1   Add ability to restore transiently failed devices on resume.
 1.5.2   'mismatch_cnt' is zero unless [last_]sync_action is "check".
+1.6.0   Add devices_handle_discards_safely module parameter to
+	allow discards on disks announcing uncertain discard_zeroes_data
+1.7.0   Add support for MD RAID0 mappings
-- 
2.1.0

