From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: [PATCH] raid6check.c: fix position printout
Date: Sat, 1 Feb 2014 17:39:27 +0100
Message-ID: <20140201163927.GA16976@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch make a bit more clear
the position, in the disk, where
an error is found.

Signed off: piergiorgio.sartor@nexgo.de
diff -uNrp a/raid6check.c b/raid6check.c
--- a/raid6check.c	2014-02-01 16:56:14.123771170 +0100
+++ b/raid6check.c	2014-02-01 17:36:05.685667361 +0100
@@ -237,11 +237,11 @@ int check_stripes(struct mdinfo *info, i
 				disk[j] = geo_map(disk[j], start, raid_disks, level, layout);
 			}
 			if(disk[j] >= 0) {
-				printf("Error detected at %llu, page %d: possible failed disk slot: %d --> %s\n",
+				printf("Error detected at stripe %llu, page %d: possible failed disk slot: %d --> %s\n",
 					start, j, disk[j], name[disk[j]]);
 			}
 			if(disk[j] == -65535) {
-				printf("Error detected at %llu, page %d: disk slot unknown\n", start, j);
+				printf("Error detected at stripe %llu, page %d: disk slot unknown\n", start, j);
 			}
 		}
 

-- 

piergiorgio
