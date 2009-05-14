From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject: [PATCH] mdadm: raid0: support chunks of 4K*n for raid0
Date: Thu, 14 May 2009 20:12:11 +0300
Message-ID: <1242321131.11444.23.camel@raz>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
	 <1242297833-13908-2-git-send-email-maan@systemlinux.org>
	 <fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name>
	 <20090514121042.GH11504@skl-net.de>
	 <4743925b38e2d64317e0b6d7c8005a29.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4743925b38e2d64317e0b6d7c8005a29.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil.
I do not know what is policy for mdadm patches. I would thankful for some instructions.
The bellow is the patch I applied to support raid0 chunk sizes 4K*n.
---
--- mdadm.c	(revision 16152)
+++ mdadm.c	(working copy)
@@ -314,7 +314,8 @@
 				exit(2);
 			}
 			chunk = strtol(optarg, &c, 10);
-			if (!optarg[0] || *c || chunk<4 || (chunk%4)) {
+			if (!optarg[0] || *c || chunk<4 ||  (((chunk-1)&chunk) && level !=0)
+					||  (((chunk%4) && level ==0) )) {
 				fprintf(stderr, Name ": invalid chunk/rounding value: %s\n",
 					optarg);
 				exit(2);


