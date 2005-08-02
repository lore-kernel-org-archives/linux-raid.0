From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 000 of 7] Introduction
Date: Tue, 02 Aug 2005 19:53:40 +1000
Message-ID: <20050802193525.12307.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Following are 7 patches for md in 2.6.13-rc4
They are all fairly well tested, with the possible exception of '4' -
I haven't actually tried throwing BIO_RW_BARRIER requests are any md
devices.  However the code is very straight forward.

I'm happy (even keen) for these to go into 2.6.13.
If it's getting a bit late, then 2 is probably the most important.
The others we can probably live without.

Thanks,
NeilBrown



 [PATCH md 001 of 7] Remove a stray debugging printk.
 [PATCH md 002 of 7] Make 'md' and alias for 'md-mod'
 [PATCH md 003 of 7] Fix minor error in raid10 read-balancing calculation.
 [PATCH md 004 of 7] Fail IO requests to md that require a barrier.
 [PATCH md 005 of 7] Always honour md bitmap being read from disk
 [PATCH md 006 of 7] Yet another attempt to get bitmap-based resync to do the right thing in all cases...
 [PATCH md 007 of 7] Make sure md bitmap updates are flushed when array is stopped.
