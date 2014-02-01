From: Nate Dailey <nate.dailey@stratus.com>
Subject: [PATCH] dm-raid: check events in super_validate
Date: Sat, 1 Feb 2014 09:35:20 -0500
Message-ID: <52ED0628.4030203@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If an LVM raid1 recovery is interrupted by deactivating the LV, when the 
LV is reactivated it comes up with both members in sync--the recovery 
never completes.

I've been trying to figure out how to fix this. Does this approach look 
okay? I'm not sure what else to use to determine that a member disk is 
out of sync. It looks like if disk_recovery_offset in the superblock 
were updated during the recovery, that would also cause it to resume 
after interruption--but MD skips the recovery target disk when writing 
superblocks, so this doesn't work.

Comments?

Thanks,

Nate Dailey
Stratus Technologies



diff -Nupr linux-3.12.9.orig/drivers/md/dm-raid.c 
linux-3.12.9/drivers/md/dm-raid.c
--- linux-3.12.9.orig/drivers/md/dm-raid.c    2014-02-01 
08:46:51.088086299 -0500
+++ linux-3.12.9/drivers/md/dm-raid.c    2014-02-01 09:02:06.657149550 -0500
@@ -1042,6 +1042,21 @@ static int super_validate(struct mddev *
          rdev->recovery_offset = le64_to_cpu(sb->disk_recovery_offset);
          if (rdev->recovery_offset != MaxSector)
              clear_bit(In_sync, &rdev->flags);
+        else if (!test_bit(Faulty, &rdev->flags)) {
+            uint64_t events_sb;
+
+            /*
+             * Trigger recovery if events is out-of-date.
+             */
+            events_sb = le64_to_cpu(sb->events);
+            if (events_sb < mddev->events) {
+                DMINFO("Force recovery on out-of-date device #%d.",
+                       rdev->raid_disk);
+                clear_bit(In_sync, &rdev->flags);
+                rdev->saved_raid_disk = rdev->raid_disk;
+                rdev->recovery_offset = 0;
+            }
+        }
      }

      /*

