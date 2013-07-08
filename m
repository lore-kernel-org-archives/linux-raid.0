From: mwilck@arcor.de
Subject: [PATCH 33/39] DDF: getinfo_super_ddf_bvd: fix raid_disk calculation
Date: Mon,  8 Jul 2013 23:50:42 +0200
Message-ID: <1373320248-7520-7-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

The return value of disk.raid_disk may be wrong.
The old code was using raiddisk, which is only valid with auto
layout. This leads to errors when arrays are created with
specified disks and mdmon is already running, like this:

mdadm -CR /dev/md/container -n5 $d1 $d2 $d3 $d4 $d5
mdadm -CR /dev/md/r5 -n5 -l5 /dev/md/container -z 5000
mdadm -CR /dev/md/r1 -n2 -l1 $d1 $d2
  => resulting array will use wrong disks

This patch fixes that.
---
 super-ddf.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index bff420c..7da4ce0 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1887,7 +1887,8 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 	if (dl) {
 		info->disk.major = dl->major;
 		info->disk.minor = dl->minor;
-		info->disk.raid_disk = dl->raiddisk;
+		info->disk.raid_disk = cd + conf->sec_elmnt_seq
+			* __be16_to_cpu(conf->prim_elmnt_count);
 		info->disk.number = dl->pdnum;
 		info->disk.state = (1<<MD_DISK_SYNC)|(1<<MD_DISK_ACTIVE);
 	}
-- 
1.7.1
