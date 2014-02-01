From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: [PATCH] raid6check.c: add O_SYNC to open
Date: Sat, 1 Feb 2014 22:27:58 +0100
Message-ID: <20140201212758.GA23076@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It could be better to make sure the
data reaches the disks, so open the
drives with O_SYNC flag.

Signed off: piergiorgio.sartor@nexgo.de
diff -uNrp a/raid6check.c b/raid6check.c
--- a/raid6check.c	2014-02-01 22:12:15.069189406 +0100
+++ b/raid6check.c	2014-02-01 22:18:26.657197036 +0100
@@ -584,7 +584,7 @@ int main(int argc, char *argv[])
 		if(disk_slot >= 0) {
 			disk_name[disk_slot] = map_dev(comp->disk.major, comp->disk.minor, 0);
 			offsets[disk_slot] = comp->data_offset * 512;
-			fds[disk_slot] = open(disk_name[disk_slot], O_RDWR);
+			fds[disk_slot] = open(disk_name[disk_slot], O_RDWR | O_SYNC);
 			if (fds[disk_slot] < 0) {
 				perror(disk_name[disk_slot]);
 				fprintf(stderr,"%s: cannot open %s\n", prg, disk_name[disk_slot]);

-- 

piergiorgio
