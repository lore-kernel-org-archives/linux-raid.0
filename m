From: <senthilkumar.muthukalai@wipro.com>
Subject: Global sparing
Date: Thu, 4 Feb 2010 18:48:16 +0530
Message-ID: <8338BD137FF1B64EB341218BD702985E0303DE20@BLR-EC-MBX03.wipro.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

Can anyone help me to understand the global sharing with the below
context?
I have two degraded RAID1s say md0 and md1 with one disk active on each.
Both the arrays were originally built with 2 disks.
I am enabling global sharing.
When I add a disk to md0, it gets rebuilt.
When I add one more disk to md0, it gets added as a spare.
The md1, which is also degraded, is not able to grab the global spare
from md0 which is sitting idle until md0 finishes rebuilding.
Is this by policy/concept of global sharing that the spare is shared
after rebuilding?

Also I am trying to change mdadm-2.6.4 to make it shared immediately as
follows.

--- mdadm-2.6.4/Monitor.c.orig  2010-02-03 16:58:50.000000000 +0530
+++ mdadm-2.6.4/Monitor.c       2010-02-03 16:59:47.000000000 +0530
@@ -469,7 +469,7 @@
                                for (st2=statelist ; st2 ;
st2=st2->next)
                                        if (st2 != st &&
                                            st2->spare > 0 &&
-                                           st2->active == st2->raid &&
+                                           st2->working >= st2->raid &&
                                            st2->spare_group != NULL &&
                                            strcmp(st->spare_group,
st2->spare_group) == 0) {
                                                /* try to remove and add
*/

Is this change valid and complete?

Thanks,
Senthil M
