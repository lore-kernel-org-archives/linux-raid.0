From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 000 of 7] Introduction
Date: Mon, 29 Aug 2005 17:33:38 +1000
Message-ID: <20050829172936.12848.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Herewith, a group of patches for md/raid in 2.6.13-mm.

They (together with the md patches already in -mm) are all appropriate
for the flood which will be pouring in to Linus now that 2.6.13 is
out.

There are a few bug fixes (it's SO good having a test suite to help find these), 
a couple of code cleanups, and the write-intent-logging stuff is now supported
on raid4/5/6 as well as raid1.

Thanks,
NeilBrown


 [PATCH md 001 of 7] Remove old cruft from md_k.h header file.
 [PATCH md 002 of 7] Limit size of sb read/written to appropriate amount.
 [PATCH md 003 of 7] Add write-intent-bitmap support to raid5
 [PATCH md 004 of 7] write-intent bitmap support for raid6
 [PATCH md 005 of 7] Use kthread infrastructure in md
 [PATCH md 006 of 7] Ensure bitmap_writeback_daemon handles shutdown properly.
 [PATCH md 007 of 7] Tidy up daemon stop/start code in md/bitmap.c
