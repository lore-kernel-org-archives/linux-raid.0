From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: After 0->10 takeover process hangs at "wait_barrier"
Date: Wed, 2 Feb 2011 12:15:28 +0000
Message-ID: <BE2BFE91933D1B4089447C6448604080670E9A24@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

I would like to return to problem related to raid0->raid10 takeover operation.
I observed following symptoms:
1. After raid0->raid10 takeover we have array with 2 missing disks. When we add disk for rebuild, recovery process starts as expected but it does not finish- it stops at about 90%, md126_resync process hangs in "D" state
2. Similar behavior is when we have mounted raid0 array and we execute takeover to raid10. After this when we try to unmount array- it causes process umount hangs in "D"

In scenarios above processes hang at the same function- wait_barrier in raid10.c.
Process waits in macro "wait_event_lock_irq" until the "!conf->barrier" condition will be true. In scenarios above it never happens.

Issue does not appear if after takeover we stop array and assemble it again- we can rebuild disks without problem. It indicates that raid0->raid10 takeover process does not initialize all array parameters in proper way.

Do you have any suggestions what can I do to get closer to solving this problem?

Regards
Krzysztof

