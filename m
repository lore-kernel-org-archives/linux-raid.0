From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 0 of 2] Introduction
Date: Wed, 01 Dec 2004 11:49:58 +1100
Message-ID: <20041201112426.2971.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Two patches for md/raid in 2.6.recent.

1/ Fix data corruption bug in raid10 when used on
   partitions.  raid10 is marked "experimental" but 
   it would be good to get this in 2.6.10
2/ Fix jiffies comparison during resync so it behaves
   correctly when jiffies wrap.  This bug has no
   performance, security, or data integrity impact.

NeilBrown
