From: Bodo Thiesen <bothie@gmx.de>
Subject: Re: RAID6 Problem (in conjunction with nested LVM and encryption)
Date: Mon, 4 Sep 2006 07:45:39 +0200
Message-ID: <20060904074539.25e930e7@30_bodo.rupinet>
References: <20060903012118.3e0b7485@30_bodo.rupinet>
	<17659.46039.259569.312043@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17659.46039.259569.312043@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> wrote:

> On Sunday September 3, bothie@gmx.de wrote:
>
>> I have a really really big problem. In fact, the problem is the output of 
>> mdadm --examine as shown on http://nomorepasting.com/paste.php?pasteID=68021
> 
> Please explain why you think that output is a problem.  It looks fine
> to me.

1. craida1 claims about itself to be raidh-raidh1 ...

2. according to craida1 the raid is composed of raidh-raidh1, a faulty disk 
   (that was craid1b), craidb1, craidc1 and craida2, but not craida1 itself, 
   of course                                ^^^^^^^

2b. Continue with craida2. It claims to be craide1 and being part of 
    craide1, craidh1, craida2, craidc2, craidd2.

YMMV, but I call that anything but "fine". ;)

This inconsistencies continue, and nearly no disk is right about which raid 
it belongs to and what other disks belong to that raid.

To get it to the point. raid1 should be craid... a1,b1(faulty),c1,d1,e1; 
r2 should be a2,c2,d2,e2,g2; r3 should be b3,c3,d3,e3,g3 and r4 should 
finally be c4,d4,e4,f4,g4.
h1 shouldn't be used yet (it should have replaced b1 already, but I didn't 
get to that point yet). And raidh-raidh1 shouldn't be known to any raid at 
all, as only c* was added to the raids at any time.

So, I hope, that I made my problem clear now.

Regards, Bodo

PS: You may stop putting me CC as I finally managed successfully to join the 
    list ;)

-- 
VGER BF report: U 0.50496
