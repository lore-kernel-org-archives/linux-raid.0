From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 0 of 7] Introduction
Date: Wed, 08 Sep 2004 12:48:09 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040908124236.20651.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following are 7 patches for md in 2.6.8-rc1-mm2

They all grew out of a desire to redo the locking in unplug_slave.
Getting and dropping a spinlock so often for very little gain (it
would be nearly impossible to lose the relevant race) really bothered
me.

I finally figured that I could reply it with rcu locking which is very
light wait, and quite up to the task.

One the way I found an number of inconsistencies that needed cleaning
up and even a few bugs to fix.
The first 6 patches deal with these inconsistencies and bugs.  The
last redoes the locking for adding/removing/accessing devices within
md personalities.


