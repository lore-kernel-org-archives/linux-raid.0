From: Andy Isaacson <adi@hexapodia.org>
Subject: [PATCH] fix read past end of array in md/linear.c
Date: Thu, 8 Mar 2007 12:52:04 -0800
Message-ID: <20070308205204.GA12152@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>, Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When iterating through an array, one must be careful to test one's index
variable rather than another similarly-named variable.  

The loop will read off the end of conf->disks[] in the following
(pathological) case:

% dd bs=1 seek=840716287 if=/dev/zero of=d1 count=1
% for i in 2 3 4; do dd if=/dev/zero of=d$i bs=1k count=$(($i+150)); done
% ./vmlinux ubd0=root ubd1=d1 ubd2=d2 ubd3=d3 ubd4=d4
# mdadm -C /dev/md0 --level=linear --raid-devices=4 /dev/ubd[1234]

adding some printks, I saw this:
[42949374.960000] hash_spacing = 821120
[42949374.960000] cnt          = 4
[42949374.960000] min_spacing  = 801
[42949374.960000] j=0 size=820928 sz=820928
[42949374.960000] i=0 sz=820928 hash_spacing=820928
[42949374.960000] j=1 size=64 sz=64
[42949374.960000] j=2 size=64 sz=128
[42949374.960000] j=3 size=64 sz=192
[42949374.960000] j=4 size=1515870810 sz=1515871002

Index: linus/drivers/md/linear.c
===================================================================
--- linus.orig/drivers/md/linear.c	2007-03-02 11:35:55.000000000 -0800
+++ linus/drivers/md/linear.c	2007-03-07 13:10:30.000000000 -0800
@@ -188,7 +188,7 @@
 	for (i=0; i < cnt-1 ; i++) {
 		sector_t sz = 0;
 		int j;
-		for (j=i; i<cnt-1 && sz < min_spacing ; j++)
+		for (j=i; j<cnt-1 && sz < min_spacing ; j++)
 			sz += conf->disks[j].size;
 		if (sz >= min_spacing && sz < conf->hash_spacing)
 			conf->hash_spacing = sz;
