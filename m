From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 0 of 2 - Introduction
Date: Fri, 05 Mar 2004 16:45:37 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040305164342.7205.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Here are two patches for md that I believe are suitable
for 2.6.4.

1/ change yield() to schedule_timeout(2) as promised a while back.

2/ Support assembling partitionable raid at boot-time so that it is
   possible to boot from a partition of a raid array without needing
   an initramfs.

Thanks,
NeilBrown

