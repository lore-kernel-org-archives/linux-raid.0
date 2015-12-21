From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/3] [mdadm] move journal to end of --detail list
Date: Mon, 21 Dec 2015 11:23:41 -0800
Message-ID: <1450725823-1832511-2-git-send-email-songliubraving@fb.com>
References: <1450725823-1832511-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450725823-1832511-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

As we give journal device raid_disk of 0, the output of --detail is:

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       5       8       24        0      journal   /dev/sdb8
       1       8       18        1      active sync   /dev/sdb2
       2       8       19        2      active sync   /dev/sdb3
       3       8       21        3      active sync   /dev/sdb5

       4       8       23        -      spare   /dev/sdb7

This patch makes it back to:
    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       18        1      active sync   /dev/sdb2
       2       8       19        2      active sync   /dev/sdb3
       3       8       21        3      active sync   /dev/sdb5

       4       8       23        -      spare   /dev/sdb7
       5       8       24        -      journal   /dev/sdb8

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 Detail.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Detail.c b/Detail.c
index 5bd2dc6..37403d6 100644
--- a/Detail.c
+++ b/Detail.c
@@ -326,7 +326,8 @@ int Detail(char *dev, struct context *c)
 		    && disks[disk.raid_disk*2].state == (1<<MD_DISK_REMOVED))
 			disks[disk.raid_disk*2] = disk;
 		else if (disk.raid_disk >= 0 && disk.raid_disk < array.raid_disks
-			 && disks[disk.raid_disk*2+1].state == (1<<MD_DISK_REMOVED))
+			 && disks[disk.raid_disk*2+1].state == (1<<MD_DISK_REMOVED)
+			 && !(disk.state & (1<<MD_DISK_JOURNAL)))
 			disks[disk.raid_disk*2+1] = disk;
 		else if (next < max_disks*2)
 			disks[next++] = disk;
@@ -621,7 +622,7 @@ This is pretty boring
 			if (disk.number < 0)
 				printf("       -   %5d    %5d        -     ",
 				       disk.major, disk.minor);
-			else if (disk.raid_disk < 0)
+			else if (disk.raid_disk < 0 || disk.state & (1<<MD_DISK_JOURNAL))
 				printf("   %5d   %5d    %5d        -     ",
 				       disk.number, disk.major, disk.minor);
 			else if (disk.number < 0)
-- 
2.4.6

