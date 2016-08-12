From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] mdadm: put journal device in right place of --detail
Date: Thu, 11 Aug 2016 17:14:13 -0700
Message-ID: <1470960853-2859579-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: yizhan@redhat.com, Song Liu <songliubraving@fb.com>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

When there is failed HDDs, journal device showed in wrong place
of --detail:

    Number   Major   Minor   RaidDevice State
       4       8       24        -      journal   /dev/sdb8
       1       8       18        1      active sync   /dev/sdb2
       2       8       19        2      active sync   /dev/sdb3
       3       8       21        3      active sync   /dev/sdb5

       0       8       17        -      faulty   /dev/sdb1

This patch fixed the output as:

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       18        1      active sync   /dev/sdb2
       2       8       19        2      active sync   /dev/sdb3
       3       8       21        3      active sync   /dev/sdb5

       0       8       17        -      faulty   /dev/sdb1
       4       8       24        -      journal   /dev/sdb8

Reported-by: Yi Zhang <yizhan@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 Detail.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Detail.c b/Detail.c
index 7a984c8..925e479 100644
--- a/Detail.c
+++ b/Detail.c
@@ -323,7 +323,8 @@ int Detail(char *dev, struct context *c)
 		if (disk.major == 0 && disk.minor == 0)
 			continue;
 		if (disk.raid_disk >= 0 && disk.raid_disk < array.raid_disks
-		    && disks[disk.raid_disk*2].state == (1<<MD_DISK_REMOVED))
+		    && disks[disk.raid_disk*2].state == (1<<MD_DISK_REMOVED)
+		    && ((disk.state & (1<<MD_DISK_JOURNAL)) == 0))
 			disks[disk.raid_disk*2] = disk;
 		else if (disk.raid_disk >= 0 && disk.raid_disk < array.raid_disks
 			 && disks[disk.raid_disk*2+1].state == (1<<MD_DISK_REMOVED)
-- 
2.8.0.rc2

